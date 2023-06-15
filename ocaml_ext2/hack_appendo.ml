open OCanren

[@@@ocaml.warnerror "-32"]

type config = { mutable unifications : int }

let config = { unifications = 0 }
let clear_unifications () = config.unifications <- 0
let incr_counter () = config.unifications <- config.unifications + 1

(*  *)
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

let rec appendo a b ab =
  (* Printf.printf "appendo %s %s %s\n" (pp (r a)) (pp (r b)) (pp (r ab)); *)
  let open Std in
  conde
    [ a === nil () &&& (b === ab)
    ; fresh (h t tmp) (a === h % t) (ab === h % tmp) (appendo t b tmp)
    ]
;;

(*  *)
(* let rec reverso a b =
  let open Std in
  conde
    [ a === nil () &&& (a === b)
    ; fresh (h t tmp) (a === h % t) (reverso t tmp) (appendo tmp !<h b)
    ]
;; *)
let rec reverso a b =
  let open Std in
  fun st ->
    pause (fun () ->
      let st = State.new_scope st in
      mplus
        (bind ((a === nil ()) st) (a === b))
        (pause (fun () ->
           print_endline "after second pause";
           (fun st ->
             pause (fun () ->
               print_endline "shit";
               let h = State.fresh st in
               let t = State.fresh st in
               let tmp = State.fresh st in
               bind (bind ((a === h % t) st) (reverso t tmp)) (appendo tmp !<h b)))
             st)))
;;

let wrap (msg, goal) =
  print_endline msg;
  run q goal (fun rr -> rr#reify (Std.List.reify OCanren.reify))
  |> Stream.take ~n:1
  |> List.iteri (fun i n ->
       Format.printf
         "%3d:\t%s\n%!"
         i
         (GT.show Std.List.logic (GT.show OCanren.logic @@ GT.show GT.int) n))
;;

let example1 () =
  wrap (REPR (fun q -> appendo (Std.list Fun.id [ !!0 ]) (Std.list Fun.id [ !!1 ]) q))
;;

let example2 () =
  wrap
    (REPR
       (fun q -> appendo (Std.list Fun.id [ !!0; !!1 ]) (Std.list Fun.id [ !!2; !!3 ]) q))
;;

let reverso0 () = wrap (REPR (fun q -> reverso (Std.list Fun.id [ !!1 ]) q))
let reverso1 () = wrap (REPR (fun q -> reverso (Std.list Fun.id [ !!1; !!2 ]) q))
let reverso2 () = wrap (REPR (fun q -> reverso q (Std.list Fun.id [ !!1; !!2 ])))

(* TODO: make double dashes, like in racket *)
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
    [ wrap "-app1" example1
    ; wrap "-app2" example2
    ; wrap "-rev0" reverso0
    ; wrap "-rev1" reverso1
    ; wrap "-rev2" reverso2
    ]
    (fun _ -> assert false)
    "";
  Printf.printf "unifications: %d\n" config.unifications
;;
