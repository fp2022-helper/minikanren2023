  $ export SILENT_UNIFICATIONS=1
  $ java -jar ../klogic/klogic.jar mul2x3
  (0, 1) * (1, 1)
  unifications: 19
  $ java -jar ../klogic/klogic.jar mul3x3
  (1, 1) * (1, 1)
  unifications: 222
  $ java -jar ../klogic/klogic.jar mul5x5
  (1, 0, 1) * (1, 0, 1)
  unifications: 384
  $ java -jar ../klogic/klogic.jar mul5x5-all
  (1, 0, 1) * (1, 0, 1)
  unifications: 386

  $ echo "obase=2;255*255" | bc
  1111111000000001
  $ java -jar ../klogic/klogic.jar mul127x127
  (1, 1, 1, 1, 1, 1, 1) * (1, 1, 1, 1, 1, 1, 1)
  unifications: 220986
  $ java -jar ../klogic/klogic.jar mul255x255
  (1, 1, 1, 1, 1, 1, 1, 1) * (1, 1, 1, 1, 1, 1, 1, 1)
  unifications: 894219

TODO: expo 255^2

  $ java -jar ../klogic/klogic.jar logo8base2
  log (0, 0, 0, 1) base (0, 1) with reminder ()
  unifications: 178
  $ java -jar ../klogic/klogic.jar logo243base3
  log (1, 1, 0, 0, 1, 1, 1, 1) base (1, 1) with reminder ()
  unifications: 74042

  $ java -jar ../klogic/klogic.jar exp2x3
  (0, 1)^(1, 1)
  unifications: 121
  $ java -jar ../klogic/klogic.jar exp3x5
  (1, 1)^(1, 0, 1)
  (1, 1, 0, 0, 1, 1, 1, 1)
  unifications: 823212
  $ java -jar ../klogic/klogic.jar exp7x2
  (1, 1, 1)^(0, 1)
  (1, 0, 0, 0, 1, 1)
  unifications: 385752
