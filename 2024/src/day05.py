#!/usr/bin/env python3

"""
Sort and Compare.
"""

from functools import cmp_to_key
from typing import DefaultDict

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


class Day05Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 5
        self.expected = 4872, 5564
        self.expected_test = 143, 123

    def solve(self, test: bool = False) -> tuple:
        R, N = solver.puzzle.split("\n\n")

        rules = DefaultDict(set)
        for r in R.splitlines():
            k, v = integers(r)
            rules[k].add(v)

        def compare(k, v):
            if v in rules[k]:
                return -1
            else:
                return 1

        p1 = 0
        F = []
        for n in N.splitlines():
            n = list(integers(n))
            nums = sorted(n, key=cmp_to_key(compare))

            if n == nums:
                p1 += nums[len(nums) // 2]
            else:
                F.append(nums)

        p2 = 0
        for n in F:
            n = sorted(n, key=cmp_to_key(compare))
            p2 += n[len(n) // 2]

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day05Solver()
    solver.run()


# ------------------------------------------------------------------------------
