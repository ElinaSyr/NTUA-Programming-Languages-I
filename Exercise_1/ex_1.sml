(*function to read file*)
fun readint(infile : string) = let

        val ins = TextIO.openIn infile


    fun loop ins =

        case TextIO.scanStream( Int.scan StringCvt.DEC) ins of

    SOME int => int :: loop ins

    | NONE => []

          in
 loop ins before TextIO.closeIn ins

  end;

(*function to fix result from input file in tuple*) 
fun fix l =
    (hd l, hd (tl l), tl (tl l)); 

(*function to reverse sign of number and subtract n from it*)
fun change_list l n = map (fn x => ~x -n )l;


(*function to calculate prefix sum of array*)
fun prefixSum xs =
    let 
        fun prefix_Sum (sums, []) = sums
    |prefix_Sum ([], x::xs) = prefix_Sum ([x],xs)
    |prefix_Sum (y::ys, x::xs) = prefix_Sum ((x+y)::y::ys,xs);
    in 
 rev (prefix_Sum([],xs))
end;

(*function to make list of tuples, #1 is index #2 is prefix sum of index*)
fun make_tuples l = 
    let
        fun maketuples index []  = []
  | maketuples index (x::xs)   = (index, x) :: ( maketuples (index+1) xs  );
    in
        maketuples 0 l
    end;

(*function to sort list of tuples by ascending prefix sum *)
fun mergeSort nil = nil
 | mergeSort [(x,y)] = [(x,y)]
 | mergeSort theList =
 let
 (* From the given list make a pair of lists 
 * (x,y), where half the elements of the 
 * original are in x and half are in y. *)
 fun halve nil = (nil, nil)
 | halve [(x,y)] = ([(x,y)], nil)
 | halve ((x,y)::xs::cs) =
 let
 val (a, b) = halve cs
 in
 ((x,y)::a, xs::b)
 end
 (* Merge two sorted lists of integers into
 * a single sorted list. *)
 fun merge (nil, ys) = ys
 | merge (xs, nil) = xs
 | merge ((x,z)::xs, (y,w)::ys) =
 if  z<w then (x,z) :: merge(xs, (y,w)::ys)
 else if z=w andalso x < y then (x,z) :: merge(xs, (y,w)::ys)
  else if z=w andalso x> y then (y,w) :: merge((x,z)::xs, ys)
 else (y,w) :: merge((x,z)::xs, ys)
 val (x, y) = halve theList
 in
 merge (mergeSort x, mergeSort y)
 end;

(*function to make list containing the minimum index value in range [0..i] in sorted prefix sum list*)
fun min_ind_of_prefix_Sum (sums, [],min_ind) = (sums,min_ind)
    |min_ind_of_prefix_Sum ([], (x,z)::xs,min_ind) = min_ind_of_prefix_Sum([(x,z)],xs,x)

    |min_ind_of_prefix_Sum ((y,w)::ys, (x,z)::xs ,min_ind) = 

        if (x < y) then min_ind_of_prefix_Sum ((x,z)::(y,w)::ys,xs,Int.min(min_ind,x))
        else min_ind_of_prefix_Sum ((y,w)::(y,w)::ys,xs,min_ind);
(*fun minPrefixSum xs= (#1 (min_ind_of_prefix_Sum([],xs,0)));*)

(*function to make list out of thw #1s of the tuple list minPrefixSum *)
fun no_more_tuples [(a,b)] = [a]|
    no_more_tuples ((a,b)::xs) = a:: (no_more_tuples xs);

(*function to create minimum index list*)
fun minimum_index l = 
    let 
        val minPrefixSum = (#1 (min_ind_of_prefix_Sum([],l,0)))
    in 
        no_more_tuples  minPrefixSum
    end;

(*Function to find index in preSum list upto which
 all prefix sum values are less than or equal to x.*)
(*)
fun main (x::xs,presum, ind, sum, k) = 
    let 
        val s = sum + x
    in
        if s > 0 then main (xs, presum,ind,s,k); ind + 1
        else 
            let
                val newind =find(presum,s-1)
                val minInd = minPrefixSum presum
            in
                if newind > ~1 andalso List.nth((#1 minInd),newind)<ind then main (xs, presum,ind,s,k); Int.max(k,ind-List.nth(minInd,newind) 
            end;

*)
open Array;
(*function to create array out of list*)
fun create_array l = Array.fromList l;

(*function to perform binary search to array*)
(*fun binsearch (A, x) = 
    let val n = length A;
      val lo = ref 0 and hi = ref n;
      val mid = ref ((!lo + !hi) div 2);
          
    in
      while ((!hi - !lo > 0) andalso (x <> sub (A, !mid))) do
      (
        if x < sub (A, !mid) then hi := !mid - 1
        else lo := !mid + 1;
        mid := (!lo + !hi) div 2
       );
          if x = sub (A, !mid) then SOME (!mid)
      else NONE
    end;*)
fun binsearch (arr:((int*int)array), x:int) =
let
  val l = Array.length arr
  fun subsearch arr x lo hi answer=
  	((*print ("answer is "^ Int.toString(answer)^" "); print "\n";*)
    if lo > hi then answer
    else
      let
        val mid = (lo + hi) div 2
        val v:(int*int)= Array.sub (arr, mid)
      in
        if  x >= (#2 v ) then  subsearch arr x (mid+1) hi mid
        else   subsearch arr x lo (mid-1) answer

      end)
in
  subsearch arr x 0 (l-1) ~1
end;

(*fun real_result_from_binsearch (arr, x) = 
    let 
        val result = (binsearch arr x)
        val l = Array.length arr
    in 
        if result = ~1 then ~1
        else (l- result)
        end;*)

open Array;

fun main (presum, presum_sort, minind)=
    let
            val arr = Array.fromList presum 
            val k = ref 0;
            val limit = (Array.length arr)-1
            val index = ref 0;
        in
            while (limit >= !index) do(
            
            if (Array.sub(arr,!index) >= 0) then (k := !index+1(*print (Int.toString (!k)); print ("\n")*))
            else 
                let 
                    val ind = (binsearch (presum_sort, (Array.sub(arr,!index))))
                in 
                    ((*print ("ind is "^ Int.toString (ind)); print ("\n");*)
                    if ( ind <> ~1) andalso Array.sub(minind,ind)<(!index) then k := Int.max(!k,((!index) - Array.sub(minind,ind)))
                    else ())
                end;
                index := !index + 1
                
                );
            if (!index <>0) then SOME (!k)
            else SOME (!k)
            end	;

fun longest filename=
    let 
        val (m,n,input_list)=fix (readint filename)
        val l = change_list input_list n 
        val pref = prefixSum l
        val tuple_list = make_tuples pref
        val sorted_tuples = mergeSort tuple_list
        val sorted_tuples_array = Array.fromList (sorted_tuples)
        val minind = minimum_index  sorted_tuples
        val pref_array = create_array pref
        val minind_array = Array.fromList (rev minind)
        
    in 
            print (Int.toString (valOf(main (pref, sorted_tuples_array, minind_array)))); print ("\n")

end;

        (*val (m,n,input_list)=fix (readint "f.txt")
        val l = change_list input_list n 
        val pref = prefixSum l
        val tuple_list = make_tuples pref
        val sorted_tuples = mergeSort tuple_list

        val minind = minimum_index  sorted_tuples
        val pref_array = create_array pref
        val minind_array = Array.fromList (rev minind)*)

(*open Array;
val arr1 = change_list [~13 ,14, 22 ,~28 ,~13 ,20 ,~5, ~7 ,9,~15 ,~10,~5 ,~15 ,6 ,28, ~1] 9;
val test1 = prefixSum arr1;
val test2= make_tuples test1;
val test3=mergeSort test2;
val test4=minimum_index test3;
val test5 = create_array test1;
val test4arr= Array.fromList ( rev test4);
val test7 = main (test1, test4arr);*)        