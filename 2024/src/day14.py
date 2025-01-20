#!/usr/bin/env pypy3

"""
Movement in Grid.

pypy3: 340ms
"""

from math import prod

from aoc import AOCSolver, integers, print2d

# ------------------------------------------------------------------------------


def visualize(P, R, C):
    G = [["."] * C for r in range(R)]
    for r in range(R):
        for c in range(C):
            if (r, c) in P:
                G[r][c] = "X"

    print2d(G)


def move(PV, R, C):
    for pv in PV:
        px, py, vx, vy = pv
        npx = (px + vx + C) % C
        npy = (py + vy + R) % R
        pv[0], pv[1] = npx, npy


def calc(PV, R, C):
    mx = C // 2
    my = R // 2

    A = [0, 0, 0, 0]
    for pv in PV:
        px, py, _, _y = pv
        if 0 <= px < mx and 0 <= py < my:
            A[0] += 1
        elif mx < px < C and 0 <= py < my:
            A[1] += 1
        elif 0 <= px < mx and my < py < R:
            A[2] += 1
        elif mx < px < C and my < py < R:
            A[3] += 1

    return prod(A)


class Day14Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 14
        self.expected_test = 12, 0
        self.expected = 218433348, 6512

    def solve(self, test: bool = False) -> tuple:
        p1, p2 = 0, 0

        R, C = 103, 101
        if test:
            R, C = 7, 11

        puzzle = solver.puzzle.splitlines()

        PV = [list(integers(pv)) for pv in puzzle]

        for i in range(10000):
            if i == 100:
                p1 = calc(PV, R, C)

                if test:
                    break

            if not test:
                P = [(px, py) for px, py, _, _ in PV]
                if len(P) == len(set(P)):
                    # visualize(P, R, C)
                    p2 = i
                    break

            move(PV, R, C)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day14Solver()
    solver.run()


# ------------------------------------------------------------------------------
