# UNIFICAZIONE

Possiamo definire una sostituzione come:

> Una funzione $\sigma: \mathcal V \rightarrow T(\mathcal F, \mathcal V)$ tale che il suo dominio $dom(\sigma) = \{X \in \mathcal V: \sigma(X) \not \equiv X\}$ è un insieme finito.
> 

Quindi una sostituzione è una funzione che mappa ogni variabile in una funzione/costante (anche in un altra variabile). Dati due termini $s, t$ ed una sostituzione $\sigma$ diremo che:

- $\sigma$ è unificatore di $s$ e $t$ se $s\sigma \equiv t\sigma$.
- $\sigma$ è un **most general unifier** (m.g.u) di $s$ e $t$ se $\sigma$ è un unificatore e per ogni unificatore $\theta$ di $s$ e $t$ vale che $\sigma \le \theta$.

Per fare un esempio di unificazione prendiamo i termini $f(g(X, a), Z)$ e  $f(Y, b)$, alcuni unificatori sono:

- La sostituzione $[Y/g(c, a), X/c, Z/b]$.
- La sostituzione $[Y/g(h(W), a), X/h(W), Z/b]$.
- La sostituzione $[Y/g(X, a), Z/b]$.

Tra questi unificatori l’unico m.g.u è $[Y/g(X, a), Z/b]$.

La definizione di unificatore può essere estesa a casi più generali in cui abbiamo un sistema di equazioni $C \equiv (s_1 = t_1 \land \dots \land s_n = t_n)$, allora se $\sigma$ è una sostituzione:

- $\sigma$ è un unificatore di $C$ se per ogni $i \in \{1, \dots, n\}$ si ha che $s_i\sigma \equiv t_i \sigma$.
- $\sigma$ è m.g.u di $C$ se $\sigma$ è unificatore di $C$ e per ogni unificatore $\theta$ di $C$ si ha che $\sigma \le \theta$.

## ALGORITMO DI UNIFICAZIONE

1. $[X/a, Y/a]$.

L'algoritmo di unificazione permette di partire da un sistema di equazioni e produrre una versione in forma risolta se il sistema iniziale ammette un m.g.u, esso lavora applicando iterativamente le 6 seguenti operazioni:

1. **Regola 1**: data un equazione in forma complessa $f(s_1, \dots, s_n) = f(t_1, \dots, t_n)$ possiamo decomporla in 
$s_1 = t_1 \land \dots \land s_n = t_n$, es:
    
    $$
    f(X, a) = f(b, Y) \rightarrow X = b \land a = Y
    $$
    
2. **Regola 2 e 6**: in casistiche in cui abbiamo situazioni come:
    1. $f(\dots)=g(\dots)$ con $f \ne g$ il sistema fallisce.
    2. $X=f(X)$ il sistema fallisce.

1. **Regola 3**: quando si hanno equazioni come $X=X$ allora queste non impongono nessun vincolo e possono essere tranquillamente eliminate.

2. **Regola 4**: quando si hanno equazioni come $t = X$, allora possono essere tranquillamente ribaltate in $X=t$.

3. **Regola 5**: quando si hanno equazioni del tipo $X=t$ allora possiamo sostituire $X$ con $t$  ovunque.

Un’esempio di come lavora l’algoritmo **Unify(**…**)** è il seguente:

$$
f(X,X) = f(a, Y)
$$

1. $X=a \land X = Y$.
2. $X=a \land a = Y$.
3. $X=a \land Y = a$.