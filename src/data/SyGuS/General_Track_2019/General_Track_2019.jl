"""
    module General_Track_2019

The 945 General-track benchmarks of SyGuS-Comp 2019 (SyGuS-IF v1, `set-logic
BV|LIA`): formal synthesis problems over bitvectors, Booleans and linear
integer arithmetic, specified by universally quantified SMT constraints. The
five original benchmark families are kept as id prefixes:
`bv_conditional_inverses_*`, `bv_invertibility_conditions_*`,
`cegist_cav18_*`, `from_2018_*` (incl. `from_2018_CrCi_*`,
`from_2018_hd_pareto_*`), and `woosuk_*`.

Each problem `problem_<id>` wraps the parsed specification in an
`SMTSpecification`; the original `.sl` files are shipped verbatim in
`specifications/`. Each problem has a matching grammar `grammar_<id>`
(translated from the file's v1 grammar where present, otherwise a documented
default; multi-synth-fun problems additionally define
`grammar_<id>__<fname>` per synthesized function). Enumerated programs are
checked against the formal specification with the external `z3` binary via
[`check_program`](@ref) and [`check_clauses`](@ref) from
`SyGuSComp2019Common` — see `README.md` for complete examples. The module
loads without z3; the binary is only invoked inside the `check_*` calls.
"""
module General_Track_2019

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

end # module General_Track_2019
