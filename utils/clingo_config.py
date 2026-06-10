configs = {
    "default": [],
    
    # Configurazione per problemi piccoli/medi (veloce)
    "fast": [
        "--configuration=frumpy",  # Configurazione veloce
        "--heuristic=Domain",      # Euristica basata sul dominio
        "--sat-prepro=2"           # Pre-processing SAT moderato
    ],
    
    # Configurazione per problemi difficili (più robusto)
    "tweety": [
        "--configuration=tweety",  # Bilanciato tra velocità e completezza
        "--sat-prepro=2",
        "--eq=5"                   # Reasoning con equivalenze
    ],
    
    # Configurazione per ottimizzazione (cerca soluzioni migliori)
    "optimize": [
        "--opt-strategy=usc,pmres,disjoint",  # Strategie di ottimizzazione
        "--opt-heuristic=1",                   # Euristica per ottimizzazione
        "--configuration=tweety"
    ],
    
    # Configurazione aggressiva per problemi molto difficili
    "crafty": [
        "--configuration=crafty",   # Più aggressivo nel pruning
        "--sat-prepro=2",
        "--heuristic=Vsids",        # VSIDS heuristic (tipo SAT solver)
        "--restarts=L,100"          # Policy di restart
    ],
    
    # Configurazione parallela (se hai più core)
    "parallel": [
        "--configuration=tweety",
        "--parallel-mode=8",        # 8 thread (adatta al tuo sistema)
        "--distribute=conflict,4"   # Distribuzione dei conflict
    ],
    
    # Configurazione incrementale (buona per planning)
    "incremental": [
        "--configuration=tweety",
        "--sat-prepro=2",
        "--strengthen=recursive",   # Strengthening ricorsivo
        "--otfs=2"                  # On-the-fly subsumption
    ],
    
    # Configurazione minimal (prima soluzione veloce)
    "first_solution": [
        "--configuration=frumpy",
        "--heuristic=Domain",
        "--enum-mode=record",       # Registra modelli trovati
        "--models=1"                # Ferma alla prima soluzione
    ],
    
    # Configurazione per SAT-like problems
    "sat_like": [
        "--sat-prepro=2",
        "--heuristic=Vsids",
        "--restarts=L,60",
        "--deletion=ipSort,75,2",   # Clause deletion policy
        "--strengthen=recursive"
    ]
}