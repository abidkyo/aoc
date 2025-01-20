#!/usr/bin/env python3

"""
Item Counter.

python3: 200ms
"""

from typing import Counter, DefaultDict

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


class Day11Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 11
        self.expected_test = 55312, 65601038650482
        self.expected = 185894, 221632504974231

    def solve(self, test: bool = False) -> tuple:
        p1, p2 = 0, 0

        S = solver.puzzle.strip()
        S = Counter(integers(S))

        for i in range(75):
            NS = DefaultDict(int)
            for k, v in S.items():
                sk = str(k)
                if k == 0:
                    NS[1] += v

                elif (s := len(sk)) % 2 == 0:
                    NS[int(sk[: s // 2])] += v
                    NS[int(sk[s // 2 :])] += v

                else:
                    NS[k * 2024] += v

            S = NS
            # print(f"{i:02}: {sum(N.values())}")

            if i == 24:
                p1 = sum(S.values())

        p2 = sum(S.values())

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day11Solver()
    solver.run()


# ------------------------------------------------------------------------------
