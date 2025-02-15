#!/usr/bin/env pypy3

"""
Optimal Seating using DFS.
"""

from collections import defaultdict

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


class Day13Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 13
        self.expected_test = 330, 286
        self.expected = 733, 725

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        G = defaultdict(dict)
        for line in puzzle:
            x = integers(line)[0]

            if "gain" in line:
                x *= 1
            elif "lose" in line:
                x *= -1
            else:
                assert False

            a, *_, b = line.split()
            b = b[:-1]

            G[a][b] = x

        def dfs(S):
            stack = [(S, 0, [S])]

            maxs = 0
            while stack:
                p, s, seen = stack.pop()

                if len(seen) == L:
                    p = seen[0]
                    np = seen[-1]
                    s = s + G[p][np] + G[np][p]

                    maxs = max(s, maxs)
                    continue

                for np in G[p].keys():
                    if np in seen:
                        continue

                    ns = s + G[p][np] + G[np][p]
                    nseen = seen + [np]

                    stack.append((np, ns, nseen))

            return maxs

        S = list(G.keys())[0]

        L = len(list(G.keys()))
        p1 = dfs(S)

        for a in list(G.keys()):
            G[a]["ME"] = 0
            G["ME"][a] = 0

        L = len(list(G.keys()))
        p2 = dfs(S)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day13Solver()
    solver.run()


# ------------------------------------------------------------------------------
