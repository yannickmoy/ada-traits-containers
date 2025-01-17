--
--  Copyright (C) 2015-2016, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

pragma Ada_2012;
with Ada.Unchecked_Deallocation;

package body Conts.Lists.Storage.Unbounded with SPARK_Mode => Off is

   procedure Unchecked_Free is new Ada.Unchecked_Deallocation
      (Node, Node_Access);

   --------------
   -- Allocate --
   --------------

   procedure Allocate
      (Self    : in out Nodes_Container'Class;
       Element : Elements.Stored_Type;
       N       : out Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      N := new Node;
      N.Element := Element;
   end Allocate;

   ------------------
   -- Release_Node --
   ------------------

   procedure Release_Node
      (Self : in out Nodes_Container'Class; N : in out Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      Unchecked_Free (N);
   end Release_Node;

   -----------------
   -- Get_Element --
   -----------------

   function Get_Element (Self : Nodes_Container'Class; N : Node_Access)
      return Elements.Stored_Type
   is
      pragma Unreferenced (Self);
   begin
      return N.Element;
   end Get_Element;

   --------------
   -- Get_Next --
   --------------

   function Get_Next
      (Self : Nodes_Container'Class; N : Node_Access) return Node_Access
   is
      pragma Unreferenced (Self);
   begin
      return N.Next;
   end Get_Next;

   ------------------
   -- Get_Previous --
   ------------------

   function Get_Previous
      (Self : Nodes_Container'Class; N : Node_Access) return Node_Access
   is
      pragma Unreferenced (Self);
   begin
      return N.Previous;
   end Get_Previous;

   ------------------
   -- Set_Previous --
   ------------------

   procedure Set_Previous
      (Self : in out Nodes_Container'Class; N, Previous : Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      N.Previous := Previous;
   end Set_Previous;

   --------------
   -- Set_Next --
   --------------

   procedure Set_Next
      (Self : in out Nodes_Container'Class; N, Next : Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      N.Next := Next;
   end Set_Next;

   -----------------
   -- Set_Element --
   -----------------

   procedure Set_Element
     (Self : in out Nodes_Container'Class;
      N    : Node_Access;
      E    : Elements.Stored_Type)
   is
      pragma Unreferenced (Self);
   begin
      N.Element := E;
   end Set_Element;

   ------------
   -- Assign --
   ------------

   procedure Assign
      (Nodes    : in out Nodes_Container'Class;
       Source   : Nodes_Container'Class;
       New_Head : out Node_Access;
       Old_Head : Node_Access;
       New_Tail : out Node_Access;
       Old_Tail : Node_Access)
   is
      pragma Unreferenced (Source, Old_Tail);
      N, Tmp, Tmp2 : Node_Access;
   begin
      if Old_Head = null then
         New_Head := null;
         New_Tail := null;
         return;
      end if;

      Tmp2 := Old_Head;
      if Elements.Copyable then
         Allocate (Nodes, Tmp2.Element, Tmp);
      else
         Allocate (Nodes, Elements.Copy (Tmp2.Element), Tmp);
      end if;
      New_Head := Tmp;

      loop
         Tmp2 := Tmp2.Next;
         exit when Tmp2 = null;

         if Elements.Copyable then
            Allocate (Nodes, Tmp2.Element, N);
         else
            Allocate (Nodes, Elements.Copy (Tmp2.Element), N);
         end if;

         Tmp.Next := N;
         N.Previous := Tmp;
         Tmp := N;
      end loop;

      New_Tail := N;
   end Assign;

end Conts.Lists.Storage.Unbounded;
