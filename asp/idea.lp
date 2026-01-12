%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definizione parametri iniziali
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dominio
grid(1..6, 1..6).          % griglia 6x6
time(0..20).               % intervallo temporale
offset(0..2).              % helper per occupazione celle

% Lunghezze veicoli
length(truck,3).
length(car,2).
length(red_car,2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definizione veicoli all'istante 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vehicle(0, Id, truck, X, Y, O) :- truck(0, Id, X, Y, O).
vehicle(0, Id, car, X, Y, O)   :- car(0, Id, X, Y, O).
vehicle(0, Id, red_car, X, Y, O) :- red_car(0, Id, X, Y, O).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inerzia: se il veicolo non si muove resta fermo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vehicle(Time+1, Id, Type, X, Y, O) :-
    vehicle(Time, Id, Type, X, Y, O),
    not moved(Time, Id).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mosse dei veicoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Mossa in orizzontale
vehicle(Time+1, Id, Type, X+1, Y, horizontal) :-
    move(Time, Id, forward),
    vehicle(Time, Id, Type, X, Y, horizontal).

vehicle(Time+1, Id, Type, X-1, Y, horizontal) :-
    move(Time, Id, backward),
    vehicle(Time, Id, Type, X, Y, horizontal).

% Mossa in verticale
vehicle(Time+1, Id, Type, X, Y+1, vertical) :-
    move(Time, Id, forward),
    vehicle(Time, Id, Type, X, Y, vertical).

vehicle(Time+1, Id, Type, X, Y-1, vertical) :-
    move(Time, Id, backward),
    vehicle(Time, Id, Type, X, Y, vertical).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Celle occupate dai veicoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
busy(Time, Id, X+I, Y) :-
    vehicle(Time, Id, Type, X, Y, horizontal),
    length(Type, L),
    offset(I), I < L.

busy(Time, Id, X, Y+I) :-
    vehicle(Time, Id, Type, X, Y, vertical),
    length(Type, L),
    offset(I), I < L.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generazione delle mosse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{ move(Time, Id, D) } :- vehicle(Time, Id, _, _, _, _), D = forward; D = backward.
moved(Time, Id) :- move(Time, Id, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controllo se la mossa è consentita
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
movement_allowed(Time, Id, forward) :-
    vehicle(Time, Id, Type, X, Y, horizontal),
    length(Type, L),
    NX = X + L,
    grid(NX, Y),
    not busy(Time, _, NX, Y).

movement_allowed(Time, Id, backward) :-
    vehicle(Time, Id, Type, X, Y, horizontal),
    PX = X - 1,
    grid(PX, Y),
    not busy(Time, _, PX, Y).

movement_allowed(Time, Id, forward) :-
    vehicle(Time, Id, Type, X, Y, vertical),
    length(Type, L),
    NY = Y + L,
    grid(X, NY),
    not busy(Time, _, X, NY).

movement_allowed(Time, Id, backward) :-
    vehicle(Time, Id, Type, X, Y, vertical),
    PY = Y - 1,
    grid(X, PY),
    not busy(Time, _, X, PY).

% Blocca le mosse illegali
:- move(Time, Id, D), not movement_allowed(Time, Id, D).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vincoli generali
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nessuna cella può essere occupata da più veicoli
:- busy(Time, Id1, X, Y), busy(Time, Id2, X, Y), Id1 != Id2.

% Tutte le celle dei veicoli devono essere dentro la griglia
:- vehicle(Time, Id, Type, X, Y, horizontal), length(Type, L), offset(I), I < L, not grid(X+I, Y).
:- vehicle(Time, Id, Type, X, Y, vertical), length(Type, L), offset(I), I < L, not grid(X, Y+I).

% Una sola mossa per turno
:- #count { Id,D : move(Time, Id, D) } > 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vincoli speciali per la macchina rossa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- red_car(Time, Id, X, Y, O), O != horizontal.
:- red_car(Time, Id, X, Y, O), Y != 3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Goal: red car deve arrivare all'uscita (X=5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
goal(Time) :-
    vehicle(Time, Id, red_car, X, 3, horizontal),
    X = 5.

%:- not goal(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ottimizzazione (opzionale: minimizzare il numero di mosse)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:~ move(Time, _, _). [1@0, Time]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#show move/3.