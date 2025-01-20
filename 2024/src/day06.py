#!/usr/bin/env pypy3

"""
Valid Path and Cycle Detection.

pypy3: 5.5s
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


def move(r: int, c: int, d: int):
    # urdl
    DIR = [(0, -1), (1, 0), (0, 1), (-1, 0)]

    dc, dr = DIR[d]
    return r + dr, c + dc, d


def walk(G: list, B: set, r: int, c: int, d: int):
    R, C = len(G), len(G[0])

    path = set()
    turns = set()

    while True:
        if not (0 <= r < R and 0 <= c < C):
            break

        if (r, c, d) in turns:
            return set()

        path.add((r, c))

        for i in range(3):
            nr, nc, nd = move(r, c, (d + i) % 4)
            if (nr, nc) not in B:
                if i > 0:
                    turns.add((r, c, d))
                break

        r, c, d = nr, nc, nd

    return path


class Day06Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 6
        self.expected = 5461, 1836
        self.expected_test = 41, 6

    def solve(self, test: bool = False) -> tuple:
        G = solver.puzzle.splitlines()
        R, C = len(G), len(G[0])

        B = set()
        for r in range(R):
            for c in range(C):
                if G[r][c] == "^":
                    S = (r, c)
                elif G[r][c] == "#":
                    B.add((r, c))

        path = walk(G, B, *S, 0)
        p1 = len(path)

        p2 = 0
        path.remove(S)
        for p in path:
            p = set((p,))
            p2 += not walk(G, B | p, *S, 0)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day06Solver()
    solver.run()


# ------------------------------------------------------------------------------
