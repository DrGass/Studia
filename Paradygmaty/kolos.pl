mnoznikX(_, [], []).
mnoznikX(X, [H|T], [H2|T2]) :- 
    H2 is H * X, 
    mnoznikX(X, T, T2).

dodajX(_, [], []).
dodajX(X, [H|T], [H2|T2]) :- 
    H2 is H + X, 
    dodajX(X, T, T2).

po_el([], _, []).
po_el([H|T], X, [H, X|T2]) :- po_el(T, X, T2).

multiply([],[],[]).
multiply([X1|Xs],[X2|Ys],[Z|Zs]) :- Z is X1*X2,  multiply(Xs,Ys,Zs). 

suma([],0).
suma([X|Xs], S) :- suma(Xs,S1), S is X+S1.

l1plusl2([], [], _, []).
l1plusl2([X|Xs], [Y|Ys], A, [Z|Zs]) :-
    Z is X + A * Y,
    l1plusl2(Xs, Ys, A, Zs).

niedodatnia1([H|_]) :- H =< 0.

iloczyn12([X,Y|_], S) :- S is X * Y.

zastap2([], []).
zastap2([H|T], [H2|T2]) :- 
    atom_concat(H, ' - ', H1),
    atom_concat(H1, H, H2), zastap2(T, T2).

k1plusl2([], [], _, []).
k1plusl2([X|Xs], [Y|Ys], A, [Z|Zs]) :-
    Z is (X + A * Y) ** 2,
    k1plusl2(Xs, Ys, A, Zs).

xlist([],[]).
xlist([H|T], [[x,H]|T2]) :-
    xlist(T, T2).

sqr2([_, X|_], S) :- S is X*X.

onetwo(L) :-
    length(L, Len),
    (Len =:= 1 ; Len =:= 2).

wieksza1([X, Y |_]) :- X > Y.

roznica21([X, Y |_],R) :- 
    R is Y - X.

sumsqr([],[],[]).
sumsqr([H1|T1],[H2|T2],[H3|T3]) :-
    H3 is (H1 ** 2) + (H2 ** 2),
    sumsqr(T1,T2,T3).