"""
    HerbInterpretV1

A frozen copy of `HerbInterpret.jl`'s `make_interpreter`/`make_stateful_interpreter`
as they were before the `optimize-generated-interpreters` branch (commit
`b5a6c5c`, the tip of `master` when that work started): a single
`RuntimeGeneratedFunctions`-backed recursive function per grammar, dispatching
on an untyped `Vector{AbstractRuleNode}` child and an `AbstractDict{Symbol,Any}`
input, both of which independently make the generated body infer as `Any` end
to end (see `HerbInterpret.jl`'s `make_interpret.jl` module docstring and
`benchmark/README.md` for the diagnosis).

Kept here, under a distinct module name, purely so `benchmark/` can build an
interpreter with *this* code and one with the current `HerbInterpret.jl` for
the exact same grammar in the same process, and report both -- "custom v1" for
this one, see `targets.jl`. Not exported, not a dependency of anything else;
delete this whole directory once that comparison is no longer wanted.
"""
module HerbInterpretV1

using HerbCore
using HerbGrammar
using HerbSpecification

include("make_interpret_v1.jl")

export
    make_interpreter,
    make_stateful_interpreter,
    build_match_cases,
    build_match_cases_stateful

end # module HerbInterpretV1
