#lang racket
(require pretty-format macro-debugger/expand)

(require "mk.rkt")

(require "debug_stuff.rkt")

(provide *o build-num zeroo poso >1o expo logo)

(define trace_after_reify (lambda (x st)
  (pp (walk* x (state-S st)))
))
(define === (lambda (a b [msg ""])
  ; (pretty-printf "partially applied unification ~a\n" msg)
  (lambda (st)
    (begin
      (incr_counter)
      (unless (getenv "SILENT_UNIFICATIONS")
        (pretty-printf "~a ~a, ~a\n" (trace_after_reify a st) (trace_after_reify b st) msg))
      ((== a b) st)))
))

(defrel (appendo l s out)
  (conde
    [(=== l '()) (=== s out)]
    [(fresh (a d res)
       (=== `(,a . ,d) l)
       (=== `(,a . ,res) out)
       (appendo d s res))]))

; (defrel (appendo l s out)
;   (lambda (st)
;     (lambda ()
;       (let ((st (state-with-scope st (new-scope))))
;         (mplus
;           (bind ((=== l '()) st) (=== s out))
;           (lambda ()
;             ((lambda (st)
;               (lambda ()
;                 (let ((scope (subst-scope (state-S st))))
;                 (let ((a (var scope)) (d (var scope)) (res (var scope)))
;                 (bind
;                 (bind ((=== `(,a . ,d) l) st) (=== `(,a . ,res) out))
;                 (appendo d s res))))))
;                 st))))))
;                 )


(define build-num
  (lambda (n)
    (cond
      ((odd? n)
       (cons 1
         (build-num (quotient (- n 1) 2))))
      ((and (not (zero? n)) (even? n))
       (cons 0
         (build-num (quotient n 2))))
      ((zero? n) '()))))

(defrel (zeroo n)
  (=== '() n))

(defrel (poso n)
  (fresh (a d)
    (== `(,a . ,d) n)))

(defrel (>1o n)
  (fresh (a ad dd)
    (== `(,a ,ad . ,dd) n)))

; (defrel (poso n)
;   (lambda (st)
;     (lambda ()
;       (let ((scope (subst-scope (state-S st))))
;         (let ((a (var scope)) (d (var scope)))
;           (pretty-printf "  a = ~a, d = ~a POSO\n"
;               (trace_after_reify a st)
;               (trace_after_reify d st) )
;           ((=== n `(,a . ,d) "poso") st))))))

; (defrel (>1o n)
;   (lambda (st)
;     (lambda ()
;       (let ((scope (subst-scope (state-S st))))
;         (let ((a (var scope)) (ad (var scope)) (dd (var scope)))
;           (pretty-printf "  a = ~a, ad = ~a, dd = ~a gt1o\n"
;               (trace_after_reify a st)
;               (trace_after_reify ad st)
;               (trace_after_reify dd st) )
;           ((=== n `(,a ,ad . ,dd) "gt1o") st)))))
; )

(defrel (full-addero b x y r c)
  (conde
    ((=== 0 b) (=== 0 x) (=== 0 y) (=== 0 r) (=== 0 c))
    ((=== 1 b) (=== 0 x) (=== 0 y) (=== 1 r) (=== 0 c))
    ((=== 0 b) (=== 1 x) (=== 0 y) (=== 1 r) (=== 0 c))
    ((=== 1 b) (=== 1 x) (=== 0 y) (=== 0 r) (=== 1 c))
    ((=== 0 b) (=== 0 x) (=== 1 y) (=== 1 r) (=== 0 c))
    ((=== 1 b) (=== 0 x) (=== 1 y) (=== 0 r) (=== 1 c))
    ((=== 0 b) (=== 1 x) (=== 1 y) (=== 0 r) (=== 1 c))
    ((=== 1 b) (=== 1 x) (=== 1 y) (=== 1 r) (=== 1 c))))

; (defrel (full-addero b x y r c)
; (lambda (st)
;   (pretty-printf "\tfull_addero ~a ~a ~a ~a ~a (REIFIED)\n"
;       (trace_after_reify b st)
;       (trace_after_reify x st)
;       (trace_after_reify y st)
;       (trace_after_reify r st)
;       (trace_after_reify c st) )
;   (lambda ()
;     (display "  full_addero after pause 1\n")
;     (let ((st (state-with-scope st (new-scope))))
;       (mplus
;        (bind
;         (bind (bind (bind ((=== 0 b) st) (=== 0 x)) (=== 0 y)) (=== 0 r))
;         (=== 0 c))
;        (lambda ()
;          (display "  full_addero after pause 2\n")
;          (mplus
;           (bind
;            (bind (bind (bind ((=== 1 b) st) (=== 0 x)) (=== 0 y)) (=== 1 r))
;            (=== 0 c))
;           (lambda ()
;             (display "  full_addero after pause 3\n") 
;             (mplus
;              (bind
;               (bind (bind (bind ((=== 0 b) st) (=== 1 x)) (=== 0 y)) (=== 1 r))
;               (=== 0 c))
;              (lambda ()
;                (display "  full_addero after pause 4\n")
;                (mplus
;                 (bind
;                  (bind
;                   (bind (bind ((=== 1 b) st) (=== 1 x)) (=== 0 y))
;                   (=== 0 r))
;                  (=== 1 c))
;                 (lambda ()
;                   (display "  full_addero after pause 5\n")
;                   (mplus
;                    (bind
;                     (bind
;                      (bind (bind ((=== 0 b) st) (=== 0 x)) (=== 1 y))
;                      (=== 1 r))
;                     (=== 0 c))
;                    (lambda ()
;                      (display "  full_addero after pause 6\n")
;                      (mplus
;                       (bind
;                        (bind
;                         (bind (bind ((=== 1 b) st) (=== 0 x)) (=== 1 y))
;                         (=== 0 r))
;                        (=== 1 c))
;                       (lambda ()
;                         (display "  full_addero after pause 7\n")
;                         (mplus
;                          (bind
;                           (bind
;                            (bind (bind ((=== 0 b) st) (=== 1 x)) (=== 1 y))
;                            (=== 0 r))
;                           (=== 1 c))
;                          (lambda ()
;                            (display "  full_addero after pause 8\n")
;                            (bind
;                             (bind
;                              (bind (bind ((=== 1 b) st) (=== 1 x)) (=== 1 y))
;                              (=== 1 r))
;                             (=== 1 c)))))))))))))))))))
; )

; Adds a carry-in bit [d] to arbitrarily large numbers [n] and [m] to produce a number [r].
(defrel (addero d n m r)
  (conde
    ((=== 0 d) (=== '() m) (=== n r))
    ((=== 0 d) (=== '() n) (=== m r)
     (poso m))
    ((=== 1 d) (=== '() m)
     (addero 0 n '(1) r))
    ((=== 1 d) (=== '() n) (poso m)
     (addero 0 '(1) m r))
    ((=== n '(1)) (=== m '(1))
     (fresh (a c)
       (=== `(,a ,c) r)
       (full-addero d 1 1 a c)))
    ((=== n '(1)) (gen-addero d n m r))
    ((=== m '(1)) (>1o n) (>1o r)
     (addero d '(1) n r))
    ((>1o n) (gen-addero d n m r))))

; (defrel (addero d n m r)
;   (lambda (st)
;     (lambda ()
;       (display "  addero after 1st pause\n")
;       (let ((st (state-with-scope st (new-scope))))
;         (mplus
;         (bind
;           (bind ((=== 0 d 50 ) st) (=== '() m 51))
;           (=== n r 52))
;         (lambda ()
;           (display "  addero after 2nd pause\n")
;           (mplus
;             (bind (bind (bind ((=== 0 d 53) st) (=== '() n 54)) (=== m r 55)) (poso m))
;             (lambda ()
;           (display "  addero after 3rd pause\n")
;               (mplus
;               (bind (bind ((=== 1 d 56) st) (=== '() m)) (addero 0 n '(1) r))
;               (lambda ()
;                 (display "  addero after 4th pause\n")
;                 (mplus
;                   (bind
;                     (bind (bind ((=== 1 d) st) (=== '() n 59)) (poso m))
;                     (addero 0 '(1) m r))
;                   (lambda ()
;                     (display "  addero after 5th pause\n")
;                     (mplus
;                     (bind
;                       (bind ((=== n '(1)  60) st) (=== m '(1)  61))
;                       (lambda (st)
;                         (lambda ()
;                           (display "  addero after 6th pause\n")
;                           (let ((scope (subst-scope (state-S st))))
;                             (let ((a (var scope)) (c (var scope)))
;                               (bind
;                               ((=== `(,a ,c) r 62) st)
;                               (full-addero d 1 1 a c)))))))
;                     (lambda ()
;                       (display "  addero after 7th pause\n")
;                       (mplus
;                         (bind ((=== n '(1) 63) st) (gen-addero d n m r))
;                         (lambda ()
;                           (display "  addero after 8th pause\n")
;                           (mplus
;                             (bind
;                               (bind
;                                 (bind
;                                   ((=== m '(1) 64) st) (>1o n))
;                                   (>1o r))
;                               (addero d '(1) n r))
;                             (lambda ()
;                               (display "  addero after 9th pause\n")
;                               (bind
;                                 ((>1o n) st)
;                                 (gen-addero d n m r)))))))))))))))))))
; )

(defrel (gen-addero d n m r)
  (fresh (a b c e x y z)
    (=== `(,a . ,x) n)
    (=== `(,b . ,y) m) (poso y)
    (=== `(,c . ,z) r) (poso z)
    (full-addero d a b c e)
    (addero e x y z)))

; (defrel (gen-addero d n m r)
;   (lambda (st)
;     (lambda ()
;       (let ((scope (subst-scope (state-S st))))
;         (let ((a (var scope))
;               (b (var scope))
;               (c (var scope))
;               (e (var scope))
;               (x (var scope))
;               (y (var scope))
;               (z (var scope)))
;           (pretty-printf "  a = ~a, b = ~a, c = ~a, e = ~a, x = ~a, y = ~a, z = ~a gen_addero\n"
;             (trace_after_reify a st)
;             (trace_after_reify b st)
;             (trace_after_reify c st)
;             (trace_after_reify e st)
;             (trace_after_reify x st)
;             (trace_after_reify y st)
;             (trace_after_reify z st) )
;           (bind
;             (bind
;               (bind
;                 (bind
;                   (bind
;                     (bind ((=== `(,a . ,x) n 30) st) (=== `(,b . ,y) m 31))
;                     (poso y))
;                   (=== `(,c . ,z) r 32))
;                 (poso z))
;               (full-addero d a b c e))
;             (addero e x y z)))))))

(defrel (pluso n m k)
  (addero 0 n m k))

(defrel (minuso n m k)
  (pluso m k n))

(defrel (bound-*o q p n m)
  (conde
    ((=== q '()) (poso p))
    ((fresh (a0 a1 a2 a3 x y z)
       (=== q `(,a0 . ,x))
       (=== p `(,a1 . ,y))
       (conde
         ((=== n '())
          (=== m `(,a2 . ,z))
          (bound-*o x y z '()))
         ((=== n `(,a3 . ,z))
          (bound-*o x y z m)))))))

; (defrel (bound-*o q p n m)
; (lambda (st)
;   (pretty-printf "\tbound_multo ~a ~a ~a ~a (REIFIED)\n"
;       (trace_after_reify q st)
;       (trace_after_reify p st)
;       (trace_after_reify n st)
;       (trace_after_reify m st)  )
;   (lambda ()
;     (let ((st (state-with-scope st (new-scope))))
;       (mplus
;        (bind ((=== q '()) st) (poso p))
;        (lambda ()
;          ((lambda (st)
;             (lambda ()
;               (let ((scope (subst-scope (state-S st))))
;                 (let ((a0 (var scope)))
;                 (let ((a1 (var scope)))
;                 (let ((a2 (var scope)))
;                 (let ((a3 (var scope)))
;                 (let ((x (var scope)))
;                 (let ((y (var scope)))
;                 (let ((z (var scope)))
;                   (pretty-printf "  a0 = ~a, a1 = ~a, a2 = ~a, a3 = ~a BOUND_MULTO\n"
;                     (trace_after_reify a0 st)
;                     (trace_after_reify a1 st)
;                     (trace_after_reify a2 st)
;                     (trace_after_reify a3 st) )
;                   (bind
;                    (bind ((=== q `(,a0 . ,x) 20) st) (=== p `(,a1 . ,y) 21))
;                    (lambda (st)
;                      (lambda ()
;                        (let ((st (state-with-scope st (new-scope))))
;                          (mplus
;                           (bind
;                            (bind ((=== n '() 22 )   st) (=== m `(,a2 . ,z) 23 ))
;                            (bound-*o x y z '()))
;                           (lambda ()
;                             (bind
;                              ((=== n `(,a3 . ,z) 24) st)
;                              (bound-*o x y z m))))))))))))))))))
;           st))))))
; )

(defrel (*o n m p)
  (conde
    ((=== n '()) (=== p '()))
    ((poso n) (=== m '()) (=== p '()))
    ((=== n '(1)) (poso m) (=== m p))
    ((>1o n) (=== m '(1)) (=== n p))
    ((fresh (x z)
       (=== n `(0 . ,x)) (poso x)
       (=== p `(0 . ,z)) (poso z)
       (>1o m)
       (*o x m z)))
    ((fresh (x y)
       (=== n `(1 . ,x)) (poso x)
       (=== m `(0 . ,y)) (poso y)
       (*o m n p)))
    ((fresh (x y)
       (=== n `(1 . ,x)) (poso x)
       (=== m `(1 . ,y)) (poso y)
       (odd-*o x n m p)))))

; (defrel (*o n m p)
;   (lambda (st)
;     (pretty-printf "\tmulto ~a ~a ~a (REIFIED)\n"
;       (trace_after_reify n st)
;       (trace_after_reify m st)
;       (trace_after_reify p st))
;     (lambda ()
;       (display "\tmulto after 1st pause\n")
;       (let ((st (state-with-scope st (new-scope))))
;        (mplus
;         (bind ((=== n '() "1") st) (=== p '() "2"))
;         (lambda ()
;           (display "\tmulto after 2nd pause\n")
;           (mplus
;             (bind (bind ((poso n) st) (=== m '() "3") ) (=== p '() "4"))
;             (lambda ()
;               (mplus
;               (bind (bind ((=== n '(1) "5") st) (poso m)) (=== m p "6"))
;               (lambda ()
;                 (mplus
;                   (bind (bind ((>1o n) st) (=== m '(1) "7")) (=== n p "8"))
;                   (lambda ()
;                     (mplus
;                     ((lambda (st)
;                         (lambda ()
;                           (let ((scope (subst-scope (state-S st))))
;                             (let ((x (var scope)) (z (var scope)))
;                               (pretty-printf "  x = ~a, z = ~a\n"
;                                 (trace_after_reify x st)
;                                 (trace_after_reify z st) )
;                               (bind
;                               (bind
;                                 (bind
;                                 (bind
;                                   (bind ((=== n `(0 . ,x) "9") st) (poso x))
;                                   (=== p `(0 . ,z) "10"))
;                                 (poso z))
;                                 (>1o m))
;                               (*o x m z))))))
;                       st)
;                     (lambda ()
;                       (mplus
;                         ((lambda (st)
;                           (lambda ()
;                             (let ((scope (subst-scope (state-S st))))
;                               (let ((x (var scope)) (y (var scope)))
;                                 (pretty-printf "  x = ~a, y = ~a AAA\n"
;                                   (trace_after_reify x st)
;                                   (trace_after_reify y st) )
;                                 (bind
;                                   (bind
;                                   (bind
;                                     (bind ((=== n `(1 . ,x) "11") st) (poso x))
;                                     (=== m `(0 . ,y) "12"))
;                                   (poso y))
;                                   (*o m n p))))))
;                         st)
;                         (lambda ()
;                           ((lambda (st)
;                             (lambda ()
;                               (let ((scope (subst-scope (state-S st))))
;                                 (let ((x (var scope)) (y (var scope)))
;                                   (pretty-printf "  x = ~a, y = ~a BBB\n"
;                                     (trace_after_reify x st)
;                                     (trace_after_reify y st) )
;                                   (bind
;                                     (bind
;                                     (bind
;                                       (bind ((=== n `(1 . ,x) "13") st) (poso x))
;                                       (=== m `(1 . ,y) "14"))
;                                     (poso y))
;                                     (odd-*o x n m p))))))
;                           st))))))))))))))))
; )

(defrel (odd-*o x n m p)
  (fresh (q)
    (bound-*o q p n m)
    (*o x m q)
    (pluso `(0 . ,q) m p)))


; (defrel (odd-*o x n m p)
;   (lambda (st)
;     (pretty-printf "\todd_multo ~a ~a ~a ~a (REIFIED)\n"
;       (trace_after_reify x st)
;       (trace_after_reify n st)
;       (trace_after_reify m st)
;       (trace_after_reify p st))
;     (lambda ()
;       (let ((scope (subst-scope (state-S st))))
;         (let ((q (var scope)))
;           (bind
;             (bind ((bound-*o q p n m) st) (*o x m q))
;             (pluso `(0 . ,q) m p))))))
; )

; extra let
#| (defrel (odd-*o x n m p)
  (lambda (st)
    (pretty-printf "\todd_multo (REIFIED) ~a ~a ~a ~a\n"
      ((reify x) st) ((reify n) st) ((reify m) st) ((reify p) st))
    (lambda ()
      (let ((scope (subst-scope (state-S st))))
        (let ((q (var scope)))
        (let ([head ((bound-*o q p n m) st) ])
          (bind
            (bind head (*o x m q))
            (pluso `(0 . ,q) m p)))))))
) |#

; eqlo
(defrel (=lo n m)
  (conde
    ((=== n '()) (=== m '()))
    ((=== n '(1)) (=== m '(1)))
    ((fresh (a x b y)
       (=== `(,a . ,x) n) (poso x)
       (=== `(,b . ,y) m) (poso y)
       (=lo x y)))))

; ltlo -- [n] has smaller length than [m]
(defrel (<lo n m)
  (conde
    ((=== n '()) (poso m))
    ((=== n '(1)) (>1o m))
    ((fresh (a x b y)
       (=== `(,a . ,x) n) (poso x)
       (=== `(,b . ,y) m) (poso y)
       (<lo x y)))))

(defrel (<=lo n m)
  (conde
    ((=lo n m))
    ((<lo n m))))

; lto
(defrel (<o n m)
  (conde
    ((<lo n m))
    ((=lo n m)
     (fresh (x)
       (poso x)
       (pluso n x m)))))

(defrel (<=o n m)
  (conde
    ((=== n m))
    ((<o n m))))

(defrel (splito n r l h)
  (conde
    ((=== n '()) (=== h '()) (=== l '()))
    ((fresh (b n^)
       (=== `(0 ,b . ,n^) n)
       (=== r '())
       (=== h `(,b . ,n^))
       (=== l '())))
    ((fresh (n^)
       (=== n `(1 . ,n^))
       (=== r '())
       (=== n^ h)
       (=== l '(1))))
    ((fresh (b n^ a r^)
       (=== n `(0 ,b . ,n^))
       (=== `(,a . ,r^) r)
       (=== l '())
       (splito `(,b . ,n^) r^ '() h)))
    ((fresh (n^ a r^)
       (=== n `(1 . ,n^))
       (=== r `(,a . ,r^))
       (=== l '(1))
       (splito n^ r^ '() h)))
    ((fresh (b n^ a r^ l^)
       (=== n `(,b . ,n^))
       (=== r `(,a . ,r^))
       (=== l `(,b . ,l^))
       (poso l^)
       (splito n^ r^ l^ h)))))

(defrel (/o n m q r)
  (conde
    ((=== r n) (=== q '()) (<o n m))
    ((=== q '(1)) (=lo n m) (pluso r m n)
     (<o r m))
    ((<lo m n)
     (<o r m)
     (poso q)
     (fresh (nh nl qh ql qlm qlmr rr rh)
       (splito n r nl nh)
       (splito q r ql qh)
       (conde
         ((=== nh '())
          (=== qh '())
          (minuso nl r qlm)
          (*o ql m qlm))
         ((poso nh)
          (*o ql m qlm)
          (pluso qlm r qlmr)
          (minuso qlmr nl rr)
          (splito rr r '() rh)
          (/o nh m qh rh)))))))

(defrel (repeated-mul n q nq)
  (conde
    ((poso n) (=== q '()) (=== nq '(1)))
    ((=== q '(1)) (=== n nq))
    ((>1o q)
     (fresh (q1 nq1)
       (pluso q1 '(1) q)
       (repeated-mul n q1 nq1)
       (*o nq1 n nq)))))

(defrel (exp2 n b q)
  (conde
    ((=== n '(1)) (=== q '()))
    ((>1o n) (=== q '(1))
     (fresh (s)
       (splito n b s '(1))))
    ((fresh (q1 b2)
       (=== q `(0 . ,q1))
       (poso q1)
       (<lo b n)
       (appendo b `(1 . ,b) b2)
       (exp2 n b2 q1)))
    ((fresh (q1 nh b2 s)
       (=== q `(1 . ,q1))
       (poso q1)
       (poso nh)
       (splito n b s nh)
       (appendo b `(1 . ,b) b2)
       (exp2 nh b2 q1)))))

(defrel (logo n b q r)
  (conde
    ((=== n '(1)) (poso b) (=== q '()) (=== r '()))
    ((=== q '()) (<o n b) (pluso r '(1) n))
    ((=== q '(1)) (>1o b) (=lo n b) (pluso r b n))
    ((=== q '(1)) (poso q) (pluso r '(1) n))
    ((=== b '()) (poso q) (=== r n))
    ((=== '(0 1) b)
     (fresh (a ad dd)
       (poso dd)
       (=== n `(,a ,ad . ,dd))
       (exp2 n '() q)
       (fresh (s)
         (splito n dd r s))))
    ((fresh (a ad add ddd)
       (conde
         ((=== '(1 1) b))
         ((=== `(,a ,ad ,add . ,ddd) b))))
     (<lo b n)
     (fresh (bw1 bw nw nw1 ql1 ql s)
       (exp2 b '() bw1)
       (pluso bw1 '(1) bw)
       (<lo q n)
       (fresh
         (q1 bwq1)
           (pluso q '(1) q1)
           (*o bw q1 bwq1)
           (<o nw1 bwq1))
       (exp2 n '() nw1)
       (pluso nw1 '(1) nw)
       (/o nw bw ql1 s)
       (pluso ql '(1) ql1)
       (<=lo ql q)
       (fresh
         (bql qh s qdh qd)
            (repeated-mul b ql bql)
            (/o nw bw1 qh s)
            (pluso ql qdh qh)
            (pluso ql qd q)
            (<=o qd qdh)
            (fresh
                (bqd bq1 bq)
                (repeated-mul b qd bqd)
                (*o bql bqd bq)
                (*o b bq bq1)
                (pluso bq r n)
                (<o n bq1)))))))

(defrel (expo b q n)
  (logo n b q '()))
