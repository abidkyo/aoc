#!/usr/bin/env python3

"""
Bounded DFS.
"""

from collections.abc import Iterator
from dataclasses import dataclass, replace

from aoc import AOCSolver, integers

# ------------------------------------------------------------------------------


@dataclass
class Spell:
    cost: int
    damage: int = 0
    heal: int = 0
    t_regen: int = 0
    t_poison: int = 0
    t_armor: int = 0


spells = [
    Spell(cost=53, damage=4),
    Spell(cost=73, damage=2, heal=2),
    Spell(cost=113, t_armor=6),
    Spell(cost=173, t_poison=6),
    Spell(cost=229, t_regen=5),
]


@dataclass
class State:
    cost: int = 0
    turn: bool = True
    hp: int = 0
    mana: int = 0
    b_hp: int = 0
    t_regen: int = 0
    t_poison: int = 0
    t_armor: int = 0


def usable_spell(state: State) -> Iterator[Spell]:
    for spell in spells:
        if state.mana < spell.cost:
            continue
        if spell.t_poison != 0 and state.t_poison != 0:
            continue
        if spell.t_armor != 0 and state.t_armor != 0:
            continue
        if spell.t_regen != 0 and state.t_regen != 0:
            continue

        yield spell


def dfs(S: State, b_damage: int, p2: bool = False) -> int:
    stack = [S]

    min_cost = int(1e5)

    i = 0
    while stack:
        i += 1
        if i > int(1e5):
            break

        state = stack.pop()

        if state.t_regen > 0:
            state.mana += 101
        if state.t_poison > 0:
            state.b_hp -= 3
        armor = 7 if state.t_armor > 0 else 0

        state.t_regen = max(0, state.t_regen - 1)
        state.t_poison = max(0, state.t_poison - 1)
        state.t_armor = max(0, state.t_armor - 1)

        if state.hp <= 0:
            continue

        if state.b_hp <= 0:
            min_cost = min(min_cost, state.cost)
            continue

        if state.turn:
            if p2:
                state.hp -= 1

            for spell in usable_spell(state):
                ns = replace(state)
                ns.turn ^= True

                ns.hp += spell.heal
                ns.b_hp -= spell.damage

                ns.cost += spell.cost
                ns.mana -= spell.cost

                ns.t_armor = spell.t_armor or state.t_armor
                ns.t_poison = spell.t_poison or state.t_poison
                ns.t_regen = spell.t_regen or state.t_regen

                stack.append(ns)
        else:
            ns = replace(state)
            ns.turn ^= True
            ns.hp -= max(1, b_damage - armor)

            stack.append(ns)

    return min_cost


class Day22Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 22
        self.expected_test = 0, 0
        self.expected = 1824, 1937

    def solve(self, test: bool = False) -> tuple:
        p1, p2 = 0, 0
        if test:
            return p1, p2

        puzzle = self.puzzle.splitlines()

        b_hp = integers(puzzle[0])[0]
        b_damage = integers(puzzle[1])[0]

        S = State(b_hp=b_hp, hp=50, mana=500)
        p1 = dfs(S, b_damage)
        p2 = dfs(S, b_damage, True)

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day22Solver()
    solver.run()


# ------------------------------------------------------------------------------
