#!/usr/bin/env python3

"""
Run-Length Encoding.
"""

from functools import cache
from itertools import groupby

from aoc import AOCSolver

# ------------------------------------------------------------------------------


@cache
def rle_encode(n):
    res = ""
    for x, g in groupby(n):
        res += f"{len(list(g))}{x}"

    return res


class Day10Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 10
        self.expected_test = 82350, 1166642
        self.expected = 492982, 6989950

    def solve(self, test: bool = False) -> tuple:
        n = self.puzzle.strip()

        p1, p2 = 0, 0
        for i in range(50):
            if i == 40:
                p1 = len(n)
            n = rle_encode(n)

        p2 = len(n)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day10Solver()
    solver.run()


# ------------------------------------------------------------------------------
