#lang racket
(require benchmark plot/pict)

(require "../../faster-miniKanren/mk.rkt")
(include "../../faster-miniKanren/numbers.scm")

(time
    (run 1 (p) (*o (build-num 255) (build-num 255) p))
)

; TODO: plot