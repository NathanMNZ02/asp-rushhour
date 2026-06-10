# LOGICA DEL PRIM’ORDINE

Nella logica del prim’ordine o logica dei predicati vengono utilizzati:

- **Simboli di costante**: denotano specifici oggetti, indicati con $a, b, c, \dots$
- **Simboli di predicato**: denotano le proprietà degli oggetti, indicati con $p, q, r, s, \dots$
- **Simboli di funzione**: denotano delle relazioni funzionali.

alcuni esempi possono essere:

$$
\text{Maria è un attrice}  \rightarrow \quad p(a) \quad \text{p=essere attrice, a = maria}
$$

$$
\text{La madre di claudio è un attrice}\rightarrow \quad p(f(a)) \quad \text{p=essere attrice, f=madre di, a=claudio}
$$

Inoltre possono essere anche espressi concetti generali introducento i **simboli di variabile**, indicati con $X, Y, \dots$

## SINTASSI

Un linguaggio del prim’ordine è caratterizzato in maniera univoca da un alfabeto $\Sigma$ costituito da:

- $\Pi$: simboli di predicato.
- $\mathcal F$: simboli di funzione e di costante.
- $\mathcal V$: simboli di variabile.

Ad ogni simbolo $\Sigma$ può essere applicata una funzione di arità $ar: \Sigma \rightarrow \N$, la quale denota il numero di argomenti che ha ciascun simbolo, vale che:

- $ar(p) \ge 0$, per ogni $p \in \Pi$, questo perché i pedicati possono avere uno o più argomenti.
- $ar(f) \ge 0$, per ogni $f \in \mathcal F$, questo perché le costanti non possono avere alcun argomento, invece le funzioni possono avere uno o più argomenti.
- $ar(X) = 0$, per ogni $X \in \mathcal V$, questo perché le variabili non possono avere alcun argomento.

I vari simboli del linguaggio potranno essere collegati tramite connettivi logici.

### TERMINE

Dati uno o più simboli di linguaggio possiamo definire il concetto di **termine**, ovvero vale che:

- Una variabile o una costante è un termine.
- Se $t_1, \dots, t_n$ sono termini e $f \in \mathcal F \text{ con } \ ar(f)= n$, allora $f(t_1, \dots, t_n)$ è un termine.

Questa definizione inquadra un termine come una variabile, una costante o una funzione che contiene variabili e/o costanti, alcuni esempi sono:

$$
f(X, f(a, b)) \rightarrow \text{termine}
$$

$$
+(1, \cdot (3, 5)) \rightarrow \text{termine}
$$

$$
ab \rightarrow \text{non è un termine}
$$

Per i termini valgono le seguenti proprietà:

- Dato un termine $t$ vale che se $s$ è una sottostringa di $t$ allora $s$ è un termine.
- Se un termine $t$ non contiene variabili allora il termine viene detto **ground**.
- Se due termini $t, s$ sono uguali si indica con $t \equiv s$, se sono diversi si indica con $t \not \equiv s$.

### FORMULA

Dati uno o più termini $t_1, \dots, t_n$ e un predicato $p$ possiamo definire il concetto di **formula atomica** o **atomo** come:

$$
p(t_1, \dots, t_n)
$$

Una formula atomica viene detta anche formula e vale che se $\varphi, \psi$ sono formule allora sono formule anche:

- $\neg\varphi$.
- $\varphi \lor \psi$.
- $\varphi \land \psi$.
- $\exist X \varphi$.
- …

Notare però che una formula atomica non è sempre una formula. Inoltre definiamo **letterale** come una formula atomica o la negazione di una formula atomica. Infine data una variabile $X$  in una formula dicamo che essa occorre libera in una formula $\varphi$ se non è catturata da un quantificatore $\forall$ o $\exist$, di fatti intuitivamente abbiamo che:

- $p(X)$: in questo caso la variabile è libera in $p(X)$, la formula non è nè vera nè falsa in assoluto, ma dipende da $X$.
- $\exist Xp(X)$: in questo caso la variabile è legata in $p(X)$, la formula sarà vera se esisterà $X$ in $p(X)$.