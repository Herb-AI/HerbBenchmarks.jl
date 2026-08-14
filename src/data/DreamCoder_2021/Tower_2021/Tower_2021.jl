"""
    Tower_2021

DreamCoder's block-tower domain (Ellis et al., 2021, Fig. 5): 113 "copy tasks"
in which a program must plan how a simulated hand builds a target tower out of
`1x3` and `3x1` blocks. See `src/data/DreamCoder_2021/README.md` for the
domain overview.

Each problem holds a single example: the input is a fresh [`TowerState`](@ref)
and the output is the target tower. Use [`tower_ascii`](@ref) to look at one.
"""
module Tower_2021
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("tower_primitives.jl")
include("visualizer.jl")
include("data.jl")
include("grammar.jl")
include("solutions.jl")

"""
    interpret(program, input)

Interpreter for [`grammar_tower`](@ref), built with
`HerbInterpret.make_interpreter`. Accepts an input dictionary, a
`HerbSpecification.IOExample`, or a vector of either.
"""
interpret = make_interpreter(grammar_tower; target_module=Tower_2021, cache_module=Tower_2021)

"""
    reference_program(identifier) -> RuleNode

The transcribed DreamCoder solution for a task, as a `RuleNode` over
[`grammar_tower`](@ref). Useful as a sanity check: interpreting it must
reproduce the problem's target tower.

`REFERENCE_PROGRAMS` stores the solution's `Sequence`; the grammar's first
rule, `Start = run_tower(Sequence, _arg_1)`, supplies the surrounding call.
"""
reference_program(identifier::AbstractString) =
    RuleNode(1, [expr2rulenode(REFERENCE_PROGRAMS[identifier], grammar_tower)])

end # module Tower_2021
