#!/usr/bin/env python3

"""
Word Search.
"""

from aoc import AOCSolver, get_neighbour

# ------------------------------------------------------------------------------


class Day04Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 4
        self.expected = 2591, 1880
        self.expected_test = 18, 9

    def solve(self, test: bool = False) -> tuple:
        P = set()
        X = set()
        A = set()
        XMAS = "XMAS"

        G = solver.read_input(test).splitlines()
        R, C = len(G), len(G[0])

        for r in range(R):
            for c in range(C):
                if (ch := G[r][c]) in XMAS:
                    P.add((r, c))

                    if ch == "X":
                        X.add((r, c))
                    elif ch == "A":
                        A.add((r, c))

        p1 = 0
        for r, c in X:
            for dr, dc in get_neighbour(0, 0, 8):
                nr, nc = r, c
                for i in range(1, len(XMAS)):
                    nr += dr
                    nc += dc
                    if (nr, nc) not in P or G[nr][nc] != XMAS[i]:
                        break
                else:
                    p1 += 1

        p2 = 0
        for r, c in A:
            ch = "".join(
                G[nr][nc] for nr, nc in get_neighbour(r, c, 3) if (nr, nc) in P
            )

            p2 += ch in ("MSMS", "SMSM", "MMSS", "SSMM")

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day04Solver()
    solver.run()


# ------------------------------------------------------------------------------
