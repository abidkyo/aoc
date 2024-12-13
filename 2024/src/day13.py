#!/usr/bin/env python3

"""
Linear Equation.
"""

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def calc(config, n):
    ax, ay, bx, by, X, Y = integers(config)
    X += n
    Y += n

    # i * ax + j * bx = X
    # i * ay + j * by = Y
    i = (X * by - Y * bx) / (ax * by - ay * bx)
    j = (Y - i * ay) / by

    res = 0
    if i % 1 == 0 and j % 1 == 0:
        res = int(3 * i + j)

    return res


class Day13Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 13
        self.expected_test = 480, 875318608908
        self.expected = 39996, 73267584326867

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.read_input(test).split("\n\n")

        p1, p2 = 0, 0
        for config in puzzle:
            p1 += calc(config, 0)
            p2 += calc(config, 1e13)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day13Solver()
    solver.run()


# ------------------------------------------------------------------------------
