quicksort([], []).
quicksort([X|Xs], Ys) :- partition1(Xs, X, Ls, Gs),
quicksort(Ls, Sl),
quicksort(Gs, Sr),
append(Sl, [X|Sr], Ys).
partition1([], _, [], []).
partition1([X|L], P, [X|Ls], Gs) :- X < P,
partition1(L, P, Ls, Gs).
partition1([X|L], P, Ls, [X|Gs]) :- X >= P,
partition1(L, P, Ls, Gs).


count([],_,0,[]).
count([El|Tail],City,0,[El|Tail]):-
    El \= City.
count([El|T],El,Count,Tail):-
   count(T,El,Count1,Tail),
   Count is Count1+1.


city_map(N,N,_,[]).
city_map(Index,N,[],[HL|TL]):-
    Index1 is Index + 1,
    HL is 0,
    city_map(Index1,N,[],TL).

city_map(Index,N,[Hpos|Tpos],[HL|TL]):-
    count([Hpos|Tpos],Index,NumofCars,NewTail),
    Index1 is Index + 1,
    HL is NumofCars,
    city_map(Index1,N,NewTail,TL)
    .


sum([],_,Curr,Curr,Max,Max,Pos,Pos):-!.
sum([Hd|Tail],N,Curr,Sum,Max,FMax,CurrPos,Pos):-
    (   Hd =:= 0 -> Dist is 0;Dist is N-Hd),
    Curr1 is Curr+Dist,
    (   Dist > Max ->
    sum(Tail,N,Curr1,Sum,Dist,FMax,Hd,Pos);
    sum(Tail,N,Curr1,Sum,Max,FMax,CurrPos,Pos)).
list_sum(List,N,Sum,Max,Pos):-
    sum(List,N,0,Sum,-1,Max,0,Pos),!.

round(Green,_,N,Cars,ListG,[],Duplicate,Sum,Max,CMinMoves,CMinCity,FMoves,FCity):-
    round(Green,0,N,Cars,ListG,Duplicate,Duplicate,Sum,Max,CMinMoves,CMinCity,FMoves,FCity).
round(_,_,_,_,[],_,_,_,_,MinMoves,MinCity,MinMoves,MinCity).
round(Green,Red,N,Cars,[Map|Mtail],[Map2|Mtail2],Duplicate,Sum,Max,CurrMinMoves,CurrMinCity,MinMoves,MinCity):-
    ( Green =:= Red ->
    Red1 is Red+1,
    round(Green,Red1,N,Cars,[Map|Mtail],Mtail2,Duplicate,Sum,Max,CurrMinMoves,CurrMinCity,MinMoves,MinCity);
    (   Map2 =:= 0 ->
    Red1 is Red+1,
    round(Green,Red1,N,Cars,[Map|Mtail],Mtail2,Duplicate,Sum,Max,CurrMinMoves,CurrMinCity,MinMoves,MinCity);
    Green1 is Green+1,
    (   Green =:= 0 ->  Green2 is Green+1,round(Green2,Red,N,Cars,Mtail,[Map2|Mtail2],Duplicate,Sum,Max,CurrMinMoves,CurrMinCity,MinMoves,MinCity);
    NewSum is  Sum + Cars - N*Map,
    (   Red>Green->
    Dist is N-Red+Green;
    Dist is Green-Red),
    Check is NewSum-Dist+1,
    (   Check > Dist ->
    (   NewSum < CurrMinMoves->
    CurrMinMoves1 is NewSum,
    CurrMinCity1 is Green;
    CurrMinMoves1 is CurrMinMoves,
    CurrMinCity1 is CurrMinCity),
    round(Green1,Red,N,Cars,Mtail,[Map2|Mtail2],Duplicate,NewSum,Max,CurrMinMoves1,CurrMinCity1,MinMoves,MinCity);

    round(Green1,Red,N,Cars,Mtail,[Map2|Mtail2],Duplicate,NewSum,Max,CurrMinMoves,CurrMinCity,MinMoves,MinCity))))).

main(Cities,Cars,Positions,Moves,City):-
    quicksort(Positions,Sorted),
    city_map(0,Cities,Sorted,Map),
    list_sum(Positions,Cities,Sum,Max,_Pos),
    round(0,0,Cities,Cars,Map,Map,Map,Sum,Max,Sum,0,Moves,City).

read_input(File, N,C,List) :-
    open(File, read, Stream),
    read_line(Stream, [N,C]),
    read_line(Stream, List).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

round(File,Moves,City):-
    read_input(File,N,C,List),
    main(N,C,List,Moves,City),
    !.









