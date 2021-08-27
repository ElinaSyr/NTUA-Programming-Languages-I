fun calc_of2 _ _ ~1 min_moves min_city = (min_moves,min_city) 
|calc_of2 pos N CountCity min_moves min_city = 
    let 
        fun distance ele [] = []  
        |distance ele (head::tail) = 
            if (ele-head)>= 0 then (ele-head)::(distance ele tail)
            else (N-head+ele)::(distance ele tail)
        val dist = distance CountCity pos 
        fun lmax [] sum max= (sum,max) 
            |lmax (x::y) sum max = 
  			if x > max then lmax y (sum+x) x 
  			else lmax y (sum+x) max 
        val (sumi,max) = lmax dist 0 ~1 
        fun is_valid max sumi = 
            let 
                val new_sum = sumi - max 
            in 
                if (max-new_sum)<2 then true 
                else false
            end
    in 
        if (is_valid max sumi) then 
            if (sumi<min_moves) then (calc_of2 pos N (CountCity-1) sumi CountCity)
            else if (sumi = min_moves andalso CountCity<min_city) then  (calc_of2 pos N (CountCity-1) sumi CountCity)
            else (calc_of2 pos N (CountCity-1) min_moves min_city)
        else (calc_of2 pos N (CountCity-1) min_moves min_city)
        
    end; 
    

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


fun round file = 
    let
 		val l = readint file 
        val (N,M,car_pos) = (hd l, hd (tl l), tl (tl l))  
        val (moves,cities) = calc_of2 car_pos N N 1073741823 0 
    in 
        if cities = N then
         	print ((Int.toString (moves))^" "^(Int.toString (0))^"\n")
        else 
            print ((Int.toString (moves))^" "^(Int.toString (cities))^"\n")
    end ;



