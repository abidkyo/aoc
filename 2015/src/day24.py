#!/usr/bin/env python3

"""
Combinations.
"""

from itertools import combinations
from math import prod

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day24Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 24
        self.expected_test = 99, 44
        self.expected = 11846773891, 80393059

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        items = set(map(int, puzzle))
        total = sum(items)

        def calc(goal: int) -> int:
            for i in range(len(items)):
                res = [prod(c) for c in combinations(items, i) if sum(c) == goal]
                if res:
                    return min(res)

            return 0

        p1 = calc(total // 3)
        p2 = calc(total // 4)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day24Solver()
    solver.run()


# ------------------------------------------------------------------------------
