# PROGRAMMAZIONE CON CLAUSOLE DEFINITE

In logica abbiamo che una **teoria** è un insieme di formule $\{\varphi_1, \dots, \varphi_n\}$ che rappresentano le affermazioni che si assumono per vere. Ora invece analizziamo il caso particolare in cui le formule sono disgiunzioni di letterali, quindi una formula sarà del tipo:

$$
l_1 \lor \dots \lor l_n
$$

In tal caso è usuale utilizzare il termine **programma** piuttosto che teoria:

> Sia dato un alfabeto $\Sigma = \{\Pi, \mathcal F, \mathcal V\}$ allora:
> 
> - Se $H, A_1, \dots, A_n$ sono atomi, allora $H \leftarrow A_1, \dots, A_n$ è una **regola**.
> - Se la regola è $H \leftarrow$ allora è detta **fatto**.
> - $\leftarrow A_1, \dots, A_n$ è detto **goal** o **query**.
> - Un programma è un insieme finito di regole.

Nella regola $H \leftarrow A_1, \dots, A_n$ la virgola è da intendersi come $\land$, perciò $H$ sarà vero se $A_1, \dots, A_n$. Nella logica vale che la regola $H \leftarrow A_1, \dots, A_n$ è equivalente a:

$$
H \lor \neg A_1 \lor \dots \lor \neg A_n
$$

In generale una disgiunzione di letterali viene chiamata **clausola** e le clausole con al più un letterale sono dette **clausole di Horn**, ma per quanto appena visto possiamo affermare che clausole e regole sono la stessa cosa. Un programma di clausole definite è detto **programma definito**.

## PROGRAMMI PROPOSIZIONALI

Programmi composti da soli simboli di predicato con arità 0:

```prolog
estate <- caldo
caldo <- estate
sudato <- estate, caldo
```

## PROGRAMMI CON DOMINIO FINITO

Programmi in cui l'insieme $\mathcal F$ è costituito da soli simboli di costante (no funzioni):

```prolog
padre(antonio, bruno).
padre(antonio, carlo).

figlio(X, Y) :- padre(Y, X).
nonno(X, Y) :- padre(X, Z), padre(Z, Y).
```

notare che la parte di programma costituita solo da fatti viene detta parte **estensionale**, la parte costituita dalle clausole con corpo non vuoto viene detta **intensionale**.

## PROGRAMMI CON DOMINIO INFINITO

Programmi in cui l'insieme $\mathcal F$ è costituito da simboli con $ar \ge 0$:

```prolog
num(0).
num(s(X)) :- num(X).
```

## TURING COMPLETEZZA

Mediante i programmi di clausole definite si dispone di un formalismo equivalente a quello della Macchina di Turing:

> **Teorema**
> 
> 
> Se una funzione $f: \N^n \rightarrow \N$ è ricorsiva (parziale), allora $f$ è definibile da un programma definito.
>