------------------------------------------------------------------------------
--                     Copyright (C) 2016, AdaCore                          --
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

pragma Ada_2012;
with Ada.Calendar;       use Ada.Calendar;
with Ada.Text_IO;        use Ada.Text_IO;
with Graph1_Support;     use Graph1_Support;
with Conts.Graphs.DFS;

procedure Graph1 is
   procedure Search is new Conts.Graphs.DFS.Search_From_Vertex
      (Custom_Graphs, My_Visitor, Set_Color, Get_Color);
   --  ??? We could avoid this instantiation if DFS_Visitor was defined in
   --  Conts.Graphs.Traits directly.

   procedure Search is new Conts.Graphs.DFS.Search_From_Vertex
      (Custom_Graphs, My_Visitor2, Set_Color, Get_Color);

   V     : My_Visitor;
   V2    : My_Visitor2;
   G     : Graph;
   Start : Time;
begin
   Start := Clock;
   Search (G, V, 3);
   Put_Line ("No visitor: " & Duration'Image (Clock - Start));

   Start := Clock;
   Search (G, V2, 3);
   Put_Line ("visitor: " & Duration'Image (Clock - Start));
end Graph1;