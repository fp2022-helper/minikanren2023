#lang racket
(require benchmark
         plot/pict
         racket/vector
         racket/list)
(require pretty-format)
(require macro-debugger/expand)

(require "mk.rkt")
(require "debug_stuff.rkt")

(require "numbers.rkt")

(command-line
 #:program "compiler"
 #:once-each 
 [("--mul1x1")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 1) (build-num 1) q)))
    (report_counters))]
 [("--mul1x2")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 1) (build-num 2) q)))
    (report_counters))]
 [("--mul2x3")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 2) (build-num 3) q)))
    (report_counters))]
 [("--mul3x3")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 3) (build-num 3) q)))
    (report_counters))]
 [("--mul4x4")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 4) (build-num 4) q)))
    (report_counters))]
 [("--mul3x5")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 3) (build-num 5) q)))
    (report_counters))]
 [("--mul5x3")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 5) (build-num 3) q)))
    (report_counters))]
 [("--mul5x4")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 5) (build-num 4) q)))
    (report_counters))]
 [("--mul5x5")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 5) (build-num 5) q)))
    (report_counters))]
 [("--mul5x6")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 5) (build-num 6) q)))
    (report_counters))]
 [("--mul7x7")
  ""
  (begin
    (pretty-printf "  ~a\n" (run 1 (q) (*o (build-num 7) (build-num 7) q)))
    (report_counters))]
 [("--mul127x127")
  ""
  (begin
    (run 1 (q) (*o (build-num 127) (build-num 127) q))
    (report_counters))]
 [("--mul255x255")
  ""
  (begin
    (run 1 (q) (*o (build-num 255) (build-num 255) q))
    (report_counters))]
  [("--exp2x3")
  ""
  (begin
    (run 1 (q) (expo (build-num 2) (build-num 3) q))
    (report_counters))]
 [("--exp3x2")
  ""
  (begin
    (run 1 (q) (expo (build-num 3) (build-num 2) q))
    (report_counters))]
 [("--exp3x5")
  ""
  (begin
    (run 1 (q) (expo (build-num 3) (build-num 5) q))
    (report_counters))]
 [("--exp7x2")
  ""
  (begin
    (run 1 (q) (expo (build-num 7) (build-num 2) q))
    (report_counters))]
 [("--logo243base3")
  ""
  (begin
    (run 1 (q) (expo (build-num 3) q (build-num 243) ))
    (report_counters))]
)

; (run 1 (q) (*o '(1 1) '(1 1) q))

; (report_counters)
