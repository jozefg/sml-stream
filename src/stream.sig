signature STREAM =
sig
    type 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t

    val empty    : 'a t
    val merge    : 'a t -> 'a t -> 'a t
    val fromList : 'a list -> 'a t
    val delay    : (unit -> 'a t) -> 'a t

    val >>=    : 'a t * ('a -> 'b t) -> 'b t
    val return : 'a -> 'a t

    val unfold   : ('b -> ('a * 'b) option) -> 'b -> 'a t

    val ifte : 'a t -> ('a -> 'b t) -> 'b t -> 'b t
    val once : 'a t -> 'a t

    val uncons  : 'a t -> ('a * 'a t) option
    exception Empty
    val observe : int -> 'a t -> 'a list
end
