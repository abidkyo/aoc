#!/usr/bin/env python3

"""
Elements Increasing/Decreasing.
"""

from aoc import AOCSolver, integers, list_remove_index, map_list

# ------------------------------------------------------------------------------


def check(L):
    incr = all(y > x for x, y in zip(L, L[1:]))
    decr = all(y < x for x, y in zip(L, L[1:]))
    diff = all(abs(y - x) <= 3 for x, y in zip(L, L[1:]))

    return (incr or decr) and diff


class Day02Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 2
        self.expected_test = 2, 4
        self.expected = 299, 364

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        G = map_list(integers, puzzle)

        p1, p2 = 0, 0
        for R in G:
            if check(R):
                p1 += 1
            elif any(check(list_remove_index(i, R)) for i in range(len(R))):
                p2 += 1

        return p1, p1 + p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day02Solver()
    solver.run()


# ------------------------------------------------------------------------------
