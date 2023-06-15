open OCanren

[@@@ocaml.warnerror "-32"]

type config = { mutable unifications : int }

let config = { unifications = 0 }
let clear_unifications () = config.unifications <- 0
let incr_counter () = config.unifications <- config.unifications + 1
let pp = GT.show Std.List.logic (GT.show OCanren.logic @@ GT.show GT.int)
let r x = reify_in_empty (Std.List.reify OCanren.reify) x
let pp_int x = GT.show OCanren.logic (GT.show GT.int) (reify_in_empty OCanren.reify x)

let pp_list x =
  GT.show
    Std.List.logic
    (GT.show OCanren.logic @@ GT.show GT.int)
    (reify_in_empty (Std.List.reify OCanren.reify) x)
;;

let ( === ) a b st =
  Printf.printf "%s %s\n" (pp (r a)) (pp (r b));
  incr_counter ();
  (a === b) st
;;

(* let rec appendo a b ab st =
  Printf.printf "appendo %s %s %s\n" (pp (r a)) (pp (r b)) (pp (r ab));
  let open Std in
  conde
    [ a === nil () &&& (b === ab)
    ; fresh (h t tmp) (a === h % t) (ab === h % tmp) (appendo t b tmp)
    ]
    st
;; *)

let rec appendo a b ab st =
  Printf.printf "appendo %s %s %s\n" (pp (r a)) (pp (r b)) (pp (r ab));
  let open Std in
  conde
    [ a === nil () &&& (b === ab)
    ; Fresh.three (fun h t tmp ->
        (* Printf.printf
          "  app.fresh h=%s, t=%s, tmp=%s\n"
          (pp_int h)
          (pp_list t)
          (pp_list tmp); *)
        delay (fun () -> ?&[ a === h % t; ab === h % tmp; appendo t b tmp ]))
    ]
    st
;;

(* let rec reverso a b st =
  Printf.printf "reverso %s %s\n" (pp (r a)) (pp (r b));
  let open Std in
  conde
    [ a === nil () &&& (a === b)
    ; fresh (h t tmp) (a === h % t) (reverso t tmp) (appendo tmp !<h b)
    ]
    st
;; *)

let rec reverso a b st =
  Printf.printf "reverso %s %s\n" (pp (r a)) (pp (r b));
  let open Std in
  conde
    [ a === nil () &&& (a === b)
    ; Fresh.three (fun h t tmp ->
        (* Printf.printf
          "  rev.fresh h=%s, t=%s, tmp=%s\n"
          (pp_int h)
          (pp_list t)
          (pp_list tmp); *)
        delay (fun () -> ?&[ a === h % t; reverso t tmp; appendo tmp !<h b ]))
    ]
    st
;;

let example1 () =
  run
    q
    (fun q -> reverso (Std.list Fun.id [ !!0; !!1 ]) q)
    (fun rr -> rr#reify (Std.List.reify OCanren.reify))
  |> Stream.take ~n:1
  |> ignore
;;

let example2 () =
  run
    q
    (fun q -> reverso q (Std.list Fun.id [ !!0; !!1 ]))
    (fun rr -> rr#reify (Std.List.reify OCanren.reify))
  |> Stream.take ~n:1
  |> ignore
;;

let example3 () =
  run
    q
    (fun q -> reverso q (Std.list Fun.id [ !!0; !!1; !!2 ]))
    (fun rr -> rr#reify (Std.List.reify OCanren.reify))
  |> Stream.take ~n:1
  |> List.iteri (fun i xs ->
       Printf.printf
         "%d: %s\n"
         i
         (GT.show Std.List.logic (GT.show OCanren.logic @@ GT.show GT.int) xs))
;;

let example4 () =
  run
    q
    (fun q ->
      fresh
        (a b d)
        (q === Std.list Fun.id [ a; b; !!1; d ])
        (reverso q (Std.list Fun.id [ !!0; !!1; !!2; !!3 ])))
    (fun rr -> rr#reify (Std.List.reify OCanren.reify))
  |> Stream.take ~n:1
  |> List.iteri (fun i xs ->
       Printf.printf
         "%d: %s\n"
         i
         (GT.show Std.List.logic (GT.show OCanren.logic @@ GT.show GT.int) xs))
;;

let () =
  let wrap name f =
    ( "-" ^ name
    , Arg.Unit
        (fun () ->
          clear_unifications ();
          f ())
    , "" )
  in
  Arg.parse
    [ wrap "ex1" example1; wrap "ex2" example2; wrap "ex3" example3; wrap "ex4" example4 ]
    (fun _ -> assert false)
    "";
  Printf.printf "unifications: %d\n" config.unifications
;;
