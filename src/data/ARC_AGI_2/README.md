# Abstraction and Reasoning Corpus (ARC) Challenge 2 

This module provides the public ARC-AGI-2 benchmark in the `Herb.jl` format.

## What is ARC-AGI-2?

ARC-AGI-2 is a benchmark for abstraction and reasoning. Each task consists of several example input/output grid pairs and one or more test inputs. The goal is to infer the transformation and produce the correct output grid(s).

## Dataset contents

The public ARC-AGI-2 dataset contains:

- **1,000 training tasks**
- **120 evaluation tasks**

In this package, both splits are translated into our `Problem` format.

## Task format

Each grid is a rectangular matrix of integers from `0` to `9`.

## Usage

Load the module and access the translated problems:

```julia
using HerbBenchmarks.ARC_AGI_2

training_problems()
evaluation_problems()
all_problems()
```

returns all training, evaluation, and all problems respectively.


