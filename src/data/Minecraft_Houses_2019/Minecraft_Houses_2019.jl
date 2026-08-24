"""
    Minecraft_Houses_2019

The 3D-Craft house dataset (Chen et al., ICCV 2019), as a program synthesis
benchmark. See `README.md` in this directory for what is modelled and how the
data was selected.

3D-Craft is 2,586 Minecraft houses built by crowdworkers, each recorded as the
*ordered* sequence of blocks the human placed. Here, each house is a target
structure and the task is to write a program that builds it.

Each problem holds a single example: the input is an empty
[`HouseState`](@ref) and the output is the finished canvas, a
`Dict{NTuple{3,Int},Int}` of cell to Minecraft block id. Every problem has its
own grammar, offering exactly the block types its house is made of.

```julia
using HerbBenchmarks
using HerbBenchmarks.Minecraft_Houses_2019
const MH = Minecraft_Houses_2019

pair = get_problem_grammar_pair(Minecraft_Houses_2019, "house_0001")
program = MH.reference_program("house_0001")
MH.interpret(program, pair.problem.spec[1]) == pair.problem.spec[1].out   # true

MH.visualize(program, "house_0001"; path="house.gif")
```
"""
module Minecraft_Houses_2019
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using ..VoxelRender

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("houses_primitives.jl")
include("grammar.jl")
include("evaluation.jl")
include("visualizer.jl")
include("data.jl")
include("solutions.jl")

"""
    INTERPRETERS

Interpreters built so far, keyed by the grammar they were built for. See
[`interpreter_for`](@ref).
"""
const INTERPRETERS = IdDict{AbstractGrammar,Any}()

"""
    interpreter_for(grammar) -> GeneratedInterpreter

The interpreter for `grammar`, built on first use and cached.

There has to be one per grammar. Every house grammar shares its rule indices up
to the trailing `Block` rules, but *those* differ: index `n + 2` is block id `5`
in one house's grammar and block id `35` in another's. An interpreter compiled
against one grammar would silently build the right shape out of the wrong
materials in every other. Caching keeps that correctness from costing anything,
since a grammar is compiled at most once.
"""
interpreter_for(grammar::AbstractGrammar) = get!(INTERPRETERS, grammar) do
    make_interpreter(grammar; target_module=Minecraft_Houses_2019,
        cache_module=Minecraft_Houses_2019)
end

"""
    interpret(program, input, grammar=grammar_builder)

Interpret a house-building `program`, returning the canvas it builds.

`input` may be an input dictionary, an `IOExample`, or a vector of either.
`grammar` must be the grammar the program was written against -- for a problem,
that is `get_grammar(Minecraft_Houses_2019, identifier)`.

```julia
julia> pair = get_problem_grammar_pair(Minecraft_Houses_2019, "house_0001");
julia> interpret(reference_program("house_0001"), pair.problem.spec[1], pair.grammar)
```
"""
interpret(program::AbstractRuleNode, input, grammar::AbstractGrammar=grammar_builder) =
    interpreter_for(grammar)(program, input)

"""
    build(identifier) -> Dict{NTuple{3,Int},Int}

Build house `identifier` with its reference program, returning the canvas.

A shorthand for wiring up the program, the empty state and the right grammar,
which is what most uses of this benchmark start by doing.
"""
build(identifier::AbstractString) = interpret(
    reference_program(identifier),
    Dict{Symbol,Any}(:_arg_1 => HouseState()),
    HOUSE_GRAMMARS[identifier])

export HouseState, grammar_builder, house_grammar

end # module Minecraft_Houses_2019
