open Scheme_interpret
open OCanren

let example1 () =
  run
    q
    (* (fun q -> evalo Gterm.(symb !!"x") (Std.nil ()) q) *)
      (fun q ->
      let open OCanren.Std in
      evalo Gterm.(seq (symb !!"quote" % (symb !!"quote" % Std.nil ()))) (Std.nil ()) q)
    (fun rr -> rr#reify Gresult.reify)
  |> Stream.take ~n:1
  |> List.iteri (fun i n -> Printf.printf "%d: %s\n" i (Gresult.show_lresult n))
;;

(* let example2 () =
  run
    q
    (* (fun q -> evalo Gterm.(symb !!"x") (Std.nil ()) q) *)
      (fun q ->


      let open OCanren.Std in

      let repeatedPart = 

      in 
      let expected = 

      in 


      evalo Gterm.(seq (symb !!"quote" % (symb !!"quote" % Std.nil ()))) (Std.nil ()) q)
    (fun rr -> rr#reify Gresult.reify)
  |> Stream.take ~n:1
  |> List.iteri (fun i n -> Printf.printf "%d: %s\n" i (Gresult.show_lresult n))
;; *)

let () = example1 ()
