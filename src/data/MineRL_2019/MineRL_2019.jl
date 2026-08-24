"""
    MineRL_2019

MineRL (Guss et al., IJCAI 2019), as a program synthesis benchmark. See
`README.md` in this directory for what is modelled, what is not, and why.

The six MineRL task families become two groups of problems, each with its own
grammar:

| Problems              | Grammar                          | MineRL task        |
|:----------------------|:---------------------------------|:-------------------|
| `navigate_01..05`     | [`grammar_minerl_navigate`](@ref) | `Navigate`         |
| `treechop`            | [`grammar_minerl`](@ref)          | `Treechop`         |
| `obtain_*`            | [`grammar_minerl`](@ref)          | `ObtainIronPickaxe`, `ObtainDiamond`, `ObtainCookedMeat`, `ObtainBed` |

Every problem holds a single example whose input is a starting
[`MineWorld`](@ref) and whose output is `true`: MineRL scores a task with a
sparse `+1` for reaching the goal or obtaining the item, so "did the plan
work?" is the whole specification.

```julia
using HerbBenchmarks
using HerbBenchmarks.MineRL_2019

pair = get_problem_grammar_pair(MineRL_2019, "obtain_wooden_pickaxe")
program = MineRL_2019.reference_program("obtain_wooden_pickaxe")
MineRL_2019.interpret(program, pair.problem.spec[1])       # true

MineRL_2019.visualize(program, pair.problem; path="pickaxe.gif")
```
"""
module MineRL_2019
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using ..VoxelRender

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("minerl_primitives.jl")
include("grammar.jl")
include("data.jl")
include("visualizer.jl")
include("solutions.jl")
include("evaluation.jl")

"""
    interpret(program, input)

Interpreter for [`grammar_minerl`](@ref) and [`grammar_minerl_navigate`](@ref).

One interpreter serves both, because the movement grammar is a rule-for-rule
prefix of the full one: rule `k` means the same thing in each, so a program
written against the smaller grammar interprets identically under the larger.
`test/test_minerl_2019.jl` checks that this stays true.
"""
interpret = make_interpreter(grammar_minerl; target_module=MineRL_2019, cache_module=MineRL_2019)

"""
    reference_program(identifier) -> RuleNode

A hand-written solution to a task, as a `RuleNode` over the problem's grammar.

These exist as a sanity check on the world model -- interpreting one must
return `true` -- and as a worked example of what a solution to each task looks
like. `SOLUTIONS` stores the `Sequence`; the grammar's first rule,
`Start = run_minerl(Sequence, _arg_1)`, supplies the surrounding call.
"""
reference_program(identifier::AbstractString) = RuleNode(1, [SOLUTIONS[identifier]])

export MineWorld, grammar_minerl, grammar_minerl_navigate

end # module MineRL_2019
