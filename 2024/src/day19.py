#!/usr/bin/env pypy3

"""
Dynamic Programming: Substring in String.

pypy3: 65 ms
"""

from functools import cache

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day19Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 19
        self.expected_test = 6, 16
        self.expected = 367, 724388733465031

    def solve(self, test: bool = False) -> tuple:
        SS, S = solver.read_input(test).split("\n\n")

        SS = tuple(SS.split(", "))
        S = S.splitlines()

        @cache
        def dp(s):
            if len(s) == 0:
                return 1

            res = 0
            for ss in SS:
                if s.startswith(ss):
                    res += dp(s[len(ss) :])

            return res

        p1, p2 = 0, 0
        for s in S:
            res = dp(s)
            p1 += res > 0
            p2 += res

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day19Solver()
    solver.run()


# ------------------------------------------------------------------------------
