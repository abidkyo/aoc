#!/usr/bin/env python3

"""
Points and Sets.
"""

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


class Day03Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 3
        self.expected_test = 4, 3
        self.expected = 2572, 2631

    def solve(self, test: bool = False) -> tuple:
        directions = self.puzzle.strip()

        for a, b in {"^": "u", ">": "r", "v": "d", "<": "l"}.items():
            directions = directions.replace(a, b)

        P = complex

        p = P(0, 0)
        p1 = P(0, 0)
        p2 = P(0, 0)

        seen = set({p})
        sseen = set({p})

        for i, d in enumerate(directions):
            p += DIRC[d]
            seen.add(p)

            if i % 2 == 0:
                p1 += DIRC[d]
                sseen.add(p1)
            else:
                p2 += DIRC[d]
                sseen.add(p2)

        p1 = len(seen)
        p2 = len(sseen)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day03Solver()
    solver.run()


# ------------------------------------------------------------------------------
