#!/usr/bin/env pypy3

"""
Calculation with Filters.
"""

from itertools import product
from math import prod

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


class Day15Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 15
        self.expected_test = 62842880, 57600000
        self.expected = 18965440, 15862900

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()
        G = [integers(line) for line in puzzle]

        p1, p2 = 0, 0

        for n in product(range(1, 100 + 1), repeat=len(G) - 1):
            n += (100 - sum(n),)

            g = [[x * v for v in g] for g, x in zip(G, n)]
            g = [sum(v) for v in zip(*g)]
            g = [v if v > 0 else 0 for v in g]

            if any(v == 0 for v in g):
                continue

            s = prod(g[:-1])

            p1 = max(p1, s)

            if g[-1] == 500:
                p2 = max(p2, s)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day15Solver()
    solver.run()


# ------------------------------------------------------------------------------
