open OCanren
include Counters.Make ()

let pp = GT.show OCanren.logic @@ GT.show GT.int
let r x = reify_in_empty OCanren.reify x

let ( === ) a b st =
  Printf.printf "%s %s\n" (pp (r a)) (pp (r b));
  incr_counter ();
  (a === b) st
;;

let conjunction _q =
  fresh (a b c d) (a === !!1 &&& (b === !!1) &&& (c === !!1) &&& (d === !!1))
;;

let conjunction2 _q =
  fresh (a b c d) (a === !!1 &&& (b === !!1 &&& (c === !!1 &&& (d === !!1))))
;;

let test rel = run q rel (fun rr -> rr#reify OCanren.reify) |> Stream.take ~n:1 |> ignore

let () =
  Arg.parse
    [ ( "-ex1"
      , Arg.Unit
          (fun () ->
            clear_unifications ();
            test conjunction)
      , "" )
    ; ( "-ex2"
      , Arg.Unit
          (fun () ->
            clear_unifications ();
            test conjunction2)
      , "" )
    ]
    (fun _ -> assert false)
    "";
  Printf.printf "unifications: %d\n" config.unifications
;;
