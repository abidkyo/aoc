#!/usr/bin/env pypy3

"""
Sum of Divisors.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day20Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 20
        self.expected_test = 0, 0
        self.expected = 665280, 705600

    def solve(self, test: bool = False) -> tuple:
        if test:
            return 0, 0

        puzzle = self.puzzle.strip()
        N = int(puzzle)
        M = N // 40

        b1 = [0] * M
        b2 = [0] * M
        for i in range(1, M):
            lim = min(M, i * 50 + i)

            for j in range(i, lim, i):
                b1[j] += i * 10
                b2[j] += i * 11
            for j in range(lim, M, i):
                b1[j] += i * 10

        p1, p2 = 0, 0
        for i, (x1, x2) in enumerate(zip(b1, b2)):
            if not p1 and x1 >= N:
                p1 = i
            if not p2 and x2 >= N:
                p2 = i

            if p1 and p2:
                break

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day20Solver()
    solver.run()


# ------------------------------------------------------------------------------
