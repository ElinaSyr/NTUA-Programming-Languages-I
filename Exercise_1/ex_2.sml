open Array2; 

fun parse file = 
    let 
        fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        
        val inStream = TextIO.openIn file
        val (n,m) = (readInt inStream, readInt inStream) 
        val _ = TextIO.inputLine inStream 

        fun readLines acc = 
            case TextIO.inputLine inStream of
              NONE => rev acc
          	| SOME line => readLines (explode (String.substring (line,0,m)) :: acc)
        val inputList = readLines []:char list list 
        val _=TextIO.closeIn inStream
    in 
        (n,m,inputList)
    end

fun List2Arr (n,m,parse) = 
    Array2.fromList parse;


fun makeList 0 result = result
  | makeList n result = makeList (n-1) (n :: result)

fun make_vis 0 m vis = vis 
    | make_vis n m vis =
      let 
        fun create_col n 0 vis = vis
            | create_col n m vis = create_col n (m-1) (false :: vis)
      in 
        make_vis (n-1) m ((create_col (n-1) m []) :: vis) 
      end; 

fun LiLi2Arr (n,m,parsal) = 
    Array2.fromList (make_vis n m []) ; 

(*stack list of tuples *) 

fun app_row1 arr LiLi2Arr stack =   
    let 
        fun loop i vis_l stack = if i = Array2.nCols arr then stack
        else 
            (if (Array2.sub(arr,0,i)= #"U")  then (update (vis_l, 0, i, true); loop (i+1) vis_l ((0,i)::stack) )
            else loop (i+1) vis_l stack)
    in 
        loop 0 LiLi2Arr stack
    end; 


fun app_row_nth arr LiLi2Arr (n,m,parse) stack =   
    let 
        fun loop i vis_l stack = if i = Array2.nCols arr then stack
        else 
            (if (Array2.sub(arr,n-1,i)= #"D")  then (update (vis_l, n-1, i, true) ; loop (i+1) vis_l ((n-1,i)::stack))
            else loop (i+1) vis_l stack )
    in 
        loop 0 LiLi2Arr stack
    end; 

fun app_col1 arr LiLi2Arr stack =   
    let 
        fun loop i vis_l stack = if i = Array2.nRows arr then stack
        else 
            (if (Array2.sub(arr,i,0)= #"L")  then (update (vis_l, i, 0, true) ; loop (i+1) vis_l ((i,0)::stack))
            else loop (i+1) vis_l stack )
    in 
        loop 0 LiLi2Arr stack
    end; 

fun app_col_nth arr LiLi2Arr (n,m,parse) stack =   
    let 
        fun loop i vis_l stack = if i = Array2.nRows arr then stack
        else 
            (if (Array2.sub(arr,i,m-1)= #"R")  then (update (vis_l, i,m-1, true) ; loop (i+1) vis_l ((i,m-1)::stack))
            else loop (i+1) vis_l stack)
    in 
        loop 0 LiLi2Arr stack
    end; 
    

fun create_stack arr (n,m,parse) LiLi2Arr= 
    let 
        val l1 = app_row1 arr LiLi2Arr [] 
    in 	
        let 
            val l2 = (app_row_nth arr LiLi2Arr (n,m,parse) l1 )
        in 
            let 
                val l3 = (app_col1 arr LiLi2Arr l2) 
            in 
                (app_col_nth arr LiLi2Arr (n,m,parse) l3 ) 
            end
        end
        
    end; 
        
 
fun isSafe x y (n,m,parse) LiLi2Arr = 
    if ((x<0 orelse y<0 orelse x>=n orelse y>=m) orelse (Array2.sub(LiLi2Arr,x,y) =true)) then false
    else true ;


(*signature MUTABLE_STACK = 
      sig
         type 'a mstack
         val new : a' list -> 'a mstack
         val push : 'a mstack * 'a -> unit
         val pop : 'a mstack -> 'a option
      end;

structure Mutable_Stack :> MUTABLE_STACK =
     struct
          a mutable stack is a ref pointing whose
          contents contains a list of values 
         type 'a mstack = ('a list) ref
          create a new ref cell and initialize it
          with the empty list 
         fun new():'a mstack= ref([])
         to push x on s, we cons x onto the current
           contents of s, and then update the cell
           referenced by s with the result 
         fun push(s:'a mstack, x:'a):unit = 
             s := x::(!s)
          top pop s, we dereference it to get the
           contents, check for null (returning NONE)
           nd otherwise return the head of the list
           after setting the contents of s to the tail. 
         fun pop(s:'a mstack):'a option = 
             case (!s) of
               [] => NONE
             | hd::tl => (s := tl; SOME(hd))
     end;
*)
(* fun loops_rooms [] (n,m,parse) count LiLi2Arr arr = n*m - count
| loops_rooms stack (n,m,parse) count LiLi2Arr arr = 
    let 	
        val row = #1 (hd stack) 
        val col = #2 (hd stack) 
        
        
    in
        pop(stack);
        if (isSafe row (col+1) (n,m,parse) LiLi2Arr)andalso (Array2.sub(arr,row,(col+1)) = #"L")
        then (update (LiLi2Arr, row,col+1,true) ; push (stack,(row,(col+1)));
        if (isSafe row (col-1) (n,m,parse) LiLi2Arr)andalso (Array2.sub(arr,row,(col-1)) = #"R")
        then (update (LiLi2Arr, row,col-1,true) ; push (stack,(row,(col-1)));
        if (isSafe (row+1) col (n,m,parse) LiLi2Arr)andalso (Array2.sub(arr,(row+1),col) = #"U")
        then (update (LiLi2Arr, row+1,col,true) ; push (stack,((row+1),col))); 
        if (isSafe (row-1) col (n,m,parse) LiLi2Arr)andalso (Array2.sub(arr,(row-1),col) = #"D")
        then (update (LiLi2Arr,(row-1),col,true); push (stack,((row-1),col))); loops_rooms stack (n,m,parse) (count+1) LiLi2Arr arr 	
    end; 
*) 


(*fun loops_rooms [] (n,m,parse) count LiLi2Arr arr = n*m - count
| loops_rooms stack (n,m,parse) count LiLi2Arr arr = 
    let 
        val row = #1 (hd stack) 
        val col = #2 (hd stack) 
    in
        if (isSafe row (col+1) (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,row,(col+1)) = #"L")
        then (update (LiLi2Arr, row,col+1,true) ;  
        if (isSafe row (col-1) (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,row,(col-1)) = #"R")
        then (update (LiLi2Arr, row,col-1,true) ; 
        if (isSafe (row+1) col (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,(row+1),col) = #"U")
        then (update (LiLi2Arr, row+1,col,true) ; ((row+1),col)::stack; 
        if (isSafe (row-1) col (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,(row-1),col) = #"D")
        then (update (LiLi2Arr, (row-1),col,true) ; ((row-1),col)::stack ; loops_rooms stack (n,m,parse) (count+1) LiLi2Arr arr 	
    end; 
*)

fun loops_rooms_1st_step stack (n,m,parse) LiLi2Arr arr = 
    let 
        val count = ref 0
        val st = ref stack
        val st1 = ref stack
        
    in 	
        while ((!st)<> []) do (
        
            (	st1 := (!st);
                let 
                    val row = (#1 (hd (!st1))) 
                    val col = (#2 (hd (!st1)))
                in 
            st := tl (!st);
            count:=(!count) +1;
            (*print( (Int.toString (row)^ "\n"));
            print( (Int.toString (col)^ "\n"));*)

        (if (isSafe (row) ((col)+1) (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,(row),((col)+1)) = #"L")
        then (st:= (((row),((col)+1))::(!st)); update (LiLi2Arr, (row),(col)+1,true) )
        else ()) ;
        (if (isSafe (row) ((col)-1) (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,(row),((col)-1)) = #"R")
        then ( st:= (((row),((col)-1))::(!st)); update (LiLi2Arr, (row),(col)-1,true))
        else ()) ;
        (if (isSafe ((row)+1) (col) (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,((row)+1),(col)) = #"U")
        then (st:=((((row)+1),(col))::(!st)); update (LiLi2Arr, (row)+1,(col),true) )
        else ()) ;
        (if (isSafe ((row)-1) (col) (n,m,parse) LiLi2Arr) andalso (Array2.sub(arr,((row)-1),(col)) = #"D")
        then (st:=((((row)-1),(col))::(!st)); update (LiLi2Arr, ((row)-1),(col),true) )
        else ())

        end
        )
        );
        if (true) then SOME (!count)
        else SOME (!count)
    end;

fun final_answer stack (n,m,parse) LiLi2Arr arr = n*m-valOf(loops_rooms_1st_step stack (n,m,parse) LiLi2Arr arr);

fun loop_rooms file = 
    let 
        val (n,m,inputList)= parse file;
        val input_array = List2Arr (n,m,inputList);
        val visited = LiLi2Arr (n,m,[]);
        val stack = create_stack input_array (n,m,[]) visited;
    in
        print( (Int.toString (final_answer stack (n,m,[]) visited input_array) )^ "\n")
    end;




(*val arri = [[#"U",#"L"],[#"R",#"L"]];
val vis_v = LiLi2Arr (2,2,arri);
val arr1 = Array2.fromList arri;
val st =create_stack arr1 (2,2,[]) vis_v ;
val lr = loops_rooms st (2,2,[]) vis_v arr1;
val b = isSafe 0 1 (2,2,parse) vis_v;



val arri2 = [[#"U",#"L",#"D"],[#"L",#"U",#"D"],[#"L",#"R",#"L"]];
val vis_v2 = LiLi2Arr (3,3,arri2);
val arr12 = Array2.fromList arri2;
val st2 =create_stack arr12 (3,3,[]) vis_v2 ;
val lr2 = final_answer st2 (3,3,[]) vis_v2 arr12;*)


(*val os = [(1,1),(1,0),(0,0)]
val x = create_stack arri (2,2,[]) vis1;
val os = create_stack arri (2,2,[]) is;

 arri (2,2,[[#"U",#"D"],[#"L",#"R"]]) vis1) *)

(*(app_col_nth arr LiLi2Arr (n,m,parse) ((app_col1 arr LiLi2Arr (app_row_nth arr LiLi2Arr (n,m,parse) (app_row1 arr LiLi2Arr [] ):: stack ) :: stack  ):: stack) ):: stack ) *)



