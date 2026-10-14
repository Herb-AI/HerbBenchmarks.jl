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
| DeepCoder_2016 | 721622 | 319166 | 216000 |
| PBE_BV_Track_2018 | 1373532 | 653694 | 434436 |
| PBE_SLIA_Track_2019 | 750657 | 479739 | 492777 |
| Robots_2020 | 2044500 | 10576 | 6094 |
| Pixels_2020 | 1982030 | 16441 | 9292 |
| String_transformations_2020 | 1144057 | 7135 | 5773 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 144.2 ms median over 5 problems, range 0.2-202.9 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.33 | 1.37 | 1.92 | 721622 | 3608111 | 35.9 | 3.38 | 0.0 | 8.7% | 9% | 0% | 6.21 | 4.7x | 1.46 | 1.1x |
| 6 | 500 | 10 | 1.62 | 1.70 | 2.50 | 583811 | 2919054 | 35.6 | 4.27 | 0.0 | 8.5% | 17% | 0% | 7.54 | 4.6x | 1.75 | 1.1x |
| 7 | 500 | 12 | 2.00 | 2.04 | 2.83 | 487365 | 2436825 | 35.3 | 5.06 | 0.0 | 4.8% | 20% | 0% | 9.50 | 4.8x | 2.08 | 1.0x |
| 8 | 500 | 14 | 2.29 | 2.37 | 3.25 | 419851 | 2099253 | 34.9 | 5.61 | 0.0 | 3.4% | 25% | 0% | 11.21 | 4.9x | 2.38 | 1.0x |
| 9 | 500 | 16 | 2.67 | 2.75 | 3.79 | 362218 | 1811091 | 35.4 | 6.13 | 0.0 | 6.4% | 26% | 0% | 13.08 | 4.9x | 2.71 | 1.0x |
| 10 | 500 | 18 | 3.04 | 3.12 | 4.29 | 319166 | 1595829 | 35.8 | 6.86 | 0.0 | 12.6% | 29% | 0% | 14.71 | 4.8x | 3.04 | 1.0x |
| 11 | 500 | 20 | 3.38 | 3.45 | 4.67 | 288641 | 1443203 | 35.1 | 7.64 | 0.0 | 10.5% | 34% | 0% | 17.17 | 5.1x | 3.29 | 1.0x |
| 12 | 500 | 21 | 3.54 | 3.61 | 4.83 | 276191 | 1380955 | 33.7 | 7.72 | 0.0 | 5.2% | 37% | 0% | 19.08 | 5.4x | 3.58 | 1.0x |
| 13 | 500 | 24 | 3.92 | 3.97 | 5.25 | 251237 | 1256187 | 33.5 | 8.04 | 0.0 | 5.3% | 39% | 0% | 21.25 | 5.4x | 3.88 | 1.0x |
| 14 | 500 | 25 | 4.29 | 4.37 | 5.92 | 228098 | 1140489 | 34.5 | 8.49 | 0.0 | 6.1% | 42% | 0% | 22.62 | 5.3x | 4.12 | 1.0x |
| 15 | 500 | 28 | 4.54 | 4.61 | 6.00 | 216000 | 1079999 | 33.6 | 8.96 | 0.0 | 6.8% | 45% | 0% | 25.46 | 5.6x | 4.50 | 1.0x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 602.15 | 6.48 | 1.50 | 1.29 | 100 | 3.75 | 1.29 | 466x | 5.0x | 1.2x | 2.9x |
| 6 | 100 | 643.33 | 7.79 | 1.83 | 1.62 | 100 | 4.67 | 1.62 | 396x | 4.8x | 1.1x | 2.9x |
| 7 | 100 | 709.04 | 10.15 | 2.25 | 2.08 | 100 | 5.60 | 2.08 | 340x | 4.9x | 1.1x | 2.7x |
| 8 | 100 | 761.12 | 11.60 | 2.58 | 2.46 | 100 | 6.83 | 2.46 | 310x | 4.7x | 1.1x | 2.8x |
| 9 | 100 | 801.77 | 12.96 | 2.79 | 2.58 | 100 | 7.67 | 2.58 | 310x | 5.0x | 1.1x | 3.0x |
| 10 | 100 | 858.60 | 15.40 | 3.17 | 3.12 | 100 | 8.88 | 3.12 | 275x | 4.9x | 1.0x | 2.8x |
| 11 | 100 | 909.06 | 17.56 | 3.46 | 3.33 | 100 | 10.08 | 3.33 | 273x | 5.3x | 1.0x | 3.0x |
| 12 | 100 | 950.73 | 19.50 | 3.71 | 3.56 | 100 | 10.54 | 3.56 | 267x | 5.5x | 1.0x | 3.0x |
| 13 | 100 | 1002.79 | 21.40 | 3.96 | 3.88 | 100 | 11.77 | 3.88 | 259x | 5.5x | 1.0x | 3.0x |
| 14 | 100 | 1054.48 | 23.54 | 4.33 | 4.29 | 100 | 12.79 | 4.29 | 246x | 5.5x | 1.0x | 3.0x |
| 15 | 100 | 1097.25 | 25.48 | 4.71 | 4.62 | 100 | 13.81 | 4.62 | 237x | 5.5x | 1.0x | 3.0x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-28.8 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.67 | 0.72 | 1.12 | 1373532 | 6867660 | 16.7 | 0.12 | 0.0 | 3.5% | 0% | 0% | 3.62 | 5.4x | 0.71 | 1.1x |
| 6 | 500 | 11 | 0.92 | 0.96 | 1.50 | 1027362 | 5136812 | 17.6 | 0.12 | 0.0 | 36.5% | 0% | 0% | 4.71 | 5.1x | 0.79 | 0.9x |
| 7 | 500 | 13 | 1.04 | 1.09 | 1.62 | 899793 | 4498966 | 17.0 | 0.12 | 0.0 | 22.7% | 0% | 0% | 5.67 | 5.4x | 0.92 | 0.9x |
| 8 | 500 | 15 | 1.17 | 1.22 | 1.75 | 813857 | 4069286 | 16.6 | 0.12 | 0.0 | 9.4% | 0% | 0% | 6.33 | 5.4x | 1.00 | 0.9x |
| 9 | 500 | 17 | 1.33 | 1.38 | 2.00 | 719640 | 3598202 | 16.0 | 0.12 | 0.0 | 17.2% | 0% | 0% | 7.67 | 5.7x | 1.21 | 0.9x |
| 10 | 500 | 19 | 1.50 | 1.52 | 2.12 | 653694 | 3268472 | 16.1 | 0.12 | 0.0 | 5.6% | 0% | 0% | 8.62 | 5.8x | 1.25 | 0.8x |
| 11 | 500 | 21 | 1.67 | 1.67 | 2.25 | 595244 | 2976220 | 15.7 | 0.12 | 0.0 | 6.6% | 0% | 0% | 10.12 | 6.1x | 1.38 | 0.8x |
| 12 | 500 | 24 | 1.88 | 1.88 | 2.54 | 527320 | 2636598 | 16.0 | 0.12 | 0.0 | 11.4% | 0% | 0% | 11.42 | 6.1x | 1.54 | 0.8x |
| 13 | 500 | 25 | 2.04 | 2.08 | 2.88 | 477779 | 2388896 | 16.6 | 0.12 | 0.0 | 20.6% | 0% | 0% | 12.33 | 6.0x | 1.67 | 0.8x |
| 14 | 500 | 28 | 2.17 | 2.20 | 2.96 | 450850 | 2254249 | 16.0 | 0.12 | 0.0 | 11.8% | 0% | 0% | 13.29 | 6.1x | 1.83 | 0.8x |
| 15 | 500 | 30 | 2.25 | 2.29 | 3.00 | 434436 | 2172181 | 15.6 | 0.12 | 0.0 | 7.9% | 0% | 0% | 14.12 | 6.3x | 1.79 | 0.8x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 527.58 | 3.69 | 0.71 | 0.71 | 100 | 3.83 | 0.71 | 745x | 5.2x | 1.0x | 5.4x |
| 6 | 100 | 588.15 | 4.88 | 0.88 | 0.92 | 100 | 4.67 | 0.92 | 641x | 5.3x | 1.0x | 5.1x |
| 7 | 100 | 629.08 | 5.62 | 0.96 | 1.04 | 100 | 5.42 | 1.04 | 604x | 5.4x | 0.9x | 5.2x |
| 8 | 100 | 674.44 | 6.42 | 1.08 | 1.17 | 100 | 6.17 | 1.17 | 578x | 5.5x | 0.9x | 5.3x |
| 9 | 100 | 746.85 | 7.75 | 1.23 | 1.38 | 100 | 7.12 | 1.38 | 543x | 5.6x | 0.9x | 5.2x |
| 10 | 100 | 804.58 | 8.85 | 1.33 | 1.50 | 100 | 8.04 | 1.50 | 536x | 5.9x | 0.9x | 5.4x |
| 11 | 100 | 841.12 | 9.88 | 1.42 | 1.62 | 100 | 8.62 | 1.62 | 518x | 6.1x | 0.9x | 5.3x |
| 12 | 100 | 894.15 | 11.04 | 1.50 | 1.75 | 100 | 9.25 | 1.75 | 511x | 6.3x | 0.9x | 5.3x |
| 13 | 100 | 948.23 | 12.42 | 1.71 | 2.08 | 100 | 10.38 | 2.08 | 455x | 6.0x | 0.8x | 5.0x |
| 14 | 100 | 1027.65 | 13.81 | 1.88 | 2.21 | 100 | 11.98 | 2.21 | 465x | 6.3x | 0.8x | 5.4x |
| 15 | 100 | 1062.27 | 14.21 | 1.88 | 2.25 | 100 | 12.17 | 2.25 | 472x | 6.3x | 0.8x | 5.4x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 64.4 ms median over 5 problems, range 61.0-66.7 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.17 | 1.32 | 2.38 | 750657 | 3753285 | 23.9 | 0.77 | 0.0 | 8.1% | 58% | 0% | 4.08 | 3.5x | 1.33 | 1.1x |
| 6 | 500 | 14 | 1.46 | 1.53 | 2.71 | 648887 | 3244436 | 21.4 | 0.76 | 0.0 | 8.7% | 66% | 0% | 4.92 | 3.4x | 1.54 | 1.1x |
| 7 | 500 | 18 | 1.75 | 1.80 | 3.12 | 550474 | 2752369 | 20.0 | 0.80 | 0.0 | 9.0% | 70% | 0% | 5.92 | 3.4x | 1.83 | 1.0x |
| 8 | 500 | 22 | 1.83 | 1.89 | 3.50 | 526293 | 2631464 | 17.6 | 0.83 | 0.0 | 4.4% | 75% | 0% | 6.44 | 3.5x | 1.96 | 1.1x |
| 9 | 500 | 25 | 1.96 | 2.03 | 3.75 | 489089 | 2445446 | 16.6 | 0.90 | 0.0 | 4.9% | 79% | 0% | 6.58 | 3.4x | 2.00 | 1.0x |
| 10 | 500 | 29 | 1.83 | 2.07 | 4.25 | 479739 | 2398695 | 14.6 | 0.88 | 0.0 | 5.2% | 80% | 0% | 6.02 | 3.3x | 1.96 | 1.1x |
| 11 | 500 | 32 | 1.67 | 2.06 | 4.54 | 481866 | 2409329 | 12.9 | 0.86 | 0.0 | 5.6% | 82% | 0% | 5.62 | 3.4x | 1.79 | 1.1x |
| 12 | 500 | 36 | 1.50 | 1.89 | 4.33 | 525850 | 2629250 | 10.7 | 0.83 | 0.0 | 2.6% | 84% | 0% | 4.96 | 3.3x | 1.62 | 1.1x |
| 13 | 500 | 39 | 1.38 | 1.83 | 4.42 | 541009 | 2705043 | 9.4 | 0.76 | 0.0 | 3.9% | 85% | 0% | 4.58 | 3.3x | 1.54 | 1.1x |
| 14 | 500 | 44 | 1.38 | 1.88 | 4.71 | 528751 | 2643754 | 8.7 | 0.80 | 0.0 | 1.4% | 84% | 0% | 4.79 | 3.5x | 1.58 | 1.2x |
| 15 | 500 | 47 | 1.50 | 2.01 | 5.33 | 492777 | 2463883 | 8.7 | 0.87 | 0.0 | 3.0% | 83% | 0% | 4.96 | 3.3x | 1.67 | 1.1x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 530.35 | 4.12 | 1.38 | 1.12 | 100 | 3.81 | 1.12 | 471x | 3.7x | 1.2x | 3.4x |
| 6 | 100 | 602.69 | 4.92 | 1.54 | 1.42 | 100 | 4.88 | 1.42 | 425x | 3.5x | 1.1x | 3.4x |
| 7 | 100 | 676.81 | 5.88 | 1.92 | 1.75 | 100 | 5.88 | 1.75 | 387x | 3.4x | 1.1x | 3.4x |
| 8 | 100 | 746.42 | 6.23 | 1.92 | 1.75 | 100 | 6.67 | 1.75 | 427x | 3.6x | 1.1x | 3.8x |
| 9 | 100 | 828.60 | 7.38 | 2.33 | 2.04 | 100 | 7.79 | 2.04 | 406x | 3.6x | 1.1x | 3.8x |
| 10 | 100 | 895.25 | 7.25 | 2.19 | 2.12 | 100 | 8.42 | 2.12 | 421x | 3.4x | 1.0x | 4.0x |
| 11 | 100 | 956.48 | 6.50 | 2.08 | 1.94 | 100 | 8.92 | 1.94 | 494x | 3.4x | 1.1x | 4.6x |
| 12 | 100 | 1040.65 | 4.27 | 1.50 | 1.21 | 100 | 9.62 | 1.21 | 861x | 3.5x | 1.2x | 8.0x |
| 13 | 100 | 1116.77 | 4.58 | 1.58 | 1.33 | 100 | 10.88 | 1.33 | 838x | 3.4x | 1.2x | 8.2x |
| 14 | 100 | 1180.85 | 4.73 | 1.62 | 1.33 | 100 | 11.65 | 1.33 | 886x | 3.5x | 1.2x | 8.7x |
| 15 | 100 | 1271.83 | 4.46 | 1.54 | 1.38 | 100 | 12.29 | 1.38 | 925x | 3.2x | 1.1x | 8.9x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.47 | 0.62 | 2044500 | 10222499 | 14.0 | 0.36 | 0.0 | 7.4% | 0% | 0% | 3.54 | 7.7x | 0.38 | 0.8x |
| 6 | 500 | 10 | 0.71 | 0.71 | 0.88 | 1377822 | 6889110 | 14.5 | 0.36 | 0.0 | 1.2% | 0% | 0% | 5.21 | 7.4x | 0.54 | 0.8x |
| 7 | 500 | 11 | 1.00 | 27.66 | 153.12 | 36138 | 180690 | 490.2 | 0.36 | 0.0 | 0.8% | 0% | 40% | 6.62 | 6.6x | 0.92 | 0.9x |
| 8 | 500 | 15 | 1.21 | 49.51 | 296.30 | 20192 | 100960 | 672.8 | 0.36 | 0.0 | 0.9% | 0% | 45% | 7.17 | 5.9x | 1.12 | 0.9x |
| 9 | 500 | 18 | 1.33 | 68.91 | 439.04 | 14509 | 72543 | 773.0 | 0.36 | 0.0 | 0.3% | 0% | 48% | 8.12 | 6.1x | 1.29 | 1.0x |
| 10 | 500 | 20 | 1.50 | 94.54 | 509.76 | 10576 | 52880 | 945.2 | 0.36 | 0.0 | 0.3% | 0% | 65% | 9.25 | 6.2x | 1.50 | 1.0x |
| 11 | 500 | 23 | 1.50 | 90.01 | 510.13 | 11108 | 55538 | 770.5 | 0.36 | 0.0 | 0.7% | 0% | 71% | 9.04 | 6.0x | 1.50 | 1.0x |
| 12 | 500 | 27 | 1.67 | 120.54 | 652.84 | 8295 | 41474 | 909.2 | 0.36 | 0.0 | 0.2% | 0% | 71% | 10.19 | 6.1x | 1.67 | 1.0x |
| 13 | 500 | 29 | 1.79 | 120.94 | 649.64 | 8267 | 41335 | 836.7 | 0.36 | 0.0 | 9.5% | 0% | 79% | 9.62 | 5.4x | 1.58 | 0.9x |
| 14 | 500 | 33 | 1.71 | 147.49 | 791.79 | 6779 | 33897 | 899.5 | 0.36 | 0.0 | 16.7% | 0% | 84% | 9.79 | 5.7x | 1.58 | 0.9x |
| 15 | 500 | 36 | 1.62 | 164.07 | 853.67 | 6094 | 30471 | 916.2 | 0.36 | 0.0 | 0.8% | 0% | 85% | 9.67 | 5.9x | 1.50 | 0.9x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.99 | 2.2% | 199 | 67.99 | 97.8% |
| 8 | 273 | 1.17 | 1.3% | 227 | 107.64 | 98.7% |
| 9 | 260 | 1.26 | 1.0% | 240 | 142.19 | 99.0% |
| 10 | 174 | 1.41 | 0.5% | 326 | 144.24 | 99.5% |
| 11 | 143 | 1.49 | 0.5% | 357 | 125.47 | 99.5% |
| 12 | 144 | 1.58 | 0.4% | 356 | 168.66 | 99.6% |
| 13 | 103 | 1.84 | 0.3% | 397 | 151.85 | 99.7% |
| 14 | 81 | 1.73 | 0.2% | 419 | 175.66 | 99.8% |
| 15 | 74 | 1.71 | 0.2% | 426 | 192.28 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.17 | 3.50 | 0.42 | 0.50 | 100 | 1.92 | 0.50 | 862x | 7.0x | 0.8x | 3.8x |
| 6 | 100 | 505.79 | 5.17 | 0.54 | 0.71 | 100 | 2.71 | 0.71 | 714x | 7.3x | 0.8x | 3.8x |
| 7 | 100 | 589.50 | 6.52 | 0.92 | 1.00 | 62 | 2.71 | 0.96 | 590x | 6.5x | 0.9x | 2.8x |
| 8 | 100 | 789.19 | 6.96 | 1.12 | 1.21 | 57 | 3.17 | 1.12 | 653x | 5.8x | 0.9x | 2.8x |
| 9 | 100 | 987.92 | 9.06 | 1.38 | 1.42 | 51 | 3.71 | 1.29 | 698x | 6.4x | 1.0x | 2.9x |
| 10 | 100 | 1143.88 | 9.19 | 1.38 | 1.46 | 40 | 3.79 | 1.29 | 785x | 6.3x | 0.9x | 2.9x |
| 11 | 100 | 1356.54 | 8.83 | 1.38 | 1.42 | 24 | 4.06 | 1.52 | 958x | 6.2x | 1.0x | 2.7x |
| 12 | 100 | 1469.38 | 10.29 | 1.60 | 1.58 | 28 | 4.38 | 1.50 | 928x | 6.5x | 1.0x | 2.9x |
| 13 | 100 | 1564.33 | 9.31 | 1.46 | 1.58 | 22 | 5.12 | 1.58 | 988x | 5.9x | 0.9x | 3.2x |
| 14 | 100 | 1728.75 | 11.92 | 1.88 | 2.23 | 15 | 5.00 | 1.50 | 776x | 5.3x | 0.8x | 3.3x |
| 15 | 100 | 1721.23 | 12.33 | 2.00 | 2.04 | 22 | 5.65 | 1.79 | 843x | 6.0x | 1.0x | 3.2x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.49 | 0.67 | 1982030 | 9910151 | 14.4 | 0.16 | 0.0 | 14.1% | 0% | 0% | 3.04 | 6.6x | 0.42 | 0.9x |
| 6 | 500 | 10 | 0.62 | 0.65 | 0.88 | 1500149 | 7500746 | 13.3 | 0.16 | 0.0 | 11.1% | 0% | 0% | 4.29 | 6.9x | 0.54 | 0.9x |
| 7 | 500 | 11 | 0.83 | 14.64 | 97.75 | 68214 | 341071 | 259.7 | 0.16 | 0.0 | 0.6% | 0% | 40% | 4.92 | 5.9x | 0.71 | 0.9x |
| 8 | 500 | 15 | 1.00 | 36.92 | 193.79 | 27076 | 135379 | 501.7 | 0.16 | 0.0 | 30.1% | 0% | 45% | 5.54 | 5.5x | 0.92 | 0.9x |
| 9 | 500 | 18 | 1.04 | 46.79 | 283.96 | 21365 | 106824 | 524.9 | 0.16 | 0.0 | 0.3% | 0% | 48% | 6.54 | 6.3x | 1.04 | 1.0x |
| 10 | 500 | 20 | 1.17 | 60.81 | 302.95 | 16441 | 82204 | 608.0 | 0.16 | 0.0 | 0.5% | 0% | 65% | 7.33 | 6.3x | 1.21 | 1.0x |
| 11 | 500 | 23 | 1.21 | 66.96 | 340.48 | 14932 | 74659 | 573.1 | 0.16 | 0.0 | 0.6% | 0% | 71% | 7.23 | 6.0x | 1.21 | 1.0x |
| 12 | 500 | 27 | 1.29 | 83.93 | 427.09 | 11912 | 59561 | 633.1 | 0.16 | 0.0 | 2.2% | 0% | 71% | 7.71 | 6.0x | 1.25 | 1.0x |
| 13 | 500 | 29 | 1.29 | 82.94 | 444.76 | 12055 | 60275 | 573.8 | 0.16 | 0.0 | 6.3% | 0% | 79% | 7.00 | 5.4x | 1.21 | 0.9x |
| 14 | 500 | 33 | 1.25 | 103.54 | 499.34 | 9657 | 48283 | 631.5 | 0.16 | 0.0 | 0.3% | 0% | 84% | 7.81 | 6.2x | 1.33 | 1.1x |
| 15 | 500 | 36 | 1.29 | 107.60 | 562.88 | 9292 | 46461 | 600.9 | 0.16 | 0.0 | 0.2% | 0% | 85% | 7.71 | 6.0x | 1.33 | 1.0x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.84 | 3.5% | 199 | 35.52 | 96.4% |
| 8 | 273 | 1.11 | 1.6% | 227 | 79.97 | 98.3% |
| 9 | 260 | 1.05 | 1.2% | 240 | 96.34 | 98.8% |
| 10 | 174 | 1.14 | 0.7% | 326 | 92.65 | 99.3% |
| 11 | 143 | 1.25 | 0.5% | 357 | 93.27 | 99.4% |
| 12 | 144 | 1.32 | 0.5% | 356 | 117.35 | 99.5% |
| 13 | 103 | 1.46 | 0.4% | 397 | 104.08 | 99.6% |
| 14 | 81 | 1.47 | 0.2% | 419 | 123.27 | 99.8% |
| 15 | 74 | 1.37 | 0.2% | 426 | 126.05 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.02 | 3.04 | 0.46 | 0.50 | 100 | 1.83 | 0.50 | 862x | 6.1x | 0.9x | 3.7x |
| 6 | 100 | 504.92 | 4.33 | 0.58 | 0.67 | 100 | 2.54 | 0.67 | 758x | 6.5x | 0.9x | 3.8x |
| 7 | 100 | 609.02 | 4.12 | 0.67 | 0.83 | 62 | 2.62 | 0.88 | 731x | 5.0x | 0.8x | 3.0x |
| 8 | 100 | 809.69 | 5.58 | 0.96 | 1.00 | 57 | 3.00 | 1.00 | 810x | 5.6x | 1.0x | 3.0x |
| 9 | 100 | 1054.71 | 6.08 | 0.96 | 0.96 | 51 | 3.58 | 1.04 | 1100x | 6.3x | 1.0x | 3.4x |
| 10 | 100 | 12260.23 | 7.54 | 1.38 | 1.08 | 40 | 3.67 | 1.02 | 11321x | 7.0x | 1.3x | 3.6x |
| 11 | 100 | 16014.15 | 6.46 | 1.08 | 1.00 | 24 | 3.85 | 1.12 | 16014x | 6.5x | 1.1x | 3.4x |
| 12 | 100 | 17309.27 | 7.02 | 1.12 | 1.21 | 28 | 4.46 | 1.23 | 14329x | 5.8x | 0.9x | 3.6x |
| 13 | 100 | 18162.73 | 6.83 | 1.21 | 1.25 | 22 | 5.04 | 1.31 | 14530x | 5.5x | 1.0x | 3.8x |
| 14 | 100 | 20123.60 | 8.54 | 1.42 | 1.38 | 15 | 6.50 | 1.58 | 14635x | 6.2x | 1.0x | 4.1x |
| 15 | 100 | 20450.46 | 9.40 | 1.50 | 1.44 | 22 | 5.08 | 1.17 | 14226x | 6.5x | 1.0x | 4.4x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.83 | 0.86 | 1.08 | 1144057 | 5720284 | 25.0 | 0.79 | 0.0 | 11.7% | 0% | 0% | 3.67 | 4.4x | 0.67 | 0.8x |
| 6 | 500 | 10 | 1.17 | 1.20 | 1.46 | 823531 | 4117653 | 24.3 | 1.00 | 0.0 | 7.7% | 0% | 0% | 5.29 | 4.5x | 0.88 | 0.7x |
| 7 | 500 | 11 | 1.46 | 42.55 | 336.42 | 23492 | 117459 | 752.5 | 26.36 | 0.0 | 3.5% | 1% | 39% | 5.96 | 4.1x | 1.21 | 0.8x |
| 8 | 500 | 15 | 1.67 | 64.52 | 526.06 | 15495 | 77475 | 872.7 | 43.93 | 0.0 | 1.3% | 3% | 43% | 6.42 | 3.8x | 1.50 | 0.9x |
| 9 | 500 | 18 | 1.92 | 78.91 | 716.47 | 12669 | 63347 | 878.8 | 51.52 | 0.0 | 0.8% | 5% | 46% | 7.79 | 4.1x | 1.75 | 0.9x |
| 10 | 500 | 20 | 2.00 | 140.13 | 884.44 | 7135 | 35677 | 1396.6 | 55.40 | 0.0 | 1.3% | 5% | 63% | 8.00 | 4.0x | 1.88 | 0.9x |
| 11 | 500 | 23 | 2.08 | 144.05 | 988.18 | 6941 | 34705 | 1231.2 | 60.84 | 0.0 | 0.5% | 7% | 69% | 8.46 | 4.1x | 2.04 | 1.0x |
| 12 | 500 | 27 | 2.17 | 157.25 | 1088.09 | 6359 | 31793 | 1185.6 | 71.40 | 0.0 | 0.8% | 5% | 71% | 8.73 | 4.0x | 1.92 | 0.9x |
| 13 | 500 | 29 | 2.21 | 171.04 | 1114.39 | 5846 | 29230 | 1180.1 | 61.35 | 0.0 | 0.9% | 5% | 78% | 8.54 | 3.9x | 1.98 | 0.9x |
| 14 | 500 | 33 | 2.17 | 169.90 | 1180.67 | 5885 | 29425 | 1036.1 | 69.94 | 0.0 | 0.5% | 5% | 83% | 8.38 | 3.9x | 1.96 | 0.9x |
| 15 | 500 | 36 | 1.92 | 173.20 | 1274.99 | 5773 | 28866 | 967.6 | 68.70 | 0.0 | 0.3% | 8% | 84% | 7.67 | 4.0x | 1.83 | 1.0x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.50 | 2.1% | 196 | 106.22 | 97.8% |
| 8 | 285 | 1.77 | 1.6% | 215 | 147.71 | 98.4% |
| 9 | 272 | 2.00 | 1.4% | 228 | 170.67 | 98.6% |
| 10 | 184 | 2.11 | 0.6% | 316 | 220.49 | 99.4% |
| 11 | 154 | 2.28 | 0.5% | 346 | 207.15 | 99.5% |
| 12 | 146 | 2.42 | 0.4% | 354 | 221.10 | 99.5% |
| 13 | 109 | 2.55 | 0.3% | 391 | 218.01 | 99.7% |
| 14 | 86 | 2.66 | 0.3% | 414 | 204.65 | 99.7% |
| 15 | 78 | 2.52 | 0.2% | 422 | 204.74 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.48 | 3.67 | 0.65 | 0.88 | 100 | 2.04 | 0.88 | 493x | 4.2x | 0.7x | 2.3x |
| 6 | 100 | 505.02 | 5.38 | 0.92 | 1.21 | 100 | 2.79 | 1.21 | 418x | 4.4x | 0.8x | 2.3x |
| 7 | 100 | 615.44 | 4.81 | 1.17 | 1.29 | 62 | 2.83 | 1.38 | 476x | 3.7x | 0.9x | 2.1x |
| 8 | 100 | 795.35 | 6.42 | 1.50 | 1.62 | 58 | 3.48 | 1.75 | 489x | 3.9x | 0.9x | 2.0x |
| 9 | 100 | 1048.35 | 7.79 | 1.75 | 1.92 | 52 | 3.92 | 1.96 | 547x | 4.1x | 0.9x | 2.0x |
| 10 | 100 | 4778.98 | 7.12 | 1.71 | 1.79 | 44 | 3.88 | 1.81 | 2668x | 4.0x | 1.0x | 2.1x |
| 11 | 100 | 12595.83 | 9.58 | 2.04 | 2.19 | 25 | 4.83 | 2.21 | 5758x | 4.4x | 0.9x | 2.2x |
| 12 | 100 | 11967.35 | 7.21 | 1.71 | 2.00 | 30 | 4.46 | 2.17 | 5984x | 3.6x | 0.9x | 2.1x |
| 13 | 100 | 13303.10 | 8.40 | 1.88 | 2.17 | 22 | 5.38 | 2.38 | 6142x | 3.9x | 0.9x | 2.3x |
| 14 | 100 | 13349.90 | 8.04 | 1.88 | 2.04 | 16 | 6.15 | 2.33 | 6539x | 3.9x | 0.9x | 2.6x |
| 15 | 100 | 13751.63 | 9.04 | 2.08 | 2.08 | 24 | 5.38 | 2.21 | 6599x | 4.3x | 1.0x | 2.4x |

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
- `v2 us` / `v2 speed-up` is "custom v2 (batched)" (see
  `BenchTarget.v2_interpret`), the same kind of direct same-subset ratio.
- The three-way comparison is informational, not a second verdict on the
  custom interpreter: `eval` pays full compiler latency every call because
  each sampled program is a structurally distinct `Expr` with no method
  cache to reuse, which is not what a real workload would do with this
  amount of code. `interpret` is the fair comparison (the generic,
  non-generated evaluator the custom interpreters replace), except that it
  cannot run a `WHILE` at all.

