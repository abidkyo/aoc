#!/usr/bin/env python3

"""
Dynamic Programming and Cache.
"""

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


P = complex
NUMPAD = {
    "7": P(0, 0),
    "8": P(1, 0),
    "9": P(2, 0),
    "4": P(0, 1),
    "5": P(1, 1),
    "6": P(2, 1),
    "1": P(0, 2),
    "2": P(1, 2),
    "3": P(2, 2),
    "0": P(1, 3),
    "A": P(2, 3),
}
DIRPAD = {
    "u": P(1, 0),
    "A": P(2, 0),
    "l": P(0, 1),
    "d": P(1, 1),
    "r": P(2, 1),
}

CACHE = dict()


def recurse(K, C, R):
    if (len(K), C, R) in CACHE:
        return CACHE[len(K), C, R]

    if R == 0:
        CACHE[len(K), C, R] = len(C)
        return len(C)

    p = K["A"]
    r = R - 1

    mins = 0
    for c in C:
        mins += min(recurse(DIRPAD, path + "A", r) for path in pathfinder(K, p, c))
        p = K[c]

    CACHE[len(K), C, R] = mins
    return mins


def pathfinder(K, S, E):
    stack = [(S, set([S]), "")]

    while stack:
        p, seen, path = stack.pop()
        if p == K[E]:
            yield path
            continue

        for d in "urdl":
            np = p + DIRC[d]

            if np not in seen and np in K.values():
                stack.append((np, seen | {np}, path + d))


class Day21Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 21
        self.expected_test = 126384, 154115708116294
        self.expected = 134120, 167389793580400

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.puzzle.splitlines()

        p1, p2 = 0, 0
        for code in puzzle:
            res = recurse(NUMPAD, code, 3)
            p1 += res * int("".join(c for c in code if c in "1234567890"))

            res = recurse(NUMPAD, code, 26)
            p2 += res * int("".join(c for c in code if c in "1234567890"))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day21Solver()
    solver.run()


# ------------------------------------------------------------------------------
