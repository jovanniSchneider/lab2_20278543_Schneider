:- ["cardsSet.pl"].

%TDA game
%Representacion: NumPlayers X Players X CardsSet X Mode X Scores X Turn X State
/*
----------------Dominios------------------
NumPlayers: Entero que señala la cantidad de jugadores.
Players: Lista que contiene a los jugadores
CardsSet(CS): Conjunto válido de cartas.
Mode: String que indica el modo de juego, la forma en que se ejecutan los turnos, repartición de cartas, etc, debe indicar en sus ejemplos de uso y manual los valores posibles que deben ser puestos en este argumento.
Seed: Semilla usada para generar números pseudo-aleatorios.
Game: TDA que alberga el área de juego, las piezas disponibles, jugadores registrados, sus cartas y el estado del juego, entre otros elementos.


---------------Predicados-----------------
dobbleGame(NumPlayers,CS,Mode,Seed,Game)    aridad = 5
game_getNumPlayers(Game,NP)                 aridad = 2
game_getPlayers(Game,P)                     aridad = 2
game_getCardsSet(Game,CS)                   aridad = 2
game_getMode(Game,Mode)                     aridad = 2
game_getScores(Game,S)                      aridad = 2
game_getTurn(Game,Turn)                     aridad = 2
game_getState(Game,State)                   aridad = 2
dobbleGameRegister(User,GameIn,GameOut)     aridad = 3

--------------Metas Primarias---------------
dobbleGame
game_getNumPlayers
game_getPlayers
game_getCardsSet
game_getMode
game_getScores
game_getTurn
game_getState
dobbleGameRegister
%-------------Metas secundarias (clausulas propias del TDA)-----------------
*/

%-----------------------------------------------------------------------------------------------------


%---------------Clausulas de Horn------------------

estado(1,"Iniciado").
estado(2,"Jugando").
estado(3,"Terminado").
%---------------Reglas---------------

%Constructor
dobbleGame(NumPlayers,CS,Mode,Seed,Game):-
    cardsSetIsDobble(CS),integer(NumPlayers),string(Mode),integer(Seed),
    Game = [NumPlayers,[],CS,Mode,[],1,1].

%Selectores
%Unifica NP con el numero de jugadores de un game
game_getNumPlayers([NP|_],NP).
%Unifica P con la lista de jugadores de un game
game_getPlayers([_|[P|_]],P).
%Unifica CS con el cardsSet de un game
game_getCardsSet([_|[_|[CS|_]]],CS).
%Unifica Mode con el modo de juego de un game
game_getMode([_|[_|[_|[Mode|_]]]],Mode).
%Unifica S con la lista de scores de un game
game_getScores([_|[_|[_|[_|[S|_]]]]],S).
%Unifica Turn con el turno correspondiente de un game
game_getTurn([_|[_|[_|[_|[_|[Turn|_]]]]]],Turn).
%Unifica State con el estado de un game
game_getState([_|[_|[_|[_|[_|[_|[State|_]]]]]]],State).

%permite relacionar un TDA de juego previo a registrar un jugador con el TDA resultante luego de haber registrado a un jugador
dobbleGameRegister(_,Game,_):-
    game_getNumPlayers(Game,NP),
    game_getPlayers(Game,P),
    length(P, NP),
    !,fail.

dobbleGameRegister(User,Game,_):-
    game_getPlayers(Game,P),
    existe(User,P),
    !,fail.
    
dobbleGameRegister(User,Game,GameOut):-
    game_getNumPlayers(Game,NP),
    game_getPlayers(Game,P),
    game_getCardsSet(Game,CS),
    game_getMode(Game,Mode),
    game_getScores(Game,Scores),
    game_getTurn(Game,Turn),
    game_getState(Game,State),
    append(P,[User],P2),
    GameOut = [NP,P2,CS,Mode,Scores,Turn,State].