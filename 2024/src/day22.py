#!/usr/bin/env python3

"""
Number Sequence.
"""

from typing import DefaultDict

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def calc(x):
    x = (x ^ (x * 64)) % 16777216
    x = (x ^ (x // 32)) % 16777216
    x = (x ^ (x * 2048)) % 16777216
    return x


class Day22Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 22
        self.expected_test = 37327623, 24
        self.expected = 18525593556, 2089

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.puzzle.strip()

        p1, p2 = 0, 0
        G = DefaultDict(int)
        for x in integers(puzzle):
            D = []
            seen = set()

            yy = x % 10
            for _ in range(2000):
                x = calc(x)
                y = x % 10

                D.append(y - yy)
                yy = y

                d = tuple(D[-4:])
                if len(d) == 4 and d not in seen:
                    G[d] += y
                    seen.add(d)

            p1 += x

        p2 = max(G.values())

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day22Solver()
    solver.run()


# ------------------------------------------------------------------------------
