--
--  Copyright (C) 2015-2016, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

--  This package provides a specialization of the Element_Traits package for
--  use with indefinite type (i.e. their size might not be known at compile
--  time).
--  Such elements are returned as reference types, so containers will not
--  return the element itself. This is in general more efficient and safer,
--  and avoids copying potentially large elements.

pragma Ada_2012;

generic
   type Element_Type (<>) is private;

   with procedure Free (E : in out Element_Type) is null;
   --  This procedure is called when the element is removed from its
   --  container.

   with package Pool is new Conts.Pools (<>);

package Conts.Elements.Indefinite is

   type Element_Access is access all Element_Type;
   for Element_Access'Storage_Pool use Pool.Pool;

   type Constant_Reference_Type
     (Element : not null access constant Element_Type)
      is null record with Implicit_Dereference => Element;
   --  ??? Would be nice if we could make this constrained by
   --  providing a default value for the discriminant, but this is
   --  illegal.

   type Reference_Type (Element : not null access Element_Type)
      is null record with Implicit_Dereference => Element;

   function To_Element_Access (E : Element_Type) return Element_Access
      is (new Element_Type'(E)) with Inline;
   function To_Constant_Ref (E : Element_Access) return Constant_Reference_Type
      is (Constant_Reference_Type'(Element => E)) with Inline;
   function To_Element (E : Constant_Reference_Type) return Element_Type
      is (E.Element.all) with Inline;
   function To_Ref (E : Element_Access) return Reference_Type
      is (Reference_Type'(Element => E)) with Inline;
   function To_Element (E : Reference_Type) return Element_Type
      is (E.Element.all) with Inline;
   function Copy (E : Element_Access) return Element_Access
      is (new Element_Type'(E.all)) with Inline;
   procedure Release (E : in out Element_Access) with Inline;

   package Traits is new Conts.Elements.Traits
     (Element_Type           => Element_Type,
      Stored_Type            => Element_Access,
      Returned_Type          => Reference_Type,
      Constant_Returned_Type => Constant_Reference_Type,
      To_Stored              => To_Element_Access,
      To_Returned            => To_Ref,
      To_Constant_Returned   => To_Constant_Ref,
      To_Element             => To_Element,
      Copy                   => Copy,
      Release                => Release,
      Copyable               => False,   --  would create aliases
      Movable                => True);

end Conts.Elements.Indefinite;
