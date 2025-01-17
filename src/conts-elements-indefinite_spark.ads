--
--  Copyright (C) 2015-2016, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

--  An implementation of the elements traits compatible with SPARK.
--  This package hides the access types.
--  Reference types are not possible with SPARK, so this package always
--  return a copy of the element (as opposed to what's done in
--  conts-elements-indefinite.ads)

pragma Ada_2012;

generic
   type Element_Type (<>) is private;

   with package Pool is new Conts.Pools (<>);
   --  The storage pool used for Elements.

package Conts.Elements.Indefinite_SPARK with SPARK_Mode => On is

   package Impl with SPARK_Mode => On is
      type Element_Access is private;

      subtype Constant_Reference_Type is Element_Type;
      --  References are not allowed in SPARK, use the element directly instead

      function To_Element_Access (E : Element_Type) return Element_Access
      with Inline,
        Global => null,
        Post   => To_Constant_Reference_Type (To_Element_Access'Result) = E;

      function To_Constant_Reference_Type
        (E : Element_Access) return Constant_Reference_Type
      with Inline,
        Global => null;

      function To_Element (E : Constant_Reference_Type) return Element_Type is
        (E)
      with Inline,
        Global => null;

      function Copy (E : Element_Access) return Element_Access
      with Inline,
        Global => null;

      procedure Free (X : in out Element_Access) with Global => null;

   private
      pragma SPARK_Mode (Off);

      type Element_Access is access all Element_Type;

      for Element_Access'Storage_Pool use Pool.Pool;

      function To_Element_Access (E : Element_Type) return Element_Access
      is (new Element_Type'(E));

      function To_Element_Type (E : Element_Access) return Element_Type
      is (E.all);

      function Copy (E : Element_Access) return Element_Access
      is (new Element_Type'(E.all));

      function To_Constant_Reference_Type
        (E : Element_Access) return Constant_Reference_Type
        is (E.all);
   end Impl;

   package Traits is new Conts.Elements.Traits
     (Element_Type           => Element_Type,
      Stored_Type            => Impl.Element_Access,
      Returned_Type          => Impl.Constant_Reference_Type,
      Constant_Returned_Type => Impl.Constant_Reference_Type,
      To_Stored              => Impl.To_Element_Access,
      To_Returned            => Impl.To_Constant_Reference_Type,
      To_Constant_Returned   => Impl.To_Constant_Reference_Type,
      To_Element             => Impl.To_Element,
      Copy                   => Impl.Copy,
      Copyable               => False,
      Movable                => False,
      Release                => Impl.Free);

end Conts.Elements.Indefinite_SPARK;
