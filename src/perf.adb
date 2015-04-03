with Ada.Text_IO;   use Ada.Text_IO;
with Perf_Support;  use Perf_Support;
with QGen;          use QGen;
with Report;        use Report;

procedure Perf is
begin
   Stdout.Show_Percent := True;

   Put_Line ("+--------- lists of integers");
   Stdout.Print_Header;
   Test_Cpp_Int;
   Test_Arrays_Int;
   Test_Ada2012_Int;
   Test_Ada2012_Int_Indefinite;
   Test_Tagged_Int;
   Test_Lists_Int;
   Test_Lists_Int_Indefinite;
   Test_Lists_Int_Indefinite_SPARK;
   Test_Lists_Bounded;
   Test_Lists_Bounded_Limited;
   Stdout.Reset;  ---  Stdout.Finish_Line to preserve percent

   New_Line;
   Put_Line ("+--------- lists of strings or std::string");
   Stdout.Print_Header;
   Test_Cpp_Str;
   Test_Ada2012_Str;
   Test_Lists_Str;
   Test_Lists_Str_Reference;
   Test_Lists_Str_Access;
   Stdout.Finish_Line;

   New_Line;
   Put_Line
      ("d/i: (in)definite b/u/s: (un)bounded/spark"
      & " (c/l): controlled/limited");
   Put_Line ("(1): slower because Iterable aspect needs primitive operations");
   Put_Line ("(2): Iterable does not support unconstrained elements");
   Put_Line ("(3): Using Stored_Element (less safe, user can free pointer)");
   Put_Line ("(4): Using Reference_Type (unconstrained type, slower)");

   Test_QGen;
end Perf;
