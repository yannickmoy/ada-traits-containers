------------------------------------------------------------------------------
--                     Copyright (C) 2015, AdaCore                          --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--  This file provides adaptors for the standard Ada2012 containers, so that
--  they can be used with the algorithms declared in our containers hierarchy

pragma Ada_2012;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Indefinite_Doubly_Linked_Lists;

package Conts.Cursors.Adaptors is

   -------------------------------------
   -- Adaptor for doubly linked lists --
   -------------------------------------

   generic
      with package Lists is new Ada.Containers.Doubly_Linked_Lists (<>);
   package List_Adaptors is
      subtype Element_Type is Lists.Element_Type;
      subtype List is Lists.List;
      subtype Cursor is Lists.Cursor;

      function First (Self : List) return Cursor
         renames Lists.First;
      function Element (Self : List; Position : Cursor) return Element_Type
         is (Lists.Element (Position));
      function Has_Element (Self : List; Position : Cursor) return Boolean
         is (Lists.Has_Element (Position));
      function Next (Self : List; Position : Cursor) return Cursor
         is (Lists.Next (Position));
      pragma Inline (Element, Has_Element, Next, First);

      package Cursors is
         package Constant_Forward is new Constant_Forward_Traits
            (Container    => List'Class,
             Cursor       => Cursor,
             Element_Type => Element_Type);
      end Cursors;
   end List_Adaptors;

   ------------------------------------------------
   -- Adaptor for indefinite doubly linked lists --
   ------------------------------------------------

   generic
      with package Lists is
         new Ada.Containers.Indefinite_Doubly_Linked_Lists (<>);
   package Indefinite_List_Adaptors is
      subtype Element_Type is Lists.Element_Type;
      subtype List is Lists.List;
      subtype Cursor is Lists.Cursor;

      function First (Self : List) return Cursor
         renames Lists.First;
      function Element (Self : List; Position : Cursor) return Element_Type
         is (Lists.Element (Position));
      function Has_Element (Self : List; Position : Cursor) return Boolean
         is (Lists.Has_Element (Position));
      function Next (Self : List; Position : Cursor) return Cursor
         is (Lists.Next (Position));
      pragma Inline (Element, Has_Element, Next, First);

      package Cursors is
         package Constant_Forward is new Constant_Forward_Traits
            (Container    => List'Class,
             Cursor       => Cursor,
             Element_Type => Element_Type);
      end Cursors;
   end Indefinite_List_Adaptors;

   ------------------------
   -- Adaptor for arrays --
   ------------------------

   generic
      type Index_Type is (<>);
      type Element_Type is private;
      type Array_Type is array (Index_Type range <>) of Element_Type;
   package Array_Adaptors is
      function First (Self : Array_Type) return Index_Type is (Self'First);
      function Element
         (Self : Array_Type; Position : Index_Type) return Element_Type
         is (Self (Position));
      function Has_Element
         (Self : Array_Type; Position : Index_Type) return Boolean
         is (Position <= Self'Last);
      function Next
         (Self : Array_Type; Position : Index_Type) return Index_Type
         is (Index_Type'Succ (Position));
      pragma Inline (Element, Has_Element, Next, First);

      package Cursors is
         package Constant_Forward is new Constant_Forward_Traits
            (Container    => Array_Type,
             Cursor       => Index_Type,
             Element_Type => Element_Type);
      end Cursors;
   end Array_Adaptors;

end Conts.Cursors.Adaptors;