#!/usr/bin/env python3

"""
Pathfinder.
"""

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


def dfs(G, S, p1):
    stack = [S]
    seen = set()

    n = 0
    while stack:
        p = stack.pop()

        if p1 and p in seen:
            continue
        seen.add(p)

        if G[p] == 9:
            n += 1
            continue

        for d in (DIRC[d] for d in "urdl"):
            np = p + d
            if np in G and G[np] - G[p] == 1:
                stack.append(np)

    return n


class Day10Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 10
        self.expected_test = 36, 81
        self.expected = 816, 1960

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.read_input(test).splitlines()

        S = []
        G = {}
        P = complex
        for y, r in enumerate(puzzle):
            for x, c in enumerate(r):
                G[P(x, y)] = int(c)
                if c == "0":
                    S.append(P(x, y))

        p1, p2 = 0, 0
        for s in S:
            p1 += dfs(G, s, True)
            p2 += dfs(G, s, False)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day10Solver()
    solver.run()


# ------------------------------------------------------------------------------
