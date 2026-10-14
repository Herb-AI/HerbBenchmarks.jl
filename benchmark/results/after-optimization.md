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
| DeepCoder_2016 | 554477 | 287042 | 204479 |
| PBE_BV_Track_2018 | 1309158 | 661668 | 399659 |
| PBE_SLIA_Track_2019 | 759465 | 482028 | 482234 |
| Robots_2020 | 2039914 | 10573 | 6120 |
| Pixels_2020 | 1956881 | 16690 | 9416 |
| String_transformations_2020 | 1150064 | 7332 | 5899 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 141.3 ms median over 5 problems, range 0.2-206.8 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 1.71 | 1.79 | 2.67 | 554477 | 2772386 | 46.7 | 3.38 | 0.0 | 25.4% | 9% | 0% | 6.00 | 3.5x | 1.46 | 0.9x |
| 6 | 500 | 10 | 1.88 | 1.96 | 2.92 | 507177 | 2535883 | 40.9 | 4.27 | 0.0 | 14.9% | 17% | 0% | 7.42 | 4.0x | 1.75 | 0.9x |
| 7 | 500 | 12 | 2.21 | 2.27 | 3.17 | 437139 | 2185697 | 39.4 | 5.06 | 0.0 | 8.7% | 20% | 0% | 9.29 | 4.2x | 2.25 | 1.0x |
| 8 | 500 | 14 | 2.62 | 2.71 | 3.75 | 367247 | 1836233 | 39.9 | 5.61 | 0.0 | 15.1% | 25% | 0% | 11.25 | 4.3x | 2.62 | 1.0x |
| 9 | 500 | 16 | 3.04 | 3.13 | 4.29 | 317913 | 1589564 | 40.3 | 6.13 | 0.0 | 11.7% | 26% | 0% | 13.33 | 4.4x | 2.88 | 0.9x |
| 10 | 500 | 18 | 3.38 | 3.47 | 4.88 | 287042 | 1435208 | 39.8 | 6.86 | 0.0 | 24.6% | 29% | 0% | 15.08 | 4.5x | 3.04 | 0.9x |
| 11 | 500 | 20 | 3.71 | 3.80 | 5.21 | 262215 | 1311074 | 38.6 | 7.64 | 0.0 | 7.6% | 34% | 0% | 17.58 | 4.7x | 3.29 | 0.9x |
| 12 | 500 | 21 | 3.79 | 3.91 | 5.33 | 254485 | 1272426 | 36.6 | 7.72 | 0.0 | 12.9% | 37% | 0% | 18.88 | 5.0x | 3.58 | 0.9x |
| 13 | 500 | 24 | 4.08 | 4.17 | 5.58 | 238858 | 1194291 | 35.3 | 8.04 | 0.0 | 8.6% | 39% | 0% | 20.58 | 5.0x | 3.83 | 0.9x |
| 14 | 500 | 25 | 4.50 | 4.59 | 6.12 | 217340 | 1086701 | 36.2 | 8.49 | 0.0 | 6.2% | 42% | 0% | 22.54 | 5.0x | 4.04 | 0.9x |
| 15 | 500 | 28 | 4.79 | 4.88 | 6.38 | 204479 | 1022397 | 35.4 | 8.96 | 0.0 | 6.7% | 45% | 0% | 24.33 | 5.1x | 4.50 | 0.9x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 618.21 | 6.38 | 1.54 | 1.79 | 100 | 4.17 | 1.79 | 345x | 3.6x | 0.9x | 2.3x |
| 6 | 100 | 659.75 | 7.83 | 1.85 | 2.04 | 100 | 4.88 | 2.04 | 323x | 3.8x | 0.9x | 2.4x |
| 7 | 100 | 730.73 | 10.21 | 2.38 | 2.29 | 100 | 6.00 | 2.29 | 319x | 4.5x | 1.0x | 2.6x |
| 8 | 100 | 779.46 | 11.75 | 2.79 | 2.75 | 100 | 7.25 | 2.75 | 283x | 4.3x | 1.0x | 2.6x |
| 9 | 100 | 804.46 | 13.29 | 2.96 | 3.04 | 100 | 7.85 | 3.04 | 264x | 4.4x | 1.0x | 2.6x |
| 10 | 100 | 879.42 | 15.79 | 3.33 | 3.44 | 100 | 9.62 | 3.44 | 256x | 4.6x | 1.0x | 2.8x |
| 11 | 100 | 918.52 | 18.54 | 3.46 | 3.79 | 100 | 10.10 | 3.79 | 242x | 4.9x | 0.9x | 2.7x |
| 12 | 100 | 950.12 | 18.73 | 3.79 | 3.88 | 100 | 11.04 | 3.88 | 245x | 4.8x | 1.0x | 2.8x |
| 13 | 100 | 1008.35 | 20.40 | 3.92 | 4.08 | 100 | 11.83 | 4.08 | 247x | 5.0x | 1.0x | 2.9x |
| 14 | 100 | 1064.25 | 22.83 | 4.21 | 4.67 | 100 | 12.69 | 4.67 | 228x | 4.9x | 0.9x | 2.7x |
| 15 | 100 | 1101.46 | 24.17 | 4.79 | 4.88 | 100 | 13.92 | 4.88 | 226x | 5.0x | 1.0x | 2.9x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-29.2 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 0.71 | 0.75 | 1.21 | 1309158 | 6545788 | 17.5 | 0.12 | 0.0 | 34.4% | 0% | 0% | 3.58 | 5.1x | 0.62 | 0.9x |
| 6 | 500 | 11 | 0.92 | 0.97 | 1.54 | 1012812 | 5064060 | 17.9 | 0.12 | 0.0 | 29.2% | 0% | 0% | 4.62 | 5.0x | 0.75 | 0.8x |
| 7 | 500 | 13 | 1.08 | 1.13 | 1.71 | 872918 | 4364589 | 17.5 | 0.12 | 0.0 | 28.2% | 0% | 0% | 5.54 | 5.1x | 0.83 | 0.8x |
| 8 | 500 | 15 | 1.17 | 1.22 | 1.79 | 808658 | 4043290 | 16.7 | 0.12 | 0.0 | 21.7% | 0% | 0% | 6.42 | 5.5x | 0.96 | 0.8x |
| 9 | 500 | 17 | 1.38 | 1.39 | 2.00 | 712099 | 3560493 | 16.2 | 0.12 | 0.0 | 9.8% | 0% | 0% | 7.62 | 5.5x | 1.08 | 0.8x |
| 10 | 500 | 19 | 1.46 | 1.50 | 2.08 | 661668 | 3308338 | 15.9 | 0.12 | 0.0 | 13.4% | 0% | 0% | 8.62 | 5.9x | 1.12 | 0.8x |
| 11 | 500 | 21 | 1.69 | 1.73 | 2.38 | 574405 | 2872023 | 16.2 | 0.12 | 0.0 | 19.6% | 0% | 0% | 10.12 | 6.0x | 1.25 | 0.7x |
| 12 | 500 | 24 | 1.83 | 1.84 | 2.50 | 540989 | 2704944 | 15.6 | 0.12 | 0.0 | 12.9% | 0% | 0% | 11.58 | 6.3x | 1.42 | 0.8x |
| 13 | 500 | 25 | 1.96 | 1.97 | 2.67 | 503969 | 2519845 | 15.7 | 0.12 | 0.0 | 14.3% | 0% | 0% | 12.35 | 6.3x | 1.50 | 0.8x |
| 14 | 500 | 28 | 2.12 | 2.16 | 2.92 | 461116 | 2305581 | 15.7 | 0.12 | 0.0 | 12.9% | 0% | 0% | 13.33 | 6.3x | 1.58 | 0.7x |
| 15 | 500 | 30 | 2.42 | 2.49 | 3.46 | 399659 | 1998295 | 16.9 | 0.12 | 0.0 | 32.3% | 0% | 0% | 14.38 | 5.9x | 1.71 | 0.7x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 527.54 | 3.71 | 0.67 | 0.71 | 100 | 3.88 | 0.71 | 745x | 5.2x | 0.9x | 5.5x |
| 6 | 100 | 592.90 | 4.67 | 0.83 | 0.96 | 100 | 4.79 | 0.96 | 619x | 4.9x | 0.9x | 5.0x |
| 7 | 100 | 624.94 | 5.52 | 0.88 | 1.04 | 100 | 5.25 | 1.04 | 600x | 5.3x | 0.8x | 5.0x |
| 8 | 100 | 669.08 | 6.35 | 1.04 | 1.21 | 100 | 6.08 | 1.21 | 554x | 5.3x | 0.9x | 5.0x |
| 9 | 100 | 743.50 | 7.81 | 1.12 | 1.38 | 100 | 7.08 | 1.38 | 541x | 5.7x | 0.8x | 5.2x |
| 10 | 100 | 794.75 | 8.83 | 1.25 | 1.50 | 100 | 8.00 | 1.50 | 530x | 5.9x | 0.8x | 5.3x |
| 11 | 100 | 838.48 | 9.92 | 1.33 | 1.67 | 100 | 8.67 | 1.67 | 503x | 5.9x | 0.8x | 5.2x |
| 12 | 100 | 885.62 | 11.29 | 1.46 | 1.75 | 100 | 9.40 | 1.75 | 506x | 6.5x | 0.8x | 5.4x |
| 13 | 100 | 943.35 | 12.67 | 1.58 | 2.00 | 100 | 10.56 | 2.00 | 472x | 6.3x | 0.8x | 5.3x |
| 14 | 100 | 1014.88 | 13.77 | 1.67 | 2.25 | 100 | 11.71 | 2.25 | 451x | 6.1x | 0.7x | 5.2x |
| 15 | 100 | 1055.83 | 14.29 | 1.75 | 2.42 | 100 | 12.04 | 2.42 | 437x | 5.9x | 0.7x | 5.0x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 63.8 ms median over 5 problems, range 60.7-66.7 ms
- discarded 1 of 26614 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 1.17 | 1.30 | 2.38 | 759465 | 3797325 | 23.6 | 0.77 | 0.0 | 2.9% | 58% | 0% | 4.04 | 3.5x | 1.25 | 1.1x |
| 6 | 500 | 14 | 1.42 | 1.52 | 2.71 | 650582 | 3252912 | 21.4 | 0.76 | 0.0 | 9.6% | 66% | 0% | 5.00 | 3.5x | 1.46 | 1.0x |
| 7 | 500 | 18 | 1.71 | 1.78 | 3.08 | 556989 | 2784947 | 19.8 | 0.80 | 0.0 | 5.2% | 70% | 0% | 5.92 | 3.5x | 1.79 | 1.0x |
| 8 | 500 | 22 | 1.81 | 1.86 | 3.46 | 533281 | 2666407 | 17.3 | 0.83 | 0.0 | 3.5% | 75% | 0% | 6.29 | 3.5x | 1.83 | 1.0x |
| 9 | 500 | 25 | 1.96 | 2.01 | 3.71 | 493652 | 2468262 | 16.5 | 0.90 | 0.0 | 1.9% | 79% | 0% | 6.71 | 3.4x | 1.96 | 1.0x |
| 10 | 500 | 29 | 1.79 | 2.06 | 4.21 | 482028 | 2410142 | 14.5 | 0.88 | 0.0 | 4.7% | 80% | 0% | 6.08 | 3.4x | 1.96 | 1.1x |
| 11 | 500 | 32 | 1.62 | 1.98 | 4.33 | 500592 | 2502962 | 12.4 | 0.86 | 0.0 | 3.4% | 82% | 0% | 5.50 | 3.4x | 1.71 | 1.1x |
| 12 | 500 | 36 | 1.54 | 1.87 | 4.25 | 529563 | 2647814 | 10.6 | 0.83 | 0.0 | 4.5% | 84% | 0% | 5.04 | 3.3x | 1.67 | 1.1x |
| 13 | 500 | 39 | 1.38 | 1.80 | 4.38 | 550111 | 2750553 | 9.3 | 0.76 | 0.0 | 4.4% | 85% | 0% | 4.58 | 3.3x | 1.54 | 1.1x |
| 14 | 500 | 44 | 1.42 | 1.90 | 4.67 | 523675 | 2618373 | 8.7 | 0.80 | 0.0 | 6.3% | 84% | 0% | 4.79 | 3.4x | 1.54 | 1.1x |
| 15 | 500 | 47 | 1.54 | 2.06 | 5.50 | 482234 | 2411169 | 8.9 | 0.87 | 0.0 | 9.7% | 83% | 0% | 5.06 | 3.3x | 1.62 | 1.1x |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 526.08 | 4.06 | 1.29 | 1.12 | 100 | 3.79 | 1.12 | 468x | 3.6x | 1.1x | 3.4x |
| 6 | 100 | 600.79 | 4.92 | 1.50 | 1.42 | 100 | 4.92 | 1.42 | 424x | 3.5x | 1.1x | 3.5x |
| 7 | 100 | 674.67 | 5.88 | 1.83 | 1.71 | 100 | 6.08 | 1.71 | 395x | 3.4x | 1.1x | 3.6x |
| 8 | 100 | 740.65 | 5.81 | 1.75 | 1.62 | 100 | 6.48 | 1.62 | 456x | 3.6x | 1.1x | 4.0x |
| 9 | 100 | 821.81 | 7.73 | 2.25 | 2.08 | 100 | 7.83 | 2.08 | 395x | 3.7x | 1.1x | 3.8x |
| 10 | 100 | 867.60 | 7.19 | 2.21 | 2.10 | 100 | 8.50 | 2.10 | 412x | 3.4x | 1.0x | 4.0x |
| 11 | 100 | 965.35 | 6.44 | 2.00 | 1.96 | 100 | 9.04 | 1.96 | 493x | 3.3x | 1.0x | 4.6x |
| 12 | 100 | 1045.52 | 4.48 | 1.58 | 1.25 | 100 | 9.71 | 1.25 | 836x | 3.6x | 1.3x | 7.8x |
| 13 | 100 | 1122.73 | 4.77 | 1.54 | 1.33 | 100 | 10.75 | 1.33 | 842x | 3.6x | 1.2x | 8.1x |
| 14 | 100 | 1184.00 | 4.79 | 1.54 | 1.38 | 100 | 11.79 | 1.38 | 861x | 3.5x | 1.1x | 8.6x |
| 15 | 100 | 1276.44 | 4.54 | 1.54 | 1.42 | 100 | 12.44 | 1.42 | 901x | 3.2x | 1.1x | 8.8x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.46 | 0.48 | 0.67 | 2039914 | 10199569 | 14.0 | 0.36 | 0.0 | 25.9% | 0% | 0% | 3.54 | 7.7x | 0.33 | 0.7x |
| 6 | 500 | 10 | 0.71 | 0.72 | 0.88 | 1352479 | 6762393 | 14.8 | 0.36 | 0.0 | 6.0% | 0% | 0% | 5.17 | 7.3x | 0.42 | 0.6x |
| 7 | 500 | 11 | 1.04 | 27.40 | 152.00 | 36475 | 182374 | 485.7 | 0.36 | 0.0 | 1.5% | 0% | 40% | 6.58 | 6.3x | 0.75 | 0.7x |
| 8 | 500 | 15 | 1.25 | 49.29 | 294.88 | 20281 | 101403 | 669.9 | 0.36 | 0.0 | 0.9% | 0% | 45% | 7.29 | 5.8x | 1.00 | 0.8x |
| 9 | 500 | 18 | 1.33 | 68.94 | 436.17 | 14502 | 72512 | 773.3 | 0.36 | 0.0 | 4.0% | 0% | 48% | 8.08 | 6.1x | 1.12 | 0.8x |
| 10 | 500 | 20 | 1.58 | 94.57 | 513.34 | 10573 | 52865 | 945.4 | 0.36 | 0.0 | 2.4% | 0% | 65% | 9.08 | 5.7x | 1.33 | 0.8x |
| 11 | 500 | 23 | 1.54 | 89.61 | 509.04 | 11157 | 55786 | 767.0 | 0.36 | 0.0 | 0.4% | 0% | 71% | 9.04 | 5.9x | 1.38 | 0.9x |
| 12 | 500 | 27 | 1.71 | 119.96 | 650.38 | 8335 | 41674 | 904.8 | 0.36 | 0.0 | 0.5% | 0% | 71% | 10.62 | 6.2x | 1.54 | 0.9x |
| 13 | 500 | 29 | 1.71 | 117.51 | 638.72 | 8509 | 42543 | 813.0 | 0.36 | 0.0 | 0.6% | 0% | 79% | 9.50 | 5.6x | 1.50 | 0.9x |
| 14 | 500 | 33 | 1.83 | 142.22 | 754.85 | 7031 | 35154 | 867.3 | 0.36 | 0.0 | 0.3% | 0% | 84% | 9.73 | 5.3x | 1.67 | 0.9x |
| 15 | 500 | 36 | 1.79 | 163.38 | 852.20 | 6120 | 30601 | 912.3 | 0.36 | 0.0 | 0.3% | 0% | 85% | 9.67 | 5.4x | 1.62 | 0.9x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 1.00 | 2.2% | 199 | 67.33 | 97.7% |
| 8 | 273 | 1.20 | 1.3% | 227 | 107.13 | 98.6% |
| 9 | 260 | 1.31 | 1.0% | 240 | 142.20 | 99.0% |
| 10 | 174 | 1.49 | 0.5% | 326 | 144.24 | 99.4% |
| 11 | 143 | 1.52 | 0.5% | 357 | 124.90 | 99.5% |
| 12 | 144 | 1.64 | 0.4% | 356 | 167.82 | 99.6% |
| 13 | 103 | 1.69 | 0.3% | 397 | 147.56 | 99.7% |
| 14 | 81 | 1.89 | 0.2% | 419 | 169.34 | 99.8% |
| 15 | 74 | 1.90 | 0.2% | 426 | 191.43 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.31 | 3.50 | 0.33 | 0.50 | 100 | 1.96 | 0.50 | 863x | 7.0x | 0.7x | 3.9x |
| 6 | 100 | 505.31 | 5.12 | 0.42 | 0.71 | 100 | 2.71 | 0.71 | 713x | 7.2x | 0.6x | 3.8x |
| 7 | 100 | 592.00 | 6.21 | 0.75 | 1.00 | 62 | 2.62 | 0.96 | 592x | 6.2x | 0.8x | 2.7x |
| 8 | 100 | 821.96 | 7.31 | 0.98 | 1.21 | 57 | 3.17 | 1.12 | 680x | 6.1x | 0.8x | 2.8x |
| 9 | 100 | 987.79 | 8.88 | 1.21 | 1.42 | 51 | 3.79 | 1.33 | 697x | 6.3x | 0.9x | 2.8x |
| 10 | 100 | 1148.67 | 8.75 | 1.29 | 1.50 | 40 | 3.83 | 1.38 | 766x | 5.8x | 0.9x | 2.8x |
| 11 | 100 | 1347.46 | 8.67 | 1.29 | 1.38 | 24 | 4.33 | 1.46 | 980x | 6.3x | 0.9x | 3.0x |
| 12 | 100 | 1476.79 | 10.65 | 1.52 | 1.62 | 28 | 4.40 | 1.52 | 909x | 6.6x | 0.9x | 2.9x |
| 13 | 100 | 1575.33 | 8.88 | 1.25 | 1.50 | 22 | 5.12 | 1.52 | 1050x | 5.9x | 0.8x | 3.4x |
| 14 | 100 | 1723.90 | 12.12 | 1.71 | 2.00 | 15 | 5.29 | 1.58 | 862x | 6.1x | 0.9x | 3.3x |
| 15 | 100 | 1767.65 | 12.92 | 2.08 | 2.17 | 22 | 5.87 | 1.88 | 816x | 6.0x | 1.0x | 3.1x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)
- discarded 1 of 5501 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.50 | 0.50 | 0.71 | 1956881 | 9784406 | 14.6 | 0.16 | 0.0 | 9.3% | 0% | 0% | 3.00 | 6.0x | 0.42 | 0.8x |
| 6 | 500 | 10 | 0.62 | 0.67 | 0.96 | 1454722 | 7273608 | 13.7 | 0.16 | 0.0 | 20.0% | 0% | 0% | 4.29 | 6.9x | 0.46 | 0.7x |
| 7 | 500 | 11 | 0.83 | 14.25 | 95.00 | 70087 | 350433 | 252.8 | 0.16 | 0.0 | 1.5% | 0% | 40% | 4.83 | 5.8x | 0.67 | 0.8x |
| 8 | 500 | 15 | 0.92 | 33.75 | 188.00 | 29617 | 148087 | 458.7 | 0.16 | 0.0 | 0.5% | 0% | 45% | 5.50 | 6.0x | 0.83 | 0.9x |
| 9 | 500 | 18 | 1.04 | 45.98 | 279.50 | 21738 | 108688 | 515.9 | 0.16 | 0.0 | 0.5% | 0% | 48% | 6.54 | 6.3x | 0.96 | 0.9x |
| 10 | 500 | 20 | 1.21 | 59.90 | 299.51 | 16690 | 83450 | 598.9 | 0.16 | 0.0 | 0.3% | 0% | 65% | 7.29 | 6.0x | 1.12 | 0.9x |
| 11 | 500 | 23 | 1.21 | 65.97 | 334.10 | 15155 | 75777 | 564.7 | 0.16 | 0.0 | 0.7% | 0% | 71% | 7.25 | 6.0x | 1.12 | 0.9x |
| 12 | 500 | 27 | 1.25 | 82.32 | 421.13 | 12146 | 60729 | 620.9 | 0.16 | 0.0 | 1.1% | 0% | 71% | 7.58 | 6.1x | 1.17 | 0.9x |
| 13 | 500 | 29 | 1.21 | 80.61 | 431.45 | 12403 | 62016 | 557.7 | 0.16 | 0.0 | 0.2% | 0% | 79% | 7.00 | 5.8x | 1.12 | 0.9x |
| 14 | 500 | 33 | 1.33 | 102.09 | 489.04 | 9794 | 48968 | 622.6 | 0.16 | 0.0 | 0.3% | 0% | 84% | 7.83 | 5.9x | 1.29 | 1.0x |
| 15 | 500 | 36 | 1.29 | 106.18 | 558.64 | 9416 | 47081 | 593.0 | 0.16 | 0.0 | 0.6% | 0% | 85% | 7.67 | 5.9x | 1.21 | 0.9x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 0.86 | 3.6% | 199 | 34.52 | 96.3% |
| 8 | 273 | 0.92 | 1.5% | 227 | 73.22 | 98.5% |
| 9 | 260 | 1.05 | 1.2% | 240 | 94.67 | 98.8% |
| 10 | 174 | 1.22 | 0.7% | 326 | 91.22 | 99.3% |
| 11 | 143 | 1.26 | 0.5% | 357 | 91.89 | 99.4% |
| 12 | 144 | 1.28 | 0.4% | 356 | 115.09 | 99.5% |
| 13 | 103 | 1.31 | 0.3% | 397 | 101.18 | 99.6% |
| 14 | 81 | 1.52 | 0.2% | 419 | 121.53 | 99.7% |
| 15 | 74 | 1.37 | 0.2% | 426 | 124.39 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.12 | 3.04 | 0.46 | 0.50 | 100 | 1.92 | 0.50 | 862x | 6.1x | 0.9x | 3.8x |
| 6 | 100 | 505.27 | 4.42 | 0.38 | 0.62 | 100 | 2.58 | 0.62 | 808x | 7.1x | 0.6x | 4.1x |
| 7 | 100 | 605.65 | 4.17 | 0.58 | 0.79 | 62 | 2.58 | 0.83 | 765x | 5.3x | 0.7x | 3.1x |
| 8 | 100 | 816.67 | 5.46 | 0.92 | 1.00 | 57 | 2.92 | 1.00 | 817x | 5.5x | 0.9x | 2.9x |
| 9 | 100 | 1048.31 | 6.04 | 0.83 | 0.96 | 51 | 3.58 | 1.04 | 1094x | 6.3x | 0.9x | 3.4x |
| 10 | 100 | 12198.69 | 7.62 | 1.19 | 1.12 | 40 | 3.62 | 1.02 | 10843x | 6.8x | 1.1x | 3.6x |
| 11 | 100 | 15695.83 | 6.33 | 1.00 | 1.04 | 24 | 4.04 | 1.08 | 15063x | 6.1x | 1.0x | 3.7x |
| 12 | 100 | 17136.54 | 6.94 | 1.04 | 1.17 | 28 | 4.25 | 1.23 | 14697x | 6.0x | 0.9x | 3.5x |
| 13 | 100 | 18035.73 | 6.98 | 1.12 | 1.21 | 22 | 4.94 | 1.33 | 14918x | 5.8x | 0.9x | 3.7x |
| 14 | 100 | 20048.42 | 8.71 | 1.33 | 1.33 | 15 | 6.83 | 1.46 | 15029x | 6.5x | 1.0x | 4.7x |
| 15 | 100 | 20433.73 | 9.33 | 1.29 | 1.48 | 22 | 5.50 | 1.17 | 13811x | 6.3x | 0.9x | 4.7x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% | v1 us | v1 speed-up | v2 us | v2 speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 0.83 | 0.85 | 1.08 | 1150064 | 5750318 | 24.8 | 0.79 | 0.0 | 6.3% | 0% | 0% | 3.71 | 4.4x | 0.54 | 0.6x |
| 6 | 500 | 10 | 1.21 | 1.23 | 1.50 | 803363 | 4016817 | 24.9 | 1.00 | 0.0 | 10.1% | 0% | 0% | 5.17 | 4.3x | 0.75 | 0.6x |
| 7 | 500 | 11 | 1.42 | 42.15 | 335.84 | 23716 | 118582 | 745.4 | 26.36 | 0.0 | 2.8% | 1% | 39% | 5.96 | 4.2x | 1.04 | 0.7x |
| 8 | 500 | 15 | 1.67 | 65.28 | 537.09 | 15315 | 76575 | 883.0 | 43.93 | 0.0 | 0.7% | 3% | 43% | 6.33 | 3.8x | 1.38 | 0.8x |
| 9 | 500 | 18 | 1.92 | 79.53 | 728.13 | 12571 | 62855 | 885.6 | 51.52 | 0.0 | 0.4% | 5% | 46% | 7.83 | 4.1x | 1.67 | 0.9x |
| 10 | 500 | 20 | 2.04 | 136.36 | 877.43 | 7332 | 36662 | 1359.0 | 55.40 | 0.0 | 0.4% | 5% | 63% | 8.04 | 3.9x | 1.75 | 0.9x |
| 11 | 500 | 23 | 2.00 | 141.32 | 962.18 | 7075 | 35376 | 1207.8 | 60.84 | 0.0 | 0.4% | 7% | 69% | 8.17 | 4.1x | 1.79 | 0.9x |
| 12 | 500 | 27 | 2.12 | 151.93 | 1045.87 | 6581 | 32906 | 1145.5 | 71.40 | 0.0 | 0.6% | 5% | 71% | 8.21 | 3.9x | 1.79 | 0.8x |
| 13 | 500 | 29 | 2.12 | 162.99 | 1046.53 | 6135 | 30674 | 1124.5 | 61.35 | 0.0 | 0.5% | 5% | 78% | 8.65 | 4.1x | 1.79 | 0.8x |
| 14 | 500 | 33 | 2.04 | 163.71 | 1138.74 | 6108 | 30538 | 998.3 | 69.94 | 0.0 | 0.6% | 5% | 83% | 8.21 | 4.0x | 1.75 | 0.9x |
| 15 | 500 | 36 | 2.00 | 169.50 | 1228.89 | 5899 | 29496 | 946.9 | 68.70 | 0.0 | 3.5% | 8% | 84% | 7.67 | 3.8x | 1.67 | 0.8x |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 1.50 | 2.2% | 196 | 105.19 | 97.8% |
| 8 | 285 | 1.77 | 1.5% | 215 | 149.46 | 98.4% |
| 9 | 272 | 2.03 | 1.4% | 228 | 171.99 | 98.6% |
| 10 | 184 | 2.11 | 0.6% | 316 | 214.54 | 99.4% |
| 11 | 154 | 2.25 | 0.5% | 346 | 203.22 | 99.5% |
| 12 | 146 | 2.31 | 0.4% | 354 | 213.63 | 99.5% |
| 13 | 109 | 2.43 | 0.3% | 391 | 207.74 | 99.7% |
| 14 | 86 | 2.45 | 0.3% | 414 | 197.21 | 99.7% |
| 15 | 78 | 2.59 | 0.2% | 422 | 200.35 | 99.8% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs
- v1 = "custom v1", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's "custom v1" section), same programs
- v2 = "custom v2 (batched)", the from-scratch batched interpreter design (see README's "custom v2 (batched)" section), same programs

| depth | progs | eval us | v1 us | v2 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | v2 speed-up | interpret speed-up |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.52 | 3.71 | 0.54 | 0.88 | 100 | 2.04 | 0.88 | 493x | 4.2x | 0.6x | 2.3x |
| 6 | 100 | 506.73 | 5.25 | 0.75 | 1.25 | 100 | 2.81 | 1.25 | 405x | 4.2x | 0.6x | 2.2x |
| 7 | 100 | 608.52 | 4.71 | 1.04 | 1.29 | 62 | 2.85 | 1.33 | 471x | 3.6x | 0.8x | 2.1x |
| 8 | 100 | 810.15 | 6.17 | 1.33 | 1.62 | 58 | 3.50 | 1.75 | 499x | 3.8x | 0.8x | 2.0x |
| 9 | 100 | 1095.19 | 7.79 | 1.71 | 2.00 | 52 | 3.92 | 2.00 | 548x | 3.9x | 0.9x | 2.0x |
| 10 | 100 | 4845.29 | 7.12 | 1.62 | 1.79 | 44 | 3.88 | 1.79 | 2705x | 4.0x | 0.9x | 2.2x |
| 11 | 100 | 12271.31 | 9.17 | 1.88 | 2.17 | 25 | 4.21 | 2.12 | 5665x | 4.2x | 0.9x | 2.0x |
| 12 | 100 | 10271.21 | 6.69 | 1.50 | 1.83 | 30 | 4.35 | 1.96 | 5602x | 3.6x | 0.8x | 2.2x |
| 13 | 100 | 13041.81 | 8.15 | 1.62 | 2.06 | 22 | 5.21 | 2.29 | 6323x | 3.9x | 0.8x | 2.3x |
| 14 | 100 | 13348.31 | 7.92 | 1.54 | 1.92 | 16 | 5.75 | 2.19 | 6963x | 4.1x | 0.8x | 2.6x |
| 15 | 100 | 13852.62 | 9.33 | 1.83 | 2.12 | 24 | 5.25 | 2.19 | 6519x | 4.4x | 0.9x | 2.4x |

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

