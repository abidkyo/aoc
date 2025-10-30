#!/usr/bin/env python3

"""
Turing machine.
"""

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


def sim(puzzle: list[str], reg: dict[str, int]) -> int:
    i = 0
    while i < len(puzzle):
        line = puzzle[i]
        x = line[4]

        if line.startswith("hlf"):
            reg[x] //= 2
        elif line.startswith("tpl"):
            reg[x] *= 3
        elif line.startswith("inc"):
            reg[x] += 1
        elif line.startswith("jmp"):
            n = integers(line)[0]
            i += n
            continue
        elif line.startswith("jie"):
            if reg[x] % 2 == 0:
                n = integers(line)[0]
                i += n
                continue
        elif line.startswith("jio"):
            if reg[x] == 1:
                n = integers(line)[0]
                i += n
                continue

        i += 1

    return reg["b"]


class Day23Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 23
        self.expected_test = 0, 0
        self.expected = 255, 334

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        p1 = sim(puzzle, {"a": 0, "b": 0})
        p2 = sim(puzzle, {"a": 1, "b": 0})

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day23Solver()
    solver.run()


# ------------------------------------------------------------------------------
