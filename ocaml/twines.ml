open Scheme_interpret

let () =
  clear_unifications ();
  find_twines ~verbose:true 1;
  Printf.printf "unifications: %d\n" config.unifications
;;
