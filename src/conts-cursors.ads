--
--  Copyright (C) 2015-2016, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

--  This package provides signature packages that describe how to iterate over
--  containers.
--  Such cursors do not provide access to the elements that are in the
--  container, this is done via a separate instance of property maps (see
--  the package Conts.Properties for more information). Separating the two
--  concepts keeps them simpler:
--     We currently provide Forward, Bidirectional and Random_Access cursors
--  If accessing and modifying the elements was built into the concept of
--  cursors, we would need an extra version for all of these to mean
--  Constant_Forward, Constant_Bidirectional and Constant_Random_Access, and
--  perhaps even a concept of Write_Only cursor (for output streams for
--  instance).

pragma Ada_2012;

package Conts.Cursors with SPARK_Mode is

   ---------------------
   -- Forward_Cursors --
   ---------------------
   --  A package that describes how to use forward cursors.  Each container
   --  for which this is applicable provides an instance of this package,
   --  and algorithms should take this package as a generic parameter.

   generic
      type Container_Type (<>) is limited private;
      type Cursor_Type is private;
      No_Element : Cursor_Type;
      with function First (Self : Container_Type) return Cursor_Type is <>;
      with function Has_Element (Self : Container_Type; Pos : Cursor_Type)
         return Boolean is <>;
      with function Next (Self : Container_Type; Pos : Cursor_Type)
         return Cursor_Type is <>;
      with function "=" (Left, Right : Cursor_Type) return Boolean is <>;
   package Forward_Cursors is
      subtype Container is Container_Type;
      subtype Cursor    is Cursor_Type;
   end Forward_Cursors;

   ---------------------------
   -- Bidirectional_Cursors --
   ---------------------------

   generic
      type Container_Type (<>) is limited private;
      type Cursor_Type is private;
      No_Element : Cursor_Type;
      with function First (Self : Container_Type) return Cursor_Type is <>;
      with function Has_Element (Self : Container_Type; Pos : Cursor_Type)
         return Boolean is <>;
      with function Next (Self : Container_Type; Pos : Cursor_Type)
         return Cursor_Type is <>;
      with function Previous (Self : Container_Type; Pos : Cursor_Type)
         return Cursor_Type is <>;
   package Bidirectional_Cursors is
      subtype Container is Container_Type;
      subtype Cursor    is Cursor_Type;

      --  A bidirectional cursor is also a forward cursor
      package Forward is new Forward_Cursors (Container, Cursor, No_Element);
   end Bidirectional_Cursors;

   ----------------------------
   -- Random_Access_Cursors --
   ----------------------------
   --  These are cursors that can access any element from a container, in no
   --  specific order.

   generic
      type Container_Type (<>) is limited private;
      type Index_Type is (<>);
      No_Element : Index_Type;

      with function First (Self : Container_Type) return Index_Type is <>;
      --  Index of the first element in the container (often Index_Type'First)
      --  ??? Can we remove this parameter and always use Index_Type'First

      with function Last (Self : Container_Type) return Index_Type is <>;
      --  Return the index of the last valid element in the container.
      --  We do not use a Has_Element function, since having an explicit range
      --  is more convenient for algorithms (for instance to select random
      --  elements in the container).

      with function Distance (Left, Right : Index_Type) return Integer is <>;
      --  Return the number of elements between the two positions.

      with function "+"
        (Left : Index_Type; N : Integer) return Index_Type is <>;
      --  Move Left forward or backward by a number of position.

   package Random_Access_Cursors is
      subtype Container is Container_Type;
      subtype Index     is Index_Type;

      function Dist
        (Left, Right : Index_Type) return Integer renames Distance;
      function Add (Left : Index_Type; N : Integer) return Index_Type
         renames "+";
      function First_Index (Self : Container_Type) return Index_Type
         renames First;
      function Last_Index (Self : Container_Type) return Index_Type
         renames Last;
      --  Make visible to users of the package
      --  ??? Why is this necessary in Ada.

      function "-" (Left : Index_Type; N : Integer) return Index_Type
        is (Left + (-N)) with Inline;

      function Next (Self : Container_Type; Idx : Index_Type) return Index_Type
        is (Idx + 1) with Inline;

      function Previous
        (Self : Container_Type; Idx : Index_Type) return Index_Type
        is (Idx - 1) with Inline;

      function Has_Element
        (Self : Container_Type; Idx : Index_Type) return Boolean
        is (Idx >= First (Self) and then Idx <= Last (Self)) with Inline;
      --  This might be made efficient if you pass a First function that
      --  returns a constant and if this contstant is Index_Type'First then
      --  the compiler can simply remove the test.

      --  A random cursor is also a bidirectional and forward cursor
      package Bidirectional is
        new Bidirectional_Cursors (Container, Index_Type, No_Element);
      package Forward renames Bidirectional.Forward;
   end Random_Access_Cursors;

end Conts.Cursors;
