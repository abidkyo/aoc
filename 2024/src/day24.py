#!/usr/bin/env python3

"""
Ripple-Carry-Adder.

P2 done manually.
todo: how to program the solution?
"""

from aoc import AOCSolver

# ------------------------------------------------------------------------------


class Day24Solver(AOCSolver):
    def __init__(self):
        super().__init__()

        self.day = 24
        self.expected_test = 2024, ""
        self.expected = 56729630917616, "bjm,hsw,nvr,skf,wkr,z07,z13,z18"
        # 22738689785549

    def solve(self, test: bool = False) -> tuple:
        wires, connections = solver.puzzle.split("\n\n")

        W = {}
        C = {}
        Z = []
        for c in connections.splitlines():
            a, op, b, _, d = c.split()
            C[d] = (a, op, b)
            if d.startswith("z"):
                Z.append(d)
        Z.sort()

        for w in wires.splitlines():
            k, v = w.split(":")
            W[k] = int(v)

        def calc(op):
            if op in W:
                return W[op]

            a, op, b = C[op]
            a = calc(a)
            b = calc(b)
            if op == "AND":
                return a & b
            elif op == "OR":
                return a | b
            elif op == "XOR":
                return a ^ b

        zs = "".join(str(calc(z)) for z in Z)
        p1 = int(zs[::-1], 2)

        def find(op, d=0):
            if op in W or d >= 3:
                return op

            a, op2, b = C[op]
            a = find(a, d + 1)
            b = find(b, d + 1)
            if op2 == "AND":
                return f"{op} = {{({a}) & ({b})}}"
            elif op2 == "OR":
                return f"{op} = {{({a}) | ({b})}}"
            elif op2 == "XOR":
                return f"{op} = {{({a}) ^ ({b})}}"

        def swap(x, y):
            temp = C[x]
            C[x] = C[y]
            C[y] = temp

        p2 = ""
        if not test:
            swap("z07", "bjm")
            swap("z13", "hsw")
            swap("z18", "skf")
            swap("nvr", "wkr")

            xs = "".join(str(W[x]) for x in W if x.startswith("x"))
            ys = "".join(str(W[x]) for x in W if x.startswith("y"))
            xy = int(xs[::-1], 2) + int(ys[::-1], 2)

            zs = "".join(str(calc(z)) for z in Z)
            assert xy == int(zs[::-1], 2)

            p2 = ",".join(
                sorted(["z07", "bjm", "z13", "hsw", "z18", "skf", "nvr", "wkr"])
            )

            # xys = bin(xy)[2:][::-1]
            # F = [(i, xy, z) for i, (xy, z) in enumerate(zip(xys, zs)) if xy != z]
            # print(xys)
            # print(zs)
            # print(F, len(F))
            #
            # for z in Z[:]:
            #     print(find(z))

        return p1, p2


# ------------------------------------------------------------------------------


if __name__ == "__main__":
    solver = Day24Solver()
    solver.run()


# ------------------------------------------------------------------------------
