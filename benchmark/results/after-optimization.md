# Custom interpreter performance

- julia: 1.12.6 on arm64-apple-darwin24.0.0
- cpu: Apple M5 (4 threads)
- depths: 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
- programs/depth: 500, examples/program: 5, repetitions: 3
- sampler: side_slack=1, max_nodes=2000, WHILE nesting limit=1, seed=20261013
- error policy: filter

## Summary: program evaluations per second

| benchmark | depth 5 | depth 10 | depth 15 |
|---|---|---|---|
| DeepCoder_2016 | 609911 | 308761 | 202621 |
| PBE_BV_Track_2018 | 1319696 | 579944 | 422074 |
| PBE_SLIA_Track_2019 | 662191 | 452006 | 476537 |
| Robots_2020 | 1573356 | 9653 | 5809 |
| Pixels_2020 | 1366380 | 16122 | 9116 |
| String_transformations_2020 | 992255 | 7138 | 5797 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 159.9 ms median over 5 problems, range 0.2-241.4 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.50 | 1.63 | 2.21 | 609911 | 3049557 | 42.5 | 3.62 | 0.0 | 1.0% | 9% | 0% |
| 6 | 500 | 10 | 1.96 | 2.38 | 4.00 | 417082 | 2085409 | 49.8 | 4.51 | 0.0 | 70.4% | 17% | 0% |
| 7 | 500 | 12 | 2.29 | 2.33 | 3.25 | 426399 | 2131993 | 40.4 | 5.30 | 0.0 | 7.2% | 20% | 0% |
| 8 | 500 | 14 | 2.71 | 2.91 | 3.96 | 341929 | 1709645 | 42.9 | 5.85 | 0.0 | 30.8% | 25% | 0% |
| 9 | 500 | 16 | 2.83 | 2.96 | 4.00 | 335855 | 1679277 | 38.1 | 6.37 | 0.0 | 10.0% | 26% | 0% |
| 10 | 500 | 18 | 3.17 | 3.23 | 4.33 | 308761 | 1543806 | 37.0 | 7.09 | 0.0 | 4.7% | 29% | 0% |
| 11 | 500 | 20 | 3.50 | 3.55 | 4.75 | 280553 | 1402765 | 36.1 | 7.87 | 0.0 | 6.1% | 34% | 0% |
| 12 | 500 | 21 | 3.83 | 3.93 | 5.29 | 253450 | 1267249 | 36.7 | 7.95 | 0.0 | 4.2% | 37% | 0% |
| 13 | 500 | 24 | 4.00 | 4.12 | 5.42 | 242027 | 1210133 | 34.8 | 8.27 | 0.0 | 2.4% | 39% | 0% |
| 14 | 500 | 25 | 4.38 | 4.51 | 6.08 | 221033 | 1105163 | 35.6 | 8.73 | 0.0 | 11.1% | 42% | 0% |
| 15 | 500 | 28 | 4.83 | 4.92 | 6.42 | 202621 | 1013103 | 35.8 | 9.20 | 0.0 | 10.0% | 45% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 608.40 | 1.54 | 395x | 100 | 3.90 | 1.54 | 2.5x |
| 6 | 100 | 698.94 | 2.17 | 323x | 100 | 4.81 | 2.17 | 2.2x |
| 7 | 100 | 727.19 | 2.38 | 306x | 100 | 5.77 | 2.38 | 2.4x |
| 8 | 100 | 768.56 | 3.00 | 256x | 100 | 6.81 | 3.00 | 2.3x |
| 9 | 100 | 801.38 | 2.75 | 291x | 100 | 7.62 | 2.75 | 2.8x |
| 10 | 100 | 859.90 | 3.21 | 268x | 100 | 8.83 | 3.21 | 2.8x |
| 11 | 100 | 914.67 | 3.46 | 264x | 100 | 10.17 | 3.46 | 2.9x |
| 12 | 100 | 951.60 | 3.79 | 251x | 100 | 10.71 | 3.79 | 2.8x |
| 13 | 100 | 1002.83 | 3.92 | 256x | 100 | 11.75 | 3.92 | 3.0x |
| 14 | 100 | 1057.52 | 4.46 | 237x | 100 | 12.67 | 4.46 | 2.8x |
| 15 | 100 | 1098.35 | 4.79 | 229x | 100 | 13.96 | 4.79 | 2.9x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-29.5 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.71 | 0.74 | 1.17 | 1319696 | 6598482 | 17.4 | 0.12 | 0.0 | 2.9% | 0% | 0% |
| 6 | 500 | 11 | 1.00 | 1.09 | 1.75 | 906299 | 4531495 | 20.0 | 0.12 | 0.0 | 47.9% | 0% | 0% |
| 7 | 500 | 13 | 1.04 | 1.11 | 1.62 | 887902 | 4439512 | 17.2 | 0.12 | 0.0 | 7.4% | 0% | 0% |
| 8 | 500 | 15 | 1.25 | 1.31 | 2.00 | 755160 | 3775802 | 17.9 | 0.12 | 0.0 | 30.6% | 0% | 0% |
| 9 | 500 | 17 | 1.38 | 1.44 | 2.21 | 689272 | 3446362 | 16.7 | 0.12 | 0.0 | 34.2% | 0% | 0% |
| 10 | 500 | 19 | 1.62 | 1.71 | 2.54 | 579944 | 2899718 | 18.2 | 0.12 | 0.0 | 19.5% | 0% | 0% |
| 11 | 500 | 21 | 1.75 | 1.81 | 2.71 | 547462 | 2737310 | 17.0 | 0.12 | 0.0 | 8.4% | 0% | 0% |
| 12 | 500 | 24 | 1.79 | 1.80 | 2.54 | 551142 | 2755708 | 15.3 | 0.12 | 0.0 | 8.2% | 0% | 0% |
| 13 | 500 | 25 | 2.08 | 2.14 | 3.21 | 464558 | 2322790 | 17.0 | 0.12 | 0.0 | 20.6% | 0% | 0% |
| 14 | 500 | 28 | 2.21 | 2.26 | 3.12 | 439587 | 2197937 | 16.4 | 0.12 | 0.0 | 18.7% | 0% | 0% |
| 15 | 500 | 30 | 2.33 | 2.36 | 3.21 | 422074 | 2110372 | 16.0 | 0.12 | 0.0 | 12.4% | 0% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 531.00 | 0.71 | 749x | 100 | 4.27 | 0.71 | 6.0x |
| 6 | 100 | 596.85 | 1.02 | 585x | 100 | 4.62 | 1.02 | 4.5x |
| 7 | 100 | 629.38 | 1.04 | 605x | 100 | 5.42 | 1.04 | 5.2x |
| 8 | 100 | 672.90 | 1.17 | 577x | 100 | 5.94 | 1.17 | 5.1x |
| 9 | 100 | 746.21 | 1.21 | 617x | 100 | 7.12 | 1.21 | 5.9x |
| 10 | 100 | 796.83 | 1.58 | 503x | 100 | 7.88 | 1.58 | 5.0x |
| 11 | 100 | 836.04 | 1.62 | 514x | 100 | 8.79 | 1.62 | 5.4x |
| 12 | 100 | 886.79 | 1.58 | 560x | 100 | 9.12 | 1.58 | 5.8x |
| 13 | 100 | 937.23 | 1.83 | 511x | 100 | 10.50 | 1.83 | 5.7x |
| 14 | 100 | 1016.40 | 2.17 | 469x | 100 | 12.21 | 2.17 | 5.6x |
| 15 | 100 | 1055.67 | 2.17 | 487x | 100 | 12.38 | 2.17 | 5.7x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 66.4 ms median over 5 problems, range 63.3-71.1 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.33 | 1.50 | 2.71 | 662191 | 3310956 | 27.1 | 0.94 | 0.0 | 19.4% | 58% | 0% |
| 6 | 500 | 14 | 1.50 | 1.68 | 2.88 | 590958 | 2954792 | 23.5 | 0.93 | 0.0 | 11.9% | 66% | 0% |
| 7 | 500 | 18 | 1.71 | 1.79 | 3.00 | 555564 | 2777821 | 19.8 | 0.97 | 0.0 | 3.6% | 70% | 0% |
| 8 | 500 | 22 | 1.88 | 1.96 | 3.58 | 507593 | 2537964 | 18.2 | 1.01 | 0.0 | 7.4% | 75% | 0% |
| 9 | 500 | 25 | 2.00 | 2.10 | 3.79 | 471840 | 2359201 | 17.2 | 1.07 | 0.0 | 4.0% | 79% | 0% |
| 10 | 500 | 29 | 1.96 | 2.20 | 4.50 | 452006 | 2260029 | 15.5 | 1.05 | 0.0 | 15.3% | 80% | 0% |
| 11 | 500 | 32 | 1.75 | 2.16 | 4.58 | 460664 | 2303322 | 13.5 | 1.03 | 0.0 | 19.5% | 82% | 0% |
| 12 | 500 | 36 | 1.67 | 2.03 | 4.67 | 488374 | 2441870 | 11.5 | 1.00 | 0.0 | 10.7% | 84% | 0% |
| 13 | 500 | 39 | 1.46 | 1.96 | 4.50 | 506614 | 2533070 | 10.1 | 0.93 | 0.0 | 9.7% | 85% | 0% |
| 14 | 500 | 44 | 1.67 | 2.21 | 5.25 | 449887 | 2249437 | 10.2 | 0.97 | 0.0 | 21.3% | 84% | 0% |
| 15 | 500 | 47 | 1.58 | 2.08 | 5.38 | 476537 | 2382686 | 9.0 | 1.04 | 0.0 | 1.3% | 83% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 529.73 | 1.29 | 410x | 100 | 3.96 | 1.29 | 3.1x |
| 6 | 100 | 604.17 | 1.50 | 403x | 100 | 4.92 | 1.50 | 3.3x |
| 7 | 100 | 676.71 | 1.67 | 406x | 100 | 6.00 | 1.67 | 3.6x |
| 8 | 100 | 744.44 | 1.71 | 436x | 100 | 6.56 | 1.71 | 3.8x |
| 9 | 100 | 832.48 | 2.17 | 384x | 100 | 7.77 | 2.17 | 3.6x |
| 10 | 100 | 883.38 | 2.10 | 420x | 100 | 8.58 | 2.10 | 4.1x |
| 11 | 100 | 968.35 | 2.00 | 484x | 100 | 9.08 | 2.00 | 4.5x |
| 12 | 100 | 1060.33 | 1.33 | 795x | 100 | 10.50 | 1.33 | 7.9x |
| 13 | 100 | 1124.02 | 1.46 | 771x | 100 | 10.65 | 1.46 | 7.3x |
| 14 | 100 | 1177.23 | 1.50 | 785x | 100 | 11.75 | 1.50 | 7.8x |
| 15 | 100 | 1270.29 | 1.44 | 884x | 100 | 12.83 | 1.44 | 8.9x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.58 | 0.62 | 0.79 | 1573356 | 7866781 | 18.2 | 0.66 | 0.0 | 8.4% | 0% | 0% |
| 6 | 500 | 10 | 0.83 | 0.91 | 1.21 | 1078393 | 5391963 | 18.5 | 0.66 | 0.0 | 29.4% | 0% | 0% |
| 7 | 500 | 11 | 1.12 | 33.20 | 184.75 | 30104 | 150520 | 588.5 | 0.66 | 0.0 | 0.8% | 0% | 40% |
| 8 | 500 | 15 | 1.42 | 59.01 | 354.17 | 16940 | 84701 | 801.9 | 0.66 | 0.0 | 1.3% | 0% | 45% |
| 9 | 500 | 18 | 1.62 | 77.96 | 500.80 | 12825 | 64125 | 874.4 | 0.66 | 0.0 | 0.6% | 0% | 48% |
| 10 | 500 | 20 | 1.83 | 103.58 | 573.54 | 9653 | 48264 | 1035.6 | 0.66 | 0.0 | 0.2% | 0% | 65% |
| 11 | 500 | 23 | 1.79 | 96.14 | 553.67 | 10400 | 52000 | 822.9 | 0.66 | 0.0 | 0.1% | 0% | 71% |
| 12 | 500 | 27 | 2.08 | 131.31 | 714.21 | 7614 | 38071 | 990.4 | 0.66 | 0.0 | 6.3% | 0% | 71% |
| 13 | 500 | 29 | 2.00 | 124.68 | 691.76 | 8019 | 40097 | 862.5 | 0.66 | 0.0 | 0.2% | 0% | 79% |
| 14 | 500 | 33 | 2.08 | 150.86 | 804.06 | 6628 | 33139 | 920.1 | 0.66 | 0.0 | 0.3% | 0% | 84% |
| 15 | 500 | 36 | 1.88 | 172.12 | 892.63 | 5809 | 29047 | 961.1 | 0.66 | 0.0 | 0.4% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.13 | 2.0% | 199 | 81.72 | 97.9% |
| 8 | 273 | 1.37 | 1.3% | 227 | 128.34 | 98.7% |
| 9 | 260 | 1.58 | 1.1% | 240 | 160.69 | 98.9% |
| 10 | 174 | 1.73 | 0.6% | 326 | 157.94 | 99.4% |
| 11 | 143 | 1.76 | 0.5% | 357 | 133.94 | 99.5% |
| 12 | 144 | 2.04 | 0.4% | 356 | 183.60 | 99.5% |
| 13 | 103 | 1.96 | 0.3% | 397 | 156.52 | 99.7% |
| 14 | 81 | 2.09 | 0.2% | 419 | 179.63 | 99.8% |
| 15 | 74 | 2.02 | 0.2% | 426 | 201.67 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.38 | 0.62 | 690x | 100 | 1.92 | 0.62 | 3.1x |
| 6 | 100 | 505.42 | 0.88 | 578x | 100 | 2.62 | 0.88 | 3.0x |
| 7 | 100 | 604.87 | 1.17 | 519x | 62 | 2.65 | 1.12 | 2.4x |
| 8 | 100 | 783.71 | 1.31 | 597x | 57 | 3.21 | 1.25 | 2.6x |
| 9 | 100 | 945.50 | 1.67 | 567x | 51 | 3.88 | 1.54 | 2.5x |
| 10 | 100 | 1175.17 | 1.71 | 688x | 40 | 3.90 | 1.58 | 2.5x |
| 11 | 100 | 1339.65 | 1.58 | 846x | 24 | 4.75 | 1.67 | 2.9x |
| 12 | 100 | 1426.73 | 1.79 | 796x | 28 | 5.35 | 1.67 | 3.2x |
| 13 | 100 | 1504.44 | 1.73 | 870x | 22 | 5.21 | 1.71 | 3.0x |
| 14 | 100 | 1882.15 | 2.23 | 844x | 15 | 5.46 | 1.67 | 3.3x |
| 15 | 100 | 1928.04 | 2.31 | 834x | 22 | 6.44 | 2.00 | 3.2x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.67 | 0.72 | 1.00 | 1366380 | 6831902 | 20.9 | 0.45 | 0.0 | 24.3% | 0% | 0% |
| 6 | 500 | 10 | 0.79 | 0.82 | 1.00 | 1205867 | 6029336 | 16.6 | 0.45 | 0.0 | 5.6% | 0% | 0% |
| 7 | 500 | 11 | 0.92 | 15.08 | 99.79 | 66231 | 331155 | 267.5 | 0.45 | 0.0 | 1.3% | 0% | 40% |
| 8 | 500 | 15 | 1.08 | 35.38 | 195.75 | 28255 | 141276 | 480.8 | 0.45 | 0.0 | 0.5% | 0% | 45% |
| 9 | 500 | 18 | 1.23 | 47.62 | 288.04 | 20993 | 104965 | 534.2 | 0.45 | 0.0 | 0.8% | 0% | 48% |
| 10 | 500 | 20 | 1.33 | 62.01 | 308.45 | 16122 | 80611 | 620.0 | 0.45 | 0.0 | 0.5% | 0% | 65% |
| 11 | 500 | 23 | 1.33 | 68.44 | 349.75 | 14608 | 73042 | 585.8 | 0.45 | 0.0 | 0.1% | 0% | 71% |
| 12 | 500 | 27 | 1.79 | 90.69 | 447.26 | 11023 | 55117 | 684.1 | 0.45 | 0.0 | 8.6% | 0% | 71% |
| 13 | 500 | 29 | 1.42 | 83.23 | 444.50 | 12013 | 60063 | 575.8 | 0.45 | 0.0 | 0.4% | 0% | 79% |
| 14 | 500 | 33 | 1.42 | 105.66 | 510.79 | 9463 | 47314 | 644.4 | 0.45 | 0.0 | 0.0% | 0% | 84% |
| 15 | 500 | 36 | 1.50 | 109.69 | 574.17 | 9116 | 45578 | 612.5 | 0.45 | 0.0 | 0.2% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.99 | 3.9% | 199 | 36.41 | 96.0% |
| 8 | 273 | 1.12 | 1.7% | 227 | 76.58 | 98.2% |
| 9 | 260 | 1.28 | 1.4% | 240 | 97.83 | 98.6% |
| 10 | 174 | 1.36 | 0.8% | 326 | 94.38 | 99.2% |
| 11 | 143 | 1.45 | 0.6% | 357 | 95.27 | 99.4% |
| 12 | 144 | 1.95 | 0.6% | 356 | 126.58 | 99.4% |
| 13 | 103 | 1.58 | 0.4% | 397 | 104.42 | 99.6% |
| 14 | 81 | 1.62 | 0.2% | 419 | 125.77 | 99.7% |
| 15 | 74 | 1.58 | 0.2% | 426 | 128.47 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 432.31 | 0.71 | 610x | 100 | 2.00 | 0.71 | 2.8x |
| 6 | 100 | 506.50 | 0.79 | 640x | 100 | 2.71 | 0.79 | 3.4x |
| 7 | 100 | 658.54 | 0.92 | 718x | 62 | 2.65 | 0.92 | 2.9x |
| 8 | 100 | 822.12 | 1.12 | 731x | 57 | 2.92 | 1.12 | 2.6x |
| 9 | 100 | 1082.65 | 1.17 | 928x | 51 | 3.62 | 1.25 | 2.9x |
| 10 | 100 | 12383.21 | 1.44 | 8614x | 40 | 3.75 | 1.33 | 2.8x |
| 11 | 100 | 15935.25 | 1.21 | 13191x | 24 | 4.23 | 1.25 | 3.4x |
| 12 | 100 | 17294.67 | 1.77 | 9768x | 28 | 4.38 | 1.56 | 2.8x |
| 13 | 100 | 18241.60 | 1.33 | 13685x | 22 | 4.79 | 1.42 | 3.4x |
| 14 | 100 | 20424.06 | 1.54 | 13249x | 15 | 6.96 | 1.75 | 4.0x |
| 15 | 100 | 20995.27 | 1.54 | 13616x | 22 | 5.25 | 1.31 | 4.0x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.96 | 0.99 | 1.17 | 992255 | 4961276 | 28.8 | 0.93 | 0.0 | 6.5% | 0% | 0% |
| 6 | 500 | 10 | 1.29 | 1.34 | 1.58 | 740512 | 3702561 | 27.0 | 1.14 | 0.0 | 7.8% | 0% | 0% |
| 7 | 500 | 11 | 1.54 | 43.93 | 348.35 | 22753 | 113765 | 776.9 | 26.50 | 0.0 | 1.0% | 1% | 39% |
| 8 | 500 | 15 | 1.83 | 66.83 | 547.17 | 14959 | 74797 | 904.0 | 44.08 | 0.0 | 0.8% | 3% | 43% |
| 9 | 500 | 18 | 2.12 | 81.36 | 732.59 | 12289 | 61445 | 906.0 | 51.66 | 0.0 | 0.9% | 5% | 46% |
| 10 | 500 | 20 | 2.25 | 140.08 | 890.17 | 7138 | 35689 | 1396.1 | 55.55 | 0.0 | 1.1% | 5% | 63% |
| 11 | 500 | 23 | 2.29 | 144.87 | 992.01 | 6902 | 34509 | 1238.2 | 60.98 | 0.0 | 0.4% | 7% | 69% |
| 12 | 500 | 27 | 2.38 | 157.24 | 1073.89 | 6359 | 31794 | 1185.5 | 71.54 | 0.0 | 3.0% | 5% | 71% |
| 13 | 500 | 29 | 2.33 | 168.72 | 1100.22 | 5926 | 29632 | 1164.1 | 61.49 | 0.0 | 1.6% | 5% | 78% |
| 14 | 500 | 33 | 2.29 | 166.77 | 1157.19 | 5996 | 29978 | 1016.9 | 70.08 | 0.0 | 0.5% | 5% | 83% |
| 15 | 500 | 36 | 2.19 | 172.48 | 1259.60 | 5797 | 28986 | 963.6 | 68.84 | 0.0 | 1.8% | 8% | 84% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.61 | 2.2% | 196 | 109.58 | 97.7% |
| 8 | 285 | 1.98 | 1.7% | 215 | 152.80 | 98.3% |
| 9 | 272 | 2.30 | 1.5% | 228 | 175.67 | 98.4% |
| 10 | 184 | 2.34 | 0.6% | 316 | 220.29 | 99.4% |
| 11 | 154 | 2.49 | 0.5% | 346 | 208.25 | 99.5% |
| 12 | 146 | 2.56 | 0.5% | 354 | 221.04 | 99.5% |
| 13 | 109 | 2.70 | 0.3% | 391 | 215.00 | 99.6% |
| 14 | 86 | 2.71 | 0.3% | 414 | 200.85 | 99.7% |
| 15 | 78 | 2.87 | 0.3% | 422 | 203.83 | 99.7% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.58 | 1.00 | 432x | 100 | 2.00 | 1.00 | 2.0x |
| 6 | 100 | 507.02 | 1.29 | 392x | 100 | 2.79 | 1.29 | 2.2x |
| 7 | 100 | 625.33 | 1.33 | 469x | 62 | 2.83 | 1.46 | 1.9x |
| 8 | 100 | 810.17 | 1.88 | 432x | 58 | 3.35 | 2.00 | 1.7x |
| 9 | 100 | 1007.29 | 2.08 | 484x | 52 | 3.88 | 2.12 | 1.8x |
| 10 | 100 | 4894.25 | 2.00 | 2447x | 44 | 3.96 | 1.96 | 2.0x |
| 11 | 100 | 12418.48 | 2.42 | 5139x | 25 | 4.54 | 2.38 | 1.9x |
| 12 | 100 | 10530.62 | 1.98 | 5320x | 30 | 4.81 | 2.06 | 2.3x |
| 13 | 100 | 13204.00 | 2.21 | 5980x | 22 | 5.62 | 2.42 | 2.3x |
| 14 | 100 | 13262.81 | 2.12 | 6241x | 16 | 5.88 | 2.29 | 2.6x |
| 15 | 100 | 14038.98 | 2.50 | 5616x | 24 | 5.65 | 2.56 | 2.2x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

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

