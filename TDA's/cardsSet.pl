:- ["card.pl"].
%TDA cardsSet
%Representacion: Elements(list) X numE(int) X maxC(int) X seed (int) X CS (CardSet)
/*
----------------Dominios------------------
Elements: Lista desde donde se puede obtener una muestra de elementos (números, letras, figuras, etc.) para construir el conjunto de cartas.
numE: Entero positivo que indica la cantidad de elementos esperada en cada carta
maxC: Entero que indica la cantidad máxima de cartas que se busca generar en el conjunto. Si maxC es una variable, entonces se producen todas las cartas posibles para un conjunto válido y esta variable toma el valor de la cantidad de cartas máximas generadas.
seed: Semilla usada para generar números pseudo-aleatorios, utilice la misma función disponible para el laboratorio 1, pero convertido su código a una relación en prolog.
CS: TDA con el set de cartas generado.

---------------Predicados-----------------
cardsSet(Elements,NumE,MaxC,Seed,CS)

*/

%constructor
cardsSet(Elements,NumE,MaxC,Seed,CS):-
    integer(NumE, MaxC, Seed),
    NumE > 0, MaxC > 0.


    



%Metas secundarias (clausulas propias del TDA)

%Verifica si existe un simbolo en una carta.
existe(A,[A|_]).
existe(A,[_|B]):-
    existe(A,B).


%Crea una carta de elementos sin repetición a partir de un conjunto de elementos.
crearCarta(Card,_,NumE,CardOut):-
    length(Card, NumE),
    card(NumE,Card,CardOut).
crearCarta(Card,Elements,NumE,CardOut):-
    existe(A,Elements),
    not(existe(A,Card)),
    append(Card,[A],Card1),
    crearCarta(Card1,Elements,NumE,CardOut).

%Verifica si hay al menos 2 elementos repetidos en 2 cartas
dobleExistencia(Card1,Card2):-
    existe(A,Card1), existe(A,Card2),
    existe(B,Card1), existe(B,Card2),
    A\=B.

%Verifica que solo haya un elemento repetido en 2 cartas
just1Match(Card1,Card2):-
    existe(A,Card1),existe(A,Card2),
    not(dobleExistencia(Card1,Card2)).

verificarConjunto([],_).
verificarConjunto([First|Conjunto],NewCard):-
    card_getSimbolos(First,Card1),
    card_getSimbolos(NewCard,Card2),
    just1Match(Card1,Card2),
    verificarConjunto(Conjunto,NewCard).


%Crea un conjunto de cartas valido
crearConjunto(Conjunto,_,_,MaxC,ConjuntoOut):-
    length(Conjunto,MaxC),!,
    ConjuntoOut = Conjunto.
crearConjunto([],Elements,NumE,MaxC,ConjuntoOut):-
    crearCarta([],Elements,NumE,NewCard),
    append([],[NewCard],NewConjunto),
    crearConjunto(NewConjunto,Elements,NumE,MaxC,ConjuntoOut).
crearConjunto(Conjunto,Elements,NumE,MaxC,ConjuntoOut):-
    crearCarta([],Elements,NumE,NewCard),
    verificarConjunto(Conjunto,NewCard),
    append(Conjunto,[NewCard],NewConjunto),
    crearConjunto(NewConjunto,Elements,NumE,MaxC,ConjuntoOut).
    



myRandom(Xn, Xn1):-
    AX is 1103515245 * Xn,
    AXC is AX + 12345,
    Xn1 is (AXC mod 2147483647).    