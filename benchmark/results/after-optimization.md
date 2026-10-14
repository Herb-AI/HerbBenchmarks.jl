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
| DeepCoder_2016 | 708935 | 324042 | 224220 |
| PBE_BV_Track_2018 | 1380961 | 669576 | 443305 |
| PBE_SLIA_Track_2019 | 768029 | 502639 | 494356 |
| Robots_2020 | 2279549 | 10636 | 6116 |
| Pixels_2020 | 2046384 | 16669 | 9419 |
| String_transformations_2020 | 1170458 | 7427 | 6042 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 144.0 ms median over 5 problems, range 0.2-199.5 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.33 | 1.40 | 2.00 | 708935 | 3544675 | 36.5 | 3.38 | 0.0 | 9.5% | 9% | 0% | 5.71 | 4.3x |
| 6 | 500 | 10 | 1.62 | 1.66 | 2.42 | 596973 | 2984866 | 34.8 | 4.27 | 0.0 | 4.3% | 17% | 0% | 7.08 | 4.4x |
| 7 | 500 | 12 | 2.00 | 2.06 | 2.88 | 483072 | 2415362 | 35.6 | 5.06 | 0.0 | 3.3% | 20% | 0% | 8.92 | 4.5x |
| 8 | 500 | 14 | 2.29 | 2.37 | 3.29 | 420277 | 2101385 | 34.9 | 5.61 | 0.0 | 3.3% | 25% | 0% | 10.62 | 4.6x |
| 9 | 500 | 16 | 2.67 | 2.76 | 3.84 | 360222 | 1801110 | 35.6 | 6.13 | 0.0 | 17.4% | 26% | 0% | 12.33 | 4.6x |
| 10 | 500 | 18 | 2.96 | 3.07 | 4.21 | 324042 | 1620212 | 35.2 | 6.86 | 0.0 | 15.8% | 29% | 0% | 14.17 | 4.8x |
| 11 | 500 | 20 | 3.25 | 3.29 | 4.46 | 302983 | 1514914 | 33.4 | 7.64 | 0.0 | 2.0% | 34% | 0% | 16.33 | 5.0x |
| 12 | 500 | 21 | 3.42 | 3.51 | 4.71 | 283783 | 1418916 | 32.8 | 7.72 | 0.0 | 3.5% | 37% | 0% | 18.44 | 5.4x |
| 13 | 500 | 24 | 3.83 | 3.89 | 5.17 | 256185 | 1280924 | 32.9 | 8.04 | 0.0 | 3.9% | 39% | 0% | 20.35 | 5.3x |
| 14 | 500 | 25 | 4.08 | 4.18 | 5.58 | 238424 | 1192122 | 33.0 | 8.49 | 0.0 | 6.9% | 42% | 0% | 21.71 | 5.3x |
| 15 | 500 | 28 | 4.42 | 4.45 | 5.75 | 224220 | 1121102 | 32.3 | 8.96 | 0.0 | 3.4% | 45% | 0% | 23.71 | 5.4x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 581.31 | 1.33 | 436x | 100 | 3.88 | 1.33 | 2.9x |
| 6 | 100 | 618.50 | 1.67 | 371x | 100 | 4.50 | 1.67 | 2.7x |
| 7 | 100 | 681.60 | 2.04 | 334x | 100 | 5.54 | 2.04 | 2.7x |
| 8 | 100 | 724.17 | 2.46 | 294x | 100 | 6.65 | 2.46 | 2.7x |
| 9 | 100 | 765.88 | 2.58 | 296x | 100 | 7.54 | 2.58 | 2.9x |
| 10 | 100 | 825.56 | 3.04 | 271x | 100 | 8.62 | 3.04 | 2.8x |
| 11 | 100 | 880.25 | 3.25 | 271x | 100 | 9.67 | 3.25 | 3.0x |
| 12 | 100 | 914.48 | 3.46 | 264x | 100 | 10.17 | 3.46 | 2.9x |
| 13 | 100 | 963.90 | 3.75 | 257x | 100 | 11.17 | 3.75 | 3.0x |
| 14 | 100 | 1024.88 | 4.21 | 244x | 100 | 12.19 | 4.21 | 2.9x |
| 15 | 100 | 1057.08 | 4.50 | 235x | 100 | 13.15 | 4.50 | 2.9x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-28.8 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.67 | 0.71 | 1.12 | 1380961 | 6904803 | 16.6 | 0.12 | 0.0 | 13.6% | 0% | 0% | 3.67 | 5.5x |
| 6 | 500 | 11 | 0.83 | 0.87 | 1.33 | 1134730 | 5673651 | 15.9 | 0.12 | 0.0 | 11.4% | 0% | 0% | 4.67 | 5.6x |
| 7 | 500 | 13 | 1.04 | 1.07 | 1.58 | 927658 | 4638291 | 16.5 | 0.12 | 0.0 | 2.6% | 0% | 0% | 5.67 | 5.4x |
| 8 | 500 | 15 | 1.12 | 1.17 | 1.67 | 844951 | 4224757 | 16.0 | 0.12 | 0.0 | 3.4% | 0% | 0% | 6.54 | 5.8x |
| 9 | 500 | 17 | 1.33 | 1.35 | 1.96 | 735989 | 3679944 | 15.6 | 0.12 | 0.0 | 13.1% | 0% | 0% | 7.71 | 5.8x |
| 10 | 500 | 19 | 1.46 | 1.48 | 2.04 | 669576 | 3347878 | 15.7 | 0.12 | 0.0 | 7.8% | 0% | 0% | 8.58 | 5.9x |
| 11 | 500 | 21 | 1.62 | 1.65 | 2.25 | 602603 | 3013015 | 15.5 | 0.12 | 0.0 | 8.1% | 0% | 0% | 10.25 | 6.3x |
| 12 | 500 | 24 | 1.75 | 1.77 | 2.38 | 559587 | 2797933 | 15.1 | 0.12 | 0.0 | 5.8% | 0% | 0% | 11.50 | 6.6x |
| 13 | 500 | 25 | 1.88 | 1.88 | 2.54 | 528444 | 2642218 | 15.0 | 0.12 | 0.0 | 11.7% | 0% | 0% | 12.58 | 6.7x |
| 14 | 500 | 28 | 2.04 | 2.06 | 2.75 | 481255 | 2406276 | 15.0 | 0.12 | 0.0 | 8.3% | 0% | 0% | 13.79 | 6.8x |
| 15 | 500 | 30 | 2.21 | 2.24 | 2.96 | 443305 | 2216525 | 15.2 | 0.12 | 0.0 | 8.9% | 0% | 0% | 14.58 | 6.6x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 508.52 | 0.67 | 762x | 100 | 3.75 | 0.67 | 5.6x |
| 6 | 100 | 574.50 | 0.83 | 690x | 100 | 4.46 | 0.83 | 5.4x |
| 7 | 100 | 614.77 | 1.00 | 615x | 100 | 5.17 | 1.00 | 5.2x |
| 8 | 100 | 654.92 | 1.08 | 605x | 100 | 5.92 | 1.08 | 5.5x |
| 9 | 100 | 721.04 | 1.25 | 577x | 100 | 7.00 | 1.25 | 5.6x |
| 10 | 100 | 780.58 | 1.46 | 535x | 100 | 7.71 | 1.46 | 5.3x |
| 11 | 100 | 815.79 | 1.54 | 529x | 100 | 8.38 | 1.54 | 5.4x |
| 12 | 100 | 871.92 | 1.67 | 523x | 100 | 9.17 | 1.67 | 5.5x |
| 13 | 100 | 924.04 | 1.83 | 504x | 100 | 10.50 | 1.83 | 5.7x |
| 14 | 100 | 995.21 | 2.08 | 478x | 100 | 11.50 | 2.08 | 5.5x |
| 15 | 100 | 1034.17 | 2.12 | 487x | 100 | 12.08 | 2.12 | 5.7x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 61.8 ms median over 5 problems, range 58.9-66.4 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.17 | 1.29 | 2.33 | 768029 | 3840147 | 23.3 | 0.77 | 0.0 | 5.9% | 58% | 0% | 4.17 | 3.6x |
| 6 | 500 | 14 | 1.42 | 1.48 | 2.67 | 667608 | 3338042 | 20.8 | 0.76 | 0.0 | 6.4% | 66% | 0% | 4.92 | 3.5x |
| 7 | 500 | 18 | 1.62 | 1.74 | 3.00 | 570039 | 2850194 | 19.3 | 0.80 | 0.0 | 7.4% | 70% | 0% | 5.88 | 3.6x |
| 8 | 500 | 22 | 1.75 | 1.78 | 3.38 | 556783 | 2783914 | 16.6 | 0.83 | 0.0 | 4.2% | 75% | 0% | 6.54 | 3.7x |
| 9 | 500 | 25 | 1.88 | 1.97 | 3.67 | 503787 | 2518934 | 16.2 | 0.90 | 0.0 | 4.5% | 79% | 0% | 6.90 | 3.7x |
| 10 | 500 | 29 | 1.75 | 1.98 | 4.12 | 502639 | 2513195 | 13.9 | 0.88 | 0.0 | 3.4% | 80% | 0% | 6.33 | 3.6x |
| 11 | 500 | 32 | 1.62 | 2.00 | 4.46 | 495737 | 2478683 | 12.5 | 0.86 | 0.0 | 20.6% | 82% | 0% | 5.54 | 3.4x |
| 12 | 500 | 36 | 1.46 | 1.83 | 4.21 | 543542 | 2717712 | 10.3 | 0.83 | 0.0 | 3.3% | 84% | 0% | 5.12 | 3.5x |
| 13 | 500 | 39 | 1.33 | 1.82 | 4.42 | 545797 | 2728985 | 9.3 | 0.76 | 0.0 | 9.3% | 85% | 0% | 4.67 | 3.5x |
| 14 | 500 | 44 | 1.38 | 1.84 | 4.46 | 539462 | 2697308 | 8.5 | 0.80 | 0.0 | 3.3% | 84% | 0% | 4.83 | 3.5x |
| 15 | 500 | 47 | 1.50 | 2.01 | 5.34 | 494356 | 2471781 | 8.7 | 0.87 | 0.0 | 8.4% | 83% | 0% | 5.04 | 3.4x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 518.48 | 1.12 | 461x | 100 | 3.71 | 1.12 | 3.3x |
| 6 | 100 | 588.35 | 1.42 | 415x | 100 | 4.75 | 1.42 | 3.4x |
| 7 | 100 | 661.33 | 1.62 | 407x | 100 | 5.75 | 1.62 | 3.5x |
| 8 | 100 | 729.21 | 1.58 | 461x | 100 | 6.46 | 1.58 | 4.1x |
| 9 | 100 | 822.00 | 2.04 | 403x | 100 | 7.75 | 2.04 | 3.8x |
| 10 | 100 | 874.69 | 2.04 | 428x | 100 | 8.29 | 2.04 | 4.1x |
| 11 | 100 | 943.46 | 1.96 | 482x | 100 | 8.71 | 1.96 | 4.4x |
| 12 | 100 | 1031.06 | 1.25 | 825x | 100 | 9.42 | 1.25 | 7.5x |
| 13 | 100 | 1103.75 | 1.25 | 883x | 100 | 10.67 | 1.25 | 8.5x |
| 14 | 100 | 1169.65 | 1.33 | 877x | 100 | 11.58 | 1.33 | 8.7x |
| 15 | 100 | 1270.90 | 1.33 | 953x | 100 | 12.12 | 1.33 | 9.1x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.38 | 0.42 | 0.62 | 2279549 | 11397747 | 12.5 | 0.36 | 0.0 | 7.3% | 0% | 0% | 3.46 | 9.2x |
| 6 | 500 | 10 | 0.67 | 0.70 | 0.88 | 1396388 | 6981941 | 14.3 | 0.36 | 0.0 | 3.4% | 0% | 0% | 4.96 | 7.4x |
| 7 | 500 | 11 | 1.04 | 27.19 | 151.83 | 36753 | 183766 | 482.0 | 0.36 | 0.0 | 2.2% | 0% | 40% | 6.50 | 6.2x |
| 8 | 500 | 15 | 1.25 | 49.36 | 294.96 | 20251 | 101255 | 670.8 | 0.36 | 0.0 | 3.9% | 0% | 45% | 7.25 | 5.8x |
| 9 | 500 | 18 | 1.33 | 68.42 | 437.18 | 14613 | 73065 | 767.4 | 0.36 | 0.0 | 1.3% | 0% | 48% | 8.00 | 6.0x |
| 10 | 500 | 20 | 1.50 | 94.01 | 511.59 | 10636 | 53179 | 939.9 | 0.36 | 0.0 | 1.8% | 0% | 65% | 9.04 | 6.0x |
| 11 | 500 | 23 | 1.54 | 89.77 | 511.68 | 11138 | 55690 | 768.4 | 0.36 | 0.0 | 1.8% | 0% | 71% | 8.88 | 5.8x |
| 12 | 500 | 27 | 2.33 | 169.44 | 801.81 | 5900 | 29502 | 1278.1 | 0.36 | 0.0 | 99.0% | 0% | 71% | 10.42 | 4.5x |
| 13 | 500 | 29 | 1.75 | 119.03 | 648.42 | 8400 | 41999 | 823.5 | 0.36 | 0.0 | 2.6% | 0% | 79% | 9.50 | 5.4x |
| 14 | 500 | 33 | 1.67 | 142.10 | 763.04 | 7036 | 35182 | 866.6 | 0.36 | 0.0 | 0.6% | 0% | 84% | 9.52 | 5.7x |
| 15 | 500 | 36 | 1.67 | 163.50 | 841.67 | 6116 | 30578 | 913.0 | 0.36 | 0.0 | 0.3% | 0% | 85% | 9.60 | 5.8x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.01 | 2.2% | 199 | 66.80 | 97.7% |
| 8 | 273 | 1.19 | 1.3% | 227 | 107.30 | 98.7% |
| 9 | 260 | 1.26 | 1.0% | 240 | 141.17 | 99.0% |
| 10 | 174 | 1.38 | 0.5% | 326 | 143.44 | 99.5% |
| 11 | 143 | 1.52 | 0.5% | 357 | 125.11 | 99.5% |
| 12 | 144 | 2.46 | 0.4% | 356 | 236.98 | 99.6% |
| 13 | 103 | 1.75 | 0.3% | 397 | 149.46 | 99.7% |
| 14 | 81 | 1.67 | 0.2% | 419 | 169.25 | 99.8% |
| 15 | 74 | 1.75 | 0.2% | 426 | 191.60 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 428.29 | 0.46 | 935x | 100 | 1.83 | 0.46 | 4.0x |
| 6 | 100 | 501.04 | 0.71 | 708x | 100 | 2.54 | 0.71 | 3.6x |
| 7 | 100 | 590.27 | 1.04 | 567x | 62 | 2.50 | 0.96 | 2.6x |
| 8 | 100 | 770.85 | 1.17 | 661x | 57 | 3.00 | 1.12 | 2.7x |
| 9 | 100 | 968.00 | 1.38 | 704x | 51 | 3.62 | 1.29 | 2.8x |
| 10 | 100 | 1130.17 | 1.46 | 775x | 40 | 3.65 | 1.29 | 2.8x |
| 11 | 100 | 1374.02 | 1.33 | 1030x | 24 | 4.21 | 1.42 | 3.0x |
| 12 | 100 | 1449.96 | 2.38 | 611x | 28 | 4.54 | 1.98 | 2.3x |
| 13 | 100 | 1533.04 | 1.56 | 981x | 22 | 4.79 | 1.54 | 3.1x |
| 14 | 100 | 1709.38 | 1.96 | 873x | 15 | 4.58 | 1.50 | 3.1x |
| 15 | 100 | 1702.37 | 2.06 | 825x | 22 | 5.65 | 1.92 | 2.9x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.47 | 0.67 | 2046384 | 10231921 | 14.0 | 0.16 | 0.0 | 5.3% | 0% | 0% | 3.12 | 6.8x |
| 6 | 500 | 10 | 0.58 | 0.61 | 0.79 | 1597784 | 7988920 | 12.5 | 0.16 | 0.0 | 16.0% | 0% | 0% | 4.38 | 7.5x |
| 7 | 500 | 11 | 0.79 | 14.25 | 96.38 | 70106 | 350530 | 252.7 | 0.16 | 0.0 | 1.5% | 0% | 40% | 5.04 | 6.4x |
| 8 | 500 | 15 | 0.92 | 34.23 | 192.12 | 29198 | 145990 | 465.3 | 0.16 | 0.0 | 2.1% | 0% | 45% | 5.54 | 6.0x |
| 9 | 500 | 18 | 1.00 | 46.12 | 282.08 | 21677 | 108386 | 517.3 | 0.16 | 0.0 | 1.3% | 0% | 48% | 6.62 | 6.6x |
| 10 | 500 | 20 | 1.12 | 59.98 | 299.22 | 16669 | 83343 | 599.7 | 0.16 | 0.0 | 0.8% | 0% | 65% | 7.38 | 6.6x |
| 11 | 500 | 23 | 1.12 | 65.80 | 338.25 | 15194 | 75968 | 563.3 | 0.16 | 0.0 | 1.3% | 0% | 71% | 7.25 | 6.4x |
| 12 | 500 | 27 | 1.25 | 82.77 | 424.58 | 12079 | 60397 | 624.3 | 0.16 | 0.0 | 2.4% | 0% | 71% | 7.69 | 6.2x |
| 13 | 500 | 29 | 1.25 | 80.87 | 435.74 | 12363 | 61815 | 559.5 | 0.16 | 0.0 | 1.3% | 0% | 79% | 7.08 | 5.7x |
| 14 | 500 | 33 | 1.29 | 102.86 | 492.20 | 9720 | 48602 | 627.3 | 0.16 | 0.0 | 0.6% | 0% | 84% | 7.88 | 6.1x |
| 15 | 500 | 36 | 1.25 | 106.15 | 554.01 | 9419 | 47095 | 592.8 | 0.16 | 0.0 | 0.5% | 0% | 85% | 7.83 | 6.3x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.85 | 3.6% | 199 | 34.52 | 96.3% |
| 8 | 273 | 0.96 | 1.5% | 227 | 74.25 | 98.4% |
| 9 | 260 | 1.02 | 1.1% | 240 | 94.97 | 98.8% |
| 10 | 174 | 1.11 | 0.6% | 326 | 91.40 | 99.3% |
| 11 | 143 | 1.16 | 0.5% | 357 | 91.69 | 99.5% |
| 12 | 144 | 1.29 | 0.4% | 356 | 115.73 | 99.5% |
| 13 | 103 | 1.36 | 0.3% | 397 | 101.50 | 99.6% |
| 14 | 81 | 1.47 | 0.2% | 419 | 122.46 | 99.8% |
| 15 | 74 | 1.31 | 0.2% | 426 | 124.37 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 432.79 | 0.50 | 866x | 100 | 1.79 | 0.50 | 3.6x |
| 6 | 100 | 505.94 | 0.58 | 868x | 100 | 2.46 | 0.58 | 4.2x |
| 7 | 100 | 603.17 | 0.75 | 804x | 62 | 2.52 | 0.79 | 3.2x |
| 8 | 100 | 808.33 | 0.96 | 844x | 57 | 2.83 | 0.92 | 3.1x |
| 9 | 100 | 1037.38 | 0.94 | 1107x | 51 | 3.50 | 0.96 | 3.6x |
| 10 | 100 | 12025.69 | 1.08 | 11099x | 40 | 3.50 | 0.96 | 3.6x |
| 11 | 100 | 15585.69 | 1.08 | 14378x | 24 | 3.71 | 1.17 | 3.2x |
| 12 | 100 | 16920.75 | 1.12 | 15041x | 28 | 4.21 | 1.12 | 3.7x |
| 13 | 100 | 17870.48 | 1.12 | 15885x | 22 | 4.62 | 1.21 | 3.8x |
| 14 | 100 | 19781.65 | 1.29 | 15311x | 15 | 5.96 | 1.42 | 4.2x |
| 15 | 100 | 20005.17 | 1.33 | 15008x | 22 | 5.12 | 1.02 | 5.0x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.83 | 0.84 | 1.04 | 1170458 | 5852290 | 24.4 | 0.79 | 0.0 | 8.5% | 0% | 0% | 3.58 | 4.3x |
| 6 | 500 | 10 | 1.17 | 1.20 | 1.46 | 824867 | 4124334 | 24.2 | 1.00 | 0.0 | 5.6% | 0% | 0% | 5.21 | 4.5x |
| 7 | 500 | 11 | 1.38 | 41.01 | 332.10 | 24375 | 121876 | 725.2 | 26.36 | 0.0 | 2.2% | 1% | 39% | 5.96 | 4.3x |
| 8 | 500 | 15 | 1.54 | 63.95 | 522.96 | 15633 | 78163 | 865.0 | 43.93 | 0.0 | 1.2% | 3% | 43% | 6.25 | 4.1x |
| 9 | 500 | 18 | 1.83 | 79.39 | 720.30 | 12593 | 62967 | 884.1 | 51.52 | 0.0 | 0.6% | 5% | 46% | 7.71 | 4.2x |
| 10 | 500 | 20 | 2.00 | 134.63 | 858.38 | 7427 | 37133 | 1341.8 | 55.40 | 0.0 | 0.5% | 5% | 63% | 8.00 | 4.0x |
| 11 | 500 | 23 | 2.00 | 139.65 | 960.65 | 7160 | 35798 | 1193.6 | 60.84 | 0.0 | 0.8% | 7% | 69% | 8.38 | 4.2x |
| 12 | 500 | 27 | 2.00 | 149.94 | 1033.51 | 6669 | 33343 | 1130.5 | 71.40 | 0.0 | 0.4% | 5% | 71% | 8.12 | 4.1x |
| 13 | 500 | 29 | 2.04 | 160.59 | 1042.95 | 6226 | 31132 | 1108.0 | 61.35 | 0.0 | 0.7% | 5% | 78% | 8.38 | 4.1x |
| 14 | 500 | 33 | 2.04 | 162.17 | 1138.31 | 6166 | 30828 | 988.9 | 69.94 | 0.0 | 3.2% | 5% | 83% | 8.08 | 4.0x |
| 15 | 500 | 36 | 1.83 | 165.48 | 1194.30 | 6042 | 30212 | 924.5 | 68.70 | 0.0 | 0.5% | 8% | 84% | 7.50 | 4.1x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.42 | 2.1% | 196 | 102.41 | 97.9% |
| 8 | 285 | 1.68 | 1.5% | 215 | 146.50 | 98.5% |
| 9 | 272 | 1.94 | 1.3% | 228 | 171.78 | 98.6% |
| 10 | 184 | 2.10 | 0.6% | 316 | 211.81 | 99.4% |
| 11 | 154 | 2.21 | 0.5% | 346 | 200.83 | 99.5% |
| 12 | 146 | 2.20 | 0.4% | 354 | 210.87 | 99.6% |
| 13 | 109 | 2.34 | 0.3% | 391 | 204.71 | 99.7% |
| 14 | 86 | 2.45 | 0.3% | 414 | 195.35 | 99.7% |
| 15 | 78 | 2.42 | 0.2% | 422 | 195.62 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 433.04 | 0.83 | 520x | 100 | 2.00 | 0.83 | 2.4x |
| 6 | 100 | 508.71 | 1.21 | 421x | 100 | 2.79 | 1.21 | 2.3x |
| 7 | 100 | 605.65 | 1.25 | 485x | 62 | 2.88 | 1.33 | 2.2x |
| 8 | 100 | 794.25 | 1.58 | 502x | 58 | 3.35 | 1.71 | 2.0x |
| 9 | 100 | 977.02 | 1.88 | 521x | 52 | 3.75 | 1.92 | 2.0x |
| 10 | 100 | 4774.12 | 1.75 | 2728x | 44 | 3.81 | 1.75 | 2.2x |
| 11 | 100 | 12114.50 | 2.17 | 5593x | 25 | 4.42 | 2.17 | 2.0x |
| 12 | 100 | 10039.35 | 1.73 | 5805x | 30 | 4.04 | 1.83 | 2.2x |
| 13 | 100 | 12897.38 | 2.00 | 6449x | 22 | 5.17 | 2.12 | 2.4x |
| 14 | 100 | 13028.73 | 1.90 | 6874x | 16 | 6.06 | 2.15 | 2.8x |
| 15 | 100 | 13610.17 | 2.04 | 6665x | 24 | 5.27 | 2.08 | 2.5x |

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
- `v1 us` / `v1 speed-up` is "custom v1" -- the pre-optimization interpreter
  (see `BenchTarget.v1_interpret`), run on the exact same programs as the
  main `median us` column, so `v1 speed-up` is a direct same-subset ratio
  (current custom interpreter's speed relative to v1), not informational
  like the three-way comparison below.
- The three-way comparison is informational, not a second verdict on the
  custom interpreter: `eval` pays full compiler latency every call because
  each sampled program is a structurally distinct `Expr` with no method
  cache to reuse, which is not what a real workload would do with this
  amount of code. `interpret` is the fair comparison (the generic,
  non-generated evaluator the custom interpreters replace), except that it
  cannot run a `WHILE` at all.

