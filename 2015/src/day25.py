#!/usr/bin/env python3

"""
Diagonal to Linear Index.
"""

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def triangular_num(n: int) -> int:
    return n * (n + 1) // 2


def diag2linear(row: int, col: int) -> int:
    row -= 1
    col -= 1
    return triangular_num(row + col) + col + 1


def calc(code: int) -> int:
    return (code * 252533) % 33554393


class Day25Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 25
        self.expected_test = 27995004, 0
        self.expected = 9132360, 0

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.strip()

        row, col = integers(puzzle)

        t = diag2linear(row, col)

        code = 20151125
        for i in range(t - 1):
            code = calc(code)

        p1, p2 = code, 0

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day25Solver()
    solver.run()


# ------------------------------------------------------------------------------
