#!/usr/bin/env python3

"""
Pathfinding.
"""

from collections import defaultdict

from aoc import INFINITY, AOCSolver

# ------------------------------------------------------------------------------


class Day09Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 9
        self.expected_test = 605, 982
        self.expected = 117, 909

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        G = defaultdict(list)
        for line in puzzle:
            a, _, b, _, d = line.split()
            G[a].append((b, int(d)))
            G[b].append((a, int(d)))

        def pathfinder(S, lim):
            queue = [(S, 0, {S})]

            mins = INFINITY
            maxs = 0

            for p, s, seen in queue:
                if len(seen) == lim:
                    mins = min(mins, s)
                    maxs = max(maxs, s)

                for np, ss in G[p]:
                    if np not in seen:
                        queue.append((np, s + ss, seen | {np}))

            return mins, maxs

        p1 = INFINITY
        p2 = 0
        for p in G:
            mins, maxs = pathfinder(p, len(G))
            p1 = min(p1, mins)
            p2 = max(p2, maxs)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day09Solver()
    solver.run()


# ------------------------------------------------------------------------------
