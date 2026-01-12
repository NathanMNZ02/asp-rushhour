%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definizione parametri iniziali
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dominio
grid(1..6, 1..6).          % griglia 6x6
time(0..20).               % intervallo temporale
offset(0..2).              % helper per occupazione celle

% Lunghezze veicoli
length(truck,3).
length(car,2).
length(red_car,2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definizione veicoli all'istante 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vehicle(0, Id, truck, X, Y, O) :- time(0), truck(0, Id, X, Y, O).
vehicle(0, Id, car, X, Y, O) :- time(0), car(0, Id, X, Y, O).
vehicle(0, Id, red_car, X, Y, O) :- time(0), red_car(0, Id, X, Y, O).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Possibili evoluzioni dei veicoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se non c'è nessun movimento che lo riguarda rimane fermo
vehicle(Time+1, Id, Type, X, Y, O) :-
    time(Time),
    vehicle(Time, Id, Type, X, Y, O),
    not moved(Time, Id).

% Mossa in orizzontale
vehicle(Time+1, Id, Type, X+1, Y, horizontal) :-
    time(Time),
    move(Time, Id, forward),
    vehicle(Time, Id, Type, X, Y, horizontal).

vehicle(Time+1, Id, Type, X-1, Y, horizontal) :-
    time(Time),
    move(Time, Id, backward),
    vehicle(Time, Id, Type, X, Y, horizontal).

% Mossa in verticale
vehicle(Time+1, Id, Type, X, Y+1, vertical) :-
    time(Time),
    move(Time, Id, forward),
    vehicle(Time, Id, Type, X, Y, vertical).

vehicle(Time+1, Id, Type, X, Y-1, vertical) :-
    time(Time),
    move(Time, Id, backward),
    vehicle(Time, Id, Type, X, Y, vertical).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generazione delle mosse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{ move(Time, Id, D) } :- vehicle(Time, Id, _, _, _, _), D = forward; D = backward.
moved(Time, Id) :- move(Time, Id, _).