#!/usr/bin/env python3

"""
RegEx.
"""

import re

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


class Day03Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 3
        self.expected_test = 161, 48
        self.expected = 166357705, 88811886

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.strip()

        # (?:...) : non-capturing group
        #       | : alternative match
        PATTERN = r"do(?:n't)?\(\)|mul\(\d+,\d+\)"

        p1, p2 = 0, 0
        enabled = True
        for res in re.findall(PATTERN, puzzle):
            try:
                x, y = integers(res)
                p1 += x * y

                if enabled:
                    p2 += x * y

            except ValueError:
                if res == "do()":
                    enabled = True
                else:
                    enabled = False

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day03Solver()
    solver.run()


# ------------------------------------------------------------------------------
