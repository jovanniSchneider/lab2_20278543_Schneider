:- ["cardsSet.pl"].

%TDA game
%Representacion: NumPlayers X Players X CardsSet X Mode X Scores X Turn X State

%Constructor
%dobbleGame(numPlayers(int) , cardsSet X mode (string) X seed (int) X game (TDA Game))
dobbleGame(NumPlayers,CS,Mode,Seed,Game):-
    Game = [NumPlayers,[],CS,Mode,[],1,1].

%Selectores
game_getNumPlayers([NP|_],NP).
game_getPlayers([_|[P|_]],P).
game_getCardsSet([_|[_|[CS|_]]],CS).
game_getMode([_|[_|[_|[Mode|_]]]],Mode).
game_getScores([_|[_|[_|[_|[S|_]]]]],S).
game_getTurn([_|[_|[_|[_|[_|[Turn|_]]]]]],Turn).
game_getState([_|[_|[_|[_|[_|[_|[State|_]]]]]]],State).

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





%Metas secundarias

estado(1,"Iniciado").
estado(2,"Jugando").
estado(3,"Terminado").