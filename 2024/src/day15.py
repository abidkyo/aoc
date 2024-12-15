#!/usr/bin/env python3

"""
Item Mover.

python3: 450ms
"""

from aoc import DIRC, AOCSolver, print2d

# ------------------------------------------------------------------------------


def visualize(S, B, W, R, C):
    G = [["."] * C for r in range(R)]
    P = complex
    for r in range(R):
        for c in range(C):
            p = P(c, r)
            if p in B:
                G[r][c] = "0"
            elif p in W:
                G[r][c] = "#"
            elif p == S:
                G[r][c] = "@"

    print2d(G)


def part1(G, M):
    def can_move(p, m):
        np = p + DIRC[m]
        if np in W:
            return None

        if np not in B:
            return [np]

        if ps := can_move(np, m):
            return [np] + ps

        return None

    B = set()
    W = set()
    P = complex
    for y, r in enumerate(G):
        for x, c in enumerate(r):
            if c == "O":
                B.add(P(x, y))
            elif c == "#":
                W.add(P(x, y))
            elif c == "@":
                S = P(x, y)

    for m in M:
        if NP := can_move(S, m):
            S = NP[0]
            B = B - set(NP[:1]) | set(NP[1:])

    return sum(int(100 * p.imag + p.real) for p in B)


def part2(G, M):
    def can_move(p, m):
        np = p + DIRC[m]
        if np in W:
            return [None]

        if np not in B:
            return [p]

        ps = can_move(np, m)

        if DIRC[m].imag:
            if np in BB:
                ps += can_move(np + 1, m)
            else:
                ps += can_move(np - 1, m)

        return [p] + ps

    B = set()
    BB = set()
    W = set()
    P = complex
    for y, r in enumerate(G):
        for x, c in enumerate(r):
            if c == "O":
                BB.add(P(x * 2, y))
                B.add(P(x * 2, y))
                B.add(P(x * 2 + 1, y))
            elif c == "#":
                W.add(P(x * 2, y))
                W.add(P(x * 2 + 1, y))
            elif c == "@":
                S = P(x * 2, y)

    for m in M:
        d = DIRC[m]
        NP = can_move(S, m)
        if all(NP):
            S += d
            NP = sorted(
                (np for np in set(NP) if np in BB),
                key=lambda x: (x.imag * -d.imag, x.real * -d.real),
            )
            for np in NP:
                B = B - {np, np + 1} | {np + d, np + d + 1}
                BB = BB - {np} | {np + d}

    return sum(int(100 * p.imag + p.real) for p in BB)


class Day15Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 15
        self.expected_test = 10092, 9021
        self.expected = 1463512, 1486520

    def solve(self, test: bool = False) -> tuple:
        G, M = solver.read_input(test).split("\n\n")
        G = G.splitlines()

        for a, b in {"\n": "", "^": "u", ">": "r", "v": "d", "<": "l"}.items():
            M = M.replace(a, b)

        p1 = part1(G, M)
        p2 = part2(G, M)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day15Solver()
    solver.run()


# ------------------------------------------------------------------------------
