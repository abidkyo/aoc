#!/usr/bin/env python3

"""
List and Counter.
"""

from collections import Counter

from aoc import integers, list_transpose, map_list, read_input

# ------------------------------------------------------------------------------


# txt = read_input(1, True).splitlines()
txt = read_input(1, False).splitlines()

a, b = list_transpose(map_list(integers, txt))

a.sort()
b.sort()

counts = Counter(b)

diff = 0
score = 0
for x, y in zip(a, b):
    diff += abs(y - x)
    score += x * counts[x]

# 11, 1579939
print(diff)

# 31, 20351745
print(score)


# ------------------------------------------------------------------------------
