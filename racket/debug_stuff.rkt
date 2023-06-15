#lang racket
(require "mk.rkt")


(provide
  clear_counters
  incr_counter
  report_counters
  pp
  )

(define unification_counter 0)
(define clear_counters  (lambda ()
  (set! unification_counter 0) ))
(define incr_counter    (lambda ()
  (set! unification_counter (+ 1 unification_counter)) ))
(define report_counters (lambda ()
  (printf "unifications: ~a\n" unification_counter) ))

; This is a specializaed walk which doesn't do any walkng, only pretty-printing.
(define pp (lambda (v)
  (cond
    ((var? v) (string-append "_" "." (number->string (var-idx v))))
    ((pair? v) (cons (pp (car v)) (pp (cdr v))) )
    (else v))
))
