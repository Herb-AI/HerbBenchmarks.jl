[![codecov](https://codecov.io/gh/Herb-AI/HerbBenchmarks.jl/graph/badge.svg?token=VUK6MXLCU4)](https://codecov.io/gh/Herb-AI/HerbBenchmarks.jl)
[![Build Status](https://github.com/Herb-AI/HerbBenchmarks.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Herb-AI/HerbBenchmarks.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Dev-Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://Herb-AI.github.io/Herb.jl/dev)


# HerbBenchmarks.jl

A collection of useful program synthesis benchmarks. Each folder contains a different benchmark.

A benchmark includes:
- A README with relevant resources for the benchmark (papers, code repos, etc.) and a brief description of the data.
- `data.jl`: One or more data set(s) of input-output examples. For more details on how the data sets should look like, see [Benchmark data](#benchmark-data). 
- `citation.bib`: Reference to cite the benchmark.
- `grammar.jl`: One or more program grammar(s).
- `<benchmark>_primitivesl.jl`: Implementation of all primitives and the custom interpret function (if exists).

## Benchmark data


In `data.jl`, problems are defined following a specific structure:
- Each data set is represented by a `Problem` object with.
- A problem has a unique **identifier**, e.g., `"problem_100"`.
- A problem contains a list of `IOExample`s. 
    - The input `in` is of type `Dict{Symbol, Any}`, with `Symbol`s following the naming convention `_arg_1_`, `_arg_2_`, etc. 
    - The expected output `out` can be anything. 

```julia
# Example 
problem_100 = Problem("problem_100", [
	IOExample(Dict{Symbol, Any}(:_arg_1_ => StringState("369K 16 Oct 17:30 JCR-Menu.ppt", 1)), StringState("16 Oct", nothing)), 
	IOExample(Dict{Symbol, Any}(:_arg_1_ => StringState("732K 11 Oct 17:59 guide.pdf", 1)), StringState("11 Oct", nothing)), 
	IOExample(Dict{Symbol, Any}(:_arg_1_ => StringState("582K 18 Oct 12:13 make-01.pdf", 1)), StringState("18 Oct", nothing))
])

```

## How to use:
HerbBenchmarks is still not yet complete and is lacking crucial benchmarking functionality. However, if you want to test on a single problem and grammar, you can do the following

Select your favourite benchmark, we use the string transformation benchmark from the SyGuS challenge:
```Julia
using HerbSpecification, HerbGrammar

using HerbBenchmarks.PBE_SLIA_Track_2019

# The id has to be matching
grammar = PBE_SLIA_Track_2019.grammar_11604909
problem = PBE_SLIA_Track_2019.problem_11604909

# Print out the grammar and problem in readable format
println("grammar:", grammar)
println("problem:", problem.examples)
```

Some benchmarks there is only a single grammar for all problems. 
