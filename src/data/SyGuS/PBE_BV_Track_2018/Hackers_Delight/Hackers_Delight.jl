"""
    Hackers_Delight

The 27 Hacker's Delight bit-manipulation problems of the SyGuS competition
(`hd-01.sl` ... `hd-27.sl`, logic `BV`, 64-bit bit-vectors), turned into
programming-by-example problems.

Each problem ships

* `grammar_hd_NN` -- the original `synth-fun` grammar (see `grammars.jl`),
* `problem_hd_NN` -- ten `IOExample`s (see `data.jl`), each of them a model of
  the original `(constraint (= (hdNN x ...) (f x ...)))` produced by z3,
* `solution_hd_NN` -- the original `define-fun`, i.e. the reference
  implementation the examples were sampled from (see `solutions.jl`).

The grammar rules call the SMT-LIB bit-vector primitives of `hd_primitives.jl`;
use [`make_hd_interpreter`](@ref) to evaluate programs over them.

See `README.md` for the sampling procedure and for the list of benchmarks whose
reference implementation does not match the natural-language comment at the top
of their `.sl` file.
"""
module Hackers_Delight

using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("hd_primitives.jl")
include("solutions.jl")
include("grammars.jl")
include("data.jl")

"""
    make_hd_interpreter(g)

Build an interpreter for one of the `grammar_hd_NN` grammars. The rules call the
SMT-LIB primitives of `hd_primitives.jl`, so they have to be resolved inside this
module.
"""
function make_hd_interpreter(g)
    return make_interpreter(g; target_module=Hackers_Delight, cache_module=Hackers_Delight)
end

"""
    HD_IDENTIFIERS

The 27 problem identifiers, in benchmark order (`get_all_identifiers` returns
them alphabetically, which coincides here).
"""
const HD_IDENTIFIERS = ["hd_$(lpad(i, 2, '0'))" for i in 1:27]

"""
    solution(identifier::AbstractString)

The reference implementation (the `define-fun` of the original `.sl` file) of the
problem with the given `identifier`, e.g. `solution("hd_01")`. This is the
function the IO examples of `problem_hd_01` were sampled from.
"""
solution(identifier::AbstractString) = getfield(Hackers_Delight, Symbol("solution_" * identifier))

export
    make_hd_interpreter,
    HD_IDENTIFIERS,
    solution

end # module Hackers_Delight
