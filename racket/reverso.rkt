#lang racket
(require benchmark plot/pict racket/vector racket/list)
(require pretty-format)
(require macro-debugger/expand)
(require racket/cmdline)

(require "mk.rkt")
(require "debug_stuff.rkt")

(define === (lambda (a b)
  (lambda (st)
    (begin
      (incr_counter)
      (pretty-printf "~a ~a\n" (pp a) (pp b))
      ((== a b) st)))
))

(define appendo (lambda (a b ab)
    (conde
      ( (=== a '())
        (=== b ab)  )
      ((fresh (h t tmp)
         (=== a  `(,h . ,t)   )
         (=== ab `(,h . ,tmp) )
         (appendo t b tmp))) )))

(define reverso (lambda (a b)
    (conde
      ( (=== a '())
        (=== a b)  )
      ((fresh (h t tmp)
         (=== a  `(,h . ,t))
         (reverso t tmp)
         (appendo tmp `(,h) b))))
))
; (define reverso (lambda (a b)
; (lambda (st)
;   (lambda ()
;     (let-values (((st) (state-with-scope st (new-scope))))
;       (mplus
;         (bind
;           ((=== a '()) st)
;           (=== a b))
;         (lambda ()
;           (begin 
;             (pretty-printf "after second pause\n")
;            ((lambda (st)
;             (lambda ()
;               (let-values (((scope) (subst-scope (state-S st))))
;                 (pretty-printf "shit\n")
;                 (let-values
;                    (((h) (var scope))
;                     ((t) (var scope))
;                     ((tmp) (var scope)))
;                   (bind
;                     (bind
;                       ((=== a `(,h . ,t)) st)
;                       (reverso t tmp))
;                     (appendo tmp `(,h) b))))))
;             st)))))))))


(command-line
  #:program "compiler"
  #:once-each
  [("--app1") ""
      (begin
        (run 1 (q) (appendo '(0) '(1) q))
        (report_counters))]
  [("--app2") ""
      (begin
        (run 1 (q) (appendo '(0 1) '(2 3) q))
        (report_counters))]
  [("--rev0") ""
      (begin
        (run 1 (q) (reverso '(1) q))
        (report_counters))]
  [("--rev1") ""
      (begin
        (pretty-printf "~a\n"
          (run 1 (q) (reverso '(1 2) q))
        )
        (report_counters))]
  [("--rev2") ""
      (begin
        (pretty-printf "~a\n"
          (run 1 (q) (reverso q '(1 2)))
        )
        (report_counters))])

; ; appendo
; (pretty-printf "~a\n" (syntax->datum (expand
;   #'(conde
;       ( (=== a '())
;         (=== b ab)  )
;       ((fresh (h t tmp)
;          (=== a  `(,h . ,t)   )
;          (=== ab `(,h . ,tmp) )
;          (appendo t b tmp))) )
  
; )))
; ; reverso
; (pretty-printf "~a\n" (syntax->datum (expand
;   #'(conde
;       ( (=== a '())
;         (=== a b)  )
;       ((fresh (h t tmp)
;          (=== a  `(,h . ,t))
;          (reverso t tmp)
;          (appendo tmp `(,h) b))))
  
; )))