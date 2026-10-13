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
| DeepCoder_2016 | 156614 | 40141 | 20938 |
| PBE_BV_Track_2018 | 1309139 | 664219 | 395992 |
| PBE_SLIA_Track_2019 | 26010 | 14561 | 11670 |
| Robots_2020 | 1754300 | 10469 | 6109 |
| Pixels_2020 | 2069202 | 16372 | 9230 |
| String_transformations_2020 | 1127362 | 7066 | 5949 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 148.3 ms median over 5 problems, range 0.2-201.5 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.50 | 6.37 | 55.29 | 156614 | 783068 | 164.9 | 3.19 | 0.0 | 1.1% | 9% | 0% |
| 6 | 500 | 10 | 1.96 | 12.10 | 66.21 | 82545 | 412725 | 253.9 | 3.75 | 0.0 | 0.2% | 17% | 0% |
| 7 | 500 | 12 | 2.33 | 15.37 | 74.31 | 64997 | 324983 | 263.9 | 4.29 | 0.0 | 1.5% | 20% | 0% |
| 8 | 500 | 14 | 2.88 | 20.32 | 81.83 | 49168 | 245841 | 296.6 | 4.52 | 0.0 | 1.7% | 26% | 0% |
| 9 | 500 | 16 | 3.25 | 22.19 | 88.46 | 45043 | 225217 | 282.5 | 4.84 | 0.0 | 1.8% | 27% | 0% |
| 10 | 500 | 18 | 3.79 | 24.90 | 90.47 | 40141 | 200704 | 281.7 | 5.43 | 0.0 | 5.9% | 29% | 0% |
| 11 | 500 | 20 | 4.46 | 33.60 | 102.09 | 29751 | 148755 | 337.4 | 5.39 | 0.0 | 4.4% | 37% | 0% |
| 12 | 500 | 22 | 4.73 | 35.84 | 109.80 | 27887 | 139434 | 333.3 | 5.51 | 0.0 | 2.6% | 37% | 0% |
| 13 | 500 | 24 | 5.17 | 40.73 | 116.42 | 24541 | 122703 | 342.0 | 5.46 | 0.0 | 1.7% | 41% | 0% |
| 14 | 500 | 26 | 5.71 | 42.47 | 123.92 | 23539 | 117696 | 329.7 | 5.87 | 0.0 | 5.0% | 41% | 0% |
| 15 | 500 | 28 | 6.38 | 47.74 | 129.76 | 20938 | 104688 | 344.4 | 5.94 | 0.0 | 3.0% | 44% | 0% |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-30.8 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.71 | 0.75 | 1.17 | 1309139 | 6545696 | 17.5 | 0.12 | 0.0 | 6.3% | 0% | 0% |
| 6 | 500 | 11 | 0.83 | 0.87 | 1.33 | 1127856 | 5639280 | 16.0 | 0.12 | 0.0 | 3.3% | 0% | 0% |
| 7 | 500 | 13 | 1.08 | 1.16 | 1.83 | 849457 | 4247287 | 18.0 | 0.12 | 0.0 | 30.5% | 0% | 0% |
| 8 | 500 | 15 | 1.12 | 1.17 | 1.71 | 846064 | 4230319 | 15.9 | 0.12 | 0.0 | 11.8% | 0% | 0% |
| 9 | 500 | 17 | 1.42 | 1.46 | 2.29 | 679720 | 3398600 | 16.9 | 0.12 | 0.0 | 13.8% | 0% | 0% |
| 10 | 500 | 19 | 1.46 | 1.49 | 2.17 | 664219 | 3321094 | 15.8 | 0.12 | 0.0 | 20.0% | 0% | 0% |
| 11 | 500 | 21 | 1.67 | 1.68 | 2.33 | 589787 | 2948934 | 15.8 | 0.12 | 0.0 | 1.7% | 0% | 0% |
| 12 | 500 | 24 | 1.83 | 1.91 | 2.67 | 519968 | 2599842 | 16.3 | 0.12 | 0.0 | 15.3% | 0% | 0% |
| 13 | 500 | 25 | 1.96 | 2.00 | 2.83 | 496627 | 2483135 | 15.9 | 0.12 | 0.0 | 31.3% | 0% | 0% |
| 14 | 500 | 28 | 2.12 | 2.16 | 3.00 | 460841 | 2304206 | 15.7 | 0.12 | 0.0 | 24.6% | 0% | 0% |
| 15 | 500 | 30 | 2.38 | 2.51 | 3.71 | 395992 | 1979958 | 17.1 | 0.12 | 0.0 | 26.0% | 0% | 0% |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 65.2 ms median over 5 problems, range 62.3-69.6 ms
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 55.38 | 38.43 | 72.21 | 26010 | 130048 | 675.9 | 0.45 | 0.0 | 3.7% | 59% | 0% |
| 6 | 500 | 15 | 59.92 | 44.89 | 79.34 | 22267 | 111336 | 597.8 | 0.45 | 0.0 | 1.5% | 66% | 0% |
| 7 | 500 | 18 | 64.67 | 51.72 | 87.00 | 19329 | 96644 | 563.8 | 0.46 | 0.0 | 2.0% | 71% | 0% |
| 8 | 500 | 22 | 72.10 | 60.40 | 95.54 | 16552 | 82761 | 555.3 | 0.42 | 0.0 | 0.5% | 77% | 0% |
| 9 | 500 | 25 | 71.40 | 63.83 | 103.46 | 15661 | 78306 | 508.6 | 0.47 | 0.0 | 2.4% | 78% | 0% |
| 10 | 500 | 29 | 77.94 | 68.66 | 111.83 | 14561 | 72804 | 479.3 | 0.45 | 0.0 | 4.7% | 79% | 0% |
| 11 | 500 | 32 | 79.83 | 71.10 | 116.75 | 14062 | 70308 | 441.8 | 0.41 | 0.0 | 1.9% | 81% | 0% |
| 12 | 500 | 36 | 84.58 | 76.29 | 123.34 | 13104 | 65521 | 424.8 | 0.38 | 0.0 | 1.3% | 83% | 0% |
| 13 | 500 | 40 | 85.96 | 81.48 | 132.38 | 12270 | 61350 | 411.8 | 0.40 | 0.0 | 2.2% | 85% | 0% |
| 14 | 500 | 43 | 90.90 | 83.70 | 140.38 | 11945 | 59725 | 385.6 | 0.45 | 0.0 | 0.9% | 83% | 0% |
| 15 | 500 | 46 | 86.38 | 85.67 | 148.34 | 11670 | 58352 | 369.1 | 0.38 | 0.0 | 0.5% | 83% | 0% |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.54 | 0.56 | 0.75 | 1754300 | 8771499 | 16.3 | 0.36 | 0.0 | 7.2% | 0% | 0% |
| 6 | 500 | 10 | 0.75 | 0.75 | 0.96 | 1301378 | 6506892 | 15.4 | 0.36 | 0.0 | 10.9% | 0% | 0% |
| 7 | 500 | 11 | 1.12 | 29.66 | 162.21 | 33694 | 168469 | 525.8 | 0.36 | 0.0 | 3.4% | 0% | 40% |
| 8 | 500 | 15 | 1.42 | 49.79 | 294.17 | 20077 | 100387 | 676.6 | 0.36 | 0.0 | 1.0% | 0% | 45% |
| 9 | 500 | 18 | 1.42 | 68.40 | 432.92 | 14617 | 73085 | 767.2 | 0.36 | 0.0 | 0.6% | 0% | 48% |
| 10 | 500 | 20 | 1.71 | 95.50 | 511.40 | 10469 | 52345 | 954.8 | 0.36 | 0.0 | 1.0% | 0% | 65% |
| 11 | 500 | 23 | 1.54 | 90.55 | 529.11 | 11041 | 55207 | 775.1 | 0.36 | 0.0 | 0.1% | 0% | 71% |
| 12 | 500 | 27 | 1.67 | 120.73 | 663.50 | 8282 | 41408 | 910.6 | 0.36 | 0.0 | 0.2% | 0% | 71% |
| 13 | 500 | 29 | 1.62 | 118.02 | 635.67 | 8472 | 42361 | 816.4 | 0.36 | 0.0 | 0.1% | 0% | 79% |
| 14 | 500 | 33 | 1.79 | 142.56 | 772.06 | 7014 | 35069 | 869.4 | 0.36 | 0.0 | 0.8% | 0% | 84% |
| 15 | 500 | 36 | 1.75 | 163.68 | 848.06 | 6109 | 30544 | 914.0 | 0.36 | 0.0 | 0.2% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.18 | 2.4% | 199 | 72.75 | 97.6% |
| 8 | 273 | 1.39 | 1.5% | 227 | 108.00 | 98.4% |
| 9 | 260 | 1.39 | 1.1% | 240 | 140.99 | 98.9% |
| 10 | 174 | 1.58 | 0.6% | 326 | 145.64 | 99.4% |
| 11 | 143 | 1.51 | 0.5% | 357 | 126.22 | 99.5% |
| 12 | 144 | 1.61 | 0.4% | 356 | 168.92 | 99.6% |
| 13 | 103 | 1.60 | 0.3% | 397 | 148.22 | 99.7% |
| 14 | 81 | 1.82 | 0.2% | 419 | 169.77 | 99.8% |
| 15 | 74 | 1.82 | 0.2% | 426 | 191.80 | 99.8% |

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.47 | 0.62 | 2069202 | 10346012 | 13.8 | 0.16 | 0.0 | 6.8% | 0% | 0% |
| 6 | 500 | 10 | 0.62 | 0.62 | 0.79 | 1581653 | 7908264 | 12.6 | 0.16 | 0.0 | 2.4% | 0% | 0% |
| 7 | 500 | 11 | 0.79 | 14.67 | 97.62 | 68118 | 340589 | 260.1 | 0.16 | 0.0 | 0.4% | 0% | 40% |
| 8 | 500 | 15 | 0.92 | 34.71 | 192.38 | 28801 | 144005 | 471.7 | 0.16 | 0.0 | 0.6% | 0% | 45% |
| 9 | 500 | 18 | 1.04 | 47.24 | 285.67 | 21163 | 105815 | 529.9 | 0.16 | 0.0 | 0.3% | 0% | 48% |
| 10 | 500 | 20 | 1.12 | 61.06 | 303.87 | 16372 | 81862 | 610.5 | 0.16 | 0.0 | 0.2% | 0% | 65% |
| 11 | 500 | 23 | 1.21 | 67.34 | 340.75 | 14846 | 74232 | 576.4 | 0.16 | 0.0 | 0.1% | 0% | 71% |
| 12 | 500 | 27 | 1.21 | 83.82 | 428.92 | 11929 | 59643 | 632.2 | 0.16 | 0.0 | 0.2% | 0% | 71% |
| 13 | 500 | 29 | 1.17 | 82.13 | 438.32 | 12174 | 60868 | 568.2 | 0.16 | 0.0 | 0.3% | 0% | 79% |
| 14 | 500 | 33 | 1.25 | 104.37 | 500.12 | 9580 | 47898 | 636.6 | 0.16 | 0.0 | 0.1% | 0% | 84% |
| 15 | 500 | 36 | 1.29 | 108.33 | 567.43 | 9230 | 46149 | 604.9 | 0.16 | 0.0 | 0.2% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.83 | 3.4% | 199 | 35.59 | 96.5% |
| 8 | 273 | 0.94 | 1.5% | 227 | 75.32 | 98.5% |
| 9 | 260 | 1.06 | 1.2% | 240 | 97.26 | 98.8% |
| 10 | 174 | 1.13 | 0.6% | 326 | 93.05 | 99.3% |
| 11 | 143 | 1.26 | 0.5% | 357 | 93.81 | 99.4% |
| 12 | 144 | 1.24 | 0.4% | 356 | 117.22 | 99.6% |
| 13 | 103 | 1.26 | 0.3% | 397 | 103.11 | 99.7% |
| 14 | 81 | 1.45 | 0.2% | 419 | 124.27 | 99.8% |
| 15 | 74 | 1.33 | 0.2% | 426 | 126.92 | 99.8% |

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.83 | 0.87 | 1.04 | 1127362 | 5636809 | 25.3 | 0.79 | 0.0 | 8.4% | 0% | 0% |
| 6 | 500 | 10 | 1.21 | 1.23 | 1.50 | 803230 | 4016152 | 24.9 | 1.00 | 0.0 | 3.9% | 0% | 0% |
| 7 | 500 | 11 | 1.42 | 42.57 | 336.80 | 23482 | 117410 | 754.4 | 25.74 | 0.0 | 0.8% | 1% | 40% |
| 8 | 500 | 15 | 1.67 | 68.13 | 540.06 | 14675 | 73374 | 925.7 | 43.92 | 0.0 | 0.6% | 3% | 45% |
| 9 | 500 | 18 | 2.00 | 86.22 | 741.77 | 11596 | 57978 | 967.1 | 51.50 | 0.0 | 1.5% | 5% | 48% |
| 10 | 500 | 20 | 2.15 | 141.51 | 877.29 | 7066 | 35328 | 1414.7 | 53.20 | 0.0 | 0.7% | 5% | 65% |
| 11 | 500 | 23 | 2.17 | 137.73 | 961.65 | 7260 | 36299 | 1178.8 | 53.33 | 0.0 | 0.5% | 7% | 71% |
| 12 | 500 | 27 | 2.12 | 143.33 | 1049.85 | 6976 | 34881 | 1081.0 | 64.26 | 0.0 | 0.2% | 5% | 71% |
| 13 | 500 | 29 | 2.19 | 167.06 | 1070.83 | 5985 | 29926 | 1155.7 | 56.65 | 0.0 | 0.4% | 5% | 79% |
| 14 | 500 | 33 | 2.17 | 166.34 | 1125.85 | 6011 | 30055 | 1014.5 | 65.57 | 0.0 | 0.6% | 5% | 84% |
| 15 | 500 | 36 | 2.04 | 168.09 | 1229.12 | 5949 | 29744 | 938.6 | 63.06 | 0.0 | 0.5% | 8% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.48 | 2.1% | 199 | 104.72 | 97.9% |
| 8 | 273 | 1.81 | 1.4% | 227 | 147.88 | 98.5% |
| 9 | 260 | 2.04 | 1.2% | 240 | 177.42 | 98.7% |
| 10 | 174 | 2.13 | 0.5% | 326 | 215.91 | 99.5% |
| 11 | 143 | 2.23 | 0.5% | 357 | 192.00 | 99.5% |
| 12 | 144 | 2.29 | 0.5% | 356 | 200.38 | 99.5% |
| 13 | 103 | 2.42 | 0.3% | 397 | 209.78 | 99.7% |
| 14 | 81 | 2.51 | 0.2% | 419 | 198.02 | 99.7% |
| 15 | 74 | 2.56 | 0.2% | 426 | 196.84 | 99.8% |

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

