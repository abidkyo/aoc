#!/usr/bin/env python3

"""
Shortest-Path with Binary-Search.

python3: 35 ms
"""

from aoc import DIRC, AOCSolver, integers

# ------------------------------------------------------------------------------


def bfs(W, S, E):
    W = set(W)
    queue = [(S, 0)]
    seen = set([S])

    for p, s in queue:
        if p == E:
            return s
        for d in (DIRC[d] for d in "urdl"):
            np = p + d
            if (
                np in seen
                or np in W
                or not (0 <= np.real <= E.real and 0 <= np.imag <= E.imag)
            ):
                continue
            seen.add(np)
            queue.append((np, s + 1))

    return 0


class Day18Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 18
        self.expected_test = 22, (6 + 1j)
        self.expected = 384, (36 + 10j)

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.read_input(test).splitlines()

        P = complex
        W = [P(*integers(p)) for p in puzzle]

        S = P(0, 0)
        if test:
            E = P(6, 6)
            L = 12
        else:
            E = P(70, 70)
            L = 1024

        p1 = bfs(W[:L], S, E)

        lo, hi = L, len(W)
        while lo < hi:
            mid = (lo + hi) // 2
            res = bfs(W[:mid], S, E)
            if res:
                lo = mid + 1
            else:
                hi = mid

        p2 = W[lo - 1]

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day18Solver()
    solver.run()


# ------------------------------------------------------------------------------
