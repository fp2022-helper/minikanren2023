open Scheme_interpret_nolog
open Benchmark

let count = 30
let repeat = 2

let warmup () =
  find_twines ~verbose:false count;
  Gc.compact ()
;;

let () =
  warmup ();
  let res =
    latency1
      ~name:(Printf.sprintf "%d twines" count)
      ~style:Nil
      ~repeat
      4L
      (fun n -> find_twines ~verbose:false n)
      count
  in
  print_newline ();
  tabulate res
;;
