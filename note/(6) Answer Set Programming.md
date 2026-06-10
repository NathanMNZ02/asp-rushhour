# ANSWER SET PROGRAMMING

In prolog il metodo di lavoro si basava sul:

1. Descrivere il problema.
2. Porre un goal.
3. Il sistema cerca di dimostrare il goal lavorando in backtracking con la SLD-Risoluzione. 

ASP si basa su un metodo di lavoro bottom-up, in cui si parte dai fatti e si applicano le regole per generare tutti i possibili modelli (answer set).

Un esempio per capire la differenza sostaziale tra i due è il seguente:

- Prolog: "Esiste un cammino per uscire dal labirinto?", il risolutore risponderà "yes" o "no" e restituisce la strada.
- ASP: "Dammi tutti i possibili scenari validi (modelli) compatibili con queste regole".

Quindi in ASP non esiste il goal come in Prolog, la soluzione sarà l'interno insieme di atomi veri.

## SINTASSI

In ASP definiamo:

- **Regola**: una clausola nella forma:
    
    $$
        L_0 \leftarrow L_1, \dots, L_m, not L_{m+1}, \dots, not L_n.
    $$
    
    in cui ogni $L_i$ è una formula atomica.
    
- **Vincolo**: una clausola nella forma:
    
    $$
        \leftarrow L_1, \dots, L_m, not L_{m+1}, \dots, not L_n. 
    $$
    
    quindi una clausola senza testa, un vincolo implica che se ciò che viene descritto nella clausola è vero allora implica falso.
    

Possiamo quindi definire un **programma** ASP come un insieme di regole e vincoli ASP.

## SEMANTICA

Quindi l’obiettivo di ASP è calcolare i possibili **answer set**, anche detti modelli stabili. Per capire se un insieme candidato $S$ è un answer set vengono eseguiti tre test di compatibilità (**Ridotto di Gelfond-Lifschitz**):

1. **Ipotesi**: prendiamo un insieme di atomi $S$ che sospettiamo sia la soluzione.
2. **Riduzione**: trasformiamo il programma originale $P$:
    1. Eliminando tutte le regole che hanno nel corpo `not A` con $A\in S$, questo perché la premessa `not A` sarebbe falsa.
    2. Dalle regole rimaste cancelliamo tutti i letterali negativi, questo perché assumiamo siano veri.
    3. Otteniamo un programma $P^S$ che non ha negazioni**.**
3. **Verifica**: calcoliamo il modello minimo di $P^S$. Se questo modello minimo è identico al nostro insieme di partenza $S$, allora $S$ è un answer set.

Di seguito un esempio:

```prolog
p :- not q.
```

- Supponiamo l’ipotesi $S=\{q\}$:
    - Riduzione: la regola `p :- not q.` contiene `not q` dove $q \in S$ quindi viene eliminata.
    - Verifica: il modello minimo del programma è $\empty$ e siccome $\empty \ne S$ possiamo affermare che $S=\{q\}$ non sia un answer set.
- Supponiamo l’ipotesi $S= \{p\}$:
    - Riduzione: la regola `p :- not q.` contiene `not q`, ma $q \not \in S$ perciò non viene eliminata completamente, seguendo quanto specificato in $2.b$ abbiamo che devono essere eliminati tutti i letterali negativi, perciò la regola diventa `p.`.
    - Verifica: il modello minimo di `p.` è $\{p\} = S$, perciò possiamo affermare che $S$ sia un answer set.

## SOLVER

Esistono differenti tipologie di solver in ASP:

- **Smodels**: il sistema Smodels è costituito da due parti:
    1. **Lparse**: effettua il **grounding**, ovvero il processo attraverso il quale dato un programma $P$ si ottiene la sua versione ground. Notare che il grounding può essere un processo molto pesante quando il numero di variabili e loro relazioni è molto grande, perciò ASP vuole che il programma sia *strongly range restricted*, ovvero:
        
        > Un programma $P$ deve essere strutturato in modo che sia possibile per ogni variabile di una regola stabilire l'insieme di valori che essa può assumere e tale insieme deve essere finito.
        > 
        
        Per fare ciò viene introdotto il concetto di **dependency graph $D_P$**, dove:
        
        - I nodi sono i simboli di predicato, quindi ogni testa di una regola diventa un nodo.
        - Due nodi $p_i$, $p_j$ sono tra di loro collegati da un arco quando nella regola del predicato $p_i$ c’è il predicato $p_j$ e l’arco potrà essere etichettato con:
            - $+$ se la regola è positiva, es: `a(X) :- b(X)` allora in tal caso avremo $(a/1, b/1, +)$.
            - $-$ se la regola è negativa, es: `a(X) :- not b(X)` allora in tal caso avremo $(a/1, b/1, -)$.
            - $+-$ se la regola è sia negativa che positiva, es: `a(X) :- b(X), not b(X)` allora in tal caso avremo $(a/1, b/1, +-)$.
        
        Nel grafo delle dipendenze potranno esserci dei cicli ed essi potranno essere:
        
        - Cicli negativi:
            
            ```python
            a :- b.
            b :- not b.
            ```
            
        - Cicli positivi:
            
            ```python
            a :- b.
            b :- a.
            ```
            
        
        Se il grafo non contiene cicli negativi esso sarà risolvibile tramite la $T_P$.
        
    
    1. Smodels: si occuperà di produrre i vari answer set seguendo le regole viste in precedenza.

## CODICE

- **Negazione**
    
    In ASP la negazione può essere espressa in più forme, ognuna con un significato preciso.
    
    - **Negazione di default (not)**: segue il principio della *negation as failure*.
        
        Il letterale not p è vero se p **non è dimostrabile**.
        
        - Se p è dimostrabile → not p è falso
        - Se p non è dimostrabile → not p è vero
        - Se p è indeterminato → può introdurre ambiguità nel modello
        
        > Attraversa il fiume se non è stato dimostrato che ci siano pirana.
        > 
        
        ```prolog
        attraversa :- not ci_sono_pirana.
        ```
        
    - **Negazione esplicita**: afferma direttamente che il predicato è falso nel modello.
        
        > Attraversa il fiume se è vero che non ci sono pirana.
        > 
        
        ```prolog
        attraversa :- -ci_sono_pirana.
        ```
        
    - **Doppia negazione**: consente di distinguere la *verità nel modello* dalla *derivabilità*.
        
        Con not not a si afferma che a può essere assunto vero se è vero nel modello, anche senza una derivazione esplicita.
        
        ```prolog
        not not a
        ```
        
    - **Teste di letterali negativi**: sono una forma alternativa di vincolo di integrità.
        
        ```prolog
        not A :- L1, ..., Ln.
        ```
        
        La regola sopra è equivalente a:
        
        ```prolog
        :- L1, ..., Ln, not A.
        ```
        

- **Disgiunzione**
    
    In ASP è possibile usare la disgiunzione nelle teste delle regole tramite or (oppure ; in clingo).
    
    ```prolog
    a or b.
    % oppure
    a;b.
    ```
    
    Questa regola **non** significa “esattamente uno” né “al massimo uno”, ma solo:
    
    > almeno uno dei due deve essere vero
    > 
    
    Se il resto del programma forza entrambi a essere veri, allora l’answer set conterrà **sia a che b**.
    
    ```prolog
    a or b.
    a :- b.
    b :- a.
    ```
    
    In questo caso l’unico answer set è:
    
    $$
    \{a, b\}
    $$
    
    La disgiunzione può comparire anche nel corpo delle regole:
    
    ```prolog
    c :- a;b.
    a.
    ```
    

- **Cardinality rule**
    
    Le **cardinality rule** generalizzano la disgiunzione permettendo di imporre vincoli numerici sul numero di atomi veri.
    
    ```prolog
    L { a1; a2; ...; an } U.
    ```
    
    Significato:
    
    > Nel modello devono essere veri **almeno L** e **al massimo U** tra gli atomi elencati.
    > 
    - a1, a2, ..., an sono atomi ground
    - L è il limite inferiore
    - U è il limite superiore
    
- **Choice rule**
    
    Una choice rule permette al solver di effettuare una scelta, ovvero il solver potrà scegliere se aggiungere o meno il letterale racchiuso tra { } all’interno dell’answer set, ad esempio:
    
    ```prolog
    activity(a; b; c).
    { do(X) } :- activity(X).
    
    % Possibili as: {}, {do(a)}, {do(b)}, {do(c)}, {do(a), do(b)}, ...
    ```
    
- **Aggregati**
    
    Gli aggregati permettono di calcolare valori a partire da insiemi di elementi selezionati, utili per esprimere vincoli complessi.
    
    Funzioni principali:
    
    - #count → conta il numero di elementi veri
    - #sum → somma i pesi
    - #sum+ → somma solo i pesi positivi
    - #min → minimo
    - #max → massimo
    
    ```prolog
    course(db,4).
    course(ai,6).
    course(xml,3).
    course(project,8).
    
    selected(db).
    selected(ai).
    
    cnt(X) :- X = #count { C : selected(C) }.
    sum(X) :- X = #sum { Cr : course(C,Cr), selected(C) }.
    
    :- #count { C : selected(C) } < 2.
    :- #sum { Cr : course(C,Cr), selected(C) } < 10.
    ```
    
    - Devono essere scelti almeno 2 corsi
    - La somma dei crediti deve essere almeno 10
    
- **Funzioni built-in**
    
    ASP mette a disposizione diverse funzioni predefinite.
    
    - **Costanti booleane**: rappresentano valori di verità assoluti.
        
        ```prolog
        #true.
        #false.
        ```
        
    - **Funzioni aritmetiche**: consentono di eseguire operazioni matematiche.
        
        ```prolog
        left(8).
        right(9).
        
        plus(L + R) :- left(L), right(R).
        prod(L * R) :- left(L), right(R).
        pow(L ** R) :- left(L), right(R).
        ```
        
    - **Funzioni di confronto**: applicabili sia a numeri che a simboli.
        
        ```prolog
        sym(1). sym(a). sym(f(a)).
        
        eq (X,Y) :- X = Y, sym(X), sym(Y).
        neq(X,Y) :- X != Y, sym(X), sym(Y).
        lt (X,Y) :- X < Y, sym(X), sym(Y).
        ```
        
    - **Intervalli**: permettono di generare valori numerici in modo compatto.
        
        ```prolog
        size(3).
        grid(X,Y) :- X = 1..S, Y = 1..S, size(S).
        ```
        
    - **Pooling**: definizione manuale di un insieme finito di valori.
        
        ```prolog
        grid(X,Y) :- X = (1;2;3), Y = (1;2;3).
        ```
        
    - **Letterali condizionali**: il letterale principale è vero se la condizione è soddisfatta per **tutti** gli elementi.
        
        ```prolog
        meet :- available(X) : person(X).
        ```
        
        Questa regola significa:
        
        > organizziamo l’incontro se ogni persona è disponibile
        > 
        

### OTTIMIZZAZIONI

Con le ottimizzazioni estendiamo la ricerca degli answer set validi andando a cercare l’answer set ottimale. Per fare ciò viene introdotta la seguente logica:

- Di base in ASP viene chiesto: "Esiste un answer set che soddisfa tutte le regole e i vincoli".
- Con le ottimizzazioni: "Tra tutti gli answer set validi, qual è il migliore secondo un criterio di costo?".

Quindi verrano prima generati gli answer set validi, poi si confrontano in base a una funzione di costo e si tengono solo quelli con costo minimo (**optimal answer sets**). Le funzioni di costo vengono introdotte tramite i **weak constraint**, ovvero vincoli nella forma:

```prolog
:~ L1, ..., Ln. [w@p, t1, ..., tk]
```

In essi abbiamo che se il corpo è vero viene assegnato un costo $w$ associato a una priorità $p$. Ad esempio supponiamo il seguente codice:

```prolog
% Fatti di base
activity(a; b; c).

% Possibili scelte: fare o non fare
{ do(X) } :- activity(X).  

% Vincoli normali (hard constraint): non possiamo fare tutte e 3 insieme
:- do(a), do(b), do(c).

% Weak constraints

% 1. Evitiamo di fare 'a', penalità 10, PRIORITÀ ALTA
:~ do(a). [10@2, a]

% 2. Evitiamo di fare 'b', penalità 5, PRIORITÀ MEDIA
:~ do(b). [5@1, b]

% 3. Evitiamo di fare 'c', penalità 1, PRIORITÀ BASSA
:~ do(c). [1@1, c]
```

Quindi in tal caso il solver:

- Farà del suo meglio per evitare che venga fatto `do(a)` siccome ha una priorità di minimizzazione alta.
-