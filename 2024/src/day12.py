#!/usr/bin/env python3

"""
Perimeters and Sides.
"""

from aoc import DIRC, AOCSolver

# ------------------------------------------------------------------------------


def perimeters(G, S):
    queue = [S]
    seen = set(queue)

    k = G[S]
    s = set()

    for p in queue:
        for d in (DIRC[d] for d in "urdl"):
            np = p + d

            if np in seen:
                continue
            if np not in G or G[np] != k:
                s.add((np, d))
                continue

            seen.add(np)
            queue.append(np)

    return queue, s


def sides(s):
    seen = set()

    c = 0
    for p in s:
        if p in seen:
            continue
        seen.add(p)

        c += 1

        p, d = p
        queue = [p]
        for p in queue:
            for dd in (DIRC[d] for d in "urdl"):
                np = p + dd
                if (np, d) in seen or (np, d) not in s:
                    continue
                queue.append(np)
                seen.add((np, d))
    return c


class Day12Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 12
        self.expected_test = 1930, 1206
        self.expected = 1465112, 893790

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.read_input(test).splitlines()

        G = {}
        P = complex
        for y, r in enumerate(puzzle):
            for x, c in enumerate(r):
                G[P(x, y)] = c

        seen = set()
        p1, p2 = 0, 0
        for i, p in enumerate(G):
            if p in seen:
                continue

            r, s = perimeters(G, p)
            p1 += len(r) * len(s)
            p2 += len(r) * sides(s)

            seen |= set(r)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day12Solver()
    solver.run()


# ------------------------------------------------------------------------------
