#!/usr/bin/env python3

"""
List and Counter.
"""

from collections import Counter

from aoc import AOCSolver, integers, list_transpose, map_list

# ------------------------------------------------------------------------------


class Day01Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 1
        self.expected_test = 11, 31
        self.expected = 1579939, 20351745

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        a, b = list_transpose(map_list(integers, puzzle))
        a.sort()
        b.sort()

        counts = Counter(b)

        p1, p2 = 0, 0
        for x, y in zip(a, b):
            p1 += abs(y - x)
            p2 += x * counts[x]

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day01Solver()
    solver.run()


# ------------------------------------------------------------------------------
