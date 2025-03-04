#!/usr/bin/env python3

"""
Chemical Compound Production.

Part 2:
S == Rn
E == Ar

1. Type
- e => XX (1->2)
- X => XX (1->2)

gen XXXXX: 5 - 1 = 4 steps
X => XX => XXX => XXXX => XXXXX

2. Type
- X => XSXE     (1->4)
- X => XSXYXE   (1->6)
- X => XSXYXYXE (1->8)

Formula =: NKeys - NS - NE - 2*NY - 1

gen XSXE: 4 - 2 - 1 = 1 step
X => XSXE

gen XSXSXEE: 7 - 4 - 1 = 2 steps
X => XSXE => XSXSXEE

gen XSXSYXEYXSYXEE: 16 - 6 - 2*3 - 1 = 3 steps
X => XSXYXE => XSXSXYXEYXE => XSXSXYXEYXSXYXEE
"""

from collections import defaultdict
from re import findall

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day19Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 19
        self.expected_test = 7, 5
        self.expected = 518, 200

    def solve(self, test: bool = False) -> tuple:
        patterns, string = self.puzzle.split("\n\n")
        string = string.strip()

        G = defaultdict(list)
        for pattern in patterns.splitlines():
            a, _, b = pattern.split()
            G[a].append(b)

        def replaces(word):
            tmp = ""
            for i in reversed(range(len(word))):
                c = word[i]

                tmp = c + tmp
                tmp = tmp[:2]

                if tmp[0] in G:
                    tmp = tmp[0]

                if tmp in G:
                    a, b = word[:i], word[i + len(tmp) :]

                    for p in G[tmp]:
                        res = a + p + b
                        yield res

                    tmp = ""

        seen = set(replaces(string))
        p1 = len(seen)

        keys = len(list(findall(r"[A-Z][a-z]*", string)))
        rnar = len(list(findall(r"(Rn)|(Ar)", string)))
        y = len(list(findall(r"Y", string)))
        p2 = keys - rnar - 2 * y - 1

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day19Solver()
    solver.run()


# ------------------------------------------------------------------------------
