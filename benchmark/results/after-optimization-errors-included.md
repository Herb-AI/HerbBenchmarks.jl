# Custom interpreter performance

- julia: 1.12.6 on arm64-apple-darwin24.0.0
- cpu: Apple M5 (4 threads)
- depths: 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
- programs/depth: 500, examples/program: 5, repetitions: 3
- sampler: side_slack=1, max_nodes=2000, WHILE nesting limit=1, seed=20261013
- error policy: allow

## Summary: program evaluations per second

| benchmark | depth 5 | depth 10 | depth 15 |
|---|---|---|---|
| DeepCoder_2016 | 155166 | 38841 | 21614 |
| PBE_BV_Track_2018 | 1326699 | 660369 | 432588 |
| PBE_SLIA_Track_2019 | 27660 | 15845 | 12307 |
| Robots_2020 | 1469267 | 10479 | 6055 |
| Pixels_2020 | 1461514 | 15895 | 8987 |
| String_transformations_2020 | 1060289 | 6974 | 5947 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 155.4 ms median over 5 problems, range 0.2-200.1 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.71 | 6.43 | 53.59 | 155166 | 775832 | 166.4 | 3.42 | 0.0 | 4.1% | 9% | 0% |
| 6 | 500 | 10 | 2.17 | 11.98 | 63.96 | 83393 | 416967 | 251.3 | 3.98 | 0.0 | 3.0% | 17% | 0% |
| 7 | 500 | 12 | 2.50 | 14.72 | 69.67 | 67864 | 339320 | 252.7 | 4.52 | 0.0 | 4.6% | 20% | 0% |
| 8 | 500 | 14 | 3.12 | 20.03 | 77.84 | 49876 | 249378 | 292.4 | 4.76 | 0.0 | 14.6% | 26% | 0% |
| 9 | 500 | 16 | 3.75 | 22.60 | 87.17 | 44223 | 221115 | 287.7 | 5.07 | 0.0 | 9.1% | 27% | 0% |
| 10 | 500 | 18 | 4.21 | 25.73 | 90.13 | 38841 | 194205 | 291.1 | 5.66 | 0.0 | 8.3% | 29% | 0% |
| 11 | 500 | 20 | 4.54 | 32.75 | 97.55 | 30520 | 152601 | 328.9 | 5.62 | 0.0 | 0.3% | 37% | 0% |
| 12 | 500 | 22 | 4.92 | 34.42 | 103.92 | 29039 | 145197 | 320.1 | 5.75 | 0.0 | 0.5% | 37% | 0% |
| 13 | 500 | 24 | 5.46 | 39.33 | 109.96 | 25415 | 127073 | 330.3 | 5.69 | 0.0 | 1.5% | 41% | 0% |
| 14 | 500 | 26 | 6.00 | 40.86 | 118.13 | 24464 | 122320 | 317.2 | 6.11 | 0.0 | 1.3% | 41% | 0% |
| 15 | 500 | 28 | 6.58 | 46.25 | 122.71 | 21614 | 108070 | 333.7 | 6.18 | 0.0 | 0.9% | 44% | 0% |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-29.7 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.71 | 0.74 | 1.17 | 1326699 | 6633493 | 17.3 | 0.12 | 0.0 | 5.7% | 0% | 0% |
| 6 | 500 | 11 | 0.88 | 0.90 | 1.38 | 1090843 | 5454216 | 16.6 | 0.12 | 0.0 | 9.5% | 0% | 0% |
| 7 | 500 | 13 | 1.12 | 1.19 | 1.92 | 829016 | 4145078 | 18.4 | 0.12 | 0.0 | 21.3% | 0% | 0% |
| 8 | 500 | 15 | 1.17 | 1.20 | 1.79 | 826807 | 4134035 | 16.3 | 0.12 | 0.0 | 27.5% | 0% | 0% |
| 9 | 500 | 17 | 1.38 | 1.40 | 2.04 | 708340 | 3541702 | 16.3 | 0.12 | 0.0 | 10.7% | 0% | 0% |
| 10 | 500 | 19 | 1.46 | 1.50 | 2.17 | 660369 | 3301843 | 15.9 | 0.12 | 0.0 | 28.4% | 0% | 0% |
| 11 | 500 | 21 | 1.67 | 1.70 | 2.38 | 583185 | 2915925 | 16.0 | 0.12 | 0.0 | 1.7% | 0% | 0% |
| 12 | 500 | 24 | 1.96 | 2.07 | 3.21 | 479125 | 2395623 | 17.6 | 0.12 | 0.0 | 23.8% | 0% | 0% |
| 13 | 500 | 25 | 2.00 | 2.07 | 3.12 | 479725 | 2398625 | 16.5 | 0.12 | 0.0 | 44.1% | 0% | 0% |
| 14 | 500 | 28 | 2.08 | 2.13 | 2.92 | 466732 | 2333661 | 15.5 | 0.12 | 0.0 | 19.3% | 0% | 0% |
| 15 | 500 | 30 | 2.25 | 2.30 | 3.04 | 432588 | 2162942 | 15.6 | 0.12 | 0.0 | 7.6% | 0% | 0% |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 66.7 ms median over 5 problems, range 63.9-71.0 ms
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 52.50 | 36.14 | 66.67 | 27660 | 138300 | 635.6 | 0.66 | 0.0 | 1.2% | 59% | 0% |
| 6 | 500 | 15 | 56.62 | 42.57 | 73.67 | 23480 | 117401 | 566.9 | 0.66 | 0.0 | 0.8% | 66% | 0% |
| 7 | 500 | 18 | 61.56 | 48.70 | 80.25 | 20526 | 102632 | 530.9 | 0.68 | 0.0 | 0.3% | 71% | 0% |
| 8 | 500 | 22 | 67.15 | 56.32 | 87.71 | 17750 | 88748 | 517.9 | 0.64 | 0.0 | 1.0% | 77% | 0% |
| 9 | 500 | 25 | 66.54 | 59.11 | 94.25 | 16913 | 84565 | 470.9 | 0.69 | 0.0 | 0.5% | 78% | 0% |
| 10 | 500 | 29 | 71.67 | 63.09 | 101.42 | 15845 | 79227 | 440.5 | 0.67 | 0.0 | 0.5% | 79% | 0% |
| 11 | 500 | 32 | 75.35 | 67.16 | 108.00 | 14887 | 74434 | 417.3 | 0.63 | 0.0 | 0.7% | 81% | 0% |
| 12 | 500 | 36 | 79.71 | 71.86 | 114.42 | 13912 | 69561 | 400.1 | 0.60 | 0.0 | 0.7% | 83% | 0% |
| 13 | 500 | 40 | 81.48 | 76.56 | 122.46 | 13059 | 65294 | 386.9 | 0.62 | 0.0 | 1.2% | 85% | 0% |
| 14 | 500 | 43 | 86.96 | 80.02 | 132.04 | 12494 | 62469 | 368.7 | 0.68 | 0.0 | 0.7% | 83% | 0% |
| 15 | 500 | 46 | 83.06 | 81.23 | 139.67 | 12307 | 61537 | 350.0 | 0.61 | 0.0 | 0.7% | 83% | 0% |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.62 | 0.67 | 0.88 | 1469267 | 7346337 | 19.4 | 0.66 | 0.0 | 11.3% | 0% | 0% |
| 6 | 500 | 10 | 0.83 | 0.85 | 1.00 | 1154698 | 5773490 | 17.3 | 0.66 | 0.0 | 2.0% | 0% | 0% |
| 7 | 500 | 11 | 1.12 | 27.80 | 152.58 | 35953 | 179766 | 492.7 | 0.66 | 0.0 | 0.6% | 0% | 40% |
| 8 | 500 | 15 | 1.42 | 49.90 | 296.13 | 20033 | 100166 | 678.1 | 0.66 | 0.0 | 0.3% | 0% | 45% |
| 9 | 500 | 18 | 1.54 | 69.44 | 439.54 | 14397 | 71985 | 778.9 | 0.66 | 0.0 | 0.4% | 0% | 48% |
| 10 | 500 | 20 | 1.79 | 95.41 | 507.80 | 10479 | 52395 | 953.9 | 0.66 | 0.0 | 0.6% | 0% | 65% |
| 11 | 500 | 23 | 1.73 | 90.95 | 514.14 | 10992 | 54962 | 778.5 | 0.66 | 0.0 | 0.7% | 0% | 71% |
| 12 | 500 | 27 | 1.92 | 121.33 | 654.67 | 8241 | 41204 | 915.1 | 0.66 | 0.0 | 0.4% | 0% | 71% |
| 13 | 500 | 29 | 1.83 | 119.00 | 648.76 | 8402 | 42012 | 823.2 | 0.66 | 0.0 | 0.2% | 0% | 79% |
| 14 | 500 | 33 | 1.96 | 143.88 | 767.34 | 6949 | 34746 | 877.5 | 0.66 | 0.0 | 0.2% | 0% | 84% |
| 15 | 500 | 36 | 1.96 | 165.13 | 857.04 | 6055 | 30276 | 922.1 | 0.66 | 0.0 | 0.2% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.10 | 2.4% | 199 | 68.18 | 97.6% |
| 8 | 273 | 1.36 | 1.5% | 227 | 108.28 | 98.5% |
| 9 | 260 | 1.49 | 1.1% | 240 | 143.06 | 98.9% |
| 10 | 174 | 1.64 | 0.6% | 326 | 145.46 | 99.4% |
| 11 | 143 | 1.75 | 0.6% | 357 | 126.69 | 99.4% |
| 12 | 144 | 1.88 | 0.4% | 356 | 169.65 | 99.5% |
| 13 | 103 | 1.84 | 0.3% | 397 | 149.39 | 99.7% |
| 14 | 81 | 2.02 | 0.2% | 419 | 171.31 | 99.8% |
| 15 | 74 | 2.07 | 0.2% | 426 | 193.46 | 99.8% |

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.62 | 0.67 | 0.75 | 1461514 | 7307570 | 19.5 | 0.45 | 0.0 | 10.0% | 0% | 0% |
| 6 | 500 | 10 | 0.79 | 0.84 | 1.08 | 1171037 | 5855185 | 17.1 | 0.45 | 0.0 | 13.3% | 0% | 0% |
| 7 | 500 | 11 | 0.96 | 15.41 | 101.88 | 64852 | 324260 | 273.2 | 0.45 | 0.0 | 0.5% | 0% | 40% |
| 8 | 500 | 15 | 1.08 | 36.22 | 200.34 | 27597 | 137984 | 492.3 | 0.45 | 0.0 | 0.6% | 0% | 45% |
| 9 | 500 | 18 | 1.25 | 49.02 | 295.09 | 20392 | 101960 | 549.9 | 0.45 | 0.0 | 0.2% | 0% | 48% |
| 10 | 500 | 20 | 1.38 | 62.90 | 313.97 | 15895 | 79473 | 628.9 | 0.45 | 0.0 | 0.5% | 0% | 65% |
| 11 | 500 | 23 | 1.33 | 69.28 | 353.89 | 14430 | 72150 | 593.1 | 0.45 | 0.0 | 0.4% | 0% | 71% |
| 12 | 500 | 27 | 1.50 | 86.58 | 441.25 | 11548 | 57740 | 653.1 | 0.45 | 0.0 | 0.5% | 0% | 71% |
| 13 | 500 | 29 | 1.42 | 84.55 | 454.23 | 11825 | 59126 | 584.9 | 0.45 | 0.0 | 0.1% | 0% | 79% |
| 14 | 500 | 33 | 1.58 | 107.13 | 508.38 | 9333 | 46663 | 653.4 | 0.45 | 0.0 | 0.0% | 0% | 84% |
| 15 | 500 | 36 | 1.54 | 111.26 | 581.13 | 8987 | 44933 | 621.3 | 0.45 | 0.0 | 0.1% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.02 | 4.0% | 199 | 37.16 | 95.9% |
| 8 | 273 | 1.14 | 1.7% | 227 | 78.41 | 98.2% |
| 9 | 260 | 1.35 | 1.4% | 240 | 100.66 | 98.5% |
| 10 | 174 | 1.43 | 0.8% | 326 | 95.71 | 99.2% |
| 11 | 143 | 1.41 | 0.6% | 357 | 96.47 | 99.4% |
| 12 | 144 | 1.51 | 0.5% | 356 | 120.99 | 99.5% |
| 13 | 103 | 1.55 | 0.4% | 397 | 106.08 | 99.6% |
| 14 | 81 | 1.80 | 0.3% | 419 | 127.50 | 99.7% |
| 15 | 74 | 1.62 | 0.2% | 426 | 130.30 | 99.8% |

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.92 | 0.93 | 1.12 | 1060289 | 5301447 | 26.9 | 0.93 | 0.0 | 7.8% | 0% | 0% |
| 6 | 500 | 10 | 1.29 | 1.31 | 1.58 | 753769 | 3768844 | 26.5 | 1.14 | 0.0 | 9.0% | 0% | 0% |
| 7 | 500 | 11 | 1.54 | 44.81 | 347.21 | 22307 | 111534 | 794.1 | 25.88 | 0.0 | 1.1% | 1% | 40% |
| 8 | 500 | 15 | 1.88 | 68.95 | 544.31 | 14500 | 72502 | 936.9 | 44.07 | 0.0 | 0.7% | 3% | 45% |
| 9 | 500 | 18 | 2.17 | 85.70 | 726.22 | 11666 | 58332 | 961.3 | 51.65 | 0.0 | 0.2% | 5% | 48% |
| 10 | 500 | 20 | 2.29 | 143.37 | 894.97 | 6974 | 34871 | 1433.3 | 53.35 | 0.0 | 0.3% | 5% | 65% |
| 11 | 500 | 23 | 2.42 | 139.25 | 967.15 | 7181 | 35903 | 1191.8 | 53.48 | 0.0 | 0.1% | 7% | 71% |
| 12 | 500 | 27 | 2.38 | 144.72 | 1044.25 | 6909 | 34546 | 1091.5 | 64.41 | 0.0 | 1.9% | 5% | 71% |
| 13 | 500 | 29 | 2.38 | 167.62 | 1077.63 | 5965 | 29827 | 1159.5 | 56.80 | 0.0 | 0.5% | 5% | 79% |
| 14 | 500 | 33 | 2.48 | 167.75 | 1134.23 | 5961 | 29803 | 1023.1 | 65.71 | 0.0 | 1.5% | 5% | 84% |
| 15 | 500 | 36 | 2.38 | 168.13 | 1214.01 | 5947 | 29735 | 938.9 | 63.21 | 0.0 | 0.3% | 8% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.64 | 2.2% | 199 | 110.11 | 97.8% |
| 8 | 273 | 1.98 | 1.6% | 227 | 149.48 | 98.4% |
| 9 | 260 | 2.28 | 1.4% | 240 | 176.07 | 98.6% |
| 10 | 174 | 2.34 | 0.6% | 326 | 218.64 | 99.4% |
| 11 | 143 | 2.47 | 0.5% | 357 | 194.04 | 99.5% |
| 12 | 144 | 2.54 | 0.5% | 356 | 202.23 | 99.5% |
| 13 | 103 | 2.66 | 0.3% | 397 | 210.42 | 99.7% |
| 14 | 81 | 2.77 | 0.3% | 419 | 199.65 | 99.7% |
| 15 | 74 | 2.83 | 0.2% | 426 | 196.85 | 99.7% |

## Reading the table

- `nodes` is the mean number of `RuleNode`s per sampled program; it grows with
  depth, so `ns/node` is the measure to compare across depths and benchmarks.
- `progs/s` counts one program evaluated on all its examples; `evals/s` counts
  program-example pairs.
- `err%` is the share of *sampled* programs that raised. Those are excluded from
  the timings under the default `:filter` policy, but the figure itself says how
  often a search over this grammar hits an exception.
- `rep±` is the spread between repetitions. Above ~10% treat the cell as noisy.
- `loop%` is the share of timed programs containing a `WHILE`. Those dominate
  the mean and `p95`, which is why `median` and `mean` diverge so far on the
  stateful benchmarks.
- The three-way comparison is informational, not a second verdict on the
  custom interpreter: `eval` pays full compiler latency every call because
  each sampled program is a structurally distinct `Expr` with no method
  cache to reuse, which is not what a real workload would do with this
  amount of code. `interpret` is the fair comparison (the generic,
  non-generated evaluator the custom interpreters replace), except that it
  cannot run a `WHILE` at all.

