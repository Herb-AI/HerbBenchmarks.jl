# Benchmarks.jl

A collection of useful program synthesis benchmarks. Each folder contains a different benchmark and a README.

A benchmark has:
- A readme, including description of data fields and dimensionality
- (multiple) sets of input output examples
- file that references where we found that
- evaluation function/interpretation function
- program grammar

Optional:
- a data grammar or data generation scripts, ideally with a notion of increasing complexity
- download script to download that specific dataset, if too big for Github
- test-/train-split getter functions if specified in the original data
- landmarks for planning problems

## How to use:
HerbBenchmarks is still not yet complete and is lacking crucial benchmarking functionality. However, if you want to test on a single problem and grammar, you can do the following

Select your favourite benchmark, we use the string transformation benchmark from the SyGuS challenge:
```Julia
using HerbData, HerbGrammar

using HerbBenchmarks.PBE_SLIA_Track_2019

# The id has to be matching
grammar = PBE_SLIA_Track_2019.grammar_11604909
problem = PBE_SLIA_Track_2019.problem_11604909

# Print out the grammar and problem in readable format
println("grammar:", grammar)
println("problem:", problem.examples)
```

For some benchmarks there is only a single grammar for all problems. 
