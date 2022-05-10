:- ["card.pl"].
%TDA cardsSet
%Representacion: cardList ([card,card,card,...]).
%Para crear cartas el cardsSet utiliza la siguiente proposición de manera recursiva: 
% ∃ A ∈ Z ^ ∉ K / A = Simbolo, Z = Elements, K = Simbolos de la carta
%=> Existe un Simbolo perteneciente a Elements y no pertenece a la Carta.
%Para crear el conjunto de cartas utiliza la siguiente proposicion: 
% ∃ A tal que ∀ B ∈ Z ∃! C ∈ A ^ ∈ B <=> A ≠ B / A = carta, B = carta, Z = Conjunto de Cartas, C = Elemento de carta
%=> Existe una Carta tal que para toda Carta perteneciente al Conjunto de cartas, existe un Unico simbolo en común entre ambas cartas.
%Logicamente esto lo hace si se cumplen los requisitos de entrada, y en caso de un conjunto de cartas vacios entonces la carta cumple y se agrega al conjunto.
/*
----------------Dominios------------------
Elements: Lista desde donde se puede obtener una muestra de elementos (números, letras, figuras, etc.) para construir el conjunto de cartas.
NumE: Entero positivo que indica la cantidad de elementos esperada en cada carta
MaxC: Entero que indica la cantidad máxima de cartas que se busca generar en el conjunto. Si maxC es una variable, entonces se producen todas las cartas posibles para un conjunto válido y esta variable toma el valor de la cantidad de cartas máximas generadas.
Seed: Semilla usada para generar números pseudo-aleatorios, utilice la misma función disponible para el laboratorio 1, pero convertido su código a una relación en prolog.
CS: TDA con el set de cartas generado.
FC: Primera carta listada del TDA cardsSet.
NC: Siguientes cartas listadas despues de la primera de un TDA cardsSet.
N: Orden del plano proyectivo.
A: Elemento cualquiera a buscar en una lista
B: Lista en la que se desea buscar un elemento
Card: TDA card
CardOut = NewCard: TDA card de salida
Conjunto: Lista de cartas antes de ser un CardsSet
Position: Numero que representa un indice dentro de una lista
---------------Predicados-----------------
cardsSet(Elements,NumE,MaxC,Seed,CS).                            aridad = 5
cardsSet_GetFirstCard(CS,FC).                                    aridad = 2
cardsSet_GetNextCards(CS,NC).                                    aridad = 2
cardsSet_GetNthCard(CS,Cont,Position,Card).                      aridad = 4
existe(A,B).                                                     aridad = 2
crearCarta(Card,Elements,NumE,CardOut).                          aridad = 4
dobleExistencia(Card1,Card2).                                    aridad = 2
just1Match(Card1,Card2).                                         aridad = 2
verificarConjunto(CS,NewCard).                                   aridad = 2
crearConjunto(Conjunto,Elements,NumE,MaxC,ConjuntoOut).          aridad = 5
addIfNotExist(Elements1,Elements2,Salida).                       aridad = 3
getElements(CS,Elements,Salida).                                 aridad = 3
myRandom(Xn, Xn1).                                               aridad = 2


-------------Metas Primarias--------------
cardsSet
cardsSet_GetFirstCard
cardsSet_GetNextCard
cardsSet_GetNthCard

------------Metas Secundarias-------------
existe
crearCarta
dobleExistencia
just1Match
verificarConjunto
crearConjunto
addIfNotExist
getElements
myRandom
*/

%-----------------------------------------------------------------------------------------------------

%---------------Reglas---------------

%constructor
cardsSet(Elements,NumE,MaxC,Seed,CS):-
    var(MaxC),
    N is NumE-1,
    MaxC is N * N + N + 1,
    cardsSet(Elements,NumE,MaxC,Seed,CS).
cardsSet(Elements,NumE,MaxC,Seed,CS):-
    var(Seed),
    Seed = 123,
    cardsSet(Elements,NumE,MaxC,Seed,CS).
cardsSet(Elements,NumE,MaxC,Seed,CS):-
    integer(NumE),
    integer(MaxC),
    integer(Seed),
    NumE > 0, MaxC > 0,
    crearConjunto([],Elements,NumE,MaxC,CS).

%pertenencia

%Funcion cardsSetIsDobble presente en el main

%Selectores

%Unifica FC con la primera carta del CS
cardsSet_GetFirstCard([FC|_],FC).
%Unifica NC con las cartas siguientes del CS despues de la primera 
cardsSet_GetNextCards([_|NC],NC).
%Obtiene la n-ésima (nth) carta desde el conjunto de cartas partiendo desde 0 hasta (totalCartas-1)
cardsSet_GetNthCard(CS,Cont,Cont,Card):-
    cardsSet_GetFirstCard(CS,Card).
cardsSet_GetNthCard(CS,Cont,Position,Card):-
    cardsSet_GetNextCards(CS,NC),
    Cont1 is Cont+1,
    cardsSet_GetNthCard(NC,Cont1,Position,Card).



    



%------------------Metas secundarias (clausulas propias del TDA)------------------

%Verifica si existe un simbolo en una carta.
existe(_,[]):-
    !,fail.
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
    existe(A,Card1),existe(A,Card2),!,
    not(dobleExistencia(Card1,Card2)).

%Verifica que una carta que se quiere agregar a un conjunto coincida solo en un elemento con cada una de las cartas del conjunto.
verificarConjunto([],_).
verificarConjunto([First|Conjunto],NewCard):-
    card_getSimbolos(First,Card1),
    card_getSimbolos(NewCard,Card2),
    just1Match(Card1,Card2),!,
    verificarConjunto(Conjunto,NewCard).


%Crea un conjunto de cartas valido
crearConjunto(Conjunto,_,_,MaxC,ConjuntoOut):-
    length(Conjunto,MaxC),
    ConjuntoOut = Conjunto.
crearConjunto(_,Elements,NumE,_,_):-
    N is NumE-1,
    MinSymb is N * N + N + 1,
    length(Elements, LargoE),
    LargoE < MinSymb,!,fail.
crearConjunto(Conjunto,Elements,NumE,MaxC,ConjuntoOut):-
    crearCarta([],Elements,NumE,NewCard),
    verificarConjunto(Conjunto,NewCard),!,
    append(Conjunto,[NewCard],NewConjunto),
    crearConjunto(NewConjunto,Elements,NumE,MaxC,ConjuntoOut).


%Agrega un elemento a una lista si es que este no existe en la misma
addIfNotExist([],Elements,Salida):-
    Salida = Elements.
addIfNotExist([FirstSymbol|NextSymbols],Elements,Salida):-
    not(existe(FirstSymbol,Elements)),
    append(Elements,[FirstSymbol],Elements2),
    addIfNotExist(NextSymbols,Elements2,Salida).

addIfNotExist([FirstSymbol|NextSymbols],Elements,Salida):-
    existe(FirstSymbol,Elements),
    addIfNotExist(NextSymbols,Elements,Salida).


%Obtiene el conjunto de elementos que forman a las cartas del CS
getElements([],Elements,Elements).
getElements(CS,Elements,Salida):-
    cardsSet_GetFirstCard(CS,FC),
    cardsSet_GetNextCards(CS,NC),
    card_getSimbolos(FC,Symbols),
    addIfNotExist(Symbols,Elements,Elements2),
    getElements(NC,Elements2,Salida).



myRandom(Xn, Xn1):-
    AX is 1103515245 * Xn,
    AXC is AX + 12345,
    Xn1 is (AXC mod 2147483647).    