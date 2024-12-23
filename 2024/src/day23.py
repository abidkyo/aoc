#!/usr/bin/env python3

"""
Cliques in Graph.
"""

from typing import DefaultDict

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day23Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 23
        self.expected_test = 7, "co,de,ka,ta"
        self.expected = 1411, "aq,bn,ch,dt,gu,ow,pk,qy,tv,us,yx,zg,zu"

    def solve(self, test: bool = False) -> tuple:
        puzzle = solver.read_input(test).splitlines()

        G = DefaultDict(set)
        for line in puzzle:
            x, y = line.split("-")
            G[x].add(y)
            G[y].add(x)

        p1 = []
        for x in G:
            for y in G[x]:
                if x > y:
                    continue
                for z in G[y]:
                    if z not in G[x] or y > z:
                        continue
                    if any(s.startswith("t") for s in (x, y, z)):
                        p1.append((x, y, z))

        p1 = len(p1)

        def bron_kerbosch(R, P, X):
            if not P and not X:
                return [R]

            u = next(iter(P | X))

            res = []
            for v in P - G[u]:
                res.extend(bron_kerbosch(R | {v}, P & G[v], X & G[v]))
                P.remove(v)
                X.add(v)

            return res

        p2, size = set(), 0
        for res in bron_kerbosch(set(), set(G), set()):
            if (s := len(res)) > size:
                p2, size = res, s

        p2 = ",".join(sorted(list(p2)))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day23Solver()
    solver.run()


# ------------------------------------------------------------------------------
