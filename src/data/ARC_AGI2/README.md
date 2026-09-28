# Abstraction and Reasoning Corpus (ARC) Challenge 2 (2025)

This module provides the public ARC-AGI-2 benchmark in the `Herb.jl` format.

## What is ARC-AGI-2?

ARC-AGI-2 is a benchmark for abstraction and reasoning. Each task consists of several example input/output grid pairs and one or more test inputs. The goal is to infer the transformation and produce the correct output grid(s).

ARC tasks are pairs of coloured input-output grids. Grid sizes range from a single cell up to `30 × 30`, and each cell can take one of `10` possible values (colours `0` to `9`).

We do not implement a grammar yet. We recommend reusing our implemented grammar from `ARC_AGI1`, based on Michael Hodel’s ARC-DSL. For more information, see the [ARC-DSL repository](https://github.com/michaelhodel/arc-dsl).

For more information on ARC-2 itself, see the original [ARC-2 repository](https://github.com/arcprize/ARC-AGI-2).

## Representation

A `Grid` stores:

- width: number of columns
- height: number of rows
- data: a two-dimensional matrix of integers in 0:9

Each `Problem` is a list of examples, with each example consisting of an input `Grid` and an output `Grid`.

The benchmark includes two sub-datasets, training and evaluation.
The benchmark includes two sub-datasets, training and evaluation.
These are stored in `ARC_AGI_2.ARC_AGI2_TRAINING` and `ARC_AGI_2.ARC_AGI2_EVALUATION` and can be accessed via:


```julia
training_problems() = ARC_AGI2_TRAINING
evaluation_problems() = ARC_AGI2_EVALUATION
all_problems() = ARC_AGI2_ALL # combines both into one large list.
```

Within each individual ARC problem, examples are originally divided into "train" and "test".
You can recover the original split using the corresponding split dictionary.

For example:

```julia
using HerbBenchmarks.ARC_AGI_2

p = ARC_AGI2.problem_007bbfb7

train_examples(p)
test_examples(p)
```

