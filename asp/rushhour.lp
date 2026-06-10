max_stati(1..s). % t passato dal solver
max_spostamento(1..6).
griglia(1..6, 1..6).
uscita(5, 3). % usiamo perché consideriamo la posizione X, Y come la prima posizione partendo da in alto a sinistra
direzione(su; giu; sinistra; destra).
orientamento(verticale; orizzontale).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Occupazione celle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cella_occupata(S, X, Y..Y + Lunghezza - 1) :-
    max_stati(S),
    griglia(X, Y),
    veicolo(Id, Lunghezza, verticale),
    stato(S, Id, X, Y).

cella_occupata(S, X..X + Lunghezza - 1, Y) :-
    max_stati(S),
    griglia(X, Y),
    veicolo(Id, Lunghezza, orizzontale),
    stato(S, Id, X, Y).

cella_libera(S, X, Y) :- 
    griglia(X, Y), 
    max_stati(S),
    not cella_occupata(S, X, Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Azioni ammissibili
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

azione_ammissibile(S, Id, su, Spostamento) :-
    max_stati(S), % lo stato deve esistere
    veicolo(Id, Lunghezza, verticale), % il veicolo deve esistere
    griglia(X, Y), % posizione testa iniziale
    griglia(X, Y + Lunghezza + Spostamento - 1), % posizione di coda finale
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    stato(S, Id, X, Y), % lo stato deve esistere
    Spostamento { cella_libera(S, X, Y + Lunghezza..Y + Lunghezza + Spostamento - 1) } Spostamento. % devono essere tutte celle libere da testa iniziale - 1 (per non controllare nuovamente la cella iniziale)  a coda finale

azione_ammissibile(S, Id, giu, Spostamento) :-
    max_stati(S), % lo stato deve esistere
    veicolo(Id, Lunghezza, verticale), % il veicolo deve esistere
    griglia(X, Y), % posizione di testa iniziale
    griglia(X, Y - Spostamento), % posizione di coda finale 
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    stato(S, Id, X, Y), % lo stato deve esistere
    Spostamento { cella_libera(S, X, Y - Spostamento..Y - 1) } Spostamento. % devono essere tutte celle libere da testa iniziale - 1 (per non controllare nuovamente la cella iniziale) a coda finale

azione_ammissibile(S, Id, sinistra, Spostamento) :-
    max_stati(S), % lo stato deve esistere
    veicolo(Id, Lunghezza, orizzontale), % il veicolo deve esistere
    griglia(X, Y), % posizione testa iniziale
    griglia(X - Spostamento, Y), % posizione di coda finale
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    stato(S, Id, X, Y), % lo stato deve esistere
    Spostamento { cella_libera(S, X - Spostamento..X-1, Y) } Spostamento. % devono essere tutte celle libere da testa iniziale - 1 (per non controllare nuovamente la cella iniziale)  a coda finale

azione_ammissibile(S, Id, destra, Spostamento) :-
    max_stati(S), % lo stato deve esistere
    veicolo(Id, Lunghezza, orizzontale), % il veicolo deve esistere
    griglia(X, Y), % posizione di testa iniziale
    griglia(X + Lunghezza + Spostamento - 1, Y), % posizione di coda finale 
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    stato(S, Id, X, Y), % lo stato deve esistere
    Spostamento { cella_libera(S, X + Lunghezza..X + Lunghezza + Spostamento - 1, Y) } Spostamento. % devono essere tutte celle libere da testa iniziale - 1 (per non controllare nuovamente la cella iniziale) a coda finale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transizione di stato
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

1 { transizione_di_stato(S, Id, Direzione, Spostamento) :
        veicolo(Id, _, _), 
        direzione(Direzione),
        max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
        azione_ammissibile(S, Id, Direzione, Spostamento) } 1 :-
        max_stati(S), % Per ogni stato S genera una e una sola transizione di stato valida
        S < s,
        not goal(S). % Non generiamo transizioni per l'ultimo stato

veicolo_in_transizione(S, Id) :- 
    transizione_di_stato(S, Id, Direzione, Spostamento), 
    direzione(Direzione),
    griglia(Spostamento, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stati aggiornati
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stato(S + 1, Id, X, Y + Spostamento) :-
    stato(S, Id, X, Y),
    veicolo(Id, _, verticale),
    griglia(X, Y),
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    max_stati(S),
    max_stati(S + 1),
    transizione_di_stato(S, Id, su, Spostamento).

stato(S + 1, Id, X, Y - Spostamento) :-
    stato(S, Id, X, Y),
    veicolo(Id, _, verticale),
    griglia(X, Y),
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    max_stati(S),
    max_stati(S + 1),
    transizione_di_stato(S, Id, giu, Spostamento).

stato(S + 1, Id, X - Spostamento, Y) :-
    stato(S, Id, X, Y),
    veicolo(Id, _, orizzontale),
    griglia(X, Y),
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    max_stati(S),
    max_stati(S + 1),
    transizione_di_stato(S, Id, sinistra, Spostamento).

stato(S + 1, Id, X + Spostamento, Y) :-
    stato(S, Id, X, Y),
    veicolo(Id, _, orizzontale),
    griglia(X, Y),
    max_spostamento(Spostamento), % lo spostamento non deve essere superiore al massimo spostamento ammissibile
    max_stati(S),
    max_stati(S + 1),
    transizione_di_stato(S, Id, destra, Spostamento).

stato(S + 1, Id, X, Y) :-
    stato(S, Id, X, Y),
    veicolo(Id, _, _),
    griglia(X, Y),
    max_stati(S),
    max_stati(S + 1),
    not veicolo_in_transizione(S, Id).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Goal finale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Il goal è portare lo stato iniziale in uno stato che soddisfi (1, 5, 3)
goal(S) :- 
    stato(S, 1, X, Y),
    uscita(X, Y).

:- not goal(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ottimizzazione
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prendiamo l'answer set che ha meno transizioni di stato per raggiungere il goal
:~ transizione_di_stato(S, Id, Direzione, Spostamento). [1@1, S, Id]

#show transizione_di_stato/4.
#show stato/4.