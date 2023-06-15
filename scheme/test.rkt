#lang racket
(require benchmark plot/pict)

(require "../faster-miniKanren/mk.rkt")
(require "../faster-miniKanren/numbers.rkt")

; (time
;     (run 1 (p) (*o (build-num 255) (build-num 255) p)))
; (time
;     (run 1 (p) (*o (build-num 127) (build-num 127) p)))
; (time
;     (run 1 (p) (logo (build-num 243) (build-num 3) p (build-num 0))))
; (time
;     (run 1 (p) (expo (build-num 3) (build-num 5) p)))
; (time
;     (run 1 (p) (expo (build-num 7) (build-num 2) p)))


