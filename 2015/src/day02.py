#!/usr/bin/env python3

"""
Geometry Math.
"""

from itertools import combinations
from math import prod

from aoc import AOCSolver, map_list

# ------------------------------------------------------------------------------


class Day02Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 2
        self.expected_test = 101, 48
        self.expected = 1606483, 3842356

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        p1, p2 = 0, 0

        for line in puzzle:
            dimensions = map_list(int, line.split("x"))
            dimensions.sort()

            areas = [x * y for x, y in combinations(dimensions, 2)]
            smallest_area = min(areas)
            surface_area = 2 * sum(areas)

            shortest_perimeter = sum(2 * x for x in dimensions[:2])
            volume = prod(dimensions)

            p1 += surface_area + smallest_area
            p2 += shortest_perimeter + volume

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day02Solver()
    solver.run()


# ------------------------------------------------------------------------------
