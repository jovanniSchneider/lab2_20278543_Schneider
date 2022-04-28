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


myRandom(Xn, Xn1):-
    AX is 1103515245 * Xn,
    AXC is AX + 12345,
    Xn1 is (AXC mod 2147483647).    