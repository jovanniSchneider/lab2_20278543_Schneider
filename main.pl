:-["TDAs/card.pl"].
:-["TDAs/cardsSet.pl"].
:-["TDAs/game.pl"].

/*
----------------Dominios------------------
V: Variable sin unificar
FirstCard = FC: Primera carta de un cardsSet
NextCards = NC: Siguientes cartas listadas despues de la primera de un TDA cardsSet.
N: Orden del plano proyectivo.
Carta: TDA card
TC: Total de cartas que debe tener un cardsSet
CS: TDA cardsSet
MC: Missing cards
CS_STR: cardsSet representado en un String
NumE: Entero positivo que indica la cantidad de elementos esperada en cada carta
Numero: Entero.
Divisor: Entero que divide recursivamente a Numero y suma 1 en cada llamado recursivo.
PreLista: Lista en la cual se van guardando los numeros primos antes de unificar con Lista
Base: Entero que representa la Base de un numero.
Str: String que va guardando el cardsSet parcialmente convertido a string.


---------------Predicados-----------------
cardsSetIsDobble(CardsSet)                              aridad = 1
cardsSetFindTotalCards(Carta,TC)                        aridad = 2
cardsSetMissingCards(CS,MC)                             aridad = 2
cardsSetToString(CS,CS_STR)                             aridad = 2
j1MWithEachCard(FC,NC)                                  aridad = 2
obtenerNumE(FirstCard,NextCards,NumE)                   aridad = 3
esPrimo(Numero,Divisor)                                 aridad = 2
primosHastaN(Numero,Contador,PreLista,Lista)            aridad = 4
esPotenciaDe(Numero,Base)                               aridad = 2
toStringAux(CS,Str,CS_STR)                              aridad = 3
eliminarRepetidas(CS1,CS2,CSAux,CSOut)                  aridad = 4
nthCard(CS,Position,Card)                               aridad = 3

--------------Metas Primarias---------------
cardsSetIsDobble
cardsSetFindTotalCards                        
cardsSetMissingCards                             
cardsSetToString 
nthCard
%-------------Metas secundarias (clausulas propias del TDA)-----------------
j1MWithEachCard
obtenerNumE
esPrimo
primosHastaN
esPotenciaDe
toStringAux
eliminarRepetidas
*/

%Permite verificar si el conjunto de cartas en el TDA corresponden a un conjunto válido.
cardsSetIsDobble(V):-
    V = 1+1, %Se le asigna cualquier valor, ya que si no está instaciada va a unificar, si está instaciada fallará.
    !,fail.
cardsSetIsDobble([]):-
    !,fail.
cardsSetIsDobble([FirstCard|NextCards]):-
    j1MWithEachCard(FirstCard,NextCards),
    obtenerNumE(FirstCard,NextCards,NumE),
    N is NumE-1,
    MaxC is N*N + N + 1,
    length(NextCards, LargoLessOne),
    LargoReal is LargoLessOne + 1,
    MaxC >= LargoReal,
    primosHastaN(N,2,[],Primos),
    existe(A,Primos),esPotenciaDe(N,A).

cardsSetIsDobble([FirstCard|NextCards]):-
    j1MWithEachCard(FirstCard,NextCards),
    obtenerNumE(FirstCard,NextCards,NumE),
    N is NumE-1,
    MaxC is N*N + N + 1,
    length(NextCards, LargoLessOne),
    LargoReal is LargoLessOne + 1,
    MaxC >= LargoReal,
    N = 1.

%Obtiene la n-ésima (nth) carta desde el conjunto de cartas partiendo desde 0 hasta (totalCartas-1)
nthCard(CS,Position,Card):-
    cardsSet_GetNthCard(CS,0,Position,Card).

%A partir de una carta de muestra, determina la cantidad total de cartas que se deben producir para construir un conjunto válido.
cardsSetFindTotalCards(Carta,TC):-
    card_getCantidad(Carta,Cantidad),
    N is Cantidad-1,
    TC is N*N + N + 1.

%A partir de un conjunto de cartas retorna el conjunto de cartas que hacen falta para que el set sea válido.
cardsSetMissingCards(CS,[]):-
    cardsSetIsDobble(CS),
    cardsSet_GetFirstCard(CS,FC),
    cardsSetFindTotalCards(FC,TC),
    length(CS,Largo),
    Largo = TC.
cardsSetMissingCards(CS,MC):-
    getElements(CS,[],Elements),
    cardsSet_GetFirstCard(CS,FC),
    cardsSet_GetNextCards(CS,NC),
    obtenerNumE(FC,NC,NumE),
    cardsSet(Elements,NumE,_,_,CSCompleto),
    eliminarRepetidas(CSCompleto,CS,[],MC).




%convierte un conjunto de cartas a una representación basada en strings que posteriormente pueda visualizarse a través de la función write.
cardsSetToString(CS,CS_STR):-
    toStringAux(CS,"",CS_STR).
    

%-------------Metas secundarias------------
%just1MatchWithEachCard(FirstCard,NextCards)
j1MWithEachCard(_,[]).
j1MWithEachCard(FC,NC):-
    cardsSet_GetFirstCard(NC,SC),
    card_getSimbolos(FC,Card1),
    card_getSimbolos(SC,Card2),
    just1Match(Card1,Card2),
    cardsSet_GetNextCards(NC,NC2),
    j1MWithEachCard(SC,NC2).

%Obtiene el NumE de un cardsSet
obtenerNumE(FirstCard,[],NumE):-
    card_getCantidad(FirstCard,NumE),!.
obtenerNumE(FirstCard,NextCards,_):-
    cardsSet_GetFirstCard(NextCards,SecondCard),
    card_getCantidad(FirstCard,A),card_getCantidad(SecondCard,B),
    A\=B,!,fail.
obtenerNumE(FirstCard,NextCards,NumE):-
    cardsSet_GetFirstCard(NextCards,SecondCard),
    card_getCantidad(FirstCard,A),card_getCantidad(SecondCard,A),
    cardsSet_GetNextCards(NextCards,NC2),
    obtenerNumE(SecondCard,NC2,NumE).

%Permite saber si Numero es primo, Divisor debe comenzar en 2
esPrimo(Numero,Divisor):-
    Divisor >= Numero.
esPrimo(Numero,Divisor):-
    Cociente is Numero mod Divisor,
    Cociente = 0,!,fail.
esPrimo(Numero,Divisor):-
    D2 is Divisor+1,
    esPrimo(Numero,D2).

%Entrega una carta con los numeros primos desde 2 hasta N, Contador debe comenzar en 2
primosHastaN(N,Contador,Lista,Lista):-
    N2 is N+1,
    N2 = Contador,!. 
primosHastaN(N,Contador,PreLista,Lista):-
    esPrimo(Contador,2),
    append(PreLista,[Contador],PreLista2),
    C2 is Contador+1,
    primosHastaN(N,C2,PreLista2,Lista).
primosHastaN(N,Contador,PreLista,Lista):-
    C2 is Contador+1,
    primosHastaN(N,C2,PreLista,Lista).

%Retorna verdadero si N es una potencia de Base
esPotenciaDe(1,_):-
    !.
esPotenciaDe(N,Base):-
    Modulo is N mod Base,
    Modulo = 0,
    N2 is N / Base,
    esPotenciaDe(N2,Base).

%Convierte un cardsSet en una representación en String
toStringAux([],CS_STR,CS_STR).
toStringAux(CS,Str,CS_STR):-
    cardsSet_GetFirstCard(CS,FC),
    cardsSet_GetNextCards(CS,NC),
    card_getSimbolos(FC,Simbolos),
    atomics_to_string(Simbolos, " ", String),
    string_concat("Carta: [", String, String1),
    string_concat(String1,"]  ",String2),
    string_concat(Str,String2,String3),
    toStringAux(NC,String3,CS_STR).


%Elimina las cartas que se repiten en 2 conjuntos y entrega un nuevo conjunto con las que no se repiten.
eliminarRepetidas([],_,CSOut,CSOut).
eliminarRepetidas([FC|NC],CS2,CSAux,CSOut):-
    existe(FC,CS2),
    eliminarRepetidas(NC,CS2,CSAux,CSOut).
eliminarRepetidas([FC|NC],CS2,CSAux,CSOut):-
    append(CSAux,[FC],CSAux2),
    eliminarRepetidas(NC,CS2,CSAux2,CSOut).




/*
**************************EJEMPLOS DE USO**********************************
TDA card:
constructor
    card(3,[a,b,c],Card). 
    card(2,[1,2],Card).
    card(7,[1,a,r,"c",[],2,3],Card).
Pertenencia
    card(3,[a,b,c],Card),isCard(Card).
    card(4,[1,2],Card),isCard(Card). %falla
    card(7,[1,a,r,"c",[],2,3],Card),isCard(Card).
Selectores
    card(3,[a,b,c],Card),card_getCantidad(Card,Cant).
    card(2,[1,2],Card),card_getSimbolos(Card,Simbolos).
Modificadores
    card(7,[1,a,r,"c",[],2],Card),agregarSimbolo(Card,q,NewCard).

--------------------------------------------------------------------

TDA cardsSet:
constructor
    cardsSet([1,2,3,4,5,6,7],3,7,123,CS)
    cardsSet([1,2,3,4,5,6,7],3,3,45312,CS)
    cardsSet([1,2,3,4],3,7,123,CS) %falla
Selectores
    cardsSet([1,2,3,4,5,6,7],3,7,123,CS),cardsSet_GetFirstCard(CS,FC).
    cardsSet([1,2,3,4,5,6,7],3,7,123,CS),cardsSet_GetNextCard(CS,NC).
    cardsSet([1,2,3,4,5,6,7],3,7,123,CS),cardsSetNthCard(CS,0,3,Card).

---------------------------------------------------------------------
Requisitos Funcionales:

cardsSetIsDobble
    cardsSet([1,2,3,4,5,6,7],3,7,123,CS),cardsSetIsDobble(CS).
    cardsSetIsDobble([[4,[a,b,c,g]],[4,[a,d,e,f]]]).
    cardsSetIsDobble([[3,[1,2,3]],[3,[1,2,5]]]). %falla porque se repiten 2 simbolos
cardsSetNthCard
    cardsSet([a,b,c,d,e,f,g],3,6,83271,CS), nthCard(CS,4,Card).
    cardsSet([a,b,c,d,e,f,g],3,6,83271,CS), nthCard(CS,6,Card). %Falla porque el ultimo indice es 5
    cardsSet([a,b,c,d,e,f,g],3,6,83271,CS), nthCard(CS,-1,Card).%Falla porque el primer indice es 0

cardsSetFindTotalCards:
    cardsSet([1,2,3,4,5,6,7],3,7,123,CS), nthCard(CS,4,Card), cardsSetFindTotalCards(Card,TotalCards).
    card(10,[q,w,e,r,t,y,u,i,o,p],Card),cardsSetFindTotalCards(Card,TotalCards).
    cardsSetFindTotalCards([8,[1,2,3,4,5,6,7,8]],TotalCards).

cardsSetMissingCards:
    cardsSet([1,2,3,4,5,6,7],3,3,45312,CS),cardsSetMissingCards(CS,MC).
    cardsSet([a,b,c,d,e,f,g],3,7,83271,CS),cardsSetMissingCards(CS,MC).
    cardsSet([1,2,3,4,5,6,7],3,2,45312,CS),cardsSetMissingCards(CS,MC). %Falla porque en las 2 cartas solo hay 5 simbolos distintos y no hay manera de saber que otros simbolos tenía el conjunto de elementos

cardsSetToString:
    cardsSet([1,2,3,4,5,6,7],3,3,45312,CS),cardsSetToString(CS,STR),write(STR).
    cardsSet([1,2,3,4,5,6,7],3,7,45312,CS),cardsSetToString(CS,STR),write(STR).
    cardsSetToString([123,456],STR),write(STR). %falla

dobbleGame:
    cardsSet([1,2,3,4,5,6,7],3,7,45312,CS),dobbleGame(2,CS,"Stack",71923,Game).
    dobbleGame(2,[],"Stack",71923,Game). %Falla porque la lista vacia no es un cardsSet valido.
    cardsSet([a,b,c,d,e,f,g],3,3,83271,CS),dobbleGame(4,CS,"Stack",71923,Game).

dobbleGameRegister:
    cardsSet([1,2,3,4,5,6,7],3,7,45312,CS),dobbleGame(2,CS,"Stack",71923,Game),dobbleGameRegister("Pedro",Game,Game2).
    cardsSet([1,2,3,4,5,6,7],3,7,45312,CS),dobbleGame(2,CS,"Stack",71923,Game),dobbleGameRegister("Pedro",Game,Game2),dobbleGameRegister("Pedro",Game2,Game3).
    %El anterior falla porque no puede ingresarse 2 usuarios con el mismo nombre
    cardsSet([1,2,3,4,5,6,7],3,7,45312,CS),dobbleGame(2,CS,"Stack",71923,Game),dobbleGameRegister("Pedro",Game,Game2),dobbleGameRegister("Juan",Game2,Game3),dobbleGameRegister("Diego",Game3,Game4).
    %El anterior falla porque el game está creado con 2 jugadores y se quieren ingresar 3.


*/
