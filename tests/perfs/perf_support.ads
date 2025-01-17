--
--  Copyright (C) 2015-2016, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

pragma Ada_2012;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Report;                use Report;
with System;

package Perf_Support is

   --------------------
   -- Unary functors --
   --------------------
   --  These packages provide objects that act like functions, except it is
   --  possible to store data in them. They can thus be used to write
   --  accumulators, or to curry binary functions into unary functions.

   generic
      type Param is private;
      type Ret is private;
   package Unary_Functors is
      --  Define the types so that we can access the generic formals from an
      --  instance of this package.
      subtype Param_Type is Param;
      subtype Returned_Type is Ret;

      type Obj is interface;
      function Call (Self : Obj; P : Param) return Ret is abstract;
   end Unary_Functors;

   generic
      with package F is new Unary_Functors (others => <>);
      with function Call (P : F.Param_Type) return F.Returned_Type;
   package Unary_Functions is
      package Functors renames F;

      type Obj is new F.Obj with null record;
      overriding function Call
         (Self : Obj; P : F.Param_Type) return F.Returned_Type
         is (Call (P));

      Make : constant Obj := (null record);
   end Unary_Functions;

   --------------------
   -- Using generics --
   --------------------

   generic
      type Param1 is private;
      type Param2 is private;
      type Ret is private;
      with function Call (P : Param1; Q : Param2) return Ret;
   package Binary_Functions is
      --  Define the types so that we can access the generic formals from an
      --  instance of this package.
      subtype Param1_Type is Param1;
      subtype Param2_Type is Param2;
      subtype Returned_Type is Ret;
   end Binary_Functions;

   generic
      type Param1 is private;
      type Param2 is private;
      B : Param2;
      type Ret is private;
      with function Call (P : Param1; Q : Param2) return Ret;
   package Binder2nd is
      --  Define the types so that we can access the generic formals from an
      --  instance of this package.
      subtype Param1_Type is Param1;
      subtype Param2_Type is Param2;
      subtype Returned_Type is Ret;

      function Binder_Call (P : Param1_Type) return Returned_Type
         is (Call (P, B));
      --  package Funcs is new Unary_Functors
      --     (Param => Param1_Type,
      --      Ret   => Returned_Type,
      --      Call  => Binder_Call);
   end Binder2nd;
   --  ??? Not the same as in C++ STL: since we do not have a class, there is
   --  no constructor to pass the value of the constant, which is therefore
   --  part of the generic formals, so we need a different instantiation for
   --  every possible value we might want for B.

   -----------
   -- Tests --
   -----------

   Items_Count : constant := 200_000;  -- untyped, for standard containers
   Integer_Items_Count : constant Integer := Items_Count;
   pragma Export (C, Integer_Items_Count, "items_count");
   --  For some reason, using 600_000 results in a storage error when
   --  allocating the bounded limited containers (but not the Ada arrays)

   Repeat_Count : constant Natural := 5;
   pragma Export (C, Repeat_Count, "repeat_count");
   --  Number of times that tests should be repeated

   function Predicate (P : Integer) return Boolean is (P <= 2)
      with Inline;
   function Predicate (P : String) return Boolean is (P (P'First) = 'f')
      with Inline;
   function Predicate (P : Unbounded_String) return Boolean is
      (Element (P, 1) = 'f')
      with Inline;
   procedure Assert (Count, Expected : Natural; Reason : String := "")
      with Inline;

   function Image (P : Integer) return String with Inline;

   procedure Test_Cpp_Int_List (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_int_list";
   procedure Test_Cpp_Str_List (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_str_list";
   procedure Test_Cpp_Int_Vector (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_int_vector";
   procedure Test_Cpp_Str_Vector (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_str_vector";
   procedure Test_Cpp_Str_Str_Map (Stdout : System.Address)
     with Import, Convention => C, External_Name => "test_cpp_str_str_map";
   procedure Test_Cpp_Str_Str_Unordered_Map (Stdout : System.Address)
     with Import, Convention => C,
          External_Name => "test_cpp_str_str_unordered_map";
   procedure Test_Cpp_Int_Int_Map (Stdout : System.Address)
     with Import, Convention => C, External_Name => "test_cpp_int_int_map";
   procedure Test_Cpp_Int_Int_Unordered_Map (Stdout : System.Address)
     with Import, Convention => C,
          External_Name => "test_cpp_int_int_unordered_map";
   --  Perform C++ testing

   procedure Test_Arrays_Int (Stdout : not null access Output'Class);
   --  Test standard Ada arrays

end Perf_Support;
