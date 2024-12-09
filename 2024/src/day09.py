#!/usr/bin/env pypy3

"""
Disk Fragmenter.
"""

from aoc import AOCSolver, digits

# ------------------------------------------------------------------------------


def grid(N, F):
    G = ["."] * N

    for k, n, v in F:
        for i in range(v):
            G[n + i] = k

    return G


def part1(G):
    p1 = 0
    for i, n in enumerate(G):
        if n != ".":
            p1 += i * n
            continue
        while (n := G.pop()) == ".":
            pass
        if i >= len(G):
            break
        p1 += i * n

    return p1


class Day09Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 9
        self.expected_test = 1928, 2858
        self.expected = 6367087064415, 6390781891880

    def solve(self, test: bool = False) -> tuple:
        D = solver.read_input(test).strip()
        D = digits(D)

        k = 0
        N = 0
        F, E = [], []
        for i, v in enumerate(D):
            if i % 2 == 0:
                F.append((k, N, v))
                k += 1
            else:
                E.append((N, v))
            N += v

        G = grid(N, F)
        p1 = part1(G)

        NF = []
        while F:
            k, n, v = F.pop()
            E = list(filter(lambda x: x[0] < n and x[1] != 0, E))
            for j, (nn, vv) in enumerate(E):
                if v <= vv:
                    E[j] = (nn + v, vv - v)
                    NF.append((k, nn, v))
                    break
            else:
                NF.append((k, n, v))

            if len(E) == 0:
                break

        F += NF
        p2 = sum(k * (n + i) for k, n, v in F for i in range(v))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day09Solver()
    solver.run()


# ------------------------------------------------------------------------------
