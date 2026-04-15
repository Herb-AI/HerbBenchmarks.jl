# Abstraction and Reasoning Corpus (ARC) 2019

A benchmark on the Abstraction and Reasoning Corpus (ARC). ARC tasks are pairs of coloured input-output grids. Grid sizes range from a single cell up to `30 × 30`, and each cell can take one of `10` possible values (colours `0` to `9`).

The DSL used in this benchmark is based on Michael Hodel’s ARC-DSL. For more information, see the [ARC-DSL repository](https://github.com/michaelhodel/arc-dsl).

For more information on ARC itself, see the original [ARC repository](https://github.com/fchollet/ARC/tree/master).

## Representation

A `Grid` stores:

- width: number of columns
- height: number of rows
- data: a two-dimensional matrix of integers in 0:9

Each `Problem` is a list of examples, with each example consisting of an input `Grid` and an output `Grid`.

The benchmark includes two sub-datasets, training and evaluation.
These are stored in `ARC_AGI_1.ARC_AGI1_TRAINING` and `ARC_AGI_1.ARC_AGI1_EVALUATION` and can be accessed via:

```julia
training_problems() = ARC_AGI1_TRAINING
evaluation_problems() = ARC_AGI1_EVALUATION
all_problems() = ARC_AGI1_ALL # combines both into one large list.
```

Within each individual ARC problem, examples are originally divided into "train" and "test".
You can recover the original split using the corresponding split dictionary.

For example:

```julia
using HerbBenchmarks.ARC_AGI1

p = ARC_AGI1.problem_007bbfb7

train_examples(p)
test_examples(p)
```

