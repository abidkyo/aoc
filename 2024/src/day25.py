#!/usr/bin/env python3

"""
Overlap in List.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day25Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 25
        self.expected_test = 3, None
        self.expected = 3269, None

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.split("\n\n")
        R = len(puzzle[0].splitlines())

        KEYS, LOCKS = [], []
        for g in puzzle:
            g = g.splitlines()

            (KEYS, LOCKS)[any(c == "#" for c in g[0])].append(
                tuple(col.count("#") - 1 for col in zip(*g))
            )

        p1 = sum(
            all(x + y <= R - 2 for x, y in zip(key, lock))
            for lock in LOCKS
            for key in KEYS
        )
        p2 = None

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day25Solver()
    solver.run()


# ------------------------------------------------------------------------------
