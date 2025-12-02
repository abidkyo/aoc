<!-- ----------------------------------------------------------------------- -->

# Advent Of Code

| Year                                      | Language    | Repo                                      |
| ----------------------------------------- | ----------- | ----------------------------------------- |
| [AOC 2025](https://adventofcode.com/2025) | Zig         | This                                      |
| [AOC 2024](https://adventofcode.com/2024) | Python, Zig | This                                      |
| [AOC 2023](https://adventofcode.com/2023) | Python      | [aoc23](https://github.com/abidkyo/aoc23) |
| [AOC 2022](https://adventofcode.com/2022) | Python      | [aoc22](https://github.com/abidkyo/aoc22) |
| [AOC 2021](https://adventofcode.com/2021) |             |                                           |
| [AOC 2020](https://adventofcode.com/2020) |             |                                           |
| [AOC 2019](https://adventofcode.com/2019) |             |                                           |
| [AOC 2018](https://adventofcode.com/2018) |             |                                           |
| [AOC 2017](https://adventofcode.com/2017) |             |                                           |
| [AOC 2016](https://adventofcode.com/2016) | Zig         | This                                      |
| [AOC 2015](https://adventofcode.com/2015) | Python, C   | This                                      |

### Zig

```bash
zig build {YEAR}_{DAY}
zig build 2025_01
```

### Python

```bash
cd {YEAR} && python src/day{DAY}.py
cd 2024 && python src/day01.py
```

or

```bash
./aoc-util.sh -y{YEAR} -d{DAY} -r
./aoc-util.sh -y2015 -d1 -r
```

### C

```bash
mkdir build && cd build && cmake .. -GNinja

ninja RUN_AOC_{YEAR}_{DAY}
ninja RUN_AOC_2015_04
```

<!-- ----------------------------------------------------------------------- -->
