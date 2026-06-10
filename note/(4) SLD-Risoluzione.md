# SLD-RISOLUZIONE

Prolog è un linguaggio a clausole definite, la sua risoluzione prende il nome di **SLD-Risoluzione** ed è il processo grazie al quale l’interprete Prolog riesce a rispondere a un goal applicato su un programma. Per fare ciò vengono eseguite una successione di trasformazioni sul goal fornito, in ogni passo di risoluzione avviene:

1. La selezione di uno dei letterali del goal.
2. La scelta di un opportuna clausola del programma.
3. L’unificazione dei letterali del goal con quelli della clausola per ottenere il nuovo goal.

Il processo, che prende anche il nome di **backward chaining**, per il fatto che l’interprete se non trova la soluzione seguendo una strada torna indietro e prova un altra strada, termina se:

1. Al punto 1 non ci sono di letterali selezionabili.
2. Al punto 2 non c’è nessuna delle clausole che permette di effettuare il passo 3.

Di seguito un’esempio:

```python
padre(antonio, bruno).
padre(antonio, carlo).
padre(bruno, davide).
padre(bruno, ettore).

antenato(X, Y) :- padre(X, Y).
antenato(X, Y) :- antenato(X, Z), padre(Z, Y). % Ricorsione su antenato finché o X è padre di Z o Z è padre di Y
```

con il seguente goal iniziale `?-antenato(antonio, Y).`, l’interprete Prolog lavorerà come segue:

- Output: `yes Y=bruno`.
- Passi:
    1. Viene selezionato un letterale del goal: in questo caso c’è un solo letterale, quindi 
    `?-antenato(antonio, Y).` 
    2. Si cerca nel programma una clausola la cui testa unifichi con l’atomo `antenato(antonio, Y)`, la prima ad essere incontrata (dall’alto verso il basso) è la clausola `antenato(X, Y) :- padre(X, Y).`
    3. Per evitare conflitti viene fatta una rinomina delle variabili nella clausola selezionata: 
        
        ```prolog
        antenato(X, Y) :- padre(X, Y). --> antenato(X1, Y1) :- padre(X1, Y1).
        ```
        
    4. Viene trovato l’m.g.u usando la sostituzione data dal letterale selezionato, in questo caso sarà $[X_1 / antonio, Y_1 / Y]$, ora quindi il nuovo goal da risolvere sarà `padre(antonio, Y).`
    5. Ora il processo continuerà reiterando quanto appena visto:
        
        ```prolog
        padre(antonio, Y) --> padre(antonio, bruno) --> [Y/bruno].
        ```
        
        il goal finale risultante da questa ultima derivazione sarà il goal vuoto $\leftarrow \square$, quindi la risoluzine è finita correttamente e darà come risposta `yes Y=bruno`.
        
    
    Il processo qui appena descritto viene formalizzato tramite il concetto di SLD-Derivazione, ovvero una sequenza di passi di derivazione.
    

## SLD-ALBERI

Guardando l’esempio precedente possiamo vedere come in realtà l’interprete possa prendere in realtà più strade, di fatti abbiamo che l’interprete potrebbe:

- Passo 1: selezionare come letterale del goal:
    - Quella più a sinistra (leftmost), questa è la regola seguita da prolog.
    - Quello più a destra (rightmost).
- Passo 2: scegliere una diversa clausola del programma, ad esempio nel esempio precedente:
    - Sia `antenato(X, Y) :- padre(X, Y).`.
    - Che `antenato(X, Y) :- antenato(X, Z), padre(Z, Y).`.

In un SLD-Albero avremo che le foglie potranno essere goal vuoti oppure goal di fallimento e diremo che l’albero è di successo se contiene almeno una SLD-Derivazione di successo. Un SLD-Albero può essere infinito, questa situazione è comune nel caso di ricorsioni mal strutturate, come ad esempio:

```prolog
p :- p. % goal: ?-p

%------------------------------------------------------

p(X) :- q(X). 
q(X) :- p(X).
```

In casistiche di alberi finiti l’interpete Prolog non garantisce di eviare i loop, sarà il programmatore a dover evitare queste casistiche.