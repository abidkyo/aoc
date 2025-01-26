#!/usr/bin/env python3

"""
String Counting.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day01Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 1
        self.expected_test = -1, 5
        self.expected = 138, 1771

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.strip()

        p1, p2 = 0, 0

        for idx, char in enumerate(puzzle, 1):
            if char == "(":
                p1 += 1
            elif char == ")":
                p1 -= 1

            if p2 == 0 and p1 == -1:
                p2 = idx

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day01Solver()
    solver.run()


# ------------------------------------------------------------------------------
