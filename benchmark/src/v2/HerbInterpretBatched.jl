"""
    HerbInterpretBatched

An experimental, from-scratch interpreter design: evaluates a program against
all of its examples in *one* tree-walk, instead of walking the tree once per
example the way `HerbInterpret.jl`'s generated interpreters (and this
benchmark's "custom v1") do. The branch-dispatch decision at each node --
which of a nonterminal's rules this node uses -- is then paid once per node
rather than once per node per example.

See `batched_interpret.jl` for the design (and the two dead ends ruled out
first: plain closures and `FunctionWrappers.jl`-erased closures, both measured
*slower* than today's interpreter, not faster -- see
`benchmark/README.md`'s "custom v2 (batched)" section).

Not exported from anywhere outside `benchmark/`; built purely so this
benchmark can report it alongside "custom" and "custom v1" as "custom v2
(batched)" -- see `targets.jl`.
"""
module HerbInterpretBatched

include("batched_interpret.jl")

export
    make_batched_interpreter,
    make_batched_stateful_interpreter,
    build_match_cases_batched,
    build_match_cases_stateful_batched

end # module HerbInterpretBatched
