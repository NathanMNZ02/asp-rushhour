% Helper per generare offset
offset(0..2).

% Intervallo di tempo per dire mantenere lo stato dei veicoli
time(0..50).

grid(1..6, 1..6).

% Lunghezze dei vari veicoli
length(truck, 3).
length(car, 2).
length(red_car, 2).

% Definizione veicoli
vehicle(Time, T, X, Y, O) :- truck(Time, X, Y, O), T = truck.
vehicle(Time, T, X, Y, O) :- car(Time, X, Y, O), T = car.
vehicle(Time, T, X, Y, O) :- red_car(Time, X, Y, O), T = red_car.

% Celle occupate da un veicolo
busy(Time, T, X+I, Y) :- vehicle(Time, T, X, Y, horizontal), length(T, L), offset(I), I < L.
busy(Time, T, X, Y+I) :- vehicle(Time, T, X, Y, vertical), length(T, L), offset(I), I < L.

% VINCOLI: 

% Vincoli speciali per la macchina rossa

:- red_car(Time, X, Y, O), O != horizontal.
:- red_car(Time, X, Y, O), Y != 3.

% tutte le celle occupate devono essere nella griglia

% Orientamento orizzontale X, X+1, X+2
:- vehicle(Time, T, X, Y, horizontal), length(T, L), offset(I), I < L, not grid(X+I, Y).

% Orientamento verticale Y, Y+1, Y+2
:- vehicle(Time, T, X, Y, vertical), length(T, L), offset(I), I < L, not grid(X, Y+I).

% nessuna cella può essere occupata da più di un veicolo

:- busy(Time, T1, X, Y), busy(Time, T2, X, Y), T1 != T2.