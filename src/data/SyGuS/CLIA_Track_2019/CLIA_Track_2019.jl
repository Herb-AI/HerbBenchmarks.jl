"""
    module CLIA_Track_2019

The 88 CLIA-track benchmarks of SyGuS-Comp 2019 (SyGuS-IF v1, `set-logic
LIA`): conditional linear integer arithmetic synthesis problems specified by
universally quantified formal SMT constraints (no IO examples). The
`synth-fun`s declare no grammars in the source files, so every problem gets a
default CLIA grammar (parameters, the integer constants appearing in its
constraints plus `0`/`1`, `+ - *`, `ite`, and comparisons).

Each problem `problem_<id>` wraps the parsed specification in an
`SMTSpecification` (with the constraint clauses inlined as canonical strings —
this track's files are small); the original `.sl` files are shipped verbatim
in `specifications/`. Enumerated programs are checked against the formal
specification with the external `z3` binary via [`check_program`](@ref) and
[`check_clauses`](@ref) from `SyGuSComp2019Common` — see `README.md`. The
module loads without z3; the binary is only invoked inside the `check_*`
calls.
"""
module CLIA_Track_2019

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

end # module CLIA_Track_2019
