:-["TDA's/card.pl"].
:-["TDA's/cardsSet.pl"].

%cardsSetIsDobble(CardsSet)
cardsSetIsDobble([firstCard|NextCards]):-
    just1Match(firstCard,NextCards),


%-------------Metas secundarias------------

obtenerNumE(firstCard,NextCards,NumE):-
