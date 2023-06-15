(* Execute as:
    sudo cpupower frequency-set --governor performance
    taskset -c 0 ../../_build/default/ocaml/bench/twines_bench.exe -raw
  *)

open Benchmark

type config = { mutable print_raw : bool }

let config = { print_raw = false }
let repeat = 1

let () =
  Arg.parse
    [ "-raw", Arg.Unit (fun () -> config.print_raw <- true), "" ]
    (fun _ -> assert false)
    "help"
;;

let test () =
  let open OCanren in
  run
    q
    (fun q ->
      sorto
        q
        (Std.list (fun n -> Std.Nat.nat @@ Std.Nat.of_int n) (List.init 8 (( + ) 1))))
    (fun rr -> rr#reify (Std.List.reify OCanren.reify))
  |> OCanren.Stream.take ~n:40320
  |> ignore
;;

let warmup () =
  test ();
  Gc.compact ()
;;

let () =
  warmup ();
  let res = latency1 ~name:"1..8 (all)" ~style:Nil ~repeat 4L test () in
  print_newline ();
  tabulate res;
  if config.print_raw
  then (
    let _, data = List.hd res in
    List.iter (fun { Benchmark.wall; _ } -> Printf.printf "%f " wall) data;
    Printf.printf "\n")
;;
