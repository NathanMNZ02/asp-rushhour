import os
import clingo

def start_benchmarks():
    benchmarks = os.listdir("asp/benchmarks")

    for b in benchmarks:
        print(f"=== ESECUZIONE BENCHMARK: {b} ===")
        ctl = clingo.Control()
        ctl.load("asp/rushhour.lp")
        ctl.load(f"asp/benchmarks/{b}")
        ctl.ground([("base", [])])

        print("=== FATTI GROUND ===")
        for atom in ctl.symbolic_atoms:
            print(atom.symbol)

        print("\n=== SOLVING ===")
        result = ctl.solve(on_model=lambda m: print(f"Model: {m.symbols(atoms=True)}"))
        print(f"Result: {result}\n\n")
        
if __name__ == "__main__":
    start_benchmarks()