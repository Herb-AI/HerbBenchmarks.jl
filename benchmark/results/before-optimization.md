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
| DeepCoder_2016 | 164650 | 67995 | 41090 |
| PBE_BV_Track_2018 | 268374 | 109173 | 68808 |
| PBE_SLIA_Track_2019 | 186696 | 110762 | 114406 |
| Robots_2020 | 244083 | 697 | 409 |
| Pixels_2020 | 227465 | 723 | 422 |
| String_transformations_2020 | 203100 | 766 | 637 |

## Per-benchmark detail

### DeepCoder_2016

grammar `grammar_000` (47 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 22.7 ms median over 5 problems, range 0.1-90.8 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 8 | 5.83 | 6.06 | 8.63 | 164650 | 823249 | 157.5 | 6.56 | 0.0 | 3.8% | 9% | 0% |
| 6 | 500 | 10 | 7.29 | 7.64 | 10.83 | 130702 | 653509 | 159.9 | 8.34 | 0.0 | 5.3% | 19% | 0% |
| 7 | 500 | 12 | 9.42 | 9.76 | 13.29 | 102280 | 511400 | 168.5 | 10.14 | 0.0 | 0.6% | 23% | 0% |
| 8 | 500 | 14 | 10.83 | 11.10 | 14.92 | 89984 | 449922 | 164.2 | 11.55 | 0.0 | 3.8% | 29% | 0% |
| 9 | 500 | 15 | 12.54 | 12.93 | 17.29 | 77279 | 386394 | 168.0 | 12.97 | 0.0 | 0.9% | 31% | 0% |
| 10 | 500 | 17 | 14.25 | 14.69 | 19.25 | 67995 | 339976 | 169.2 | 14.64 | 0.0 | 1.8% | 35% | 0% |
| 11 | 500 | 19 | 17.79 | 18.52 | 25.34 | 53941 | 269706 | 190.9 | 16.59 | 0.0 | 4.2% | 41% | 0% |
| 12 | 500 | 21 | 20.54 | 23.18 | 43.70 | 43109 | 215543 | 217.7 | 17.40 | 0.0 | 43.9% | 43% | 0% |
| 13 | 500 | 23 | 20.25 | 20.66 | 26.75 | 48368 | 241841 | 177.9 | 18.57 | 0.0 | 1.8% | 47% | 0% |
| 14 | 500 | 25 | 22.17 | 22.50 | 28.47 | 44420 | 222101 | 178.2 | 20.17 | 0.0 | 3.5% | 49% | 0% |
| 15 | 500 | 27 | 23.96 | 24.32 | 29.63 | 41090 | 205452 | 179.3 | 21.47 | 0.0 | 2.4% | 54% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 590.58 | 6.12 | 96x | 100 | 3.75 | 6.12 | 0.6x |
| 6 | 100 | 625.42 | 7.33 | 85x | 100 | 4.58 | 7.33 | 0.6x |
| 7 | 100 | 695.90 | 9.58 | 73x | 100 | 5.62 | 9.58 | 0.6x |
| 8 | 100 | 733.71 | 11.40 | 64x | 100 | 6.71 | 11.40 | 0.6x |
| 9 | 100 | 775.12 | 12.17 | 64x | 100 | 7.60 | 12.17 | 0.6x |
| 10 | 100 | 831.65 | 15.10 | 55x | 100 | 8.56 | 15.10 | 0.6x |
| 11 | 100 | 894.40 | 18.25 | 49x | 100 | 10.75 | 18.25 | 0.6x |
| 12 | 100 | 1008.71 | 20.44 | 49x | 100 | 10.46 | 20.44 | 0.5x |
| 13 | 100 | 970.79 | 19.65 | 49x | 100 | 11.38 | 19.65 | 0.6x |
| 14 | 100 | 1037.15 | 22.58 | 46x | 100 | 12.33 | 22.58 | 0.5x |
| 15 | 100 | 1085.08 | 24.58 | 44x | 100 | 13.40 | 24.58 | 0.5x |

### PBE_BV_Track_2018

grammar `grammar_PRE_100_10` (13 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 0.0 ms median over 5 problems, range 0.0-28.3 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 9 | 3.54 | 3.71 | 5.88 | 268374 | 1341872 | 85.5 | 3.97 | 0.0 | 8.4% | 0% | 0% |
| 6 | 500 | 11 | 4.75 | 5.03 | 7.79 | 198266 | 991331 | 91.2 | 5.12 | 0.0 | 13.9% | 0% | 0% |
| 7 | 500 | 13 | 5.79 | 6.43 | 10.09 | 155132 | 775658 | 98.4 | 6.14 | 0.0 | 28.0% | 0% | 0% |
| 8 | 500 | 15 | 6.42 | 6.63 | 9.50 | 150431 | 752156 | 89.7 | 7.01 | 0.0 | 3.2% | 0% | 0% |
| 9 | 500 | 17 | 7.71 | 7.87 | 11.21 | 126846 | 634229 | 90.8 | 8.28 | 0.0 | 0.8% | 0% | 0% |
| 10 | 500 | 19 | 8.92 | 9.14 | 12.88 | 109173 | 545865 | 96.4 | 9.09 | 0.0 | 7.0% | 0% | 0% |
| 11 | 500 | 21 | 10.21 | 10.37 | 13.83 | 96273 | 481363 | 96.9 | 10.27 | 0.0 | 0.6% | 0% | 0% |
| 12 | 500 | 24 | 11.71 | 11.83 | 15.75 | 84437 | 422186 | 100.1 | 11.38 | 0.0 | 2.4% | 0% | 0% |
| 13 | 500 | 25 | 12.46 | 12.63 | 16.62 | 79092 | 395460 | 100.1 | 12.23 | 0.0 | 1.3% | 0% | 0% |
| 14 | 500 | 28 | 13.25 | 13.53 | 17.59 | 73815 | 369077 | 97.8 | 13.39 | 0.0 | 1.8% | 0% | 0% |
| 15 | 500 | 30 | 14.40 | 14.52 | 18.58 | 68808 | 344041 | 98.2 | 14.35 | 0.0 | 3.9% | 0% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 518.44 | 3.62 | 143x | 100 | 3.58 | 3.62 | 1.0x |
| 6 | 100 | 579.67 | 4.79 | 121x | 100 | 4.58 | 4.79 | 1.0x |
| 7 | 100 | 623.90 | 5.56 | 112x | 100 | 5.04 | 5.56 | 0.9x |
| 8 | 100 | 676.06 | 6.17 | 110x | 100 | 5.79 | 6.17 | 0.9x |
| 9 | 100 | 734.63 | 7.75 | 95x | 100 | 6.85 | 7.75 | 0.9x |
| 10 | 100 | 790.33 | 8.73 | 91x | 100 | 7.71 | 8.73 | 0.9x |
| 11 | 100 | 830.21 | 9.77 | 85x | 100 | 8.46 | 9.77 | 0.9x |
| 12 | 100 | 880.15 | 11.00 | 80x | 100 | 9.06 | 11.00 | 0.8x |
| 13 | 100 | 936.67 | 12.58 | 74x | 100 | 10.25 | 12.58 | 0.8x |
| 14 | 100 | 1013.92 | 13.71 | 74x | 100 | 11.42 | 13.71 | 0.8x |
| 15 | 100 | 1036.54 | 14.06 | 74x | 100 | 11.75 | 14.06 | 0.8x |

### PBE_SLIA_Track_2019

grammar `grammar_11440431` (27 rules), 5 examples/program

- cold interpreter (generate one for an unseen grammar + run its first program): 42.5 ms median over 5 problems, range 41.9-49.7 ms

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 11 | 5.04 | 5.34 | 8.79 | 186696 | 933479 | 96.0 | 4.63 | 0.0 | 3.5% | 58% | 0% |
| 6 | 500 | 14 | 6.25 | 6.43 | 10.79 | 155061 | 775304 | 89.7 | 5.39 | 0.0 | 2.8% | 66% | 0% |
| 7 | 500 | 18 | 7.29 | 7.35 | 12.29 | 135727 | 678636 | 81.2 | 6.32 | 0.0 | 0.3% | 70% | 0% |
| 8 | 500 | 22 | 7.75 | 7.66 | 13.58 | 130339 | 651697 | 70.9 | 6.63 | 0.0 | 6.2% | 75% | 0% |
| 9 | 500 | 25 | 8.33 | 8.54 | 16.08 | 116914 | 584569 | 69.6 | 7.13 | 0.0 | 5.2% | 79% | 0% |
| 10 | 500 | 29 | 7.67 | 9.01 | 18.25 | 110762 | 553809 | 63.2 | 7.30 | 0.0 | 14.0% | 80% | 0% |
| 11 | 500 | 32 | 6.75 | 8.70 | 19.00 | 114785 | 573925 | 54.2 | 7.16 | 0.0 | 4.7% | 82% | 0% |
| 12 | 500 | 36 | 6.25 | 8.03 | 18.72 | 124345 | 621727 | 45.1 | 6.65 | 0.0 | 4.2% | 84% | 0% |
| 13 | 500 | 39 | 5.60 | 7.76 | 19.34 | 128732 | 643659 | 39.6 | 6.45 | 0.0 | 3.4% | 85% | 0% |
| 14 | 500 | 44 | 6.12 | 8.36 | 20.72 | 119379 | 596896 | 38.4 | 6.69 | 0.0 | 5.8% | 84% | 0% |
| 15 | 500 | 47 | 6.29 | 8.73 | 23.38 | 114406 | 572028 | 37.5 | 7.19 | 0.0 | 1.8% | 83% | 0% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 519.60 | 5.00 | 104x | 100 | 3.79 | 5.00 | 0.8x |
| 6 | 100 | 589.48 | 6.21 | 95x | 100 | 4.81 | 6.21 | 0.8x |
| 7 | 100 | 674.25 | 7.12 | 95x | 100 | 5.77 | 7.12 | 0.8x |
| 8 | 100 | 729.79 | 7.42 | 98x | 100 | 6.38 | 7.42 | 0.9x |
| 9 | 100 | 823.04 | 9.29 | 89x | 100 | 7.96 | 9.29 | 0.9x |
| 10 | 100 | 864.40 | 9.52 | 91x | 100 | 8.12 | 9.52 | 0.9x |
| 11 | 100 | 955.96 | 8.02 | 119x | 100 | 9.02 | 8.02 | 1.1x |
| 12 | 100 | 1035.10 | 5.35 | 193x | 100 | 9.35 | 5.35 | 1.7x |
| 13 | 100 | 1111.02 | 5.60 | 198x | 100 | 10.54 | 5.60 | 1.9x |
| 14 | 100 | 1174.79 | 6.12 | 192x | 100 | 11.31 | 6.12 | 1.8x |
| 15 | 100 | 1269.54 | 5.50 | 231x | 100 | 12.04 | 5.50 | 2.2x |

### Robots_2020

grammar `grammar_robots` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 4.04 | 4.08 | 4.46 | 244083 | 1220413 | 117.1 | 10.77 | 0.0 | 1.5% | 0% | 0% |
| 6 | 500 | 10 | 5.96 | 6.09 | 6.71 | 163802 | 819008 | 122.1 | 15.69 | 0.0 | 5.6% | 0% | 0% |
| 7 | 500 | 11 | 7.62 | 479.71 | 2612.86 | 2085 | 10423 | 8498.3 | 1116.77 | 5.1 | 2.3% | 0% | 40% |
| 8 | 500 | 15 | 8.54 | 798.58 | 4464.38 | 1252 | 6261 | 10849.1 | 1875.45 | 6.5 | 0.2% | 0% | 45% |
| 9 | 500 | 18 | 9.92 | 1094.02 | 6891.60 | 914 | 4570 | 12269.1 | 2534.62 | 7.0 | 3.3% | 0% | 48% |
| 10 | 500 | 20 | 10.83 | 1434.26 | 7833.65 | 697 | 3486 | 14337.0 | 3398.71 | 7.5 | 0.7% | 0% | 65% |
| 11 | 500 | 23 | 10.58 | 1354.09 | 7792.91 | 738 | 3692 | 11588.4 | 3192.11 | 7.4 | 1.5% | 0% | 71% |
| 12 | 500 | 27 | 12.10 | 1799.51 | 9719.80 | 556 | 2778 | 13571.1 | 4229.63 | 7.9 | 1.0% | 0% | 71% |
| 13 | 500 | 29 | 11.65 | 1753.31 | 9478.67 | 570 | 2852 | 12127.9 | 4116.44 | 8.0 | 3.5% | 0% | 79% |
| 14 | 500 | 33 | 13.04 | 2234.29 | 11621.04 | 448 | 2238 | 13624.7 | 4956.33 | 8.1 | 10.4% | 0% | 84% |
| 15 | 500 | 36 | 12.04 | 2443.69 | 12968.95 | 409 | 2046 | 13644.5 | 5673.69 | 8.2 | 0.4% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 7.00 | 0.9% | 199 | 1194.72 | 99.1% |
| 8 | 273 | 10.58 | 0.7% | 227 | 1746.27 | 99.3% |
| 9 | 260 | 9.62 | 0.5% | 240 | 2268.78 | 99.5% |
| 10 | 174 | 10.13 | 0.2% | 326 | 2194.37 | 99.8% |
| 11 | 143 | 12.70 | 0.3% | 357 | 1891.39 | 99.7% |
| 12 | 144 | 17.85 | 0.3% | 356 | 2520.18 | 99.7% |
| 13 | 103 | 11.94 | 0.1% | 397 | 2205.10 | 99.9% |
| 14 | 81 | 13.95 | 0.1% | 419 | 2663.51 | 99.9% |
| 15 | 74 | 12.81 | 0.1% | 426 | 2865.96 | 99.9% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 430.81 | 4.00 | 108x | 100 | 1.88 | 4.00 | 0.5x |
| 6 | 100 | 504.79 | 6.04 | 84x | 100 | 2.58 | 6.04 | 0.4x |
| 7 | 100 | 597.10 | 7.25 | 82x | 62 | 2.54 | 6.62 | 0.4x |
| 8 | 100 | 791.35 | 8.42 | 94x | 57 | 3.04 | 7.83 | 0.4x |
| 9 | 100 | 1013.15 | 10.58 | 96x | 51 | 3.62 | 9.54 | 0.4x |
| 10 | 100 | 1163.52 | 10.46 | 111x | 40 | 3.88 | 9.60 | 0.4x |
| 11 | 100 | 1306.94 | 9.65 | 135x | 24 | 4.25 | 10.88 | 0.4x |
| 12 | 100 | 1391.67 | 11.85 | 117x | 28 | 4.06 | 10.69 | 0.4x |
| 13 | 100 | 1490.81 | 10.67 | 140x | 22 | 4.85 | 11.00 | 0.4x |
| 14 | 100 | 1823.29 | 15.19 | 120x | 15 | 4.75 | 10.54 | 0.5x |
| 15 | 100 | 1846.58 | 14.60 | 126x | 22 | 5.75 | 12.79 | 0.4x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### Pixels_2020

grammar `grammar_pixels` (21 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- inputs are deep-copied per evaluation (mutable state)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 4.33 | 4.38 | 4.88 | 227465 | 1137326 | 125.6 | 3.22 | 0.0 | 1.4% | 0% | 0% |
| 6 | 500 | 10 | 6.33 | 6.44 | 7.12 | 155004 | 775020 | 129.0 | 4.62 | 0.0 | 5.0% | 0% | 0% |
| 7 | 500 | 11 | 7.33 | 417.63 | 2776.64 | 2394 | 11972 | 7398.6 | 273.38 | 2.0 | 14.2% | 0% | 40% |
| 8 | 500 | 15 | 8.29 | 903.77 | 5066.79 | 1106 | 5532 | 12278.1 | 594.30 | 1.9 | 5.1% | 0% | 45% |
| 9 | 500 | 18 | 9.42 | 1117.11 | 6644.11 | 895 | 4476 | 12528.1 | 773.44 | 2.0 | 1.4% | 0% | 48% |
| 10 | 500 | 20 | 10.31 | 1383.35 | 7039.14 | 723 | 3614 | 13828.1 | 970.26 | 1.9 | 1.0% | 0% | 65% |
| 11 | 500 | 23 | 10.29 | 1519.50 | 8086.81 | 658 | 3291 | 13004.0 | 1051.74 | 1.9 | 3.3% | 0% | 71% |
| 12 | 500 | 27 | 11.02 | 1834.42 | 9323.92 | 545 | 2726 | 13834.4 | 1291.89 | 2.0 | 1.2% | 0% | 71% |
| 13 | 500 | 29 | 9.88 | 1763.08 | 9393.39 | 567 | 2836 | 12195.5 | 1252.91 | 2.0 | 1.7% | 0% | 79% |
| 14 | 500 | 33 | 10.88 | 2255.10 | 11001.40 | 443 | 2217 | 13751.6 | 1581.01 | 2.1 | 1.4% | 0% | 84% |
| 15 | 500 | 36 | 11.10 | 2367.57 | 12359.90 | 422 | 2112 | 13219.4 | 1634.26 | 2.1 | 5.8% | 0% | 85% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 301 | 7.59 | 1.1% | 199 | 1037.84 | 98.9% |
| 8 | 273 | 8.74 | 0.5% | 227 | 1980.18 | 99.5% |
| 9 | 260 | 9.49 | 0.4% | 240 | 2317.04 | 99.6% |
| 10 | 174 | 10.25 | 0.3% | 326 | 2116.23 | 99.7% |
| 11 | 143 | 11.12 | 0.2% | 357 | 2123.70 | 99.8% |
| 12 | 144 | 11.25 | 0.2% | 356 | 2571.88 | 99.8% |
| 13 | 103 | 11.61 | 0.1% | 397 | 2217.49 | 99.9% |
| 14 | 81 | 13.22 | 0.1% | 419 | 2688.50 | 99.9% |
| 15 | 74 | 12.04 | 0.1% | 426 | 2776.75 | 99.9% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 431.98 | 4.33 | 100x | 100 | 1.88 | 4.33 | 0.4x |
| 6 | 100 | 505.04 | 6.38 | 79x | 100 | 2.46 | 6.38 | 0.4x |
| 7 | 100 | 634.25 | 7.00 | 91x | 62 | 2.71 | 7.17 | 0.4x |
| 8 | 100 | 796.62 | 8.85 | 90x | 57 | 2.92 | 8.54 | 0.3x |
| 9 | 100 | 1114.06 | 9.08 | 123x | 51 | 3.46 | 9.46 | 0.4x |
| 10 | 100 | 12150.54 | 11.04 | 1100x | 40 | 3.71 | 10.62 | 0.3x |
| 11 | 100 | 15743.06 | 9.62 | 1636x | 24 | 3.83 | 10.52 | 0.4x |
| 12 | 100 | 17223.92 | 9.92 | 1737x | 28 | 4.38 | 10.58 | 0.4x |
| 13 | 100 | 18009.60 | 9.73 | 1851x | 22 | 4.73 | 11.77 | 0.4x |
| 14 | 100 | 19874.50 | 11.81 | 1682x | 15 | 6.38 | 13.58 | 0.5x |
| 15 | 100 | 20498.73 | 13.40 | 1530x | 22 | 5.40 | 10.94 | 0.5x |

`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` has no `:while` case, so loop-containing programs cannot be run through it at all; its own `custom us` column is therefore the custom interpreter's median over *that* subset, not over the `progs`-wide one used for the `eval` comparison.

### String_transformations_2020

grammar `grammar_string` (26 rules), 5 examples/program

- one interpreter is generated at module load and shared by all problems
- discarded 1 of 5741 candidates as oversized or pathologically slow (0.0%)

| depth | progs | nodes | median us | mean us | p95 us | progs/s | evals/s | ns/node | KiB/prog | GC% | rep± | err% | loop% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 500 | 7 | 4.83 | 4.91 | 5.29 | 203100 | 1015498 | 140.7 | 7.14 | 0.0 | 3.0% | 0% | 0% |
| 6 | 500 | 10 | 7.50 | 7.62 | 8.46 | 130931 | 654653 | 152.8 | 10.39 | 0.0 | 5.9% | 0% | 0% |
| 7 | 500 | 11 | 8.04 | 392.68 | 2931.45 | 2546 | 12732 | 6941.8 | 534.92 | 2.7 | 0.8% | 1% | 39% |
| 8 | 500 | 15 | 8.54 | 639.00 | 5106.85 | 1565 | 7825 | 8641.2 | 876.89 | 3.5 | 0.2% | 3% | 43% |
| 9 | 500 | 18 | 10.46 | 804.07 | 7134.75 | 1244 | 6218 | 8952.2 | 1111.68 | 4.3 | 0.6% | 5% | 46% |
| 10 | 500 | 20 | 11.00 | 1304.71 | 7914.56 | 766 | 3832 | 13001.8 | 1763.85 | 4.6 | 1.8% | 5% | 63% |
| 11 | 500 | 23 | 11.17 | 1319.60 | 8425.57 | 758 | 3789 | 11276.9 | 1816.41 | 4.5 | 3.1% | 7% | 69% |
| 12 | 500 | 27 | 11.38 | 1461.02 | 10016.88 | 684 | 3422 | 11014.3 | 1945.81 | 4.9 | 5.2% | 5% | 71% |
| 13 | 500 | 29 | 11.71 | 1605.98 | 10333.20 | 623 | 3113 | 11079.7 | 2103.87 | 4.6 | 10.6% | 5% | 78% |
| 14 | 500 | 33 | 11.00 | 1509.86 | 10097.04 | 662 | 3312 | 9206.0 | 2044.82 | 4.9 | 1.6% | 5% | 83% |
| 15 | 500 | 36 | 9.96 | 1569.52 | 10943.05 | 637 | 3186 | 8767.4 | 2124.80 | 5.0 | 1.8% | 8% | 84% |

Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:

| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |
|---|---|---|---|---|---|---|
| 7 | 304 | 8.11 | 1.3% | 196 | 989.15 | 98.7% |
| 8 | 285 | 9.52 | 0.8% | 215 | 1473.42 | 99.1% |
| 9 | 272 | 10.88 | 0.7% | 228 | 1750.33 | 99.3% |
| 10 | 184 | 11.53 | 0.3% | 316 | 2057.70 | 99.7% |
| 11 | 154 | 12.37 | 0.3% | 346 | 1901.43 | 99.7% |
| 12 | 146 | 13.13 | 0.3% | 354 | 2058.17 | 99.7% |
| 13 | 109 | 13.90 | 0.2% | 391 | 2049.81 | 99.8% |
| 14 | 86 | 14.12 | 0.2% | 414 | 1820.57 | 99.8% |
| 15 | 78 | 13.66 | 0.1% | 422 | 1857.10 | 99.9% |

Three-way comparison (informational -- see "Reading the table" below):

- eval = `rulenode2expr` + a state-threading rewrite (`stateful_expr`) + literal `Core.eval` (fresh compile every call)
- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)
- custom = this benchmark's generated interpreter, same programs

| depth | progs | eval us | custom us | eval speed-up | interpret progs | interpret us | custom us | interpret speed-up |
|---|---|---|---|---|---|---|---|---|
| 5 | 100 | 432.48 | 4.94 | 88x | 100 | 2.08 | 4.94 | 0.4x |
| 6 | 100 | 513.58 | 7.54 | 68x | 100 | 2.96 | 7.54 | 0.4x |
| 7 | 100 | 611.56 | 6.25 | 98x | 62 | 2.81 | 7.54 | 0.4x |
| 8 | 100 | 819.40 | 8.40 | 98x | 58 | 3.25 | 8.58 | 0.4x |
| 9 | 100 | 963.31 | 10.42 | 92x | 52 | 3.94 | 10.50 | 0.4x |
| 10 | 100 | 4859.44 | 9.60 | 506x | 44 | 4.06 | 10.33 | 0.4x |
| 11 | 100 | 12459.54 | 12.54 | 993x | 25 | 4.54 | 12.62 | 0.4x |
| 12 | 100 | 10089.46 | 9.58 | 1053x | 30 | 4.29 | 11.15 | 0.4x |
| 13 | 100 | 12892.92 | 11.27 | 1144x | 22 | 5.06 | 13.27 | 0.4x |
| 14 | 100 | 13081.75 | 10.58 | 1236x | 16 | 6.06 | 13.23 | 0.5x |
| 15 | 100 | 14031.21 | 11.79 | 1190x | 24 | 5.29 | 13.00 | 0.4x |

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

