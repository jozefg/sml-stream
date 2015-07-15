signature STREAM =
sig
    (* The core type of this library, a potentially infinite stream of
     * values of type 'a. This is left abstract so the only way to
     * construct one of these is with the helpful functions below.
     *)
    type 'a t

    (* map f t applies a function f to every element in t.
     * Note that since [t] may contain elements which haven't
     * been evaluated, there is no guarantee when or if [f] will
     * be run on all the elements of the list. EG,
     *
     *    map print (delay (fn () => return "Hello World"))
     *
     * Needn't print anything, but would if we ever used [observe]
     * or friends.
     *)
    val map : ('a -> 'b) -> 'a t -> 'b t

    (* The empty sequence containing no elements *)
    val empty    : 'a t

    (* Combine two sequences. The nice part of this function is that
     * any element which has a finite index in either sequence will have
     * a finite element in the output stream.
     *)
    val merge : 'a t -> 'a t -> 'a t

    (* Convert a list to a stream so that [toList o fromList]
     * is id
     *)
    val fromList : 'a list -> 'a t

    (* When tying knots in ML, it's necessary to introduce a lambda in
     * order to do so. This function facilitates that. EG
     *
     *    val fives = merge (return 5) fives
     *
     * will diverge but
     *
     *    fun fives () = merge (return 5) (delay fives)
     *    val fives = fives ()
     *
     * Will work as expected.
     *)
    val delay : (unit -> 'a t) -> 'a t

    (* Fair-sharing version of >>=. This behaves a lot like
     * mapping a function over a stream and then @-ing the results.
     *
     * However, it does this in such a way that if any component is finitely
     * reachable in any of the resulting ['b t]'s, it has a finite index
     * in the output.
     *)
    val >>= : 'a t * ('a -> 'b t) -> 'b t

    (* Creates a stream with a single element in it. *)
    val return : 'a -> 'a t

    (* The canonical unfolding operator streams should give rise to.
     * The idea is that you supply a seed and an unfolding operation.
     * unfold will create a stream by applying the seed
     *
     * This can be used to create potentially infinite streams.
     *)
    val unfold   : ('b -> ('a * 'b) option) -> 'b -> 'a t

    val ifte : 'a t -> ('a -> 'b t) -> 'b t -> 'b t
    val once : 'a t -> 'a t

    val uncons  : 'a t -> ('a * 'a t) option
    exception Empty
    val observe : int -> 'a t -> 'a list
    val toList : 'a t -> 'a list
end
