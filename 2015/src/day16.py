#!/usr/bin/env python3

"""
Similarities in Data.
"""

from re import findall

from aoc import AOCSolver

# ------------------------------------------------------------------------------


SUE = {
    "children": 3,
    "cats": 7,
    "samoyeds": 2,
    "pomeranians": 3,
    "akitas": 0,
    "vizslas": 0,
    "goldfish": 5,
    "trees": 3,
    "cars": 2,
    "perfumes": 1,
}


class Day16Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 16
        self.expected_test = 0, 0
        self.expected = 373, 260

    def solve(self, test: bool = False) -> tuple:
        if test:
            return 0, 0

        puzzle = self.puzzle.splitlines()

        p1, p2 = 0, 0
        for i, line in enumerate(puzzle, 1):
            s1, s2 = 0, 0
            for s in findall(r"\w+: \d+", line):
                k, v = s.split(": ")
                v = int(v)

                if k in ["cats", "trees"]:
                    if SUE[k] < v:
                        s2 += 1
                elif k in ["pomeranians", "goldfish"]:
                    if SUE[k] > v:
                        s2 += 1
                else:
                    if SUE[k] == v:
                        s2 += 1

                if SUE[k] == v:
                    s1 += 1

            # only 3 attributes per line
            if s1 == 3:
                p1 = i
            if s2 == 3:
                p2 = i

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day16Solver()
    solver.run()


# ------------------------------------------------------------------------------
