%TDA Card
%Representacion: CantidadSimbolos(Int) X Simbolos(list) X Card(card)
/*
----------------Dominios------------------
Cant: Entero que representa la cantidad de simbolos que contiene la lista Simbolos.
Simbolos: Lista que contiene los simbolos pertenecientes a la carta
Card: TDA card

---------------Predicados-----------------
card(CantidadSimbolos,Simbolos,Card)
isCard(Card).
card_getCantidad(Card,Cant).
card_getSimbolos(Card,Simbolos).
card_getCant(Card,Cant).
card_getSimb(Card,Simbolos).

--------------Metas---------------
card
isCard
card_getCantidad
card_getSimbolos

*/

%Constructor
card(_,[],Card):- %Si entra una lista vacia la idea es que no se pueda hacer backtracking a la siguiente opcion.
	Card = [0,[]],!.
card(Cant,Simbolos,Card):-
	integer(Cant),Cant>0,
	Card = [Cant,Simbolos].



%Pertenencia
isCard([Cant|[Simbolos|_]]):-
	integer(Cant),
	length(Simbolos, Cant).

%Selectores

%"Entrega" la cantidad de simbolos
card_getCantidad(Card,Cant):-
	isCard(Card),
	card_getCant(Card,Cant).

%"Entrega la lista de simbolos"
card_getSimbolos(Card,Simbolos):-
	isCard(Card),
	card_getSimb(Card,Simbolos).

%Modificadores
agregarSimbolo([Cant|[Simbolos|_]],Simbolo,NewCard):-
	append(Simbolos,[Simbolo],NewSimbolos),
	NewCant is Cant+1,
	card(NewCant,NewSimbolos,NewCard).



%--------------------------------------------------------------------

%Metas secundarias (clausulas propias del TDA)

%Unifica el primer elemento de el Card, es decir la cantidad, en la variable Out.
card_getCant([Cant|_],Out):-
	Out = Cant.

%Unifica el segundo elemento de el Card, es decir la lista de simbolos, en la variable Out.
card_getSimb([_|[Simbolos|_]],Out):-
	Out = Simbolos.