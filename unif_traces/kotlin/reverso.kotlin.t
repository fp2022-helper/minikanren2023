TODO: Why no answers?
  $ java -jar ../../klogic/klogic.jar reverso
  reverso: (1, 2) _.0
  (1, 2) ()
  (1, 2) (_.0, _.1)
  reverso: _.1 _.2
  _.1 ()
  _.1 (_.3, _.4)
  reverso: _.4 _.5
  _.4 ()
  _.4 _.5
  appendo: _.5 (_.3) _.2
  _.5 ()
  (_.3) _.2
  appendo: _.2 (_.0) _.0
  _.4 (_.6, _.7)
  _.2 ()
  _.5 (_.9, _.10)
  _.2 (_.12, _.13)
  _.0 (_.12, _.14)
  Exception in thread "main" java.lang.IndexOutOfBoundsException: Index 0 out of bounds for length 0
  	at java.base/jdk.internal.util.Preconditions.outOfBounds(Preconditions.java:64)
  	at java.base/jdk.internal.util.Preconditions.outOfBoundsCheckIndex(Preconditions.java:70)
  	at java.base/jdk.internal.util.Preconditions.checkIndex(Preconditions.java:266)
  	at java.base/java.util.Objects.checkIndex(Objects.java:361)
  	at java.base/java.util.ArrayList.get(ArrayList.java:427)
  	at ReversoTest.testReverso(ReversoTest.kt:25)
  	at TestRunnerKt$tasks$3.invoke(TestRunner.kt:6)
  	at TestRunnerKt$tasks$3.invoke(TestRunner.kt:6)
  	at TestRunnerKt.main(TestRunner.kt:35)
  [1]
