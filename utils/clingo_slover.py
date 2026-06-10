import clingo

class ClingoSolver:
    def __init__(self, files: list[str], max_states: int, config: list[str] = []):
        self.ctl = clingo.Control(["-c", f"s={max_states}"] + config)
        for file in files:
            self.ctl.load(file)
        self.ctl.ground([("base", [])])
        self.answer_sets = []
    
    def __on_model__(self, model):
        transitions = []
        for atom in model.symbols(shown=True):
            if atom.name == "transizione_di_stato":
                S = atom.arguments[0].number
                Id = atom.arguments[1].number
                direction = str(atom.arguments[2])
                steps = atom.arguments[3].number
                transitions.append((S, Id, direction, steps))
        transitions.sort(key=lambda x: x[0])
        self.answer_sets.append((len(transitions), transitions))

    def solve(self, timeout: int = None):
        with self.ctl.solve(on_model=self.__on_model__, async_=True) as handle:
            if timeout:
                finished = handle.wait(timeout)
                if not finished:
                    handle.cancel()
                    return None, None
            else:
                handle.wait()
                           
        self.answer_sets.sort(key = lambda x: x[0])
        if len(self.answer_sets) == 0:
            return None, None
        
        return self.answer_sets[0][1], self.ctl.statistics
        