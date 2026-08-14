"""
    Physics_2021

DreamCoder's physical-law discovery domain (Ellis et al., 2021, Fig. 7A): 61
equations and mathematical identities taken from AP and MCAT physics tables,
each specified by 20 numerical examples. See
`src/data/DreamCoder_2021/README.md` for the domain overview.

Outputs are real-valued, so programs are checked with a tolerance rather than
by exact equality — use [`solves`](@ref) instead of comparing outputs with `==`.
"""
module Physics_2021
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("physics_primitives.jl")
include("data.jl")
include("signatures.jl")
include("grammars.jl")

"""
    make_physics_interpreter(g::AbstractGrammar)

Build an interpreter for a physics grammar. Grammars differ per problem (each
law has its own arity and argument types), so the interpreter is built per
grammar rather than once for the module.
"""
make_physics_interpreter(g::AbstractGrammar) =
    make_interpreter(g; target_module=Physics_2021, cache_module=Physics_2021)

"""
    solves(interpreter, program, problem; rtol=1e-6, atol=1e-8) -> Bool

Does `program` reproduce every example of `problem`?

This domain's outputs are floating-point, so exact equality is the wrong test:
DreamCoder itself scored these tasks with a squared-error loss under a
likelihood threshold. `solves` compares scalars and vectors with `isapprox`,
and returns `false` if the program throws (a division by zero, a square root
of a negative number, ...) on any example.
"""
function solves(interpreter, program::AbstractRuleNode, problem::Problem;
    rtol::Real=1e-6, atol::Real=1e-8)
    for example in problem.spec
        got = try
            interpreter(program, example.in)
        catch
            return false
        end
        expected = example.out
        if got isa AbstractVector && expected isa AbstractVector
            length(got) == length(expected) || return false
            all(isapprox.(got, expected; rtol, atol)) || return false
        elseif got isa Real && expected isa Real
            isapprox(got, expected; rtol, atol) || return false
        else
            return false
        end
    end
    return true
end

end # module Physics_2021
