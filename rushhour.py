import os
import sys
import matplotlib.pyplot as plt
import asp.benchmarks.bench as bench
from utils.clingo_slover import ClingoSolver
from utils.game_screen import GameScreen

CONFIGURATIONS = ["frumpy", "jumpy", "tweety", "trendy", "crafty", "handy"]
HEURISTICS = ["berkmin", "vsids", "vmtf", "domain",]

def test(benchmarks_lp) -> dict[str, int]:
    results = {}
    for benchmark_f in benchmarks_lp:
        results[benchmark_f] = {}

        benchmark_p = os.path.join("asp/benchmarks", benchmark_f)
        for config in CONFIGURATIONS:
            for heuristic in HEURISTICS:                
                solver = ClingoSolver(
                    ["asp/rushhour.lp", benchmark_p], 
                    18, 
                    [
                        f"--configuration={config}",
                        f"--heuristic={heuristic}", 
                        "--enum-mode=bt",
                        "--opt-mode=opt",
                        f"-t {os.cpu_count()}", # usiamo tutti i thread disponibili
                        "--seed=12345", # fissiamo il seed per rendere il problema riproducibile
                        "--stats"
                    ])
                moves, stats = solver.solve(timeout=120)
                
                key = (config, heuristic)
                if key not in results[benchmark_f]:
                    results[benchmark_f][key] = {}

                grounding_time = None
                solving_time = None
                if stats:
                    grounding_time = stats['summary']['times']['total'] - stats['summary']['times']['solve']
                    solving_time = stats['summary']['times']['solve']

                results[benchmark_f][key] = {
                    "grounding_time": grounding_time,
                    "solving_time": solving_time,
                    "moves": moves
                }

                print(
                    "--------------------------------------------------------------------------------------------"
                    f"\n{benchmark_f}\n"
                    f"configuration={config}\n"
                    f"heur={heuristic}\n"
                    f"grounding_time={results[benchmark_f][key]["grounding_time"]}\n"
                    f"solving_time={results[benchmark_f][key]["solving_time"]}\n"
                    f"moves={results[benchmark_f][key]["moves"]}\n"
                    "--------------------------------------------------------------------------------------------"
                )
    
    return results


def simulate(benchmarks_lp, config: list[str]):
    for benchmark in benchmarks_lp:
        benchmark = os.path.join("asp/benchmarks", benchmark)
                
        solver = ClingoSolver(["asp/rushhour.lp", benchmark], 20, [
            f"--enum-mode=bt",
            f"--opt-mode=opt",
            f"-t {os.cpu_count()}",
        ] + config)
        moves, _ = solver.solve()
        print(f"{benchmark}: {moves}")

        if "b1" in benchmark:
            vehicles = bench.b1()
        elif "b2" in benchmark:
            vehicles = bench.b2()
        elif "b3" in benchmark:
            vehicles = bench.b3()
        elif "b4" in benchmark:
            vehicles = bench.b4()
        elif "b5" in benchmark:
            vehicles = bench.b5()
            
        game = GameScreen()
        game.create(vehicles, moves)

if __name__ == "__main__":
    files = os.listdir("asp/benchmarks")
        
    benchmarks_lp = [f for f in files if f.endswith(".lp")]
    benchmarks_lp.sort()
    if len(sys.argv) > 1 and sys.argv[1] == "g":
        simulate(benchmarks_lp, [
            f"--configuration=jumpy",
            f"--heuristic=domain"
            ]
        )
    else:
        results = test(benchmarks_lp)
        
        for benchmark, data in results.items():
            configs_heuristics = list(data.keys())
            grounding_times = [data[k]["grounding_time"] for k in configs_heuristics]
            solving_times = [data[k]["solving_time"] for k in configs_heuristics]

            # Etichette sull’asse x: "config-heuristic"
            labels = [f"{c}-{h}" for c, h in configs_heuristics]

            x = range(len(labels))

            plt.figure(figsize=(14,6))

            # Grounding time
            plt.bar([i - 0.2 for i in x], grounding_times, width=0.4, label="Grounding Time (s)", color="skyblue")
            # Solving time
            plt.bar([i + 0.2 for i in x], solving_times, width=0.4, label="Solving Time (s)", color="salmon")

            plt.xticks(x, labels, rotation=45, ha="right")
            plt.ylabel("Time (seconds)")
            plt.title(f"Benchmark: {benchmark}")
            plt.legend()
            plt.tight_layout()
            plt.show()
            
