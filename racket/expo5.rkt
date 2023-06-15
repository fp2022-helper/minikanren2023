#lang racket
(require benchmark plot/pict racket/vector racket/list)
(require pretty-format)
(require macro-debugger/expand)

(require "mk.rkt")
(require "debug_stuff.rkt")

(require "numbers.rkt")

(define base 3)
(define power 2)

(pretty-printf "~a^~a\n" base power)

(run 1 (q)
  (expo (build-num base) (build-num power) q))

(report_counters)
