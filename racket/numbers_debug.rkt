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

; multo
(pretty-printf
 "~a\n"
 (syntax->datum
  (expand
   #'(conde ((=== n '()) (=== p '()))
            ((poso n) (=== m '()) (=== p '()))
            ((=== n '(1)) (poso m) (=== m p))
            ((>1o n) (=== m '(1)) (=== n p))
            ((fresh (x z) (=== n `(0 . ,x)) (poso x) (=== p `(0 . ,z)) (poso z) (>1o m) (*o x m z)))
            ((fresh (x y) (=== n `(1 . ,x)) (poso x) (=== m `(0 . ,y)) (poso y) (*o m n p)))
            ((fresh (x y) (=== n `(1 . ,x)) (poso x) (=== m `(1 . ,y)) (poso y) (odd-*o x n m p)))))))

; multo
(pretty-printf
 "\n\n~a\n"
 (syntax->datum
  (expand-only
   #'(conde ((=== n '()) (=== p '()))
            ((poso n) (=== m '()) (=== p '()))
            ((=== n '(1)) (poso m) (=== m p))
            ((>1o n) (=== m '(1)) (=== n p))
            ((fresh (x z) (=== n `(0 . ,x)) (poso x) (=== p `(0 . ,z)) (poso z) (>1o m) (*o x m z)))
            ((fresh (x y) (=== n `(1 . ,x)) (poso x) (=== m `(0 . ,y)) (poso y) (*o m n p)))
            ((fresh (x y) (=== n `(1 . ,x)) (poso x) (=== m `(1 . ,y)) (poso y) (odd-*o x n m p))))
   (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

#|
(pretty-printf "\n~a\n" (syntax->datum (expand-only
  #'(lambda (st)
    (lambda ()
      (let ((st (state-with-scope st (new-scope))))
        (mplus*
        (bind* ((=== n '()) st) (=== p '()))
        (bind* ((poso n) st) (=== m '()) (=== p '()))
        (bind* ((=== n '(1)) st) (poso m) (=== m p))
        (bind* ((>1o n) st) (=== m '(1)) (=== n p))
        (bind*
          ((lambda (st)
            (lambda ()
              (let ((scope (subst-scope (state-S st))))
                (let ((x (var scope)) (z (var scope)))
                  (bind*
                    ((=== n `(0 . ,x)) st)
                    (poso x)
                    (=== p `(0 . ,z))
                    (poso z)
                    (>1o m)
                    (*o x m z))))))
          st))
        (bind*
          ((lambda (st)
            (lambda ()
              (let ((scope (subst-scope (state-S st))))
                (let ((x (var scope)) (y (var scope)))
                  (bind*
                    ((=== n `(1 . ,x)) st)
                    (poso x)
                    (=== m `(0 . ,y))
                    (poso y)
                    (*o m n p))))))
          st))
        (bind*
          ((lambda (st)
            (lambda ()
              (let ((scope (subst-scope (state-S st))))
                (let ((x (var scope)) (y (var scope)))
                  (bind*
                    ((=== n `(1 . ,x)) st)
                    (poso x)
                    (=== m `(1 . ,y))
                    (poso y)
                    (odd-*o x n m p))))))
          st))))))
    (list #'bind* #'mplus*)
)))
 |#

; odd-multo
#| (pretty-printf "~a\n" (syntax->datum (expand-only
  #'(fresh (q)
    (bound-*o q p n m)
    (*o x m q)
    (pluso `(0 . ,q) m p))
  (list #'conde #'fresh #'suspend #'bind* #'mplus*)
))) |#

; bound_multo
(pretty-printf
 "~a\n"
 (syntax->datum
  (expand-only #'(conde ((=== q '()) (poso p))
                        ((fresh (a0 a1 a2 a3 x y z)
                                (=== q `(,a0 . ,x))
                                (=== p `(,a1 . ,y))
                                (conde ((=== n '()) (=== m `(,a2 . ,z)) (bound-*o x y z '()))
                                       ((=== n `(,a3 . ,z)) (bound-*o x y z m))))))
               (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; addero
(pretty-printf
 "\n~a\n"
 (syntax->datum
  (expand-only
   #'(conde ((=== 0 d) (=== '() m) (=== n r))
            ((=== 0 d) (=== '() n) (=== m r) (poso m))
            ((=== 1 d) (=== '() m) (addero 0 n '(1) r))
            ((=== 1 d) (=== '() n) (poso m) (addero 0 '(1) m r))
            ((=== '(1) n) (=== '(1) m) (fresh (a c) (=== `(,a ,c) r) (full-addero d 1 1 a c)))
            ((=== '(1) n) (gen-addero d n m r))
            ((=== '(1) m) (>1o n) (>1o r) (addero d '(1) n r))
            ((>1o n) (gen-addero d n m r)))
   (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; gen-addero
(pretty-printf "\n~a\n"
               (syntax->datum (expand-only #'(fresh (a b c e x y z)
                                                    (=== `(,a . ,x) n)
                                                    (=== `(,b . ,y) m)
                                                    (poso y)
                                                    (=== `(,c . ,z) r)
                                                    (poso z)
                                                    (full-addero d a b c e)
                                                    (addero e x y z))
                                           (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; full-addero
(pretty-printf
 "\n~a\n"
 (syntax->datum (expand-only #'(conde ((=== 0 b) (=== 0 x) (=== 0 y) (=== 0 r) (=== 0 c))
                                      ((=== 1 b) (=== 0 x) (=== 0 y) (=== 1 r) (=== 0 c))
                                      ((=== 0 b) (=== 1 x) (=== 0 y) (=== 1 r) (=== 0 c))
                                      ((=== 1 b) (=== 1 x) (=== 0 y) (=== 0 r) (=== 1 c))
                                      ((=== 0 b) (=== 0 x) (=== 1 y) (=== 1 r) (=== 0 c))
                                      ((=== 1 b) (=== 0 x) (=== 1 y) (=== 0 r) (=== 1 c))
                                      ((=== 0 b) (=== 1 x) (=== 1 y) (=== 0 r) (=== 1 c))
                                      ((=== 1 b) (=== 1 x) (=== 1 y) (=== 1 r) (=== 1 c)))
                             (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; poso
(pretty-printf "\n~a\n"
               (syntax->datum (expand-only #'(fresh (a d) (=== n `(,a . ,d) "poso"))
                                           (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; >1o
(pretty-printf "\n~a\n"
               (syntax->datum (expand-only #'(fresh (a ad dd) (=== n `(,a ,ad . ,dd) "gt1o"))
                                           (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; appendo
(pretty-printf
 "\n~a\n"
 (syntax->datum
  (expand-only
   #'(conde [(=== l '()) (=== s out)]
            [(fresh (a d res) (=== `(,a . ,d) l) (=== `(,a . ,res) out) (appendo d s res))])
   (list #'conde #'fresh #'suspend #'bind* #'mplus*))))

; run
(pretty-printf "\n~a\n"
               (syntax->datum (expand-only #'(run 1 (q) (*o (build-num 5) (build-num 5) q))
                                           (list #'run #'conde #'fresh #'suspend #'bind* #'mplus*))))
