# Custom interpreter performance

- julia: 1.12.6 on arm64-apple-darwin24.0.0
- cpu: Apple M5 (4 threads)
- depths: 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
- programs/depth: 500, examples/program: 5, repetitions: 5
- sampler: side_slack=1, max_nodes=2000, WHILE nesting limit=1, seed=20261013
- error policy: filter

## Summary: program evaluations per second

| benchmark | depth 5 | depth 10 | depth 15 |
|---|---|---|---|
| DeepCoder_2016 | 648368 | 300582 | 200348 |
| PBE_BV_Track_2018 | 1304233 | 662669 | 374343 |
| PBE_SLIA_Track_2019 | 665115 | 475741 | 482998 |
| Robots_2020 | 1769025 | 10369 | 5995 |
| Pixels_2020 | 1848030 | 16678 | 9304 |
| String_transformations_2020 | 1088514 | 7028 | 5808 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 146.4 ms median over 5 problems, range 0.2-213.8 ms
- discarded 1 of 7948 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.46 | 1.53 | 2.25 | 648368 | 3241842 | 39.9 | 3.39 | 0.0 | 23.1% | 9% | 0% |
| 6 | 500 | 10 | 1.67 | 1.73 | 2.50 | 573679 | 2868397 | 36.2 | 4.27 | 0.0 | 4.2% | 17% | 0% |
| 7 | 500 | 12 | 2.08 | 2.17 | 3.04 | 458159 | 2290793 | 37.6 | 5.06 | 0.0 | 13.2% | 20% | 0% |
| 8 | 500 | 14 | 2.50 | 2.62 | 3.67 | 379629 | 1898146 | 38.6 | 5.61 | 0.0 | 18.0% | 25% | 0% |
| 9 | 500 | 16 | 2.75 | 2.81 | 3.83 | 353941 | 1769703 | 36.2 | 6.13 | 0.0 | 3.4% | 26% | 0% |
| 10 | 500 | 18 | 3.21 | 3.31 | 4.50 | 300582 | 1502908 | 38.0 | 6.86 | 0.0 | 9.3% | 29% | 0% |
| 11 | 500 | 20 | 3.54 | 3.65 | 5.04 | 272768 | 1363841 | 37.1 | 7.64 | 0.0 | 14.2% | 34% | 0% |
| 12 | 500 | 21 | 3.71 | 3.79 | 5.17 | 262740 | 1313698 | 35.4 | 7.72 | 0.0 | 12.5% | 37% | 0% |
| 13 | 500 | 24 | 4.12 | 4.21 | 5.71 | 236754 | 1183768 | 35.6 | 8.04 | 0.0 | 8.6% | 39% | 0% |
| 14 | 500 | 25 | 4.50 | 4.64 | 6.25 | 214844 | 1074218 | 36.6 | 8.49 | 0.0 | 16.8% | 42% | 0% |
| 15 | 500 | 28 | 4.88 | 4.98 | 6.67 | 200348 | 1001740 | 36.2 | 8.96 | 0.0 | 12.4% | 45% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 612.69 | 1.42 | 432x | 100 | 3.96 | 1.42 | 2.8x |
| 6 | 100 | 660.35 | 1.67 | 396x | 100 | 4.67 | 1.67 | 2.8x |
| 7 | 100 | 721.73 | 2.17 | 333x | 100 | 6.62 | 2.17 | 3.1x |
| 8 | 100 | 768.25 | 2.69 | 286x | 100 | 6.94 | 2.69 | 2.6x |
| 9 | 100 | 807.58 | 2.62 | 308x | 100 | 7.92 | 2.62 | 3.0x |
| 10 | 100 | 867.02 | 3.25 | 267x | 100 | 8.92 | 3.25 | 2.7x |
| 11 | 100 | 925.98 | 3.54 | 262x | 100 | 10.08 | 3.54 | 2.8x |
| 12 | 100 | 959.54 | 3.67 | 262x | 100 | 10.62 | 3.67 | 2.9x |
| 13 | 100 | 1007.27 | 4.00 | 252x | 100 | 11.90 | 4.00 | 3.0x |
| 14 | 100 | 1064.40 | 4.62 | 230x | 100 | 12.77 | 4.62 | 2.8x |
| 15 | 100 | 1107.15 | 4.71 | 235x | 100 | 14.21 | 4.71 | 3.0x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-31.3 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.71 | 0.74 | 1.17 | 1304233 | 6521166 | 17.6 | 0.12 | 0.0 | 17.5% | 0% | 0% |
| 6 | 500 | 11 | 0.88 | 0.89 | 1.38 | 1104240 | 5521201 | 16.4 | 0.12 | 0.0 | 2.7% | 0% | 0% |
| 7 | 500 | 13 | 1.08 | 1.14 | 1.67 | 868207 | 4341033 | 17.6 | 0.12 | 0.0 | 11.8% | 0% | 0% |
| 8 | 500 | 15 | 1.17 | 1.21 | 1.75 | 814686 | 4073430 | 16.6 | 0.12 | 0.0 | 11.3% | 0% | 0% |
| 9 | 500 | 17 | 1.42 | 1.44 | 2.08 | 685801 | 3429003 | 16.8 | 0.12 | 0.0 | 23.0% | 0% | 0% |
| 10 | 500 | 19 | 1.46 | 1.50 | 2.12 | 662669 | 3313343 | 15.9 | 0.12 | 0.0 | 13.6% | 0% | 0% |
| 11 | 500 | 21 | 1.79 | 1.89 | 2.92 | 526561 | 2632803 | 17.7 | 0.12 | 0.0 | 56.7% | 0% | 0% |
| 12 | 500 | 24 | 2.21 | 2.37 | 3.62 | 418883 | 2094416 | 20.2 | 0.12 | 0.0 | 77.1% | 0% | 0% |
| 13 | 500 | 25 | 2.00 | 2.03 | 2.79 | 488687 | 2443434 | 16.2 | 0.12 | 0.0 | 15.6% | 0% | 0% |
| 14 | 500 | 28 | 2.58 | 2.67 | 3.79 | 372070 | 1860350 | 19.4 | 0.12 | 0.0 | 37.3% | 0% | 0% |
| 15 | 500 | 30 | 2.58 | 2.66 | 3.67 | 374343 | 1871713 | 18.1 | 0.12 | 0.0 | 16.8% | 0% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 532.83 | 0.71 | 752x | 100 | 3.79 | 0.71 | 5.3x |
| 6 | 100 | 595.33 | 0.88 | 680x | 100 | 4.58 | 0.88 | 5.2x |
| 7 | 100 | 645.54 | 1.08 | 596x | 100 | 5.25 | 1.08 | 4.8x |
| 8 | 100 | 676.75 | 1.17 | 580x | 100 | 5.96 | 1.17 | 5.1x |
| 9 | 100 | 750.25 | 1.40 | 538x | 100 | 7.00 | 1.40 | 5.0x |
| 10 | 100 | 823.33 | 1.46 | 564x | 100 | 8.00 | 1.46 | 5.5x |
| 11 | 100 | 847.75 | 1.79 | 473x | 100 | 8.71 | 1.79 | 4.9x |
| 12 | 100 | 913.79 | 2.00 | 457x | 100 | 9.33 | 2.00 | 4.7x |
| 13 | 100 | 952.46 | 1.98 | 481x | 100 | 10.48 | 1.98 | 5.3x |
| 14 | 100 | 1052.79 | 2.50 | 421x | 100 | 12.50 | 2.50 | 5.0x |
| 15 | 100 | 1079.46 | 2.46 | 439x | 100 | 12.92 | 2.46 | 5.3x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 72.7 ms median over 5 problems, range 67.4-81.2 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.29 | 1.49 | 2.79 | 665115 | 3325573 | 27.0 | 0.77 | 0.0 | 22.5% | 58% | 0% |
| 6 | 500 | 14 | 1.62 | 1.78 | 3.21 | 558134 | 2790671 | 24.9 | 0.76 | 0.0 | 40.3% | 66% | 0% |
| 7 | 500 | 18 | 1.88 | 1.95 | 3.38 | 509083 | 2545415 | 21.7 | 0.80 | 0.0 | 20.0% | 70% | 0% |
| 8 | 500 | 22 | 2.04 | 2.14 | 3.92 | 464954 | 2324771 | 19.9 | 0.83 | 0.0 | 9.1% | 75% | 0% |
| 9 | 500 | 25 | 1.96 | 2.08 | 3.88 | 477658 | 2388288 | 17.0 | 0.90 | 0.0 | 3.4% | 79% | 0% |
| 10 | 500 | 29 | 1.88 | 2.09 | 4.38 | 475741 | 2378706 | 14.7 | 0.88 | 0.0 | 10.8% | 80% | 0% |
| 11 | 500 | 32 | 1.67 | 2.06 | 4.50 | 481359 | 2406797 | 12.9 | 0.86 | 0.0 | 14.5% | 82% | 0% |
| 12 | 500 | 36 | 1.46 | 1.86 | 4.33 | 534436 | 2672178 | 10.5 | 0.83 | 0.0 | 3.0% | 84% | 0% |
| 13 | 500 | 39 | 1.46 | 1.94 | 4.62 | 511008 | 2555040 | 10.0 | 0.76 | 0.0 | 16.9% | 85% | 0% |
| 14 | 500 | 44 | 1.54 | 2.10 | 5.12 | 473332 | 2366658 | 9.7 | 0.80 | 0.0 | 20.1% | 84% | 0% |
| 15 | 500 | 47 | 1.50 | 2.06 | 5.46 | 482998 | 2414992 | 8.9 | 0.87 | 0.0 | 1.1% | 83% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 543.48 | 1.29 | 421x | 100 | 4.33 | 1.29 | 3.4x |
| 6 | 100 | 617.96 | 1.62 | 380x | 100 | 4.92 | 1.62 | 3.0x |
| 7 | 100 | 696.17 | 1.83 | 380x | 100 | 6.15 | 1.83 | 3.4x |
| 8 | 100 | 792.85 | 1.96 | 405x | 100 | 6.83 | 1.96 | 3.5x |
| 9 | 100 | 829.29 | 2.08 | 398x | 100 | 7.75 | 2.08 | 3.7x |
| 10 | 100 | 879.42 | 2.04 | 431x | 100 | 8.54 | 2.04 | 4.2x |
| 11 | 100 | 959.50 | 2.08 | 461x | 100 | 8.88 | 2.08 | 4.3x |
| 12 | 100 | 1055.48 | 1.27 | 831x | 100 | 9.42 | 1.27 | 7.4x |
| 13 | 100 | 1132.29 | 1.42 | 799x | 100 | 10.79 | 1.42 | 7.6x |
| 14 | 100 | 1195.12 | 1.46 | 820x | 100 | 11.54 | 1.46 | 7.9x |
| 15 | 100 | 1284.23 | 1.38 | 934x | 100 | 12.33 | 1.38 | 9.0x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.54 | 0.55 | 0.79 | 1769025 | 8845124 | 16.2 | 0.36 | 0.0 | 21.9% | 0% | 0% |
| 6 | 500 | 10 | 0.75 | 0.79 | 1.00 | 1243317 | 6216586 | 16.1 | 0.36 | 0.0 | 23.2% | 0% | 0% |
| 7 | 500 | 11 | 1.04 | 28.08 | 154.54 | 35597 | 177983 | 497.7 | 0.36 | 0.0 | 1.1% | 0% | 40% |
| 8 | 500 | 15 | 1.25 | 50.60 | 301.59 | 19755 | 98773 | 687.7 | 0.36 | 0.0 | 0.8% | 0% | 45% |
| 9 | 500 | 18 | 1.46 | 70.72 | 448.38 | 14138 | 70690 | 793.2 | 0.36 | 0.0 | 1.0% | 0% | 48% |
| 10 | 500 | 20 | 1.62 | 96.42 | 520.56 | 10369 | 51847 | 964.0 | 0.36 | 0.0 | 0.4% | 0% | 65% |
| 11 | 500 | 23 | 1.65 | 92.09 | 523.33 | 10857 | 54287 | 788.2 | 0.36 | 0.0 | 0.7% | 0% | 71% |
| 12 | 500 | 27 | 1.88 | 123.32 | 667.22 | 8108 | 40538 | 930.2 | 0.36 | 0.0 | 2.1% | 0% | 71% |
| 13 | 500 | 29 | 1.83 | 120.36 | 654.05 | 8307 | 41536 | 832.7 | 0.36 | 0.0 | 1.1% | 0% | 79% |
| 14 | 500 | 33 | 1.96 | 145.43 | 792.62 | 6876 | 34378 | 886.9 | 0.36 | 0.0 | 0.5% | 0% | 84% |
| 15 | 500 | 36 | 1.62 | 166.78 | 869.89 | 5995 | 29976 | 931.3 | 0.36 | 0.0 | 0.3% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.01 | 2.2% | 199 | 69.01 | 97.8% |
| 8 | 273 | 1.21 | 1.3% | 227 | 110.00 | 98.7% |
| 9 | 260 | 1.42 | 1.0% | 240 | 145.78 | 98.9% |
| 10 | 174 | 1.56 | 0.6% | 326 | 147.05 | 99.4% |
| 11 | 143 | 1.67 | 0.5% | 357 | 128.30 | 99.5% |
| 12 | 144 | 1.79 | 0.4% | 356 | 172.49 | 99.6% |
| 13 | 103 | 1.79 | 0.3% | 397 | 151.12 | 99.7% |
| 14 | 81 | 1.98 | 0.2% | 419 | 173.16 | 99.8% |
| 15 | 74 | 1.78 | 0.2% | 426 | 195.44 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 433.02 | 0.58 | 743x | 100 | 1.92 | 0.58 | 3.3x |
| 6 | 100 | 507.38 | 0.75 | 676x | 100 | 2.67 | 0.75 | 3.6x |
| 7 | 100 | 604.42 | 1.00 | 604x | 62 | 2.62 | 0.96 | 2.7x |
| 8 | 100 | 807.35 | 1.17 | 692x | 57 | 3.17 | 1.12 | 2.8x |
| 9 | 100 | 967.19 | 1.46 | 663x | 51 | 3.88 | 1.38 | 2.8x |
| 10 | 100 | 1157.10 | 1.54 | 751x | 40 | 3.96 | 1.42 | 2.8x |
| 11 | 100 | 1350.44 | 1.50 | 900x | 24 | 4.46 | 1.58 | 2.8x |
| 12 | 100 | 1450.67 | 1.71 | 849x | 28 | 4.71 | 1.58 | 3.0x |
| 13 | 100 | 1555.87 | 1.58 | 983x | 22 | 5.60 | 1.54 | 3.6x |
| 14 | 100 | 1779.23 | 2.23 | 798x | 15 | 5.50 | 1.67 | 3.3x |
| 15 | 100 | 1738.94 | 2.02 | 861x | 22 | 5.71 | 1.81 | 3.1x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.50 | 0.53 | 0.71 | 1848030 | 9240149 | 15.5 | 0.16 | 0.0 | 23.8% | 0% | 0% |
| 6 | 500 | 10 | 0.62 | 0.65 | 0.88 | 1514272 | 7571362 | 13.2 | 0.16 | 0.0 | 23.2% | 0% | 0% |
| 7 | 500 | 11 | 0.79 | 14.48 | 96.46 | 69000 | 344999 | 256.7 | 0.16 | 0.0 | 0.9% | 0% | 40% |
| 8 | 500 | 15 | 0.88 | 34.10 | 189.04 | 29312 | 146561 | 463.5 | 0.16 | 0.0 | 0.5% | 0% | 45% |
| 9 | 500 | 18 | 1.04 | 46.18 | 279.62 | 21649 | 108245 | 518.0 | 0.16 | 0.0 | 0.4% | 0% | 48% |
| 10 | 500 | 20 | 1.17 | 59.94 | 298.64 | 16678 | 83389 | 599.4 | 0.16 | 0.0 | 0.5% | 0% | 65% |
| 11 | 500 | 23 | 1.29 | 66.27 | 337.33 | 15086 | 75429 | 567.3 | 0.16 | 0.0 | 0.7% | 0% | 71% |
| 12 | 500 | 27 | 1.38 | 84.28 | 432.96 | 11863 | 59315 | 635.7 | 0.16 | 0.0 | 1.3% | 0% | 71% |
| 13 | 500 | 29 | 1.29 | 81.74 | 440.16 | 12231 | 61154 | 565.5 | 0.16 | 0.0 | 0.8% | 0% | 79% |
| 14 | 500 | 33 | 1.50 | 108.16 | 528.29 | 9244 | 46221 | 659.7 | 0.16 | 0.0 | 22.5% | 0% | 84% |
| 15 | 500 | 36 | 1.33 | 107.46 | 556.55 | 9304 | 46522 | 600.1 | 0.16 | 0.0 | 0.5% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.82 | 3.4% | 199 | 35.13 | 96.5% |
| 8 | 273 | 0.91 | 1.5% | 227 | 74.01 | 98.5% |
| 9 | 260 | 1.06 | 1.2% | 240 | 95.05 | 98.8% |
| 10 | 174 | 1.19 | 0.7% | 326 | 91.30 | 99.3% |
| 11 | 143 | 1.40 | 0.6% | 357 | 92.26 | 99.4% |
| 12 | 144 | 1.40 | 0.5% | 356 | 117.80 | 99.5% |
| 13 | 103 | 1.46 | 0.4% | 397 | 102.58 | 99.6% |
| 14 | 81 | 1.74 | 0.3% | 419 | 128.73 | 99.7% |
| 15 | 74 | 1.40 | 0.2% | 426 | 125.88 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 432.50 | 0.50 | 865x | 100 | 1.83 | 0.50 | 3.7x |
| 6 | 100 | 507.10 | 0.67 | 760x | 100 | 2.54 | 0.67 | 3.8x |
| 7 | 100 | 620.85 | 0.79 | 784x | 62 | 2.60 | 0.79 | 3.3x |
| 8 | 100 | 814.79 | 0.96 | 850x | 57 | 3.12 | 0.96 | 3.3x |
| 9 | 100 | 1002.21 | 1.00 | 1002x | 51 | 3.62 | 1.08 | 3.3x |
| 10 | 100 | 12266.00 | 1.17 | 10511x | 40 | 5.06 | 1.08 | 4.7x |
| 11 | 100 | 15994.23 | 1.08 | 14755x | 24 | 4.48 | 1.21 | 3.7x |
| 12 | 100 | 17510.40 | 1.19 | 14746x | 28 | 4.35 | 1.12 | 3.9x |
| 13 | 100 | 18194.44 | 1.12 | 16173x | 22 | 5.17 | 1.23 | 4.2x |
| 14 | 100 | 20264.10 | 1.50 | 13509x | 15 | 6.67 | 1.50 | 4.4x |
| 15 | 100 | 20619.69 | 1.50 | 13746x | 22 | 5.33 | 1.29 | 4.1x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.88 | 0.90 | 1.17 | 1088514 | 5442568 | 26.2 | 0.79 | 0.0 | 10.3% | 0% | 0% |
| 6 | 500 | 10 | 1.33 | 1.43 | 1.88 | 691197 | 3455983 | 28.9 | 1.00 | 0.0 | 24.2% | 0% | 0% |
| 7 | 500 | 11 | 1.67 | 45.97 | 360.96 | 21745 | 108727 | 812.9 | 26.36 | 0.0 | 6.9% | 1% | 39% |
| 8 | 500 | 15 | 1.71 | 65.93 | 540.00 | 15164 | 75818 | 891.8 | 43.93 | 0.0 | 1.0% | 3% | 43% |
| 9 | 500 | 18 | 1.96 | 82.13 | 754.51 | 12174 | 60869 | 914.5 | 51.52 | 0.0 | 0.6% | 5% | 46% |
| 10 | 500 | 20 | 2.12 | 142.28 | 910.68 | 7028 | 35138 | 1418.0 | 55.40 | 0.0 | 0.6% | 5% | 63% |
| 11 | 500 | 23 | 2.29 | 148.95 | 1024.21 | 6713 | 33563 | 1273.1 | 60.84 | 0.0 | 2.9% | 7% | 69% |
| 12 | 500 | 27 | 2.50 | 173.56 | 1166.30 | 5761 | 28803 | 1308.7 | 71.40 | 0.0 | 26.8% | 5% | 71% |
| 13 | 500 | 29 | 2.29 | 171.44 | 1121.95 | 5832 | 29162 | 1182.9 | 61.35 | 0.0 | 1.5% | 5% | 78% |
| 14 | 500 | 33 | 2.12 | 166.86 | 1158.59 | 5993 | 29963 | 1017.5 | 69.94 | 0.0 | 0.6% | 5% | 83% |
| 15 | 500 | 36 | 1.96 | 172.15 | 1273.75 | 5808 | 29041 | 961.7 | 68.70 | 0.0 | 0.7% | 8% | 84% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.85 | 2.4% | 196 | 114.40 | 97.5% |
| 8 | 285 | 1.81 | 1.6% | 215 | 150.93 | 98.4% |
| 9 | 272 | 2.15 | 1.4% | 228 | 177.53 | 98.6% |
| 10 | 184 | 2.28 | 0.6% | 316 | 223.80 | 99.4% |
| 11 | 154 | 2.56 | 0.5% | 346 | 214.10 | 99.5% |
| 12 | 146 | 2.83 | 0.5% | 354 | 243.98 | 99.5% |
| 13 | 109 | 2.65 | 0.3% | 391 | 218.49 | 99.7% |
| 14 | 86 | 2.57 | 0.3% | 414 | 200.98 | 99.7% |
| 15 | 78 | 2.61 | 0.2% | 422 | 203.49 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 433.31 | 0.92 | 473x | 100 | 2.27 | 0.92 | 2.5x |
| 6 | 100 | 530.08 | 1.40 | 380x | 100 | 3.29 | 1.40 | 2.4x |
| 7 | 100 | 624.69 | 1.58 | 395x | 62 | 3.00 | 1.67 | 1.8x |
| 8 | 100 | 822.10 | 1.75 | 470x | 58 | 3.75 | 1.85 | 2.0x |
| 9 | 100 | 995.81 | 2.04 | 488x | 52 | 4.21 | 2.08 | 2.0x |
| 10 | 100 | 5167.54 | 1.92 | 2696x | 44 | 4.54 | 1.94 | 2.3x |
| 11 | 100 | 13559.40 | 2.42 | 5612x | 25 | 4.83 | 2.46 | 2.0x |
| 12 | 100 | 11346.58 | 2.40 | 4737x | 30 | 5.00 | 2.46 | 2.0x |
| 13 | 100 | 13406.00 | 2.29 | 5849x | 22 | 5.50 | 2.44 | 2.3x |
| 14 | 100 | 13444.69 | 2.00 | 6722x | 16 | 6.23 | 2.44 | 2.6x |
| 15 | 100 | 16016.31 | 2.17 | 7393x | 24 | 6.02 | 2.25 | 2.7x |

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

