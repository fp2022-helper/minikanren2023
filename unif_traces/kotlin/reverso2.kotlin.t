TODO: Why no answers?
  $ java -jar ../../klogic/klogic.jar reverso2
  reverso: _.0 (1, 2)
  _.0 ()
  _.0 (1, 2)
  _.0 (_.0, _.1)
  Exception in thread "main" java.lang.IndexOutOfBoundsException: Index 0 out of bounds for length 0
  	at java.base/jdk.internal.util.Preconditions.outOfBounds(Preconditions.java:64)
  	at java.base/jdk.internal.util.Preconditions.outOfBoundsCheckIndex(Preconditions.java:70)
  	at java.base/jdk.internal.util.Preconditions.checkIndex(Preconditions.java:266)
  	at java.base/java.util.Objects.checkIndex(Objects.java:361)
  	at java.base/java.util.ArrayList.get(ArrayList.java:427)
  	at ReversoTest.testReverso2(ReversoTest.kt:36)
  	at TestRunnerKt$tasks$4.invoke(TestRunner.kt:7)
  	at TestRunnerKt$tasks$4.invoke(TestRunner.kt:7)
  	at TestRunnerKt.main(TestRunner.kt:35)
  [1]
