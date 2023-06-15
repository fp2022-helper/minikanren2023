.PHONY: test test_kotlin test_ocaml test_caml test_racket
PROMOTE ?=

.DEFAULT_GOAL := test

test_kotlin:
	dune b $(PROMOTE) \
		@appendo1.kotlin \
		@appendo2.kotlin \
		@reverso.kotlin \
		@expo1.kotlin \
		@logo1.kotlin \

test_racket:
	dune b $(PROMOTE) \
		@appendo1.rkt \
		@appendo2.rkt \

test_ocaml: test_caml
test_caml:
	dune b $(PROMOTE) \
		@appendo1.ml \
		@appendo2.ml \
		@expo1.ml \
		@logo1.ml \
		#@quines.ml \
		#@twines.ml \
		#@thrines.ml \

test: test_caml test_kotlin #test_racket

clean:
	dune clean
	$(RM) -r klogic/build


.PHONY: check 
CHARG ?= mul5x5	
check:
	dune exec ocaml_ext2/hack_numero.exe --display=quiet -- --$(CHARG) | tail -n +2 | nl -ba > ocaml.log && \
	racket racket/mulo1.rkt --$(CHARG) | nl -ba > racket.log && \
	grc diff -u ocaml.log racket.log

