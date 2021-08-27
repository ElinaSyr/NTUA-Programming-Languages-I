go(QList,Moves):-
    length(Moves,N),
    MOD is mod(N,2),
    (   MOD =:= 0->solution(QList,[],Moves);false).


%append to the end of difference list
%dapp(L1-V1,L2-V2,L3-V3) :- V1=L2,
 %   L3=L1,
 %   V3=V2,!.
%an empty list is a sorted list
sorted([]).

%a list with one element only is a sorted list
sorted([_A]).

%a list with more than one elements is sorted if the first 2 elements
%are in orded and the rest of the list is also sorted
sorted([A,B|T]):-
    (A=<B, sorted([B|T]);
    false).

popfront([Front|Tail],Front,Tail).


safe(List):-
    ( List = [] -> false;true).

%visit(QList,SList,[Visited|New]-New,VisitedNew-S):-
    %atomic_list_concat(QList,' ',Q),
   % atomic_list_concat(SList,' ',S),
   % dapp([Visited|New]-New,[(QList,SList)|W]-W,VisitedNew-S).

add_front(List,Elem,[Elem|List]).

%Q MOVE
move(QList,SList,'Q',QListNew,SListNew):-
    safe(QList),
    popfront(QList,FrontQ,QListNew),
    add_front(SList,FrontQ,SListNew).

%S MOVE
move(QList,SList,'S',QListNew,SListNew):-
    [QHead|_Qtail] = QList,
    [SHead|_Stail] = SList,
    not(QHead = SHead),
    safe(SList),
    popfront(SList,LastS,SListNew),
    append(QList,[LastS],QListNew).

solution(QList,[],[]):-
    sorted(QList),!.

solution(QList,SList,[Move|Moves]):-
   % not(member([QList,SList],Visited)),
    move(QList,SList,Move,QListNew,SListNew),
   %(QList,SList,Visited,VisitedNew-S),
    solution(QListNew,SListNew,Moves).

read_input(File, QList) :-
    open(File, read, Stream),
    read_line(Stream, [_]),
    read_line(Stream, QList).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


qssort(File,Answer):-
    read_input(File,QList),
    go(QList,Moves),
   (Moves = [] -> Answer = "empty";
          atomics_to_string(Moves,Answer)),
   !.

