# Generates src/data/DreamCoder_2021/LOGO_2021/data.jl by running the reference
# programs in solutions.jl through this benchmark's own grammar and renderer.
#
# Producing the targets from Julia (rather than from the Python extractor that
# produced solutions.jl) keeps the specification and the evaluator on exactly
# the same code path, so a target can never disagree with its own reference
# program over a floating-point rounding difference.
using HerbCore, HerbSpecification, HerbGrammar, HerbInterpret

const DIR = abspath(ARGS[1])

module Gen
using HerbCore, HerbSpecification, HerbGrammar, HerbInterpret
using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)
const DIR = Main.DIR
include(joinpath(DIR, "logo_primitives.jl"))
include(joinpath(DIR, "grammar.jl"))
include(joinpath(DIR, "solutions.jl"))
interpret = make_interpreter(grammar_logo; target_module=Gen, cache_module=Gen)
end

function bitmatrix_literal(m::AbstractMatrix{Bool})
    rows = ["    " * join([m[r, c] ? "1" : "0" for c in axes(m, 2)], " ")
            for r in axes(m, 1)]
    return "Bool[\n" * join(rows, ";\n") * "]"
end

io = IOBuffer()
println(io, "# Auto-generated from DreamCoder's LOGO turtle-graphics domain")
println(io, "# (`dreamcoder/domains/logo/makeLogoTasks.py`, Ellis et al., 2021).")
println(io, "#")
println(io, "# Each problem has a single example: the input is a fresh `TurtleState`")
println(io, "# and the output is the target picture, a 28x28 bitmap produced by running")
println(io, "# the reference program in `solutions.jl` through this module's renderer.")
println(io)

for ident in sort(collect(keys(Gen.REFERENCE_PROGRAMS)))
    rn = RuleNode(1, [expr2rulenode(Gen.REFERENCE_PROGRAMS[ident], Gen.grammar_logo)])
    image = Gen.interpret(rn, Dict{Symbol,Any}(:_arg_1 => Gen.TurtleState()))
    println(io, "problem_$ident = Problem(\"problem_$ident\", [")
    println(io, "\tIOExample(Dict{Symbol, Any}(:_arg_1 => TurtleState()), $(bitmatrix_literal(image)))")
    println(io, "])\n")
end

write(joinpath(DIR, "data.jl"), String(take!(io)))
println("wrote $(length(Gen.REFERENCE_PROGRAMS)) LOGO problems")
