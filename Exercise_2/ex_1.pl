% initial code from https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x-set-2/
sums(L,S,N):- prefix(L,S,0,N).

prefix([],[],_,_).

prefix([X|Xs],[Y|Ys],Total,N):-

    Y is Total + X + N,

    prefix(Xs,Ys,Y,N).



minimum(X,Y,Z):-

    (X<Y -> Z is X;

     Z is Y).

maximum(X,Y,Z):-

    (X>Y -> Z is X;

    Z is Y).



lmax([],[],_).

lmax(Arr,LList,PrevM):-

    [Head|Tail] = Arr,

    maximum(Head,PrevM,Larger),

    LList = [Larger|NLList],

    lmax(Tail,NLList,Larger).



rmin([],[],_).

rmin(Arr,RList,Prevm):-

    [Head|Tail] = Arr,

    minimum(Head,Prevm,Smaller),

    RList = [Smaller|NRList],

    rmin(Tail,NRList,Smaller).



positions(Presum,Rmin,Lmax):-

    reverse(Presum,RPresum),

    [RH|_RT] = RPresum,

    rmin(RPresum,Rmin1,RH),

    reverse(Rmin1,Rmin),

    [H|_T] =Presum,

    lmax(Presum,Lmax,H),

    !.



table(Len,_,MaxDif,_,_,Len,MaxDif,_,_).

table(_,Len,MaxDif,_,_,Len,MaxDif,_,_).

table(I,J,MaxDif,Rmin,Lmax,Len,Ans,_Hos,_First):-

    [HRmin|TRmin] = Rmin,

    [HLmax|TLmax] = Lmax,

    (   HRmin =< HLmax ->

    Dif is J-I,

    maximum(MaxDif,Dif,NMaxDiff),

    NJ is J + 1,

    table(I,NJ,NMaxDiff,TRmin,Lmax,Len,Ans,_,_);

    NI is I + 1,

    table(NI,J,MaxDif,Rmin,TLmax,Len,Ans,_,_)).





main(List,Len,Hos,Ans):-

    sums(List,Presum,Hos),

    positions(Presum,Rmin1,Lmax1),

    [H|_T] = Presum,

    table(0,0,-1,Rmin1,Lmax1,Len,MaxDif,Hos,H),

    (H =< -Hos ->

     Ans is MaxDif + 1;

     Ans is MaxDif).


read_input(File, K, C,L) :-

    open(File, read, Stream),

    read_line(Stream, [L,K]),

    read_line(Stream, C).



read_line(Stream, L) :-

    read_line_to_codes(Stream, Line),

    atom_codes(Atom, Line),

    atomic_list_concat(Atoms, ' ', Atom),

    maplist(atom_number, Atoms, L).



longest(File,Final_ans):-

    read_input(File,Hosp,F_List,Len),

    main(F_List,Len,Hosp,Ans),

    number_string(Ans,Final_ans),!.        