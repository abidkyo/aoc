#!/usr/bin/env python3

"""
Elements Increasing/Decreasing.
"""

from aoc import integers, list_remove_index, map_list, read_input

# ------------------------------------------------------------------------------


def check(L):
    incr = all(y > x for x, y in zip(L, L[1:]))
    decr = all(y < x for x, y in zip(L, L[1:]))
    diff = all(abs(y - x) <= 3 for x, y in zip(L, L[1:]))

    return (incr or decr) and diff


# txt = read_input(2, True).splitlines()
txt = read_input(2, False).splitlines()

G = map_list(integers, txt)

p1 = 0
p2 = 0
for R in G:
    if check(R):
        p1 += 1
    elif any(check(list_remove_index(i, R)) for i in range(len(R))):
        p2 += 1


# 2, 299
print(p1)

# 4, 364
print(p1 + p2)


# ------------------------------------------------------------------------------
