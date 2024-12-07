#!/usr/bin/env pypy3

"""
Number Operations.

pypy3: 2.2s
"""

from itertools import product

from aoc import AOCSolver, integers, map_list

# ------------------------------------------------------------------------------


def calc(N, OP):
    res = 0
    target = N[0]
    for ops in OP:
        r = N[1]
        for i, op in enumerate(ops):
            if op == "A":
                r += N[i + 2]
            elif op == "B":
                r *= N[i + 2]
            elif op == "C":
                r = int(str(r) + str(N[i + 2]))

        if r == target:
            res += r
            break

    return res


class Day07Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 7
        self.expected = 1545311493300, 169122112716571
        self.expected_test = 3749, 11387

    def solve(self, test: bool = False) -> tuple:
        G = solver.read_input(test).splitlines()
        N = map_list(integers, G)

        p1, p2 = 0, 0
        for nums in N:
            p1 += calc(nums, product("AB", repeat=len(nums) - 2))
            p2 += calc(nums, product("ABC", repeat=len(nums) - 2))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day07Solver()
    solver.run()


# ------------------------------------------------------------------------------
