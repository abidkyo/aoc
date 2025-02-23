#!/usr/bin/env pypy3

"""
DFS.
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day17Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 17
        self.expected_test = 4, 3
        self.expected = 4372, 4

    def solve(self, test: bool = False) -> tuple:
        if test:
            L = 25
        else:
            L = 150

        G = self.puzzle.splitlines()
        G = sorted([int(g) for g in G], reverse=True)

        def dfs(graph):
            stack = [(graph[0], {0})]

            while stack:
                score, visited = stack.pop()

                if score == L:
                    yield len(visited)

                for i, g in enumerate(graph):
                    if i <= max(visited):
                        continue

                    nscore = score + g
                    if nscore > L:
                        continue

                    nvisited = visited | {i}
                    stack.append((nscore, nvisited))

        res = []
        for i in range(len(G)):
            res.extend(dfs(G[i:]))

        p1 = len(res)
        p2 = len(list(filter(lambda x: x == min(res), res)))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day17Solver()
    solver.run()


# ------------------------------------------------------------------------------
