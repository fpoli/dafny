// Generating tests:
// RUN: cp TestGeneration.dfy %t.dfy
// RUN: %dafny /definiteAssignment:3 /generateTestMode:Block %t.dfy > %t-tests.dfy

// Compiling test to java:
// RUN: cd Output; %dafny /compileTarget:java %t-tests.dfy; cd ../

// Adding reflection code that allows running the tests:
// RUN: perl -pe 's/import M_Compile.*;/`cat import.txt`/ge' -i %t-tests-java/TestGenerationUnitTests_Compile/__default.java
// RUN: perl -pe 's/public class __default {/`cat reflectionCode.txt`/ge' -i %t-tests-java/TestGenerationUnitTests_Compile/__default.java

// Compiling to bytecode and running the tests
// RUN: javac -cp %t-tests-java:../../Binaries/DafnyRuntime.jar %t-tests-java/TestGenerationUnitTests_Compile/__default.java
// RUN: java -cp %t-tests-java:../../Binaries/DafnyRuntime.jar TestGenerationUnitTests_Compile/__default > %t
// RUN: %diff "%s.expect" "%t"

module M {
  class Value {
    var v:int;
  }
  method compareToZero(v:Value) returns (i:int) {
    if (v.v == 0) {
      return 0;
    } else if (v.v > 0) {
      return 1;
    }
    return -1;
  }
}
