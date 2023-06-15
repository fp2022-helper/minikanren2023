(* Execute as:
    sudo cpupower frequency-set --governor performance
    taskset -c 0 ../../_build/default/ocaml/bench/twines_bench.exe -raw
  *)

open Numero_decls_nolog
open Benchmark

type config = { mutable print_raw : bool }

let config = { print_raw = false }
let repeat = 10

let () =
  Arg.parse
    [ "-raw", Arg.Unit (fun () -> config.print_raw <- true), "" ]
    (fun _ -> assert false)
    "help"
;;

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
  let res = latency1 ~name:"3^5" ~style:Nil ~repeat 10L test () in
  print_newline ();
  tabulate res;
  if config.print_raw
  then (
    let _, data = List.hd res in
    List.iter (fun { Benchmark.wall; _ } -> Printf.printf "%f " wall) data;
    Printf.printf "\n")
;;
