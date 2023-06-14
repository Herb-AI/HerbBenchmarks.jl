module dev

include("Herb.jl")

using .Herb
using Revise

using .Herb.HerbConstraints
using .Herb.HerbGrammar
using .Herb.HerbSearch
using .Herb.HerbData
using .Herb.HerbEvaluation

using Serialization

"""
returns a list of programs and IOExamples that can be used to search.

grammar is the grammar to use
eval_type is the type of the resulting expression
min_size is the minimum size of the program
max_size is the maximum size of the program
variables is a list of variables in the grammar
domains is a list of domains for the variables
max_count is the maximum number of programs to return
skip is the number of programs to skip before appending one to the result
"""
function io_examples_all(grammar:: Grammar, eval_type:: Symbol, variables:: Vector{Symbol}, domains:: Vector{Vector{Any}}; min_size::Int, max_size::Int, max_count:: Int=10, skip:: Int=0) :: Vector{Tuple{RuleNode, Vector{IOExample}}}
    skip_rem = skip + 1
    es = []
    iterations = 0
    for program ∈ get_bfs_enumerator(grammar, typemax(Int), max_size, eval_type) 
        s = length(program)
        if s < min_size
            continue
        end
        if length(es) >= max_count
            break
        end
        iterations += 1
        if iterations % skip_rem != 0
            continue
        end
        println("Generated program $(rulenode2expr(program, grammar))")
        push!(es, (program, io_examples(grammar, program, variables, domains)))
    end
    return es
end

function io_examples(grammar:: Grammar, program:: RuleNode, variables:: Vector{Symbol}, domains:: Vector{Vector{Any}}) :: Vector{IOExample}
    symbol_table = SymbolTable(grammar)

    # TODO: only use variables that are actually in the program
    # How?

    expr = rulenode2expr(program, grammar)
    cartesian = Iterators.product(domains...)
    ret = []
    for variables_values ∈ cartesian
        input:: Dict{Symbol, Any} = Dict()
        for (i, v) ∈ enumerate(variables)
            input[v] = variables_values[i]
        end
        res = test_with_input(symbol_table, expr, input)
        push!(ret, IOExample(input, res))
    end
    return ret
end

g₁ = Herb.HerbGrammar.@csgrammar begin
    Real = Real + Real # 1
    Real = Real - Real # 2
    Real = Real * Real # 3
    Real = x           
    Real = y
    Real = z
end

examples₁ = io_examples_all(g₁, 
    :Real, 
    [:x, :y, :z], 
    Vector{Any}[
        [-1, 2], 
        [-2, 1], 
        [-3, 3]
    ]; min_size=6, max_size=8, max_count=10, skip=10)
# for (program, e) in examples₁
#     println(rulenode2expr(program, g₁))
#     for ex in e
#         println(ex)
#     end
# end
# println("")

# g₂ = Herb.HerbGrammar.@csgrammar begin
#     Bool = Bool & Bool
#     Bool = Bool | Bool
#     Bool = !Bool
#     Bool = x
#     Bool = y
#     Bool = z
# end

# examples₂ = io_examples_all(g₂, :Bool, 3, 5, [:x, :y, :z], Vector{Any}[[true, false], [true, false], [true, false]], 10, 10)

# g₃ = Herb.HerbGrammar.@csgrammar begin
#     List = (Item, List)
#     List = :Nil
#     Item = x
#     Item = y
#     Item = z
# end

# examples₃ = io_examples_all(g₃, :List, 12, 40, [:x, :y, :z], Vector{Any}[[-1, 0, 1, 2], [-1, 0, 1, 2], [-1, 0, 1, 2]], 10, 0)

tests = [
    (g₁, examples₁, :Real),
    # (g₂, examples₂, :Bool),
    # (g₃, examples₃, :List)
]

fout = "tests.bin"

open(fout, "w") do f
    serialize(f, tests)
end

println("Generated tests and written them to $fout")

end # module  

