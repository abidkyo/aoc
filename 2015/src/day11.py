#!/usr/bin/env pypy3

"""
ASCII Code.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------

BANNED = [ord(c) for c in "iol"]
A = ord("a")
Z = ord("z")


def increment(nums: list):
    carry = 1
    for i in reversed(range(len(nums))):
        nums[i] += carry
        if nums[i] <= Z:
            break
        else:
            nums[i] = A
            carry = 1


def encoder(nums):
    return "".join(chr(n) for n in nums)


def rules(nums):
    for n in BANNED:
        if n in nums:
            return False

    for i in range(len(nums) - 2):
        if (nums[i + 1] - nums[i] == 1) and (nums[i + 2] - nums[i + 1] == 1):
            break
    else:
        return False

    doubles = 0
    prev = Z + 1
    for i in range(len(nums) - 1):
        if nums[i] == nums[i + 1] and nums[i] != prev:
            doubles += 1
            prev = nums[i]

    return doubles > 1


class Day11Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 11
        self.expected_test = "ghjaabcc", "ghjbbcdd"
        self.expected = "cqjxxyzz", "cqkaabcc"

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.strip()
        nums = [ord(c) for c in puzzle]

        tmp = []
        while True:
            increment(nums)
            if rules(nums):
                tmp.append(encoder(nums))

            if len(tmp) == 2:
                break

        p1, p2 = tmp

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day11Solver()
    solver.run()


# ------------------------------------------------------------------------------
