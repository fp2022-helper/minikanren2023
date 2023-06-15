  $ ../../ocaml/appendo.exe --app01+23
  fun q ->
    appendo (Std.list Fun.id [!! 0; !! 1]) (Std.list Fun.id [!! 2; !! 3]) q
  appendo: [0; 1] [2; 3] _.0
  [0; 1] []
  [0; 1] [_.1 | _.2]
  _.0 [_.1 | _.3]
  appendo: _.2 [2; 3] _.3
  _.2 []
  _.2 [_.4 | _.5]
  _.3 [_.4 | _.6]
  appendo: _.5 [2; 3] _.6
  _.5 []
  [2; 3] _.6
    0:	[0; 1; 2; 3]
  unifications: 8
