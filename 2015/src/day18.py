#!/usr/bin/env python3

"""
Game of Life.
"""

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


class Day18Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 18
        self.expected_test = 4, 17
        self.expected = 1061, 1006

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        if test:
            T = 5
        else:
            T = 100

        P = complex

        R = len(puzzle)
        C = len(puzzle[0])
        E = [P(0, 0), P(R - 1, 0), P(0, C - 1), P(R - 1, C - 1)]

        G1 = {}
        for y, r in enumerate(puzzle):
            for x, c in enumerate(r):
                if c == "#":
                    G1[P(x, y)] = 1
                elif c == ".":
                    G1[P(x, y)] = 0
                else:
                    assert False

        G2 = G1.copy()

        for p in E:
            G2[p] = 1

        def calc(g, p, part2):
            if part2 and p in E:
                return 1

            count = 0
            for d in DIRC.values():
                np = p + d
                if np in g and g[np] == 1:
                    count += 1

            if count == 3:
                return 1
            if g[p] and count == 2:
                return 1
            return 0

        for _ in range(T):
            # todo: instead of looping through all points,
            # maybe loop over active points only
            G1 = {p: calc(G1, p, False) for p in G1}
            G2 = {p: calc(G2, p, True) for p in G2}

        p1 = sum(G1.values())
        p2 = sum(G2.values())

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day18Solver()
    solver.run()


# ------------------------------------------------------------------------------
