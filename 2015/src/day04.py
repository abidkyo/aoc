#!/usr/bin/env python3

"""
MD5 Hash.
"""

import hashlib

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day04Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 4
        self.expected_test = 609043, 6742839
        self.expected = 346386, 9958218

    def solve(self, test: bool = False) -> tuple:
        secret = self.puzzle.strip()

        p1, p2 = 0, 0
        for i in range(int(1e7)):
            chars = secret + str(i)
            hash = hashlib.md5(chars.encode("utf-8")).hexdigest()

            if p1 == 0 and hash.startswith("00000"):
                p1 = i
            if p2 == 0 and hash.startswith("000000"):
                p2 = i

            if p1 and p2:
                break

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day04Solver()
    solver.run()


# ------------------------------------------------------------------------------
