(* Execute as:
    sudo cpupower frequency-set --governor performance
    taskset -c 0 ../../_build/default/ocaml/bench/twines_bench.exe -raw
  *)

open Scheme_interpret_nolog
open Benchmark

type config = { mutable print_raw : bool }

let config = { print_raw = false }
let count = 200
let repeat = 2

let () =
  Arg.parse
    [ "-raw", Arg.Unit (fun () -> config.print_raw <- true), "" ]
    (fun _ -> assert false)
    "help"
;;

let warmup () =
  find_quines ~verbose:false count;
  Gc.compact ()
;;

let () =
  warmup ();
  let res =
    latency1
      ~name:(Printf.sprintf "%d quines" count)
      ~style:Nil
      ~repeat
      4L
      (fun n -> find_quines ~verbose:false n)
      count
  in
  print_newline ();
  tabulate res;
  if config.print_raw
  then (
    let _, data = List.hd res in
    List.iter (fun { Benchmark.wall; _ } -> Printf.printf "%f " wall) data;
    Printf.printf "\n")
;;
