type bench_info = int * float

(* time in ms * unif_count *)
type info = { racket : bench_info; kotlin : bench_info }

let data =
  let make text ~racket ~kotlin = (text, { racket; kotlin }) in
  [
    make {|         $3^5$|} ~racket:(342799, 137.64213867187)
      ~kotlin:(342799, 2118.403);
    make {|   $log_3 243$|} ~racket:(44410, 19.8337890625)
      ~kotlin:(74042, 3161.079);
    make {|$127\cdot 127$|} ~racket:(133947, 72.112133789062)
      ~kotlin:(220986, 406.594);
    make {|$225\cdot 225$|} ~racket:(543997, 339.57961425781)
      ~kotlin:(894219, 1876.773);
    make {|         $7^2$|} ~racket:(299688, 105.97465820313)
      ~kotlin:(385752, 887.934);
  ]

let _ =
  Out_channel.with_open_text "bench_table.tex" (fun ch ->
      let printfn fmt =
        Printf.kprintf (fun s -> Printf.fprintf ch "%s\n" s) fmt
      in
      printfn {|\begin{tabular}{l*{6}{ |c }}|};
      printfn
        {|\multirow{2}{*}{} & \multicolumn{3}{ |c| }{Kotlin}  & \multicolumn{3}{ |c| }{Racket}  \\|};
      printfn {|\cline{2-7}|};
      printfn {| & unifications & ms & U/ms  & unifications & ms & U/ms   \\|};
      printfn {|\hline|};
      data
      |> List.iter (fun (name, { racket; kotlin }) ->
             let speed (a, b) = float_of_int a /. b in
             printfn
               {|%s &   %7d & %5.2f & %5.0f &    %d & %5.2f & %5.0f    \\|} name
               (fst kotlin) (snd kotlin) (speed kotlin) (fst racket)
               (snd racket) (speed racket));
      printfn {|\end{tabular}|};
      ())
