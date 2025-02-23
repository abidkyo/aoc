#!/usr/bin/env pypy3

"""
Dynamic Programming.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day17Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 17
        self.expected_test = 4, 3
        self.expected = 4372, 4

    def solve(self, test: bool = False) -> tuple:
        if test:
            L = 25
        else:
            L = 150

        G = self.puzzle.splitlines()
        G = sorted([int(g) for g in G], reverse=True)

        def dp(i, x, c):
            if x == 0:
                return [c]
            if i == len(G):
                return []

            path = []
            if G[i] <= x:
                path += dp(i + 1, x - G[i], c + 1)
            path += dp(i + 1, x, c)
            return path

        res = dp(0, L, 0)

        p1 = len(res)
        p2 = res.count(min(res))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day17Solver()
    solver.run()


# ------------------------------------------------------------------------------
