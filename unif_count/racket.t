  $ export SILENT_UNIFICATIONS=1
  $ racket ../racket/mulo1.rkt --mul2x3
    ((0 1 1))
  unifications: 12

  $ racket ../racket/mulo1.rkt --mul3x3
    ((1 0 0 1))
  unifications: 173

  $ racket ../racket/mulo1.rkt --mul5x5
    ((1 0 0 1 1))
  unifications: 280
  $ racket ../racket/mulo1.rkt --mul127x127
  unifications: 133947
  $ racket ../racket/mulo1.rkt --mul255x255
  unifications: 543997
  $ racket ../racket/mulo1.rkt --exp3x5
  unifications: 342799
  $ racket ../racket/mulo1.rkt --exp7x2
  unifications: 299688
  $ racket ../racket/mulo1.rkt --logo243base3
  unifications: 44410
