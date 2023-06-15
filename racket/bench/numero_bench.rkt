#lang racket
(require benchmark plot/pict)

(require "../../faster-miniKanren/mk.rkt")
(include "../../faster-miniKanren/numbers.scm")

(pretty-print
    (run-benchmarks
        ; operations (whats)
        (list 'mul255x255
            'mul127x127 'log243base3 'exp3x5 'exp7x2
        )
        ; list of options (hows)
        (list)
        ; to run each benchmark
        (lambda (op)
            (match op
            ['mul255x255 (run 1 (p) (*o (build-num 255) (build-num 255) p))]
            ['mul127x127 (run 1 (p) (*o (build-num 127) (build-num 127) p))]
            ['log243base3 (run 1 (p) (logo (build-num 243) (build-num 3) p (build-num 0)))]
            ['exp3x5 (run 1 (p) (expo (build-num 3) (build-num 5) p))]
            ['exp7x2 (run 1 (p) (expo (build-num 7) (build-num 2) p))]
            ))
        ; don't extract time, instead time (run ...)
        #:extract-time 'delta-time
        #:num-trials 40 ; TODO: 40 is better
        #:results-file "numero_bench_racket.sexp"
    ))

; TODO: plot
