using Revise
using HerbBenchmarks

using HerbCore
using HerbSearch
using HerbGrammar
using HerbInterpret
using HerbConstraints
using HerbSpecification

include("debug_benchmark/Debug_benchmark.jl")
using .Debug_benchmark


"""
The first step is to define the benchmark to be evaluated. One needs to specify the module
in which it is located. Additionally, a regex filter on the problem ids can be given to only
load a certain selection of problems. By default all problems are included.
"""
benchmark_1 = Benchmark(Debug_benchmark)
benchmark_2 = Benchmark(Debug_benchmark, problem_id_filter=r"[1-3]")

"""
Currently, running multiple benchmarks with the same name, will create messy results, so
we chose to run only one.
"""
benchmark = benchmark_2

"""
The next thing to define the iterator that is to be evaluated. Since an iterator takes in a
grammar and a starting symbol, which are unknown to the user, a constructor must be given.
This constructor takes in a grammar and a starting symbol and output an iterator.
"""
iterator_constructor(g, s) = BFSIterator(g, s)

"""
Now we can evaluate this iterator on a (or multiple) benchmarks(s). The evaluate_iterator
method takes in more parameters than the benchmark(s) and the iterator constructor. The 
user can define the following paramters:
    - shortcircuit (default true)              - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
    - allow_evaluation_errors (default false)  - Whether the search should crash if an exception is thrown in the evaluation
    - max_time (default infinity)              - The maximum time before termination of a single program search 
    - max_enumerations (default infinity)      - The maximum amount of enumerations before termination of a single program search
    - path (default nothing)                   - The location at which the result folder is located.

Most are probably familiar with all, except the path. This path is the location at which the 
results are stored. If the path is 'nothing', the results will not be stored and only returned
by the method. If a folder already exists at the specified path, an expection is thrown to
prevent corrupting results of the earlier evaluations. 
"""
path = "results"
res = evaluate_iterator(iterator_constructor, benchmark, max_time=1, path=path)

"""
When this is run, a folder called 'results' should exists. This folder has the following structure:
< specified_path >/
	environment.txt            Environment variables
	statistics.txt             Statistics per benchmark
	benchmarks/                Problem results per benchmark
		< benchmark 1 >.txt    ..Problem results benchmark 1
		< benchmark 2 >.txt    ..Problem results benchmark 2
		...
"""

res
