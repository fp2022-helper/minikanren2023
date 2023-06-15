open Scheme_interpret_nolog
open Benchmark

let count = 2
let repeat = 2

let warmup () =
  find_thrines ~verbose:false count;
  Gc.compact ()
;;

let () =
  warmup ();
  let res =
    latency1
      ~name:(Printf.sprintf "%d thrines" count)
      ~style:Nil
      ~repeat
      4L
      (fun n -> find_thrines ~verbose:false n)
      count
  in
  print_newline ();
  tabulate res
;;
