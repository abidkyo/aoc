#!/usr/bin/env python3

"""
Dynamic Programming.
"""

from functools import cache

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day07Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 7
        self.expected_test = 727, 727
        self.expected = 16076, 2797

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        G = {}
        for line in puzzle:
            op, d = line.split(" -> ")
            G[d] = op.split()

        @cache
        def calc(op):
            try:
                return int(op)
            except ValueError:
                pass

            op = G[op]

            if len(op) == 1:
                return calc(op[0])

            # NOT operator
            if len(op) == 2:
                _, b = op
                b = calc(b)
                return 0xFFFF - b

            # other operators
            if len(op) == 3:
                a, op, b = op
                a = calc(a)
                b = calc(b)

                if op == "AND":
                    return a & b
                if op == "OR":
                    return a | b
                if op == "LSHIFT":
                    return a << b
                if op == "RSHIFT":
                    return a >> b

        p1 = calc("a")

        G["b"] = [p1]
        calc.cache_clear()
        p2 = calc("a")

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day07Solver()
    solver.run()


# ------------------------------------------------------------------------------
