  $ ../../ocaml/reverso.exe -ex1
  reverso [0; 1] _.0
  [0; 1] []
  [0; 1] [_.1 | _.2]
  reverso _.2 _.3
  _.2 []
  _.2 [_.4 | _.5]
  reverso _.5 _.6
  _.5 []
  _.5 _.6
  appendo _.6 [_.4] _.3
  _.6 []
  [_.4] _.3
  appendo _.3 [_.1] _.0
  _.5 [_.7 | _.8]
  _.3 []
  _.6 [_.10 | _.11]
  _.3 [_.13 | _.14]
  _.0 [_.13 | _.15]
  appendo _.14 [_.1] _.15
  _.14 []
  [_.1] _.15
  unifications: 15

$ cat <<EOF > a.ml
> let rec appendo a b ab =
>   conde
>   [
>     a === nil () &&& (b === ab);
>     fresh (h t tmp) (a === h % t) (ab === h % tmp) (appendo t b tmp);
>   ]
> EOF

$ ./rewriter.exe a.ml
