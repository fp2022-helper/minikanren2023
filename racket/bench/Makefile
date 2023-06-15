numero_bench.exe: numero_bench.rkt
	raco exe -v --cs -o $@ $^

mul255x255.exe: mul255x255.rkt
	raco exe -v --cs -o $@ $^

.PHONY: numero_bench_racket.sexp
numero_bench_racket.sexp: numero_bench.exe
	@/usr/bin/time -f "%U" $(RM) $@   # %U means secodnds
	./$^

#quines.so: quines.scm
#echo '(compile-file "quines.scm")' | scheme -q

#quines.chez.sexp: quines.so
#scheme --program $^

clean:
	$(RM) numero_bench_racket.sexp numero_bench.exe
