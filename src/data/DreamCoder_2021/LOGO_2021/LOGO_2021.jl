"""
    LOGO_2021

DreamCoder's LOGO turtle-graphics domain (Ellis et al., 2021, Fig. 4): 160
drawing tasks in which a program must steer a pen so that it reproduces a
target picture. See `src/data/DreamCoder_2021/README.md` for the domain
overview.

Each problem holds a single example: the input is a fresh [`TurtleState`](@ref)
and the output is the target picture as a 28x28 bitmap. Use
[`logo_ascii`](@ref) to look at one in a terminal, or [`logo_svg`](@ref) for a
proper vector rendering.
"""
module LOGO_2021
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("logo_primitives.jl")
include("visualizer.jl")
include("data.jl")
include("grammar.jl")
include("solutions.jl")

"""
    interpret(program, input)

Interpreter for [`grammar_logo`](@ref), built with
`HerbInterpret.make_interpreter`. Accepts an input dictionary, a
`HerbSpecification.IOExample`, or a vector of either.
"""
interpret = make_interpreter(grammar_logo; target_module=LOGO_2021, cache_module=LOGO_2021)

"""
    reference_program(identifier) -> RuleNode

The transcribed DreamCoder solution for a task, as a `RuleNode` over
[`grammar_logo`](@ref). Interpreting it must reproduce the problem's target
picture.

`REFERENCE_PROGRAMS` stores the solution's `Sequence`; the grammar's first
rule, `Start = run_logo(Sequence, _arg_1)`, supplies the surrounding call.
"""
reference_program(identifier::AbstractString) =
    RuleNode(1, [expr2rulenode(REFERENCE_PROGRAMS[identifier], grammar_logo)])

end # module LOGO_2021
