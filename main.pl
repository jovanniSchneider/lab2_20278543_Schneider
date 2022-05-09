:-["TDAs/card.pl"].
:-["TDAs/cardsSet.pl"].
:-["TDAs/game.pl"].

%cardsSetIsDobble(CardsSet)
cardsSetIsDobble(A):-
    A = 1+1, %Se le asigna cualquier valor, ya que si no está instaciada va a unificar, si está instaciada fallará.
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

%cardsSetFindTotalCards(Card,TotalCards)
cardsSetFindTotalCards(Carta,TC):-
    card_getCantidad(Carta,Cantidad),
    N is Cantidad-1,
    TC is N*N + N + 1.

%cardsSetMissingCards(CardsSet,MissingCards)
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




%cardsSetToString(CardsSet,String)
cardsSetToString(CS,CS_STR):-
    toStringAux(CS,"",CS_STR).
    

%-------------Metas secundarias------------

%just1MatchWithEachCard(FirstCard,NextCards)
j1MWithEachCard(_,[]).
j1MWithEachCard(FC,NC):-
    cardsSet_GetFirstCard(NC,SC),
    just1Match(FC,SC),
    cardsSet_GetNextCards(NC,NC2),
    j1MWithEachCard(SC,NC2).

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

esPrimo(Numero,Divisor):-
    Divisor >= Numero.
esPrimo(Numero,Divisor):-
    Cociente is Numero mod Divisor,
    Cociente = 0,!,fail.
esPrimo(Numero,Divisor):-
    D2 is Divisor+1,
    esPrimo(Numero,D2).

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

esPotenciaDe(1,_):-
    !.
esPotenciaDe(N,Base):-
    Modulo is N mod Base,
    Modulo = 0,
    N2 is N / Base,
    esPotenciaDe(N2,Base).

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

eliminarRepetidas([],_,CSOut,CSOut).
eliminarRepetidas([FC|NC],CS2,CSAux,CSOut):-
    existe(FC,CS2),
    eliminarRepetidas(NC,CS2,CSAux,CSOut).
eliminarRepetidas([FC|NC],CS2,CSAux,CSOut):-
    append(CSAux,[FC],CSAux2),
    eliminarRepetidas(NC,CS2,CSAux2,CSOut).