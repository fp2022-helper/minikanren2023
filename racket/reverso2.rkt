#lang racket
(require benchmark plot/pict racket/vector racket/list)
(require pretty-format)
(require macro-debugger/expand)

(require "mk.rkt")
(require "debug_stuff.rkt")

(define === (lambda (a b)
  (lambda (st)
    (begin
      (incr_counter)
      (pretty-printf "~a  ~a\n" (pp a) (pp b))
      ((== a b) st)))
))

(define appendo (lambda (a b ab)
  (lambda (st)
  (begin
    (pretty-printf "appendo: ~a ~a ~a\n" (pp a) (pp b) (pp ab))
    ((conde
      ( (=== a '())
        (=== b ab)  )
      ((fresh (h t tmp)
         (=== a  `(,h . ,t)   )
         (=== ab `(,h . ,tmp) )
         (appendo t b tmp)))) st)
         )
)))

(define reverso (lambda (ab ba)
  (lambda (st)
    (begin
      (pretty-printf "reverso: ~a ~a\n" (pp ab) (pp ba))
      ((conde
        ( (=== ab '())
          (=== ab ba)  )
        ((fresh (h t tmp)
          (=== ab `(,h . ,t)   )
          (reverso t tmp)
          (appendo tmp `(,h) ba)))) st)
          )
)))

(run 1 (q) (reverso q '(0 1)))
(report_counters)
