#!/usr/bin/env pypy3

"""
Manhattan-Distance.

pypy3: 4.4 s
"""

from itertools import combinations

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


class Day20Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 20
        self.expected_test = 1, 285
        self.expected = 1358, 1005856

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.read_input(test).splitlines()

        G = {}
        W = set()
        P = complex
        for y, r in enumerate(puzzle):
            for x, c in enumerate(r):
                G[P(x, y)] = c
                if c == "#":
                    W.add(P(x, y))
                elif c == "S":
                    S = P(x, y)
                elif c == "E":
                    E = P(x, y)

        def bfs(S, E):
            queue = [(S, 0)]
            seen = {S: 0}

            for p, s in queue:
                if p == E:
                    return seen

                for d in (DIRC[d] for d in "urdl"):
                    np = p + d
                    if np in seen or np in W or np not in G:
                        continue
                    queue.append((np, s + 1))
                    seen[np] = s + 1

            return dict()

        seen = bfs(S, E)

        if test:
            L = 50
        else:
            L = 100

        p1, p2 = 0, 0
        for x, y in combinations(seen, 2):
            dc = int(abs(x.real - y.real) + abs(x.imag - y.imag))
            dp = abs(seen[x] - seen[y])
            if dc <= 20 and dc + L <= dp:
                if dc == 2:
                    p1 += 1
                p2 += 1

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day20Solver()
    solver.run()


# ------------------------------------------------------------------------------
