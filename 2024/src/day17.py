#!/usr/bin/env python3

"""
Program Operations.

python3: 120ms
"""

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def run(R, P):
    def combo_op(op):
        return op if op <= 3 else R[op - 4]

    i = 0
    out = []
    while i < len(P):
        code, op = P[i : i + 2]

        if code == 0:
            R[0] = int(R[0] / (2 ** combo_op(op)))
        elif code == 6:
            R[1] = int(R[0] / (2 ** combo_op(op)))
        elif code == 7:
            R[2] = int(R[0] / (2 ** combo_op(op)))
        elif code == 1:
            R[1] = R[1] ^ op
        elif code == 4:
            R[1] = R[1] ^ R[2]
        elif code == 2:
            R[1] = combo_op(op) % 8
        elif code == 5:
            out += [combo_op(op) % 8]
        elif code == 3:
            if R[0] != 0:
                i = op
                continue

        i += 2

    return ",".join(map(str, out))


class Day17Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 17
        self.expected_test = "5,7,3,0", 117440
        self.expected = "2,1,4,7,6,0,3,1,4", 266932601404433

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.puzzle.strip()
        puzzle = list(integers(puzzle))

        R = puzzle[:3]
        P = puzzle[3:]

        p1 = run(R, P)

        X = range(8)
        for i in range(2, len(P) + 1):
            T = ",".join(map(str, P[-i:]))

            NX = set()
            for x in X:
                for y in range(8):
                    nx = (x << 3) + y
                    if run([nx, 0, 0], P) == T:
                        NX.add(nx)
            X = NX

        p2 = min(X)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day17Solver()
    solver.run()


# ------------------------------------------------------------------------------
