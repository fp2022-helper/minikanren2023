open Scheme_interpret

let () =
  clear_unifications ();
  find_thrines ~verbose:true 1;
  Printf.printf "unifications: %d\n" config.unifications
;;
