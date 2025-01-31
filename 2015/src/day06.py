#!/usr/bin/env pypy3

"""
State Machine.
"""

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def get_functions(instr):
    if "on" in instr:
        return lambda x: True, lambda x: x + 1
    elif "off" in instr:
        return lambda x: False, lambda x: max(x - 1, 0)
    elif "toggle" in instr:
        return lambda x: not x, lambda x: x + 2


class Day06Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 6
        self.expected_test = 998996, 1001996
        self.expected = 543903, 14687245

    def solve(self, test: bool = False) -> tuple:
        instructions = self.puzzle.splitlines()

        R = C = 1000

        G1 = [[0] * R for _ in range(C)]
        G2 = [[0] * R for _ in range(C)]
        for instr in instructions:
            x1, y1, x2, y2 = integers(instr)
            f1, f2 = get_functions(instr)

            for x in range(x1, x2 + 1):
                for y in range(y1, y2 + 1):
                    G1[x][y] = f1(G1[x][y])
                    G2[x][y] = f2(G2[x][y])

        p1 = sum(x for y in G1 for x in y)
        p2 = sum(x for y in G2 for x in y)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day06Solver()
    solver.run()


# ------------------------------------------------------------------------------
