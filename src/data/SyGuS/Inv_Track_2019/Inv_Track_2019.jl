"""
    module Inv_Track_2019

The 858 Inv-track benchmarks of SyGuS-Comp 2019 (SyGuS-IF v1 `synth-inv`
loop-invariant synthesis; `set-logic LIA`, plus 15 Boolean Lustre problems
with `set-logic SAT`). The three original benchmark families are kept as id
prefixes: `From2018_*`, `Lustre_*`, and `XC_*`.

Each file's `(inv-constraint inv-f pre-f trans-f post-f)` is expanded at parse
time into the three standard clauses over the unprimed/primed program
variables: pre ⟹ inv, inv ∧ trans ⟹ inv′, and inv ⟹ post. Each problem
`problem_<id>` wraps the parsed specification in an `SMTSpecification`; the
original `.sl` files are shipped verbatim in `specifications/`. `synth-inv`
declares no grammar, so every problem gets a default invariant grammar over
the unprimed variables (Boolean combinations of comparisons between linear
terms; purely Boolean combinations for the Bool-typed problems). Candidate
invariants are checked with the external `z3` binary via
[`check_program`](@ref) and [`check_clauses`](@ref) from
`SyGuSComp2019Common` — see `README.md`. The module loads without z3; the
binary is only invoked inside the `check_*` calls.
"""
module Inv_Track_2019

using HerbCore
using HerbSpecification
using HerbGrammar
using ..SyGuSComp2019Common: CompSpec, PreambleItem, parse_spec_file,
    expr_to_smt, verification_query, check_program, check_clauses

include("grammars.jl")
include("data.jl")

export
    CompSpec,
    parse_spec_file,
    expr_to_smt,
    verification_query,
    check_program,
    check_clauses

end # module Inv_Track_2019
