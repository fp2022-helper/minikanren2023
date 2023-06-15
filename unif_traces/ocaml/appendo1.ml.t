
  $ ../../ocaml/appendo.exe --app0+1
  fun q -> appendo (Std.list Fun.id [!! 0]) (Std.list Fun.id [!! 1]) q
  appendo: [0] [1] _.0
  [0] []
  [0] [_.1 | _.2]
  _.0 [_.1 | _.3]
  appendo: _.2 [1] _.3
  _.2 []
  [1] _.3
    0:	[0; 1]
  unifications: 5
