(* Core_bench is used for microbenchmarks. Not sure it is needed. *)

open Numero_decls_nolog
(* open Benchmark *)

type config = { mutable print_raw : bool }

let config = { print_raw = false }
let count = 200
let repeat = 2

(* let () =
  Arg.parse
    [ "-raw", Arg.Unit (fun () -> config.print_raw <- true), "" ]
    (fun _ -> assert false)
    "help"
;; *)

let test () =
  let goal q = expo (build_num 3) (build_num 5) q in
  OCanren.(run q) goal (fun rr -> rr#reify num_reifier)
  |> OCanren.Stream.take ~n:1
  |> ignore
;;

let warmup () =
  test ();
  Gc.compact ()
;;

let () =
  warmup ();
  let open Core in
  let open Core_bench in
  Command_unix.run
    (Bench.make_command [ Bench.Test.create ~name:"3^5" (fun () -> ignore (test ())) ])
;;
