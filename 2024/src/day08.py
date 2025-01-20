#!/usr/bin/env python3

"""
Grid Math.
"""

from itertools import combinations
from typing import DefaultDict

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day08Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 8
        self.expected_test = 14, 34
        self.expected = 392, 1235

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.puzzle.splitlines()

        A = DefaultDict(list)
        G = {}
        P = complex
        for y, r in enumerate(puzzle):
            for x, c in enumerate(r):
                G[P(x, y)] = c
                if c != ".":
                    A[c].append(P(x, y))

        V = set()
        W = set()
        for k, v in A.items():
            for a, b in combinations(v, 2):
                W.add(a)
                W.add(b)
                d = b - a

                na = a - d
                if na in G:
                    V.add(na)
                while True:
                    na = na - d
                    if na in G:
                        W.add(na)
                    else:
                        break

                nb = b + d
                if nb in G:
                    V.add(nb)
                while True:
                    nb = nb + d
                    if nb in G:
                        W.add(nb)
                    else:
                        break

        p1 = len(V)
        p2 = len(V | W)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day08Solver()
    solver.run()


# ------------------------------------------------------------------------------
