#!/usr/bin/env python3

"""
JSON data.
"""

import json

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def recurse(obj):
    if isinstance(obj, str):
        return 0

    if isinstance(obj, int):
        return obj

    if isinstance(obj, list):
        return sum(recurse(val) for val in obj)

    if isinstance(obj, dict):
        if "red" in obj.values():
            return 0
        return sum(recurse(val) for val in obj.values())


class Day12Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 12
        self.expected_test = 6, 4
        self.expected = 191164, 87842

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.strip()

        p1 = sum(integers(puzzle))

        puzzle = json.loads(puzzle)
        p2 = recurse(puzzle)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day12Solver()
    solver.run()


# ------------------------------------------------------------------------------
