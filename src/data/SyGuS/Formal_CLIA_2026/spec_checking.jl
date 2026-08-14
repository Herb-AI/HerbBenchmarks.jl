# Z3-subprocess utilities for checking enumerated Herb programs against the
# formal SyGuS CLIA specifications in this benchmark set. Mirrors the approach
# of the students' CEGIS project (https://github.com/Rav0702/CEGIS): queries are
# written to a temporary .smt2 file and solved by the external `z3` binary.
# No CEGIS loop is provided here — only (per-spec and per-clause) checking.

"""
    expr_to_smt(expr, params::Vector{Symbol})::String

Convert a Julia expression produced by `HerbGrammar.rulenode2expr` on the
grammars of this benchmark set into an SMT-LIB LIA term.

Supported inputs: `Int` literals (incl. negative), argument symbols
`:_arg_1 .. :_arg_n` (mapped to `params[i]`), and calls to
`+ - * ifelse < <= > >= ==` (plus `Expr(:if, c, a, b)`).

`ifelse(c, a, b)` becomes `(ite c a b)`, `==` becomes `=`, and a negative
literal `n` becomes `(- |n|)`. If the root expression is a comparison (a Bool
term), it is wrapped as `(ite <cmp> 1 0)` so the result is always an Int term.
"""
function expr_to_smt(expr, params::Vector{Symbol})::String
    smt = _to_smt(expr, params)
    if expr isa Expr && expr.head == :call && expr.args[1] in (:<, :<=, :>, :>=, :(==))
        return "(ite $smt 1 0)"
    end
    return smt
end

_to_smt(n::Int, ::Vector{Symbol})::String = n >= 0 ? string(n) : "(- $(-n))"

function _to_smt(s::Symbol, params::Vector{Symbol})::String
    m = match(r"^_arg_(\d+)$", String(s))
    m === nothing && error("Unsupported symbol '$s' (expected _arg_1 .. _arg_$(length(params)))")
    i = parse(Int, m.captures[1])
    1 <= i <= length(params) ||
        error("Argument $s out of range: the synth-fun has $(length(params)) parameter(s)")
    return String(params[i])
end

function _to_smt(e::Expr, params::Vector{Symbol})::String
    if e.head == :call
        op = e.args[1]
        args = [_to_smt(a, params) for a in e.args[2:end]]
        if op == :ifelse
            length(args) == 3 || error("ifelse expects 3 arguments, got $(length(args))")
            return "(ite $(args[1]) $(args[2]) $(args[3]))"
        elseif op in (:+, :-, :*, :<, :<=, :>, :>=)
            return "($op $(join(args, " ")))"
        elseif op == :(==)
            return "(= $(join(args, " ")))"
        else
            error("Unsupported operator '$op' in expression '$e'")
        end
    elseif e.head == :if
        args = [_to_smt(a, params) for a in e.args]
        length(args) == 3 || error("if expects 3 arguments, got $(length(args))")
        return "(ite $(args[1]) $(args[2]) $(args[3]))"
    else
        error("Unsupported expression head '$(e.head)' in '$e'")
    end
end

_to_smt(x, ::Vector{Symbol}) = error("Unsupported expression of type $(typeof(x)): $x")

# A few specs (conditional_sum_medium, find_max_three_medium/hard, max_two_hard)
# declare helper signatures `(declare-fun min (Int Int) Int)` / `max` and use
# them in constraints. We give them their standard LIA semantics via define-fun
# whenever a constraint references them.
const _MINMAX_DEFS = Dict(
    "min" => "(define-fun min ((a Int) (b Int)) Int (ite (<= a b) a b))",
    "max" => "(define-fun max ((a Int) (b Int)) Int (ite (>= a b) a b))",
)

_helper_defs(spec)::Vector{String} =
    [_MINMAX_DEFS[f] for f in ("min", "max")
     if any(occursin("($f ", c) for c in spec.constraints)]

_define_fun(spec, smt_body::AbstractString)::String =
    "(define-fun $(spec.fname) ($(join(["($p Int)" for p in spec.params], " "))) Int $smt_body)"

"""
    verification_query(spec, smt_body::AbstractString)::String

Build a full-specification SMT-LIB verification query for a candidate program
body (an SMT term over the synth-fun parameters, see [`expr_to_smt`](@ref)).

The query defines the candidate as the synth-fun, declares the free variables
as constants, and asserts the *negation* of the conjunction of all constraint
clauses. Semantics: `unsat` means the program satisfies the specification
universally; `sat` means the model is a counterexample input.

`spec` can be a [`CLIASpec`](@ref) or the NamedTuple stored in the problems'
`SMTSpecification` (both expose `fname`, `params`, `free_vars`, `constraints`).
"""
function verification_query(spec, smt_body::AbstractString)::String
    parts = String[]
    push!(parts, "(set-logic LIA)")
    append!(parts, _helper_defs(spec))
    push!(parts, _define_fun(spec, smt_body))
    for v in spec.free_vars
        push!(parts, "(declare-const $v Int)")
    end
    body = length(spec.constraints) == 1 ? spec.constraints[1] :
           "(and $(join(spec.constraints, " ")))"
    push!(parts, "(assert (not $body))")
    push!(parts, "(check-sat)")
    if !isempty(spec.free_vars)
        push!(parts, "(get-value ($(join(spec.free_vars, " "))))")
    end
    return join(parts, "\n") * "\n"
end

"""
    _run_z3(query::String; z3_cmd="z3")::String

Write `query` to a temporary `.smt2` file, run the z3 binary on it, and return
its stdout. The exit status is ignored (z3 may exit nonzero on unsat); callers
interpret the output. The temporary file is always deleted.
"""
function _run_z3(query::String; z3_cmd::AbstractString="z3")::String
    tmp = tempname() * ".smt2"
    try
        write(tmp, query)
        out = IOBuffer()
        run(pipeline(ignorestatus(Cmd([z3_cmd, tmp])); stdout=out, stderr=out))
        return String(take!(out))
    finally
        isfile(tmp) && rm(tmp)
    end
end

# Parse a z3 value term ("5", "(- 5)") to an Int. `v` is an atom String or a
# parsed s-expression list from `_parse_sexpr`.
function _z3_value_to_int(v)::Int
    v isa String && return parse(Int, v)
    v isa Vector{Any} && length(v) == 2 && v[1] == "-" && return -parse(Int, v[2]::String)
    error("Cannot parse z3 value '$v' as an Int")
end

# Parse z3 `(get-value ...)` output text (e.g. "((x 1)\n (y (- 5)))") into a
# Dict{Symbol,Int}.
function _parse_model(text::AbstractString)::Dict{Symbol,Int}
    tokens = _tokenize_sl(String(text))
    pos = Ref(1)
    model = Dict{Symbol,Int}()
    while pos[] <= length(tokens)
        sexpr = _parse_sexpr(tokens, pos)
        sexpr isa Vector{Any} || continue
        for pair in sexpr
            (pair isa Vector{Any} && length(pair) == 2 && pair[1] isa String) || continue
            model[Symbol(pair[1])] = _z3_value_to_int(pair[2])
        end
    end
    return model
end

"""
    check_program(spec, expr; z3_cmd="z3")

Check a candidate program (a Julia expression from `rulenode2expr`, see
[`expr_to_smt`](@ref)) against the full specification using the external z3
binary.

Returns a NamedTuple `(verified, counterexample)`:
- `(verified=true, counterexample=nothing)` if z3 reports `unsat` (the program
  satisfies every constraint for all inputs);
- `(verified=false, counterexample::Dict{Symbol,Int})` if z3 reports `sat`
  (the dict is a concrete input on which the program violates the spec).

Errors if z3 reports `unknown` or produces unparseable output.
"""
function check_program(spec, expr; z3_cmd::AbstractString="z3")
    query = verification_query(spec, expr_to_smt(expr, Vector{Symbol}(spec.params)))
    out = _run_z3(query; z3_cmd=z3_cmd)
    lines = [strip(l) for l in split(out, '\n') if !isempty(strip(l))]
    verdict = isempty(lines) ? "" : lines[1]
    if verdict == "unsat"
        return (verified=true, counterexample=nothing)
    elseif verdict == "sat"
        model = _parse_model(join(lines[2:end], "\n"))
        return (verified=false, counterexample=model)
    else
        error("z3 did not return sat/unsat for spec '$(spec.fname)'. Raw output:\n$out")
    end
end

"""
    check_clauses(spec, expr; z3_cmd="z3")::Vector{Bool}

Check, for each constraint clause of the specification separately, whether the
candidate program satisfies it *universally* (for all inputs). All clauses are
checked in a single z3 process using assumption literals and
`(check-sat-assuming ...)` — the students' "Method 2".

For clause `i`, the query asserts `(=> csat_i (not Ci))` and checks
satisfiability assuming `csat_i`: `unsat` means no input violates clause `i`,
i.e. the clause is satisfied universally (`true` in the result vector).
"""
function check_clauses(spec, expr; z3_cmd::AbstractString="z3")::Vector{Bool}
    n = length(spec.constraints)
    parts = String[]
    push!(parts, "(set-logic LIA)")
    append!(parts, _helper_defs(spec))
    push!(parts, _define_fun(spec, expr_to_smt(expr, Vector{Symbol}(spec.params))))
    for v in spec.free_vars
        push!(parts, "(declare-const $v Int)")
    end
    for (i, c) in enumerate(spec.constraints)
        push!(parts, "(declare-const csat_$i Bool)")
        push!(parts, "(assert (=> csat_$i (not $c)))")
    end
    for i in 1:n
        push!(parts, "(echo \"clause_$i\")")
        push!(parts, "(check-sat-assuming (csat_$i))")
    end
    out = _run_z3(join(parts, "\n") * "\n"; z3_cmd=z3_cmd)

    verdicts = fill(:missing, n)
    current = 0
    for raw in split(out, '\n')
        line = strip(strip(raw), ['"'])
        isempty(line) && continue
        m = match(r"^clause_(\d+)$", line)
        if m !== nothing
            current = parse(Int, m.captures[1])
        elseif 1 <= current <= n && line in ("sat", "unsat", "unknown")
            verdicts[current] = Symbol(line)
            current = 0
        end
    end
    any(v -> v ∉ (:sat, :unsat), verdicts) &&
        error("z3 did not return sat/unsat for every clause of '$(spec.fname)'. Raw output:\n$out")
    return [v == :unsat for v in verdicts]
end
