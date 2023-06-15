(*
  Quines stuff by Dmitrii Rozplokhas. Adopted from
  https://raw.githubusercontent.com/rozplokhas/OCanren/master/regression/test015.ml
*)

open Printf
open OCanren

(* let () = Printexc.record_backtrace true *)

include Counters.Make ()

module StringLo = struct
  type ground = GT.string [@@deriving gt ~options:{ show; fmt; gmap }]
  type logic = string OCanren.logic

  let logic =
    { GT.gcata = ()
    ; fix = (fun _ _ -> assert false)
    ; plugins =
        object
          method fmt = GT.fmt OCanren.logic (fun ppf -> Format.fprintf ppf "%s")
          method gmap x = [%gmap: GT.string OCanren.logic] () x
        end
    }
  ;;

  type injected = GT.string OCanren.ilogic

  let prj_exn = OCanren.prj_exn
  let reify = OCanren.reify
end

module ListLo = struct
  type 'a ground = 'a Std.List.ground [@@deriving gt ~options:{ gmap; fmt }]
  type 'a logic = 'a Std.List.logic

  let logic =
    { Std.List.logic with
      plugins =
        object
          method fmt fa ppf xs =
            let default ppf xs = (GT.fmt Std.List.logic) fa ppf xs in
            match xs with
            | Var _ -> default ppf xs
            | Value _ ->
              let rec iter ppf xs =
                match xs with
                | Value Std.List.Nil -> ()
                | Value (Std.List.Cons (h, tl)) -> Format.fprintf ppf "%a %a" fa h iter tl
                | Var _ -> Format.fprintf ppf " . %a" default xs
              in
              Format.fprintf ppf "(%a)" iter xs

          method gmap fa xs = [%gmap: 'a Std.List.logic] (GT.lift fa) () xs
        end
    }
  ;;

  type 'a injected = 'a Std.List.groundi

  let prj_exn = Std.List.prj_exn
  let reify = Std.List.reify
end

(* let (_ : int) = GT.gmap ListLo.logic *)
(*
module Std = struct
  include Std

  module Triple = struct
    (*   [%%distrib
      type nonrec ('a,'b,'c) t = 'a * 'b * 'c
        [@@deriving gt ~options:{fmt;gmap}]
      type nonrec ('a,'b,'c) ground = ('a,'b,'c) t (* Kind of abstract type *)
    ] *)
    (* module F = Fmap3(struct
        type ('a,'b,'c) t = ('a,'b,'c) ground
        let fmap eta = GT.gmap ground eta
      end)
 *)
    type nonrec ('a, 'b, 'c) t = 'a * 'b * 'c [@@deriving gt ~options:{ fmt; gmap }]

    let reify ra rb rc =
      let ( >>= ) = Env.Monad.bind in
      Reifier.fix (fun _self ->
        Reifier.compose
          Reifier.reify
          (ra
           >>= fun fa ->
           rb
           >>= fun fb ->
           rc
           >>= fun fc ->
           let rec foo = function
             | Var (v, xs) -> Var (v, Stdlib.List.map foo xs)
             | Value x -> Value (GT.gmap t fa fb fc x)
           in
           Env.Monad.return foo))
    ;;

    let make x y z = inj @@ (x, y, z)
  end
end
 *)
let list_combine3 xs ys zs =
  let rec helper acc = function
    | x :: xs, y :: ys, z :: zs -> helper ((x, y, z) :: acc) (xs, ys, zs)
    | [], [], [] -> List.rev acc
    | _ -> failwith "bad argument of list_combine3"
  in
  helper [] (xs, ys, zs)
;;

let list_iter3 f xs ys zs =
  let rec helper = function
    | x :: xs, y :: ys, z :: zs ->
      f (x, y, z);
      helper (xs, ys, zs)
    | [], [], [] -> ()
    | _ -> failwith "bad argument of list_combine3"
  in
  helper (xs, ys, zs)
;;

module Gterm = struct
  [@@@ocaml.warnerror "-32-34"]

  [%%distrib
  type nonrec ('s, 'xs) t =
    | Symb of 's
    | Seq of 'xs
  [@@deriving gt ~options:{ fmt; gmap }]

  type ground = (StringLo.ground, ground ListLo.ground) t]

  let t =
    { t with
      gcata = ()
    ; plugins =
        object
          method gmap = t.plugins#gmap

          method fmt fa fb fmt =
            GT.transform
              t
              (fun fself ->
                object
                  inherit ['a, 'b, _] fmt_t_t fa fb fself
                  method! c_Symb fmt _ str = Format.fprintf fmt "(symb '%a)" fa str
                  method! c_Seq fmt _ xs = Format.fprintf fmt "(seq %a)" fb xs
                end)
              fmt
        end
    }
  ;;

  (* This is a hack to apply custom printers for logic strings and lists *)
  type logic = (StringLo.logic, logic ListLo.logic) t OCanren.logic
  [@@deriving gt ~options:{ fmt; gmap }]

  type injected = (GT.string OCanren.ilogic, injected Std.List.groundi) t ilogic

  let show_rterm = Format.asprintf "%a" (GT.fmt ground)
  let show_lterm = Format.asprintf "%a" (GT.fmt logic)
end

(* let gterm_reifier = Gterm.reify *)

module Gresult = struct
  [%%distrib
  type nonrec ('s, 't, 'xs) t =
    | Closure of 's * 't * 'xs
    | Val_ of 't
  [@@deriving gt ~options:{ fmt; gmap }]

  type ground =
    ( StringLo.ground
    , Gterm.ground
    , (StringLo.ground, ground) Std.Pair.ground Std.List.ground )
    t]

  let show_string = GT.(show string)
  let show_stringl = GT.(show OCanren.logic) show_string
  let show_rresult r = Format.asprintf "%a" (GT.fmt ground) r
  let show_lresult (r : logic) = Format.asprintf "%a" (GT.fmt logic) r
end

let gresult_reifier = Gresult.reify
let ( !! ) x = inj x

open Gterm
open Gresult

module Env = struct
  type logic = (GT.string OCanren.logic, Gresult.logic) Std.Pair.logic Std.List.logic
  [@@deriving gt ~options:{ fmt }]

  type injected =
    (string OCanren.ilogic, Gresult.injected) Std.Pair.injected Std.List.injected

  let reify : (_, logic) Reifier.t =
    Std.List.reify (Std.Pair.reify OCanren.reify gresult_reifier)
  ;;
end

type fenv = Env.injected

let ( === ) : 'a -> 'a -> goal = fun _ _ -> assert false
let show_reif_term h t = show_lterm @@ Gterm.reify h t
let show_reif_result h t = show_lresult @@ gresult_reifier h t

[@@@ocamlformat.disable]

IFDEF TRACE THEN

(* Specialized unifications for counting and printing  *)
include struct
  let ( =/= ) = OCanren.( =/= )
  let ( =//= ) = OCanren.( =/= )
  let pp = Format.asprintf "%a" (GT.fmt Env.logic)
  let r x = reify_in_empty Env.reify x

  let ( ===! ) : fenv -> fenv -> goal =
   fun x y st ->
    incr_counter ();
    Printf.printf "%s %s\n" (pp (r x)) (pp (r y));
    OCanren.( === ) x y st 
   [@@inline]
 ;;

  let pp = Format.asprintf "%a" (GT.fmt Gterm.logic)
  let r x = reify_in_empty Gterm.reify x

  let ( ==== ) : Gterm.injected -> Gterm.injected -> goal =
   fun x y st ->
    incr_counter ();
    Printf.printf "%s %s\n" (pp (r x)) (pp (r y));
    OCanren.( === ) x y st 
   [@@inline]
 ;;

  let pp = Format.asprintf "%a" (GT.fmt Std.List.logic @@ GT.fmt Gterm.logic)
  let r x = reify_in_empty (Std.List.reify Gterm.reify) x

  let ( ====^ )
    : Gterm.injected Std.List.injected -> Gterm.injected Std.List.injected -> goal
    =
   fun x y st ->
    incr_counter ();
    Printf.printf "%s %s\n" (pp (r x)) (pp (r y));
    OCanren.( === ) x y st 
   [@@inline]
 ;;

  let pp = Format.asprintf "%a" (GT.fmt StringLo.logic)
  let r x = reify_in_empty StringLo.reify x

  let ( ===!! ) : string ilogic -> string ilogic -> goal =
   fun x y st ->
    incr_counter ();
    Printf.printf "%s %s\n" (pp (r x)) (pp (r y));
    OCanren.( === ) x y  st 
   [@@inline]
 ;;

  let pp = Format.asprintf "%a" (GT.fmt Gresult.logic)
  let r x = reify_in_empty Gresult.reify x

  let ( ==!! ) : Gresult.injected -> Gresult.injected -> goal =
   fun x y st ->
    incr_counter ();
    Printf.printf "%s %s\n" (pp (r x)) (pp (r y));
    OCanren.( === ) x y st 
   [@@inline]
 ;;
end

ELSE

include struct 

  let (===!) = OCanren.(===) 
  (* let (===!!) = OCanren.(===)  *)
  let (====) = OCanren.(===) 
  let (====^) = OCanren.(===)
  let ( ===!! ) = OCanren.(===)
  let ( ==!!) = OCanren.(===) 

  let ( =/= ) = OCanren.( =/= ) 
  let ( =//= ) = OCanren.( =/= ) 
end

END

let rec lookupo : _ -> fenv -> Gresult.injected -> goal =
 fun x env t ->
  let open OCanren.Std in
  fresh
    (rest y v)
    (Std.Pair.pair y v % rest ===! env)
    (conde [ y ===!! x &&& (v ==!! t); y =/= x &&& lookupo x rest t ])
;;

let rec not_in_envo : _ -> fenv -> goal =
 fun x env ->
  let open OCanren.Std in
  conde
    [ fresh (y v rest) (env ===! Std.pair y v % rest) (y =/= x) (not_in_envo x rest)
    ; nil () ===! env
    ]
;;

let rec proper_listo : (Gterm.injected Std.List.injected as 'i) -> fenv -> 'i -> goal =
 fun es env rs ->
  let open OCanren.Std in
  conde
    [ Std.nil () ====^ es &&& (Std.nil () ====^ rs)
    ; fresh
        (e d te td)
        (es ====^ e % d)
        (rs ====^ te % td)
        (evalo e env (val_ te))
        (proper_listo d env td)
    ]

and evalo : Gterm.injected -> fenv -> Gresult.injected -> goal =
 fun term env r ->
  let open OCanren.Std in
  conde
    [ fresh
        t
        (term ==== seq (symb !!"quote" %< t))
        (r ==!! val_ t)
        (not_in_envo !!"quote" env)
    ; fresh
        (es rs)
        (term ==== seq (symb !!"list" % es))
        (r ==!! val_ (seq rs))
        (not_in_envo !!"list" env)
        (proper_listo es env rs)
    ; fresh s (term ==== symb s) (lookupo s env r)
    ; fresh
        (func arge arg x body env')
        (term ==== seq (func %< arge))
        (evalo arge env arg)
        (evalo func env (closure x body env'))
        (evalo body (Std.pair x arg % env') r)
    ; fresh
        (x body)
        (term ==== seq (symb !!"lambda" % (seq !<(symb x) %< body)))
        (not_in_envo !!"lambda" env)
        (r ==!! closure x body env)
    ]
;;

let s tl = seq (Std.list Fun.id tl)
let nil = Std.nil ()
let quineso q = evalo q nil (val_ q)
let twineso q p = q =/= p &&& evalo q nil (val_ p) &&& evalo p nil (val_ q)

let thrineso p q r =
  (* let (=//=) = diseqtrace @@ show_reif_term in *)
  fresh
    ()
    (p =//= q)
    (q =//= r)
    (r =//= p)
    (evalo p nil (val_ q))
    (evalo q nil (val_ r))
    (evalo r nil (val_ p))
;;

let wrap_term rr = rr#reify Gterm.reify |> show_lterm
let wrap_result rr = rr#reify gresult_reifier |> show_lresult

let find_quines ~verbose n =
  run q quineso (fun r -> r#reify Gterm.reify)
  |> OCanren.Stream.take ~n
  |> List.iter (fun q -> if verbose then printf "%s\n\n" (show_lterm q) else ())
;;

let find_twines ~verbose n =
  run qr twineso (fun q r -> q#reify Gterm.reify, r#reify Gterm.reify)
  |> OCanren.Stream.take ~n
  |> List.iter (fun (q, r) ->
       if verbose then printf "%s,\n%s\n\n" (show_lterm q) (show_lterm r) else ())
;;

let find_thrines ~verbose n =
  run qrs thrineso (fun r1 r2 r3 ->
    r1#reify Gterm.reify, r2#reify Gterm.reify, r3#reify Gterm.reify)
  |> Stream.take ~n
  |> List.iter (fun (q, r, s) ->
       if verbose
       then printf "%s,\n%s\,\n%s\n\n" (show_lterm q) (show_lterm r) (show_lterm s)
       else ())
;;
