
# The Generic Ada Library for Algorithms and Containers

## Goals

This library is another containers library for Ada. Although it
provides containers that do not exist in the standard Ada
runtime (graphs for instance), it is more interesting for the
flexibility it proposes:

  - [X] Bounded/Unbounded containers and even more variants suitable
        for use with the SPARK language.

  - [X} Finite/Indefinite elements, and even more specialized
        variants optimized for specific types

  - [X} Pre and Post conditions, compatible with SPARK, so that some
        variants of the containers can be proven.

  - [X} Highly efficient; the user has full control over memory
        allocations, checks, locks, ...

All this flexibility is done via the intentive use of generic
packages, themselves used to instantiate other generic packages.

Check the documentation for more details on the design of the API,
and its current usage.

## Compiling

The library itself is pure Ada code, and only requires a working
compiler to be available in your environment.

This library comes with a testsuite which measures the performance
of the various variants of the containers, and compares them with
C++ equivalent (or near equivalents). This testsuite generates a
nice interactive HTML file.

Compiling and running the testsuite requires that you also have a
C++ compiler in your environment. In addition, you must install the
Boost Graph Library (http://www.boost.org).

Once this is done, modify the file
AdaCore/ada-traits-containers/src/shared.gpr@master to modify the

```
   Boost_Include := "/usr/include";
```

variable. Finally, compile and run the test with

```
make
```

and finally open the file AdaCore/ada-traits-containers/index.html
in a browser to view the performance comparison.