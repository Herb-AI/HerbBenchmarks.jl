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
| DeepCoder_2016 | 715564 | 333000 | 220594 |
| PBE_BV_Track_2018 | 1344869 | 653623 | 433319 |
| PBE_SLIA_Track_2019 | 763398 | 420881 | 501706 |
| Robots_2020 | 1887207 | 10602 | 6092 |
| Pixels_2020 | 2012004 | 16587 | 9361 |
| String_transformations_2020 | 1105828 | 7282 | 5913 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 140.0 ms median over 5 problems, range 0.2-202.2 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.33 | 1.38 | 1.96 | 715564 | 3577818 | 36.2 | 3.38 | 0.0 | 3.2% | 9% | 0% | 5.71 | 4.3x |
| 6 | 500 | 10 | 1.62 | 1.67 | 2.42 | 593096 | 2965482 | 35.0 | 4.27 | 0.0 | 3.8% | 17% | 0% | 7.54 | 4.6x |
| 7 | 500 | 12 | 2.00 | 2.04 | 2.83 | 488039 | 2440195 | 35.3 | 5.06 | 0.0 | 2.3% | 20% | 0% | 9.12 | 4.6x |
| 8 | 500 | 14 | 2.29 | 2.39 | 3.33 | 416187 | 2080934 | 35.2 | 5.61 | 0.0 | 7.2% | 25% | 0% | 10.75 | 4.7x |
| 9 | 500 | 16 | 2.62 | 2.68 | 3.67 | 370682 | 1853408 | 34.6 | 6.13 | 0.0 | 6.0% | 26% | 0% | 12.79 | 4.9x |
| 10 | 500 | 18 | 2.94 | 2.99 | 4.04 | 333000 | 1665002 | 34.3 | 6.86 | 0.0 | 3.4% | 29% | 0% | 14.62 | 5.0x |
| 11 | 500 | 20 | 3.25 | 3.31 | 4.46 | 300879 | 1504393 | 33.7 | 7.64 | 0.0 | 1.8% | 34% | 0% | 16.96 | 5.2x |
| 12 | 500 | 21 | 3.48 | 3.54 | 4.79 | 281239 | 1406193 | 33.1 | 7.72 | 0.0 | 4.6% | 37% | 0% | 18.67 | 5.4x |
| 13 | 500 | 24 | 3.88 | 3.98 | 5.29 | 250201 | 1251006 | 33.7 | 8.04 | 0.0 | 9.1% | 39% | 0% | 20.69 | 5.3x |
| 14 | 500 | 25 | 4.12 | 4.18 | 5.58 | 238357 | 1191786 | 33.0 | 8.49 | 0.0 | 5.7% | 42% | 0% | 22.38 | 5.4x |
| 15 | 500 | 28 | 4.46 | 4.52 | 5.83 | 220594 | 1102970 | 32.9 | 8.96 | 0.0 | 5.8% | 45% | 0% | 25.17 | 5.6x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 591.12 | 5.96 | 1.33 | 100 | 3.79 | 1.33 | 443x | 4.5x | 2.8x |
| 6 | 100 | 633.81 | 7.54 | 1.62 | 100 | 4.50 | 1.62 | 390x | 4.6x | 2.8x |
| 7 | 100 | 698.02 | 9.42 | 2.08 | 100 | 5.58 | 2.08 | 335x | 4.5x | 2.7x |
| 8 | 100 | 741.38 | 11.00 | 2.48 | 100 | 6.83 | 2.48 | 299x | 4.4x | 2.8x |
| 9 | 100 | 788.31 | 12.46 | 2.50 | 100 | 7.54 | 2.50 | 315x | 5.0x | 3.0x |
| 10 | 100 | 844.27 | 15.10 | 3.00 | 100 | 8.77 | 3.00 | 281x | 5.0x | 2.9x |
| 11 | 100 | 894.65 | 16.71 | 3.33 | 100 | 9.73 | 3.33 | 268x | 5.0x | 2.9x |
| 12 | 100 | 934.54 | 18.85 | 3.46 | 100 | 10.33 | 3.46 | 270x | 5.5x | 3.0x |
| 13 | 100 | 982.79 | 20.73 | 3.88 | 100 | 11.54 | 3.88 | 254x | 5.3x | 3.0x |
| 14 | 100 | 1042.79 | 22.73 | 4.17 | 100 | 12.50 | 4.17 | 250x | 5.5x | 3.0x |
| 15 | 100 | 1086.33 | 24.56 | 4.58 | 100 | 13.46 | 4.58 | 237x | 5.4x | 2.9x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-30.2 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.67 | 0.73 | 1.12 | 1344869 | 6724345 | 17.1 | 0.12 | 0.0 | 12.6% | 0% | 0% | 3.67 | 5.5x |
| 6 | 500 | 11 | 0.88 | 0.90 | 1.38 | 1094052 | 5470261 | 16.5 | 0.12 | 0.0 | 14.0% | 0% | 0% | 4.92 | 5.6x |
| 7 | 500 | 13 | 1.25 | 1.45 | 2.33 | 682446 | 3412230 | 22.4 | 0.12 | 0.0 | 91.9% | 0% | 0% | 6.12 | 4.9x |
| 8 | 500 | 15 | 1.17 | 1.19 | 1.71 | 830415 | 4152076 | 16.2 | 0.12 | 0.0 | 8.7% | 0% | 0% | 6.83 | 5.9x |
| 9 | 500 | 17 | 1.38 | 1.38 | 2.00 | 716640 | 3583202 | 16.1 | 0.12 | 0.0 | 10.5% | 0% | 0% | 8.08 | 5.9x |
| 10 | 500 | 19 | 1.46 | 1.52 | 2.12 | 653623 | 3268117 | 16.1 | 0.12 | 0.0 | 12.3% | 0% | 0% | 9.04 | 6.2x |
| 11 | 500 | 21 | 1.79 | 1.85 | 2.58 | 536797 | 2683987 | 17.4 | 0.12 | 0.0 | 24.7% | 0% | 0% | 10.83 | 6.0x |
| 12 | 500 | 24 | 1.88 | 1.94 | 2.58 | 512593 | 2562963 | 16.5 | 0.12 | 0.0 | 24.3% | 0% | 0% | 12.19 | 6.5x |
| 13 | 500 | 25 | 2.00 | 2.14 | 3.17 | 463135 | 2315673 | 17.1 | 0.12 | 0.0 | 49.4% | 0% | 0% | 13.06 | 6.5x |
| 14 | 500 | 28 | 2.12 | 2.19 | 2.96 | 453093 | 2265467 | 15.9 | 0.12 | 0.0 | 15.5% | 0% | 0% | 14.12 | 6.6x |
| 15 | 500 | 30 | 2.25 | 2.29 | 3.00 | 433319 | 2166597 | 15.6 | 0.12 | 0.0 | 4.5% | 0% | 0% | 15.12 | 6.7x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 519.29 | 3.71 | 0.71 | 100 | 3.92 | 0.71 | 733x | 5.2x | 5.5x |
| 6 | 100 | 612.79 | 4.88 | 0.88 | 100 | 4.79 | 0.88 | 700x | 5.6x | 5.5x |
| 7 | 100 | 629.79 | 6.04 | 1.21 | 100 | 5.21 | 1.21 | 521x | 5.0x | 4.3x |
| 8 | 100 | 666.38 | 6.54 | 1.12 | 100 | 6.00 | 1.12 | 592x | 5.8x | 5.3x |
| 9 | 100 | 734.48 | 8.04 | 1.33 | 100 | 7.08 | 1.33 | 551x | 6.0x | 5.3x |
| 10 | 100 | 796.42 | 9.17 | 1.50 | 100 | 8.10 | 1.50 | 531x | 6.1x | 5.4x |
| 11 | 100 | 850.96 | 10.48 | 1.75 | 100 | 8.67 | 1.75 | 486x | 6.0x | 5.0x |
| 12 | 100 | 894.98 | 11.71 | 1.79 | 100 | 9.33 | 1.79 | 499x | 6.5x | 5.2x |
| 13 | 100 | 939.29 | 13.04 | 1.98 | 100 | 10.46 | 1.98 | 475x | 6.6x | 5.3x |
| 14 | 100 | 1033.06 | 14.54 | 2.17 | 100 | 11.83 | 2.17 | 477x | 6.7x | 5.5x |
| 15 | 100 | 1059.94 | 14.79 | 2.21 | 100 | 12.50 | 2.21 | 480x | 6.7x | 5.7x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 63.3 ms median over 5 problems, range 61.7-93.1 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.12 | 1.30 | 2.38 | 763398 | 3816989 | 23.5 | 0.77 | 0.0 | 16.0% | 58% | 0% | 4.17 | 3.7x |
| 6 | 500 | 14 | 1.50 | 1.73 | 3.54 | 573323 | 2866616 | 24.3 | 0.76 | 0.0 | 87.9% | 66% | 0% | 5.21 | 3.5x |
| 7 | 500 | 18 | 1.67 | 1.74 | 3.04 | 570863 | 2854316 | 19.3 | 0.80 | 0.0 | 8.8% | 70% | 0% | 6.12 | 3.7x |
| 8 | 500 | 22 | 1.75 | 1.80 | 3.38 | 552593 | 2762965 | 16.7 | 0.83 | 0.0 | 1.6% | 75% | 0% | 6.58 | 3.8x |
| 9 | 500 | 25 | 1.88 | 2.05 | 3.79 | 484751 | 2423753 | 16.8 | 0.90 | 0.0 | 16.4% | 79% | 0% | 6.96 | 3.7x |
| 10 | 500 | 29 | 2.04 | 2.36 | 5.00 | 420881 | 2104407 | 16.6 | 0.88 | 0.0 | 64.3% | 80% | 0% | 6.23 | 3.1x |
| 11 | 500 | 32 | 1.60 | 1.99 | 4.38 | 498621 | 2493103 | 12.5 | 0.86 | 0.0 | 7.1% | 82% | 0% | 5.54 | 3.5x |
| 12 | 500 | 36 | 1.71 | 2.28 | 6.12 | 435531 | 2177654 | 12.9 | 0.83 | 0.0 | 134.1% | 84% | 0% | 5.12 | 3.0x |
| 13 | 500 | 39 | 1.38 | 1.81 | 4.33 | 549239 | 2746196 | 9.3 | 0.76 | 0.0 | 13.2% | 85% | 0% | 4.62 | 3.4x |
| 14 | 500 | 44 | 1.42 | 1.92 | 4.75 | 516094 | 2580468 | 8.9 | 0.80 | 0.0 | 20.7% | 84% | 0% | 4.83 | 3.4x |
| 15 | 500 | 47 | 1.46 | 1.98 | 5.25 | 501706 | 2508530 | 8.6 | 0.87 | 0.0 | 8.5% | 83% | 0% | 5.12 | 3.5x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 528.60 | 4.17 | 1.12 | 100 | 3.90 | 1.12 | 470x | 3.7x | 3.5x |
| 6 | 100 | 610.50 | 5.08 | 1.46 | 100 | 4.92 | 1.46 | 419x | 3.5x | 3.4x |
| 7 | 100 | 684.85 | 6.06 | 1.62 | 100 | 6.40 | 1.62 | 421x | 3.7x | 3.9x |
| 8 | 100 | 753.21 | 6.15 | 1.62 | 100 | 6.46 | 1.62 | 464x | 3.8x | 4.0x |
| 9 | 100 | 840.48 | 7.60 | 2.00 | 100 | 7.83 | 2.00 | 420x | 3.8x | 3.9x |
| 10 | 100 | 874.85 | 7.52 | 2.21 | 100 | 8.83 | 2.21 | 396x | 3.4x | 4.0x |
| 11 | 100 | 998.67 | 6.60 | 1.98 | 100 | 9.10 | 1.98 | 505x | 3.3x | 4.6x |
| 12 | 100 | 1044.15 | 4.46 | 1.56 | 100 | 9.35 | 1.56 | 668x | 2.9x | 6.0x |
| 13 | 100 | 1119.73 | 4.58 | 1.31 | 100 | 10.67 | 1.31 | 853x | 3.5x | 8.1x |
| 14 | 100 | 1196.60 | 5.06 | 1.42 | 100 | 11.60 | 1.42 | 845x | 3.6x | 8.2x |
| 15 | 100 | 1269.65 | 4.54 | 1.33 | 100 | 12.17 | 1.33 | 952x | 3.4x | 9.1x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.50 | 0.52 | 0.67 | 1887207 | 9436035 | 15.1 | 0.36 | 0.0 | 5.7% | 0% | 0% | 3.79 | 7.6x |
| 6 | 500 | 10 | 0.67 | 0.71 | 0.88 | 1384563 | 6922814 | 14.4 | 0.36 | 0.0 | 4.2% | 0% | 0% | 5.29 | 7.9x |
| 7 | 500 | 11 | 1.04 | 27.79 | 154.21 | 35959 | 179797 | 492.6 | 0.36 | 0.0 | 0.9% | 0% | 40% | 7.08 | 6.8x |
| 8 | 500 | 15 | 1.17 | 49.41 | 295.29 | 20230 | 101152 | 671.5 | 0.36 | 0.0 | 1.3% | 0% | 45% | 7.71 | 6.6x |
| 9 | 500 | 18 | 1.38 | 69.07 | 438.13 | 14474 | 72372 | 774.8 | 0.36 | 0.0 | 3.2% | 0% | 48% | 8.29 | 6.0x |
| 10 | 500 | 20 | 1.50 | 94.31 | 511.00 | 10602 | 53009 | 942.9 | 0.36 | 0.0 | 0.6% | 0% | 65% | 9.48 | 6.3x |
| 11 | 500 | 23 | 1.50 | 89.83 | 509.79 | 11131 | 55653 | 768.9 | 0.36 | 0.0 | 0.9% | 0% | 71% | 9.17 | 6.1x |
| 12 | 500 | 27 | 1.71 | 120.41 | 652.76 | 8304 | 41520 | 908.2 | 0.36 | 0.0 | 0.8% | 0% | 71% | 10.35 | 6.1x |
| 13 | 500 | 29 | 1.58 | 117.43 | 638.67 | 8514 | 42571 | 812.4 | 0.36 | 0.0 | 0.4% | 0% | 79% | 9.67 | 6.1x |
| 14 | 500 | 33 | 1.71 | 141.99 | 754.12 | 7042 | 35209 | 866.0 | 0.36 | 0.0 | 0.2% | 0% | 84% | 10.04 | 5.9x |
| 15 | 500 | 36 | 1.79 | 164.14 | 852.14 | 6092 | 30459 | 916.6 | 0.36 | 0.0 | 2.6% | 0% | 85% | 9.94 | 5.5x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.01 | 2.2% | 199 | 68.30 | 97.8% |
| 8 | 273 | 1.13 | 1.3% | 227 | 107.48 | 98.7% |
| 9 | 260 | 1.29 | 1.0% | 240 | 142.51 | 99.0% |
| 10 | 174 | 1.46 | 0.5% | 326 | 143.86 | 99.4% |
| 11 | 143 | 1.48 | 0.5% | 357 | 125.22 | 99.5% |
| 12 | 144 | 1.66 | 0.4% | 356 | 168.44 | 99.6% |
| 13 | 103 | 1.58 | 0.3% | 397 | 147.49 | 99.7% |
| 14 | 81 | 1.74 | 0.2% | 419 | 169.10 | 99.8% |
| 15 | 74 | 1.88 | 0.2% | 426 | 192.32 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 430.69 | 3.67 | 0.54 | 100 | 1.88 | 0.54 | 796x | 6.8x | 3.5x |
| 6 | 100 | 506.00 | 5.25 | 0.71 | 100 | 2.67 | 0.71 | 715x | 7.4x | 3.8x |
| 7 | 100 | 608.21 | 6.85 | 1.00 | 62 | 2.58 | 0.96 | 608x | 6.9x | 2.7x |
| 8 | 100 | 787.23 | 7.65 | 1.12 | 57 | 3.12 | 1.04 | 700x | 6.8x | 3.0x |
| 9 | 100 | 986.90 | 9.48 | 1.46 | 51 | 3.75 | 1.33 | 677x | 6.5x | 2.8x |
| 10 | 100 | 1144.38 | 9.48 | 1.42 | 40 | 3.73 | 1.29 | 808x | 6.7x | 2.9x |
| 11 | 100 | 1345.60 | 8.60 | 1.38 | 24 | 4.12 | 1.54 | 979x | 6.3x | 2.7x |
| 12 | 100 | 1463.46 | 10.23 | 1.67 | 28 | 4.23 | 1.58 | 878x | 6.1x | 2.7x |
| 13 | 100 | 1554.60 | 9.19 | 1.50 | 22 | 4.81 | 1.50 | 1036x | 6.1x | 3.2x |
| 14 | 100 | 1759.08 | 11.50 | 2.00 | 15 | 5.04 | 1.62 | 880x | 5.8x | 3.1x |
| 15 | 100 | 1750.67 | 13.15 | 2.27 | 22 | 5.98 | 2.04 | 771x | 5.8x | 2.9x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.48 | 0.67 | 2012004 | 10060022 | 14.2 | 0.16 | 0.0 | 6.0% | 0% | 0% | 3.08 | 6.7x |
| 6 | 500 | 10 | 0.58 | 0.61 | 0.83 | 1600682 | 8003411 | 12.5 | 0.16 | 0.0 | 14.8% | 0% | 0% | 4.46 | 7.6x |
| 7 | 500 | 11 | 0.79 | 14.53 | 97.29 | 68776 | 343878 | 257.6 | 0.16 | 0.0 | 1.9% | 0% | 40% | 5.17 | 6.5x |
| 8 | 500 | 15 | 0.92 | 34.43 | 191.21 | 29031 | 145154 | 468.0 | 0.16 | 0.0 | 3.1% | 0% | 45% | 5.54 | 6.0x |
| 9 | 500 | 18 | 1.00 | 46.16 | 281.46 | 21654 | 108272 | 517.9 | 0.16 | 0.0 | 0.4% | 0% | 48% | 6.58 | 6.6x |
| 10 | 500 | 20 | 1.17 | 60.27 | 299.79 | 16587 | 82933 | 602.7 | 0.16 | 0.0 | 0.1% | 0% | 65% | 7.29 | 6.3x |
| 11 | 500 | 23 | 1.08 | 66.41 | 337.55 | 15054 | 75269 | 568.5 | 0.16 | 0.0 | 0.5% | 0% | 71% | 7.12 | 6.6x |
| 12 | 500 | 27 | 1.19 | 82.29 | 422.63 | 12150 | 60751 | 620.7 | 0.16 | 0.0 | 0.5% | 0% | 71% | 7.69 | 6.5x |
| 13 | 500 | 29 | 1.17 | 80.83 | 430.28 | 12369 | 61846 | 559.2 | 0.16 | 0.0 | 0.4% | 0% | 79% | 6.92 | 5.9x |
| 14 | 500 | 33 | 1.29 | 102.50 | 489.99 | 9754 | 48772 | 625.1 | 0.16 | 0.0 | 0.3% | 0% | 84% | 7.90 | 6.1x |
| 15 | 500 | 36 | 1.33 | 106.80 | 558.88 | 9361 | 46807 | 596.4 | 0.16 | 0.0 | 0.6% | 0% | 85% | 7.90 | 5.9x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.82 | 3.4% | 199 | 35.25 | 96.5% |
| 8 | 273 | 0.94 | 1.5% | 227 | 74.70 | 98.5% |
| 9 | 260 | 1.02 | 1.2% | 240 | 95.07 | 98.8% |
| 10 | 174 | 1.12 | 0.6% | 326 | 91.85 | 99.3% |
| 11 | 143 | 1.16 | 0.5% | 357 | 92.55 | 99.5% |
| 12 | 144 | 1.21 | 0.4% | 356 | 115.08 | 99.6% |
| 13 | 103 | 1.29 | 0.3% | 397 | 101.47 | 99.7% |
| 14 | 81 | 1.44 | 0.2% | 419 | 122.04 | 99.8% |
| 15 | 74 | 1.38 | 0.2% | 426 | 125.12 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 430.42 | 3.08 | 0.50 | 100 | 1.81 | 0.50 | 861x | 6.2x | 3.6x |
| 6 | 100 | 504.42 | 4.54 | 0.67 | 100 | 2.50 | 0.67 | 756x | 6.8x | 3.7x |
| 7 | 100 | 605.65 | 4.17 | 0.79 | 62 | 2.54 | 0.79 | 765x | 5.3x | 3.2x |
| 8 | 100 | 802.58 | 5.62 | 0.88 | 57 | 2.96 | 0.88 | 917x | 6.4x | 3.4x |
| 9 | 100 | 1026.69 | 6.25 | 1.00 | 51 | 3.46 | 1.08 | 1027x | 6.2x | 3.2x |
| 10 | 100 | 12120.25 | 7.67 | 1.12 | 40 | 3.75 | 1.00 | 10774x | 6.8x | 3.8x |
| 11 | 100 | 15717.62 | 6.54 | 1.04 | 24 | 3.77 | 1.19 | 15099x | 6.3x | 3.2x |
| 12 | 100 | 17054.42 | 6.83 | 1.00 | 28 | 4.31 | 1.00 | 17054x | 6.8x | 4.3x |
| 13 | 100 | 17911.33 | 6.92 | 1.12 | 22 | 4.56 | 1.17 | 15921x | 6.1x | 3.9x |
| 14 | 100 | 19814.12 | 8.58 | 1.29 | 15 | 6.17 | 1.38 | 15342x | 6.6x | 4.5x |
| 15 | 100 | 20217.33 | 9.54 | 1.38 | 22 | 5.44 | 1.08 | 14704x | 6.9x | 5.0x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.88 | 0.89 | 1.12 | 1105828 | 5529141 | 25.8 | 0.79 | 0.0 | 15.4% | 0% | 0% | 3.67 | 4.2x |
| 6 | 500 | 10 | 1.17 | 1.19 | 1.46 | 828935 | 4144674 | 24.1 | 1.00 | 0.0 | 5.3% | 0% | 0% | 5.25 | 4.5x |
| 7 | 500 | 11 | 1.42 | 42.02 | 336.65 | 23790 | 118949 | 743.1 | 26.36 | 0.0 | 3.6% | 1% | 39% | 6.12 | 4.3x |
| 8 | 500 | 15 | 1.62 | 64.31 | 525.93 | 15544 | 77721 | 869.9 | 43.93 | 0.0 | 1.1% | 3% | 43% | 6.54 | 4.0x |
| 9 | 500 | 18 | 1.88 | 79.69 | 717.17 | 12547 | 62734 | 887.4 | 51.52 | 0.0 | 0.7% | 5% | 46% | 8.00 | 4.3x |
| 10 | 500 | 20 | 2.00 | 137.31 | 881.43 | 7282 | 36410 | 1368.5 | 55.40 | 0.0 | 0.6% | 5% | 63% | 8.21 | 4.1x |
| 11 | 500 | 23 | 2.00 | 140.61 | 952.92 | 7111 | 35556 | 1201.7 | 60.84 | 0.0 | 0.6% | 7% | 69% | 8.46 | 4.2x |
| 12 | 500 | 27 | 2.00 | 151.59 | 1048.78 | 6596 | 32979 | 1143.0 | 71.40 | 0.0 | 0.5% | 5% | 71% | 8.33 | 4.2x |
| 13 | 500 | 29 | 2.08 | 164.39 | 1067.04 | 6083 | 30413 | 1134.2 | 61.35 | 0.0 | 1.5% | 5% | 78% | 8.50 | 4.1x |
| 14 | 500 | 33 | 2.00 | 163.16 | 1136.39 | 6128 | 30642 | 994.9 | 69.94 | 0.0 | 0.3% | 5% | 83% | 8.17 | 4.1x |
| 15 | 500 | 36 | 1.88 | 169.10 | 1248.06 | 5913 | 29565 | 944.7 | 68.70 | 0.0 | 0.7% | 8% | 84% | 7.58 | 4.0x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.48 | 2.1% | 196 | 104.90 | 97.8% |
| 8 | 285 | 1.72 | 1.5% | 215 | 147.29 | 98.4% |
| 9 | 272 | 2.00 | 1.4% | 228 | 172.36 | 98.6% |
| 10 | 184 | 2.10 | 0.6% | 316 | 216.04 | 99.4% |
| 11 | 154 | 2.17 | 0.5% | 346 | 202.22 | 99.5% |
| 12 | 146 | 2.24 | 0.4% | 354 | 213.19 | 99.6% |
| 13 | 109 | 2.37 | 0.3% | 391 | 209.55 | 99.7% |
| 14 | 86 | 2.41 | 0.3% | 414 | 196.55 | 99.7% |
| 15 | 78 | 2.45 | 0.2% | 422 | 199.90 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 433.08 | 3.71 | 0.88 | 100 | 2.04 | 0.88 | 495x | 4.2x | 2.3x |
| 6 | 100 | 507.40 | 5.29 | 1.25 | 100 | 2.96 | 1.25 | 406x | 4.2x | 2.4x |
| 7 | 100 | 618.12 | 4.92 | 1.29 | 62 | 3.21 | 1.38 | 478x | 3.8x | 2.3x |
| 8 | 100 | 801.54 | 6.50 | 1.58 | 58 | 3.58 | 1.67 | 506x | 4.1x | 2.1x |
| 9 | 100 | 1060.60 | 8.10 | 1.92 | 52 | 4.00 | 1.92 | 554x | 4.2x | 2.1x |
| 10 | 100 | 4837.54 | 7.12 | 1.79 | 44 | 3.92 | 1.79 | 2700x | 4.0x | 2.2x |
| 11 | 100 | 12140.98 | 9.73 | 2.12 | 25 | 4.29 | 2.12 | 5713x | 4.6x | 2.0x |
| 12 | 100 | 10522.56 | 6.79 | 1.75 | 30 | 4.23 | 1.92 | 6013x | 3.9x | 2.2x |
| 13 | 100 | 12834.65 | 8.38 | 2.04 | 22 | 5.15 | 2.15 | 6285x | 4.1x | 2.4x |
| 14 | 100 | 13180.31 | 8.00 | 1.94 | 16 | 6.02 | 2.21 | 6803x | 4.1x | 2.7x |
| 15 | 100 | 13701.98 | 9.15 | 2.12 | 24 | 5.25 | 2.23 | 6448x | 4.3x | 2.4x |

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

