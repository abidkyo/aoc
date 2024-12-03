#!/usr/bin/env python3

"""
RegEx.
"""

import re

from aoc import integers, read_input

# ------------------------------------------------------------------------------


# txt = read_input(3, True).strip()
txt = read_input(3, False).strip()

# (?:...) : non-capturing group
#       | : alternative match
PATTERN = r"do(?:n't)?\(\)|mul\(\d+,\d+\)"

p1, p2 = 0
enabled = True
for res in re.findall(PATTERN, txt):
    try:
        x, y = integers(res)
        p1 += x * y
        if enabled:
            p2 += x * y
    except ValueError:
        if res == "do()":
            enabled = True
        else:
            enabled = False


# 161, 166357705
print(p1)

# 48, 88811886
print(p2)


# ------------------------------------------------------------------------------
