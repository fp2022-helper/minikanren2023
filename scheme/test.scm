(eval-when (compile) (optimize-level 3))

(include "../faster-miniKanren/mk-vicare.scm")
(include "../faster-miniKanren/mk.scm")
;(include "../faster-miniKanren/chez.scm")
(include "../faster-miniKanren/numbers.scm")

(printf "warmup ~a\n"
    (run 1 (p) (*o (build-num 255) (build-num 255) p)))
(define time_acc 0.0)
(define iter (lambda (n f)
  (cond
    ((= n 0) (void) )
    (else
      (let ((tbegin (real-time)))
      (let ( (ans (f)) )
        ;(printf "~a\n" ans)
      (let ((tend (real-time)))
        (set! time_acc (+ time_acc (- tend tbegin)))
        (iter (- n 1) f)
      )))))))

(define avg (lambda (name n f)
    (set! time_acc 0.0)
    (collect)
    (iter n f)
    (printf "~a: ~a(s)\n" name (/ time_acc (* n 1000)))
))

(avg "mul255x255" 10
    (lambda ()
        (run 1 (p) (*o (build-num 255) (build-num 255) p))))

(avg "mul127x127" 10
    (lambda ()
        (run 1 (p) (*o (build-num 127) (build-num 127) p))))

(avg "log243base3" 10
    (lambda ()
        (run 1 (p) (logo (build-num 243) (build-num 3) p (build-num 0)))))

(avg "exp3^5" 10
    (lambda ()
        (run 1 (p) (expo (build-num 3) (build-num 5) p)) ))

(avg "exp7^2" 10
    (lambda ()
        (run 1 (p) (expo (build-num 7) (build-num 2) p)) ))
