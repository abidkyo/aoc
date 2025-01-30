#!/usr/bin/env python3

"""
Substring in String.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


def p1_rule(s):
    vowels = sum(s.count(c) for c in ("a", "e", "i", "o", "u"))
    if vowels < 3:
        return False

    for a, b in zip(s, s[1:]):
        if a == b:
            break
    else:
        return False

    return all(c not in s for c in ("ab", "cd", "pq", "xy"))


def p2_rule(s):
    for i, c in enumerate(s[:-2]):
        c = s[i : i + 2]
        r = s[i + 2 :]

        if c in r:
            break
    else:
        return False

    for x, y, z in zip(s, s[1:], s[2:]):
        if x == z != y:
            break
    else:
        return False

    return True


class Day05Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 5
        self.expected_test = 2, 2
        self.expected = 258, 53

    def solve(self, test: bool = False) -> tuple:
        strings = self.puzzle.splitlines()

        p1 = sum(p1_rule(s) for s in strings)
        p2 = sum(p2_rule(s) for s in strings)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day05Solver()
    solver.run()


# ------------------------------------------------------------------------------
