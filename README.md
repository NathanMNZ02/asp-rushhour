# Rush Hour Solver in ASP

Questo progetto implementa un **solver del puzzle Rush Hour** utilizzando **Answer Set Programming (ASP)** e il solver **Clingo**.

L’obiettivo è modellare il gioco in modo dichiarativo e permettere al solver di:
- verificare la correttezza di una configurazione iniziale
- cercare automaticamente una sequenza di mosse valida
- portare la macchina rossa all’uscita nel minor numero possibile di step

---

## 📌 Descrizione del problema

Rush Hour è un puzzle su griglia 6×6 composto da:
- veicoli di lunghezza 2 o 3
- orientamento orizzontale o verticale
- una macchina rossa che deve uscire dal lato destro della griglia

Ogni mossa consiste nello spostare un veicolo avanti o indietro lungo il proprio orientamento, senza mai:
- uscire dalla griglia
- sovrapporsi ad altri veicoli

---

## 🧠 Approccio

Il progetto utilizza **Answer Set Programming** per modellare:

- **Stato** dei veicoli nel tempo
- **Vincoli** geometrici (griglia, overlap, orientamento)
- **Azioni** (mosse forward/backward)
- **Inerzia** (frame axiom)
- **Goal** (uscita della macchina rossa)

Il solver esplora automaticamente lo spazio delle soluzioni e restituisce una sequenza valida di mosse.



