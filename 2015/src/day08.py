#!/usr/bin/env python3

"""
String with Special Characters.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day08Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 8
        self.expected_test = 12, 19
        self.expected = 1371, 2117

    def solve(self, test: bool = False) -> tuple:
        strings = self.puzzle.splitlines()

        p1, p2 = 0, 0
        for s in strings:
            noise = 0
            anoise = 0

            # quotes
            noise += 2
            anoise += 4

            i = 0
            while i < len(s):
                if s[i] == "\\":
                    # \\ or \"
                    if s[i + 1] == '"' or s[i + 1] == "\\":
                        noise += 1
                        anoise += 2
                        i += 1
                    # \x..
                    elif s[i + 1] == "x":
                        noise += 3
                        anoise += 1
                        i += 3

                i += 1

            p1 += noise
            p2 += anoise

        # # one-liner, but runtime is slower
        # # taken from https://www.reddit.com/r/adventofcode/comments/3vw32y/comment/cxrad1k
        # # eval will remove noise from the string :)
        # p1 = sum(len(s) - len(eval(s)) for s in strings)
        # p2 = sum(2 + s.count("\\") + s.count('"') for s in strings)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day08Solver()
    solver.run()


# ------------------------------------------------------------------------------
