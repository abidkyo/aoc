#!/usr/bin/env python3

"""
Cartesian Product of Items.
"""

from collections.abc import Iterator
from dataclasses import dataclass

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


@dataclass
class Item:
    cost: int
    damage: int
    armor: int


@dataclass
class Character:
    hp: int
    damage: int
    armor: int


weapons = [
    Item(8, 4, 0),
    Item(10, 5, 0),
    Item(25, 6, 0),
    Item(40, 7, 0),
    Item(74, 8, 0),
]
armors = [
    Item(0, 0, 0),
    Item(13, 0, 1),
    Item(31, 0, 2),
    Item(53, 0, 3),
    Item(75, 0, 4),
    Item(102, 0, 5),
]
rings = [
    Item(0, 0, 0),
    Item(0, 0, 0),
    Item(25, 1, 0),
    Item(50, 2, 0),
    Item(100, 3, 0),
    Item(20, 0, 1),
    Item(40, 0, 2),
    Item(80, 0, 3),
]


def assemble() -> Iterator[tuple[int, ...]]:
    for w in weapons:
        for a in armors:
            for r1 in rings:
                for r2 in rings:
                    if r2.cost != 0 and r1 == r2:
                        continue

                    cost = sum(x.cost for x in [w, a, r1, r2])
                    damage = sum(x.damage for x in [w, a, r1, r2])
                    armor = sum(x.armor for x in [w, a, r1, r2])

                    yield (cost, damage, armor)


def fight(player: Character, boss: Character) -> bool:
    while True:
        boss.hp -= max(player.damage - boss.armor, 1)

        if boss.hp <= 0:
            return True

        player.hp -= max(boss.damage - player.armor, 1)

        if player.hp <= 0:
            return False


class Day21Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 21
        self.expected_test = 8, 0
        self.expected = 111, 188

    def solve(self, test: bool = False) -> tuple:
        puzzle = self.puzzle.splitlines()

        bhp = integers(puzzle[0])[0]
        bdamage = integers(puzzle[1])[0]
        barmor = integers(puzzle[2])[0]

        min_cost = 1e5
        max_cost = 0
        for cost, damage, armor in assemble():
            player = Character(100, damage, armor)
            boss = Character(bhp, bdamage, barmor)

            res = fight(player, boss)

            if res:
                min_cost = min(min_cost, cost)
            else:
                max_cost = max(max_cost, cost)

        p1, p2 = min_cost, max_cost

        return p1, p2


# ------------------------------------------------------------------------------

if __name__ == "__main__":
    solver = Day21Solver()
    solver.run()


# ------------------------------------------------------------------------------
