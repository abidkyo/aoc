#!/usr/bin/env python3

"""
Pathfinder.
"""

from heapq import heappop, heappush

from aoc import DIR, AOCSolver

# ------------------------------------------------------------------------------


DIRS = [DIR[d] for d in "urdl"]


def bfs(G, S, E, p2):
    R, C = len(G), len(G[0])

    if p2:
        Q = [(0, *S, d) for d in range(len(DIRS))]
    else:
        Q = [(0, *S, 1)]

    seen = {}
    score = []

    while Q:
        s, r, c, d = heappop(Q)

        if (r, c, d) in seen:
            continue
        seen[(r, c, d)] = s

        if (r, c) == E:
            score.append(s)
            continue

        heappush(Q, (s + 1000, r, c, (d + 1) % 4))
        heappush(Q, (s + 1000, r, c, (d + 3) % 4))

        if p2:
            dc, dr = DIRS[(d + 2) % 4]
        else:
            dc, dr = DIRS[d]

        rr, cc = r + dr, c + dc
        if 0 <= rr < R and 0 <= cc < C and G[rr][cc] != "#":
            heappush(Q, (s + 1, rr, cc, d))

    return score[0], seen


class Day16Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 16
        self.expected_test = 11048, 64
        self.expected = 111480, 529

    def solve(self, test: bool = False) -> tuple:
        G = solver.read_input(test).splitlines()
        R, C = len(G), len(G[0])

        for r in range(R):
            for c in range(C):
                ch = G[r][c]

                if ch == "S":
                    S = (r, c)
                elif ch == "E":
                    E = (r, c)

        p1, P1 = bfs(G, S, E, False)
        p2, P2 = bfs(G, E, S, True)

        PS = set(P1) & set(P2)

        P = set()
        for pp in PS:
            if P1[pp] + P2[pp] == p1:
                P.add((pp[0], pp[1]))

        p2 = len(P)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day16Solver()
    solver.run()


# ------------------------------------------------------------------------------
