#!/usr/bin/env python3

"""
Game of Life.
"""

from collections import defaultdict

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


class Day18Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 18
        self.expected_test = 4, 17
        self.expected = 1061, 1006

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        if test:
            T = 5
        else:
            T = 100

        P = complex

        R = len(puzzle)
        C = len(puzzle[0])
        E = set([P(0, 0), P(R - 1, 0), P(0, C - 1), P(R - 1, C - 1)])

        G = set()
        for y, r in enumerate(puzzle):
            for x, c in enumerate(r):
                if c == "#":
                    G.add(P(x, y))

        G2 = G

        def evolve(g):
            N = defaultdict(int)
            for p in g:
                for d in DIRC.values():
                    np = p + d
                    if 0 <= np.real < C and 0 <= np.imag < R:
                        N[np] += 1

            ng = set()
            for p, n in N.items():
                if n == 3:
                    ng.add(p)
                elif p in g and n == 2:
                    ng.add(p)

            return ng

        for _ in range(T):
            G = evolve(G)
            G2 = evolve(G2 | E)

        p1 = len(G)
        p2 = len(G2 | E)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day18Solver()
    solver.run()


# ------------------------------------------------------------------------------
