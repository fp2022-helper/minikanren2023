  $ export SILENT_UNIFICATIONS=1
  $ ../ocaml/numero.exe --mul2x3
  multo (build_num 2) (build_num 3)
    0:	[0; 1; 1]
  unifications: 19

  $ ../ocaml/numero.exe --mul3x3
  multo (build_num 3) (build_num 3)
    0:	[1; 0; 0; 1]
  unifications: 227
  $ ../ocaml/numero.exe --mul5x5
  multo (build_num 5) (build_num 5)
    0:	[1; 0; 0; 1; 1]
  unifications: 379
  $ ../ocaml/numero.exe --mul5x5-all
  multo (build_num 5) (build_num 5)
    0:	[1; 0; 0; 1; 1]
  unifications: 386

  $ echo "obase=2;255*255" | bc
  1111111000000001

  $ ../ocaml/numero.exe --mul127x127
  multo (build_num 127) (build_num 127)
    0:	[1; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 1]
  unifications: 193469
  $ ../ocaml/numero.exe --mul255x255
  multo (build_num 255) (build_num 255)
    0:	[1; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 1; 1]
  unifications: 784097

TODO: expo 255^2

  $ ../ocaml/numero.exe --logo8base2
  fun q -> logo (build_num 8) (build_num 2) q (build_num 0)
    0:	[1; 1]
  unifications: 207
  $ ../ocaml/numero.exe --exp2x3
  expo (build_num 2) (build_num 3)
    0:	[0; 0; 0; 1]
  unifications: 133

  $ ../ocaml/numero.exe --exp3x5
  expo (build_num 3) (build_num 5)
    0:	[1; 1; 0; 0; 1; 1; 1; 1]
  unifications: 410259

  $ ../ocaml/numero.exe --exp7x2
  expo (build_num 7) (build_num 2)
    0:	[1; 0; 0; 0; 1; 1]
  unifications: 365455


  $ ../ocaml/numero.exe --logo243base3
  fun q -> logo (build_num 243) (build_num 3) q (build_num 0)
    0:	[1; 0; 1]
  unifications: 59618


