(* Execute as:
    sudo cpupower frequency-set --governor performance
    taskset -c 0 ../../_build/default/ocaml/bench/twines_bench.exe -raw
  *)

open Benchmark

type config =
  { mutable print_raw : bool
  ; mutable repeat : int
  }

let config = { print_raw = false; repeat = 10 }

let () =
  Arg.parse
    [ "-raw", Arg.Unit (fun () -> config.print_raw <- true), ""
    ; ( "-r"
      , Arg.Int (fun n -> config.repeat <- n)
      , Printf.sprintf " repeatitions (default=%d)" config.repeat )
    ]
    (fun _ -> assert false)
    "help"
;;

let wrap_test ?(n = 1) goal () =
  OCanren.(run q) goal (fun rr -> rr#reify num_reifier)
  |> OCanren.Stream.take ~n
  |> ignore
;;

let warmup () =
  let { Gc.minor_collections; major_collections; _ } = Gc.stat () in
  wrap_test (expo (build_num 3) (build_num 5)) ();
  let new_stat = Gc.stat () in
  Printf.printf
    "collections during warmup: minor = %d, major = %d\n"
    (new_stat.Gc.minor_collections - minor_collections)
    (new_stat.Gc.major_collections - major_collections);
  Gc.compact ()
;;

let () =
  warmup ();
  print_endline "Benching...";
  let res =
    latencyN
      ~style:Nil
      ~repeat:config.repeat
      4L
      [ "3^5", wrap_test (expo (build_num 3) (build_num 5)), ()
      ; "log_3 243", wrap_test (fun q -> logo q (build_num 3) (build_num 5) zero), ()
      ; "7^2", wrap_test (expo (build_num 7) (build_num 2)), ()
      ; "127*127", wrap_test (multo (build_num 127) (build_num 127)), ()
        (* ; ("255*255", wrap_test (multo (build_num 255) (build_num 255)), ()) *)
        (* ; ("15^2", wrap_test  (expo (build_num 63) (build_num 2)), ()) *)
      ]
  in
  print_newline ();
  tabulate res;
  if config.print_raw
  then (
    let _, data = List.hd res in
    List.iter (fun { Benchmark.wall; _ } -> Printf.printf "%f " wall) data;
    Printf.printf "\n")
;;
