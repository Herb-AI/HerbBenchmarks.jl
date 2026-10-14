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
| DeepCoder_2016 | 696872 | 322165 | 215781 |
| PBE_BV_Track_2018 | 1294080 | 675782 | 444487 |
| PBE_SLIA_Track_2019 | 785464 | 498136 | 505314 |
| Robots_2020 | 2181421 | 10890 | 6186 |
| Pixels_2020 | 2024496 | 15651 | 9101 |
| String_transformations_2020 | 1147710 | 7348 | 5931 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 141.5 ms median over 5 problems, range 0.2-200.3 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.38 | 1.42 | 2.00 | 696872 | 3484362 | 37.2 | 3.38 | 0.0 | 14.1% | 9% | 0% | 5.58 | 4.1x |
| 6 | 500 | 10 | 1.67 | 1.72 | 2.50 | 574977 | 2874886 | 36.1 | 4.27 | 0.0 | 7.8% | 17% | 0% | 7.17 | 4.3x |
| 7 | 500 | 12 | 1.96 | 2.02 | 2.83 | 490838 | 2454189 | 35.1 | 5.06 | 0.0 | 2.8% | 20% | 0% | 8.96 | 4.6x |
| 8 | 500 | 14 | 2.33 | 2.43 | 3.42 | 408210 | 2041052 | 35.9 | 5.61 | 0.0 | 13.7% | 25% | 0% | 10.77 | 4.6x |
| 9 | 500 | 16 | 2.62 | 2.70 | 3.75 | 368725 | 1843624 | 34.7 | 6.13 | 0.0 | 8.9% | 26% | 0% | 12.33 | 4.7x |
| 10 | 500 | 18 | 3.00 | 3.09 | 4.25 | 322165 | 1610825 | 35.4 | 6.86 | 0.0 | 13.5% | 29% | 0% | 14.08 | 4.7x |
| 11 | 500 | 20 | 3.25 | 3.32 | 4.46 | 299889 | 1499445 | 33.8 | 7.64 | 0.0 | 1.4% | 34% | 0% | 16.38 | 5.0x |
| 12 | 500 | 21 | 3.46 | 3.55 | 4.75 | 280253 | 1401267 | 33.2 | 7.72 | 0.0 | 6.8% | 37% | 0% | 18.58 | 5.4x |
| 13 | 500 | 24 | 3.96 | 4.04 | 5.46 | 246762 | 1233811 | 34.1 | 8.04 | 0.0 | 19.9% | 39% | 0% | 20.62 | 5.2x |
| 14 | 500 | 25 | 4.12 | 4.21 | 5.67 | 236539 | 1182695 | 33.3 | 8.49 | 0.0 | 3.6% | 42% | 0% | 21.58 | 5.2x |
| 15 | 500 | 28 | 4.54 | 4.62 | 6.04 | 215781 | 1078904 | 33.6 | 8.96 | 0.0 | 12.7% | 45% | 0% | 24.08 | 5.3x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | eval speed-up | v1 speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 598.58 | 5.96 | 1.33 | 449x | 4.5x | 100 | 3.83 | 1.33 | 2.9x |
| 6 | 100 | 627.46 | 7.21 | 1.67 | 377x | 4.3x | 100 | 4.54 | 1.67 | 2.7x |
| 7 | 100 | 688.35 | 9.50 | 2.00 | 344x | 4.8x | 100 | 5.62 | 2.00 | 2.8x |
| 8 | 100 | 737.15 | 11.23 | 2.48 | 297x | 4.5x | 100 | 6.79 | 2.48 | 2.7x |
| 9 | 100 | 773.31 | 12.08 | 2.62 | 295x | 4.6x | 100 | 7.58 | 2.62 | 2.9x |
| 10 | 100 | 836.29 | 14.65 | 3.08 | 271x | 4.8x | 100 | 8.67 | 3.08 | 2.8x |
| 11 | 100 | 882.33 | 16.65 | 3.33 | 265x | 5.0x | 100 | 9.75 | 3.33 | 2.9x |
| 12 | 100 | 921.23 | 18.52 | 3.50 | 263x | 5.3x | 100 | 10.42 | 3.50 | 3.0x |
| 13 | 100 | 969.08 | 19.81 | 3.96 | 245x | 5.0x | 100 | 11.46 | 3.96 | 2.9x |
| 14 | 100 | 1024.90 | 21.71 | 4.25 | 241x | 5.1x | 100 | 12.75 | 4.25 | 3.0x |
| 15 | 100 | 1071.88 | 23.75 | 4.71 | 228x | 5.0x | 100 | 13.40 | 4.71 | 2.8x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-30.1 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.71 | 0.76 | 1.25 | 1294080 | 6470401 | 17.7 | 0.12 | 0.0 | 41.2% | 0% | 0% | 3.54 | 5.0x |
| 6 | 500 | 11 | 0.83 | 0.87 | 1.33 | 1128584 | 5642918 | 16.0 | 0.12 | 0.0 | 5.0% | 0% | 0% | 4.75 | 5.7x |
| 7 | 500 | 13 | 1.04 | 1.07 | 1.58 | 920132 | 4600662 | 16.6 | 0.12 | 0.0 | 3.5% | 0% | 0% | 5.75 | 5.5x |
| 8 | 500 | 15 | 1.17 | 1.18 | 1.71 | 836575 | 4182874 | 16.1 | 0.12 | 0.0 | 9.9% | 0% | 0% | 6.62 | 5.7x |
| 9 | 500 | 17 | 1.33 | 1.37 | 1.96 | 722161 | 3610803 | 15.9 | 0.12 | 0.0 | 8.6% | 0% | 0% | 7.67 | 5.7x |
| 10 | 500 | 19 | 1.46 | 1.47 | 2.04 | 675782 | 3378911 | 15.6 | 0.12 | 0.0 | 9.6% | 0% | 0% | 8.75 | 6.0x |
| 11 | 500 | 21 | 1.62 | 1.63 | 2.21 | 608205 | 3041024 | 15.3 | 0.12 | 0.0 | 9.0% | 0% | 0% | 10.42 | 6.4x |
| 12 | 500 | 24 | 1.79 | 1.79 | 2.46 | 553587 | 2767936 | 15.3 | 0.12 | 0.0 | 14.1% | 0% | 0% | 11.62 | 6.5x |
| 13 | 500 | 25 | 1.92 | 1.93 | 2.62 | 515486 | 2577431 | 15.4 | 0.12 | 0.0 | 14.2% | 0% | 0% | 12.46 | 6.5x |
| 14 | 500 | 28 | 2.08 | 2.12 | 2.88 | 467789 | 2338944 | 15.4 | 0.12 | 0.0 | 13.2% | 0% | 0% | 13.46 | 6.5x |
| 15 | 500 | 30 | 2.21 | 2.24 | 2.96 | 444487 | 2222437 | 15.2 | 0.12 | 0.0 | 10.4% | 0% | 0% | 14.54 | 6.6x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | eval speed-up | v1 speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 515.02 | 3.54 | 0.73 | 706x | 4.9x | 100 | 3.67 | 0.73 | 5.0x |
| 6 | 100 | 575.65 | 4.92 | 0.88 | 658x | 5.6x | 100 | 4.46 | 0.88 | 5.1x |
| 7 | 100 | 618.21 | 5.71 | 1.04 | 593x | 5.5x | 100 | 5.12 | 1.04 | 4.9x |
| 8 | 100 | 659.56 | 6.50 | 1.12 | 586x | 5.8x | 100 | 5.96 | 1.12 | 5.3x |
| 9 | 100 | 732.60 | 7.67 | 1.29 | 567x | 5.9x | 100 | 6.85 | 1.29 | 5.3x |
| 10 | 100 | 780.73 | 8.88 | 1.46 | 535x | 6.1x | 100 | 7.58 | 1.46 | 5.2x |
| 11 | 100 | 817.48 | 10.08 | 1.54 | 530x | 6.5x | 100 | 8.23 | 1.54 | 5.3x |
| 12 | 100 | 869.00 | 10.85 | 1.75 | 497x | 6.2x | 100 | 9.29 | 1.75 | 5.3x |
| 13 | 100 | 930.40 | 12.62 | 1.96 | 475x | 6.4x | 100 | 10.25 | 1.96 | 5.2x |
| 14 | 100 | 1005.17 | 13.75 | 2.17 | 464x | 6.3x | 100 | 11.58 | 2.17 | 5.3x |
| 15 | 100 | 1027.83 | 14.33 | 2.17 | 474x | 6.6x | 100 | 11.88 | 2.17 | 5.5x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 62.1 ms median over 5 problems, range 59.4-66.2 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.12 | 1.26 | 2.33 | 785464 | 3927318 | 22.8 | 0.77 | 0.0 | 9.9% | 58% | 0% | 4.04 | 3.6x |
| 6 | 500 | 14 | 1.38 | 1.47 | 2.62 | 672993 | 3364963 | 20.7 | 0.76 | 0.0 | 3.4% | 66% | 0% | 4.79 | 3.5x |
| 7 | 500 | 18 | 1.62 | 1.69 | 2.92 | 587164 | 2935822 | 18.8 | 0.80 | 0.0 | 5.8% | 70% | 0% | 5.88 | 3.6x |
| 8 | 500 | 22 | 1.75 | 1.78 | 3.29 | 558405 | 2792023 | 16.5 | 0.83 | 0.0 | 4.2% | 75% | 0% | 6.21 | 3.5x |
| 9 | 500 | 25 | 1.83 | 1.92 | 3.54 | 518206 | 2591031 | 15.7 | 0.90 | 0.0 | 5.3% | 79% | 0% | 6.67 | 3.6x |
| 10 | 500 | 29 | 1.77 | 1.99 | 4.17 | 498136 | 2490680 | 14.1 | 0.88 | 0.0 | 4.5% | 80% | 0% | 6.02 | 3.4x |
| 11 | 500 | 32 | 1.54 | 1.93 | 4.21 | 515561 | 2577806 | 12.1 | 0.86 | 0.0 | 5.1% | 82% | 0% | 5.46 | 3.5x |
| 12 | 500 | 36 | 1.46 | 1.81 | 4.25 | 549053 | 2745267 | 10.2 | 0.83 | 0.0 | 3.5% | 84% | 0% | 4.96 | 3.4x |
| 13 | 500 | 39 | 1.29 | 1.74 | 4.17 | 571679 | 2858395 | 8.9 | 0.76 | 0.0 | 4.2% | 85% | 0% | 4.54 | 3.5x |
| 14 | 500 | 44 | 1.38 | 1.81 | 4.46 | 549541 | 2747707 | 8.3 | 0.80 | 0.0 | 1.2% | 84% | 0% | 4.75 | 3.5x |
| 15 | 500 | 47 | 1.46 | 1.97 | 5.21 | 505314 | 2526571 | 8.5 | 0.87 | 0.0 | 5.1% | 83% | 0% | 4.96 | 3.4x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | eval speed-up | v1 speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 519.58 | 4.00 | 1.08 | 479x | 3.7x | 100 | 3.81 | 1.08 | 3.5x |
| 6 | 100 | 589.08 | 4.62 | 1.38 | 428x | 3.4x | 100 | 4.75 | 1.38 | 3.5x |
| 7 | 100 | 658.50 | 5.71 | 1.62 | 405x | 3.5x | 100 | 5.92 | 1.62 | 3.6x |
| 8 | 100 | 725.60 | 6.02 | 1.62 | 447x | 3.7x | 100 | 6.54 | 1.62 | 4.0x |
| 9 | 100 | 809.62 | 7.33 | 2.02 | 401x | 3.6x | 100 | 7.54 | 2.02 | 3.7x |
| 10 | 100 | 861.79 | 7.17 | 2.04 | 422x | 3.5x | 100 | 8.46 | 2.04 | 4.1x |
| 11 | 100 | 930.77 | 6.42 | 1.88 | 496x | 3.4x | 100 | 8.88 | 1.88 | 4.7x |
| 12 | 100 | 1029.29 | 4.21 | 1.25 | 823x | 3.4x | 100 | 9.50 | 1.25 | 7.6x |
| 13 | 100 | 1106.33 | 4.54 | 1.25 | 885x | 3.6x | 100 | 10.85 | 1.25 | 8.7x |
| 14 | 100 | 1181.77 | 4.92 | 1.33 | 887x | 3.7x | 100 | 11.67 | 1.33 | 8.8x |
| 15 | 100 | 1258.48 | 4.54 | 1.29 | 974x | 3.5x | 100 | 13.02 | 1.29 | 10.1x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.42 | 0.44 | 0.62 | 2181421 | 10907105 | 13.1 | 0.36 | 0.0 | 6.2% | 0% | 0% | 3.54 | 8.5x |
| 6 | 500 | 10 | 0.67 | 0.70 | 0.83 | 1409741 | 7048707 | 14.2 | 0.36 | 0.0 | 5.3% | 0% | 0% | 5.04 | 7.6x |
| 7 | 500 | 11 | 1.00 | 26.16 | 146.17 | 38204 | 191021 | 463.7 | 0.36 | 0.0 | 1.5% | 0% | 40% | 6.54 | 6.5x |
| 8 | 500 | 15 | 1.17 | 47.78 | 286.96 | 20922 | 104612 | 649.3 | 0.36 | 0.0 | 0.8% | 0% | 45% | 7.29 | 6.2x |
| 9 | 500 | 18 | 1.42 | 67.17 | 428.29 | 14883 | 74417 | 753.5 | 0.36 | 0.0 | 1.4% | 0% | 48% | 8.12 | 5.7x |
| 10 | 500 | 20 | 1.54 | 91.81 | 501.25 | 10890 | 54452 | 917.9 | 0.36 | 0.0 | 0.4% | 0% | 65% | 9.25 | 6.0x |
| 11 | 500 | 23 | 1.54 | 88.60 | 504.55 | 11285 | 56424 | 758.4 | 0.36 | 0.0 | 3.7% | 0% | 71% | 8.83 | 5.7x |
| 12 | 500 | 27 | 1.71 | 118.01 | 643.06 | 8473 | 42365 | 890.1 | 0.36 | 0.0 | 0.8% | 0% | 71% | 10.21 | 6.0x |
| 13 | 500 | 29 | 1.65 | 115.59 | 628.48 | 8650 | 43251 | 799.6 | 0.36 | 0.0 | 0.8% | 0% | 79% | 9.42 | 5.7x |
| 14 | 500 | 33 | 1.75 | 140.20 | 747.36 | 7132 | 35658 | 855.1 | 0.36 | 0.0 | 0.5% | 0% | 84% | 9.67 | 5.5x |
| 15 | 500 | 36 | 1.58 | 161.63 | 840.59 | 6186 | 30931 | 902.6 | 0.36 | 0.0 | 1.0% | 0% | 85% | 9.42 | 5.9x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.98 | 2.2% | 199 | 64.25 | 97.7% |
| 8 | 273 | 1.12 | 1.3% | 227 | 103.89 | 98.7% |
| 9 | 260 | 1.33 | 1.0% | 240 | 138.51 | 99.0% |
| 10 | 174 | 1.44 | 0.5% | 326 | 140.04 | 99.4% |
| 11 | 143 | 1.50 | 0.5% | 357 | 123.49 | 99.5% |
| 12 | 144 | 1.60 | 0.4% | 356 | 165.09 | 99.6% |
| 13 | 103 | 1.60 | 0.3% | 397 | 145.16 | 99.7% |
| 14 | 81 | 1.76 | 0.2% | 419 | 166.97 | 99.8% |
| 15 | 74 | 1.69 | 0.2% | 426 | 189.42 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | eval speed-up | v1 speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 429.88 | 3.50 | 0.50 | 860x | 7.0x | 100 | 1.83 | 0.50 | 3.7x |
| 6 | 100 | 503.79 | 4.96 | 0.71 | 712x | 7.0x | 100 | 2.54 | 0.71 | 3.6x |
| 7 | 100 | 594.67 | 6.40 | 0.96 | 621x | 6.7x | 62 | 2.56 | 0.92 | 2.8x |
| 8 | 100 | 767.96 | 7.31 | 1.12 | 683x | 6.5x | 57 | 3.08 | 1.08 | 2.8x |
| 9 | 100 | 965.02 | 8.85 | 1.42 | 681x | 6.2x | 51 | 3.75 | 1.29 | 2.9x |
| 10 | 100 | 1130.67 | 9.06 | 1.42 | 798x | 6.4x | 40 | 3.67 | 1.29 | 2.8x |
| 11 | 100 | 1337.52 | 8.54 | 1.42 | 945x | 6.0x | 24 | 3.96 | 1.48 | 2.7x |
| 12 | 100 | 1444.65 | 10.54 | 1.69 | 856x | 6.2x | 28 | 4.21 | 1.54 | 2.7x |
| 13 | 100 | 1529.40 | 8.96 | 1.50 | 1020x | 6.0x | 22 | 4.98 | 1.42 | 3.5x |
| 14 | 100 | 1704.62 | 11.21 | 1.92 | 889x | 5.8x | 15 | 5.25 | 1.54 | 3.4x |
| 15 | 100 | 1737.69 | 11.96 | 1.96 | 887x | 6.1x | 22 | 5.31 | 1.62 | 3.3x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.48 | 0.67 | 2024496 | 10122482 | 14.1 | 0.16 | 0.0 | 6.3% | 0% | 0% | 3.04 | 6.6x |
| 6 | 500 | 10 | 0.58 | 0.60 | 0.79 | 1615944 | 8079722 | 12.4 | 0.16 | 0.0 | 8.5% | 0% | 0% | 4.33 | 7.4x |
| 7 | 500 | 11 | 0.83 | 14.46 | 97.46 | 69077 | 345386 | 256.4 | 0.16 | 0.0 | 4.2% | 0% | 40% | 5.12 | 6.2x |
| 8 | 500 | 15 | 0.92 | 34.36 | 192.75 | 29091 | 145455 | 467.0 | 0.16 | 0.0 | 1.7% | 0% | 45% | 5.50 | 6.0x |
| 9 | 500 | 18 | 1.04 | 48.15 | 290.84 | 20764 | 103819 | 540.1 | 0.16 | 0.0 | 1.6% | 0% | 48% | 6.62 | 6.4x |
| 10 | 500 | 20 | 1.21 | 63.88 | 317.02 | 15651 | 78256 | 638.7 | 0.16 | 0.0 | 3.3% | 0% | 65% | 7.38 | 6.1x |
| 11 | 500 | 23 | 1.08 | 68.89 | 357.71 | 14512 | 72560 | 589.7 | 0.16 | 0.0 | 0.4% | 0% | 71% | 7.21 | 6.7x |
| 12 | 500 | 27 | 1.25 | 85.94 | 445.09 | 11635 | 58173 | 648.2 | 0.16 | 0.0 | 3.6% | 0% | 71% | 7.69 | 6.2x |
| 13 | 500 | 29 | 1.17 | 83.39 | 454.44 | 11990 | 59950 | 576.9 | 0.16 | 0.0 | 0.6% | 0% | 79% | 7.04 | 6.0x |
| 14 | 500 | 33 | 1.38 | 106.62 | 504.01 | 9378 | 46889 | 650.3 | 0.16 | 0.0 | 1.0% | 0% | 84% | 7.75 | 5.6x |
| 15 | 500 | 36 | 1.33 | 109.86 | 572.46 | 9101 | 45507 | 613.5 | 0.16 | 0.0 | 0.4% | 0% | 85% | 7.79 | 5.8x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.85 | 3.5% | 199 | 35.05 | 96.4% |
| 8 | 273 | 0.93 | 1.5% | 227 | 74.57 | 98.5% |
| 9 | 260 | 1.07 | 1.2% | 240 | 99.15 | 98.8% |
| 10 | 174 | 1.21 | 0.7% | 326 | 97.33 | 99.3% |
| 11 | 143 | 1.16 | 0.5% | 357 | 96.02 | 99.5% |
| 12 | 144 | 1.28 | 0.4% | 356 | 120.18 | 99.6% |
| 13 | 103 | 1.28 | 0.3% | 397 | 104.69 | 99.7% |
| 14 | 81 | 1.53 | 0.2% | 419 | 126.94 | 99.8% |
| 15 | 74 | 1.35 | 0.2% | 426 | 128.71 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | eval speed-up | v1 speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 430.44 | 3.04 | 0.50 | 861x | 6.1x | 100 | 1.79 | 0.50 | 3.6x |
| 6 | 100 | 504.42 | 4.33 | 0.58 | 864x | 7.4x | 100 | 2.46 | 0.58 | 4.2x |
| 7 | 100 | 608.83 | 4.54 | 0.79 | 769x | 5.7x | 62 | 2.56 | 0.83 | 3.1x |
| 8 | 100 | 808.46 | 5.46 | 0.96 | 844x | 5.7x | 57 | 2.92 | 0.92 | 3.2x |
| 9 | 100 | 978.58 | 6.17 | 1.00 | 979x | 6.2x | 51 | 3.50 | 1.08 | 3.2x |
| 10 | 100 | 12253.31 | 7.71 | 1.25 | 9803x | 6.2x | 40 | 3.62 | 1.12 | 3.2x |
| 11 | 100 | 15656.75 | 6.44 | 0.96 | 16326x | 6.7x | 24 | 3.71 | 1.04 | 3.6x |
| 12 | 100 | 16931.79 | 6.98 | 1.12 | 15050x | 6.2x | 28 | 4.25 | 1.12 | 3.8x |
| 13 | 100 | 17959.73 | 7.00 | 1.08 | 16583x | 6.5x | 22 | 5.06 | 1.19 | 4.3x |
| 14 | 100 | 19748.46 | 8.73 | 1.38 | 14363x | 6.3x | 15 | 6.00 | 1.54 | 3.9x |
| 15 | 100 | 20088.96 | 9.62 | 1.42 | 14182x | 6.8x | 22 | 5.17 | 1.17 | 4.4x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.83 | 0.86 | 1.04 | 1147710 | 5738549 | 24.9 | 0.79 | 0.0 | 6.7% | 0% | 0% | 3.75 | 4.5x |
| 6 | 500 | 10 | 1.17 | 1.19 | 1.46 | 828158 | 4140788 | 24.1 | 1.00 | 0.0 | 9.1% | 0% | 0% | 5.46 | 4.7x |
| 7 | 500 | 11 | 1.42 | 42.36 | 340.68 | 23598 | 117989 | 749.1 | 26.36 | 0.0 | 1.2% | 1% | 39% | 6.08 | 4.3x |
| 8 | 500 | 15 | 1.58 | 65.28 | 535.55 | 15315 | 76577 | 882.9 | 43.93 | 0.0 | 0.8% | 3% | 43% | 6.42 | 4.1x |
| 9 | 500 | 18 | 1.83 | 79.76 | 726.61 | 12535 | 62676 | 888.2 | 51.52 | 0.0 | 0.9% | 5% | 46% | 7.88 | 4.3x |
| 10 | 500 | 20 | 2.00 | 136.07 | 878.65 | 7348 | 36741 | 1356.1 | 55.40 | 0.0 | 0.4% | 5% | 63% | 8.12 | 4.1x |
| 11 | 500 | 23 | 2.00 | 141.30 | 960.59 | 7076 | 35382 | 1207.6 | 60.84 | 0.0 | 0.7% | 7% | 69% | 8.42 | 4.2x |
| 12 | 500 | 27 | 2.00 | 151.51 | 1046.03 | 6600 | 32998 | 1142.3 | 71.40 | 0.0 | 1.2% | 5% | 71% | 8.46 | 4.2x |
| 13 | 500 | 29 | 2.08 | 163.09 | 1060.78 | 6131 | 30654 | 1125.3 | 61.35 | 0.0 | 0.6% | 5% | 78% | 8.54 | 4.1x |
| 14 | 500 | 33 | 2.00 | 162.31 | 1148.70 | 6160 | 30802 | 989.8 | 69.94 | 0.0 | 0.6% | 5% | 83% | 8.29 | 4.1x |
| 15 | 500 | 36 | 1.92 | 168.58 | 1239.15 | 5931 | 29657 | 941.8 | 68.70 | 0.0 | 0.7% | 8% | 84% | 7.75 | 4.0x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.43 | 2.1% | 196 | 105.83 | 97.9% |
| 8 | 285 | 1.71 | 1.5% | 215 | 149.55 | 98.5% |
| 9 | 272 | 1.93 | 1.3% | 228 | 172.60 | 98.7% |
| 10 | 184 | 2.06 | 0.6% | 316 | 214.10 | 99.4% |
| 11 | 154 | 2.20 | 0.5% | 346 | 203.21 | 99.5% |
| 12 | 146 | 2.24 | 0.4% | 354 | 213.07 | 99.6% |
| 13 | 109 | 2.35 | 0.3% | 391 | 207.90 | 99.7% |
| 14 | 86 | 2.41 | 0.3% | 414 | 195.53 | 99.7% |
| 15 | 78 | 2.49 | 0.2% | 422 | 199.28 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs

| depth | progs | eval us | v1 us | custom us | eval speed-up | v1 speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.42 | 3.79 | 0.83 | 517x | 4.5x | 100 | 2.00 | 0.83 | 2.4x |
| 6 | 100 | 506.67 | 5.58 | 1.21 | 419x | 4.6x | 100 | 2.83 | 1.21 | 2.3x |
| 7 | 100 | 609.29 | 4.79 | 1.29 | 472x | 3.7x | 62 | 2.79 | 1.35 | 2.1x |
| 8 | 100 | 796.29 | 6.33 | 1.62 | 490x | 3.9x | 58 | 3.46 | 1.71 | 2.0x |
| 9 | 100 | 959.15 | 7.96 | 1.85 | 517x | 4.3x | 52 | 3.96 | 1.88 | 2.1x |
| 10 | 100 | 4736.73 | 7.04 | 1.77 | 2675x | 4.0x | 44 | 3.79 | 1.83 | 2.1x |
| 11 | 100 | 12128.06 | 9.56 | 2.17 | 5598x | 4.4x | 25 | 4.42 | 2.21 | 2.0x |
| 12 | 100 | 11679.35 | 6.92 | 1.73 | 6753x | 4.0x | 30 | 4.00 | 1.90 | 2.1x |
| 13 | 100 | 12832.19 | 8.42 | 2.04 | 6286x | 4.1x | 22 | 5.06 | 2.17 | 2.3x |
| 14 | 100 | 13089.02 | 8.08 | 1.92 | 6828x | 4.2x | 16 | 5.94 | 2.17 | 2.7x |
| 15 | 100 | 13622.81 | 9.29 | 2.06 | 6607x | 4.5x | 24 | 5.31 | 2.17 | 2.5x |

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

