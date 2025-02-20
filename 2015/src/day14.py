#!/usr/bin/env python3

"""
Calculation with State.
"""

from dataclasses import dataclass

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


@dataclass
class Reindeer:
    speed: int
    fly: int
    rest: int
    t_fly: int
    t_rest: int
    flying: bool
    distance: int
    points: int


def move(reindeer: Reindeer):
    if reindeer.flying:
        reindeer.t_fly += 1
        reindeer.distance += reindeer.speed

        if reindeer.t_fly == reindeer.fly:
            reindeer.t_fly = 0
            reindeer.flying = False
    else:
        reindeer.t_rest += 1

        if reindeer.t_rest == reindeer.rest:
            reindeer.t_rest = 0
            reindeer.flying = True


class Day14Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 14
        self.expected_test = 1120, 689
        self.expected = 2660, 1256

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        if test:
            L = 1000
        else:
            L = 2503

        p1, p2 = 0, 0

        R = []
        for line in puzzle:
            speed, fly, rest = integers(line)
            R.append(Reindeer(speed, fly, rest, 0, 0, True, 0, 0))

        p1, p2 = 0, 0
        for _ in range(L):
            d_max = max(g.distance for g in R)
            for r in R:
                if r.distance == d_max != 0:
                    r.points += 1
                move(r)

        p1 = d_max
        p2 = max(r.points for r in R)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day14Solver()
    solver.run()


# ------------------------------------------------------------------------------
