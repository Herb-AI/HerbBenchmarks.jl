"""
    module Formal_CLIA_2026

Conditional linear integer arithmetic (CLIA) synthesis problems specified by
universally quantified formal SMT constraints (SyGuS v2, `set-logic LIA`) — not
by IO examples. The 31 problems originate from a master students' CEGIS project
(https://github.com/Rav0702/CEGIS).

Each problem `problem_<id>` wraps the parsed specification in an
`SMTSpecification`; the original `.sl` files are kept in `specifications/`.
Each problem has a matching grammar `grammar_<id>`. Enumerated programs are
checked against the specification with the external `z3` binary via
[`check_program`](@ref) and [`check_clauses`](@ref) — see `README.md` for
complete examples. The module itself loads fine without z3 installed; z3 is
only invoked inside the `check_*` calls.
"""
module Formal_CLIA_2026

using HerbCore
using HerbSpecification
using HerbGrammar

include("sygus_clia_parser.jl")
include("spec_checking.jl")
include("grammars.jl")
include("data.jl")

export
    CLIASpec,
    parse_spec,
    expr_to_smt,
    verification_query,
    check_program,
    check_clauses

end # module Formal_CLIA_2026
