"""
    module SyGuSComp2019Common

Shared parsing and z3-based checking utilities for the three formal SyGuS-Comp
2019 benchmark sets (`General_Track_2019`, `CLIA_Track_2019`, `Inv_Track_2019`).
This module is included once from `HerbBenchmarks` and referenced by the three
track modules via `using ..SyGuSComp2019Common`.

The specifications are SyGuS-IF v1 files. [`parse_spec_file`](@ref) parses a
`.sl` file into a [`CompSpec`](@ref); [`check_program`](@ref) and
[`check_clauses`](@ref) verify candidate programs against the specification by
running the external `z3` binary on a temporary `.smt2` file — the same
subprocess style as `Formal_CLIA_2026.spec_checking`. The module itself loads
without z3; the binary is only invoked inside the `check_*` calls.
"""
module SyGuSComp2019Common

export CompSpec, PreambleItem, parse_spec_file, expr_to_smt,
    verification_query, check_program, check_clauses

# ---------------------------------------------------------------------------
# S-expression tokenizer / parser / serializer (same approach as
# Formal_CLIA_2026/sygus_clia_parser.jl; duplicated here because that module
# is self-contained and must not be modified).
# ---------------------------------------------------------------------------

"""
    _tokenize_sl(text::String)::Vector{String}

Tokenize SMT-LIB/SyGuS source: parentheses are single tokens, everything else
is split on whitespace. `;` line comments are stripped. (String literals do
not occur in the SyGuS-Comp 2019 formal tracks.)
"""
function _tokenize_sl(text::String)::Vector{String}
    text = replace(text, r";[^\n]*" => "")
    tokens = String[]
    i = firstindex(text)
    n = lastindex(text)
    while i <= n
        c = text[i]
        if isspace(c)
            i = nextind(text, i)
        elseif c == '(' || c == ')'
            push!(tokens, string(c))
            i = nextind(text, i)
        else
            j = i
            while j <= n && !isspace(text[j]) && text[j] != '(' && text[j] != ')'
                j = nextind(text, j)
            end
            push!(tokens, text[i:prevind(text, j)])
            i = j
        end
    end
    return tokens
end

"""
    _parse_sexpr(tokens, pos::Ref{Int})

Read one s-expression starting at `tokens[pos[]]`. Returns either a `String`
(atom) or a `Vector{Any}` (list); advances `pos`.
"""
function _parse_sexpr(tokens::Vector{String}, pos::Ref{Int})
    pos[] > length(tokens) && error("Unexpected end of input while parsing s-expression")
    t = tokens[pos[]]
    pos[] += 1
    t == ")" && error("Unexpected ')' while parsing s-expression")
    t != "(" && return t
    children = Any[]
    while pos[] <= length(tokens) && tokens[pos[]] != ")"
        push!(children, _parse_sexpr(tokens, pos))
    end
    pos[] > length(tokens) && error("Missing ')' while parsing s-expression")
    pos[] += 1  # consume ')'
    return children
end

"""
Serialize an s-expression tree back to a canonical single-space string.
SyGuS-IF v1 allows nullary function applications `(f)`, which SMT-LIB 2 (and
z3) reject — singleton atom lists are therefore collapsed to the bare atom.
"""
_serialize_sexpr(sexpr::String) = sexpr
function _serialize_sexpr(sexpr::Vector{Any})
    length(sexpr) == 1 && sexpr[1] isa String && return sexpr[1]::String
    return "(" * join(map(_serialize_sexpr, sexpr), " ") * ")"
end

"Parse a whole file into a vector of top-level s-expressions."
function _parse_sl_forms(text::String)
    tokens = _tokenize_sl(text)
    pos = Ref(1)
    forms = Any[]
    while pos[] <= length(tokens)
        push!(forms, _parse_sexpr(tokens, pos))
    end
    return forms
end

_is_sort(s) = s isa String ? s in ("Int", "Bool", "Real") :
              (s isa Vector{Any} && length(s) == 2 && s[1] == "BitVec")

"""
    _fix_lets(sexpr)

SyGuS-IF v1 `let` bindings carry a sort annotation — `(let ((x <sort> <term>) ...)
<body>)` — which SMT-LIB 2 (and hence z3) does not accept. Rewrite every such
3-element binding to the 2-element SMT-LIB form `(x <term>)`, recursively.
Everything else is passed through verbatim.
"""
_fix_lets(sexpr::String) = sexpr
function _fix_lets(sexpr::Vector{Any})
    if length(sexpr) == 3 && sexpr[1] == "let" && sexpr[2] isa Vector{Any}
        bindings = Any[]
        for b in sexpr[2]
            if b isa Vector{Any} && length(b) == 3 && _is_sort(b[2])
                push!(bindings, Any[b[1], _fix_lets(b[3])])
            elseif b isa Vector{Any}
                push!(bindings, Any[b[1], map(_fix_lets, b[2:end])...])
            else
                push!(bindings, b)
            end
        end
        return Any["let", bindings, _fix_lets(sexpr[3])]
    end
    return Any[_fix_lets(c) for c in sexpr]
end

# ---------------------------------------------------------------------------
# CompSpec and parse_spec_file
# ---------------------------------------------------------------------------

"""
    PreambleItem

One ordered top-level item of a specification file's preamble.

- `kind`: `:define_fun`, `:synth_fun` (also used for `synth-inv`),
  `:declare_var`, or `:declare_primed_var`.
- `text`: the canonical serialization of the original form (`let` bindings
  rewritten to SMT-LIB 2 syntax, see `_fix_lets`).
- `fname`: for `:define_fun`/`:synth_fun` the defined/synthesized function
  name, otherwise `nothing`.
"""
struct PreambleItem
    kind::Symbol
    text::String
    fname::Union{Symbol,Nothing}
end

const SynthFunSig = @NamedTuple{name::Symbol, params::Vector{Symbol},
    param_sorts::Vector{String}, ret_sort::String}
const FreeVar = @NamedTuple{name::Symbol, sort::String}

"""
    CompSpec

A parsed SyGuS-IF v1 specification from the SyGuS-Comp 2019 formal tracks.

# Fields
- `logic::String`: the `set-logic` argument (`"LIA"`, `"BV"`, or `"SAT"`).
- `preamble::Vector{PreambleItem}`: `define-fun`s, `synth-fun`s/`synth-inv`s
  and variable declarations *in source order* (`define-fun`s may reference the
  synthesized function(s), so order matters when building queries).
- `synth_funs::Vector`: signature of each `synth-fun`/`synth-inv`, as NamedTuples
  `(name, params, param_sorts, ret_sort)`; `synth-inv` has `ret_sort = "Bool"`.
- `grammar_sexprs::Vector`: per synth-fun, the raw v1 grammar s-expression, or
  `nothing` if the synth-fun declares no grammar.
- `free_vars::Vector`: NamedTuples `(name, sort)` of the universally quantified
  variables (`declare-var`s; `declare-primed-var p σ` yields both `p` and `p!`).
- `constraints::Vector{String}`: canonical constraint clauses. An
  `inv-constraint` is expanded at parse time into the three standard clauses
  (pre ⟹ inv, inv ∧ trans ⟹ inv', inv ⟹ post) over unprimed/primed variables.
- `path::String`: the parsed `.sl` file.
"""
struct CompSpec
    logic::String
    preamble::Vector{PreambleItem}
    synth_funs::Vector{SynthFunSig}
    grammar_sexprs::Vector{Any}
    free_vars::Vector{FreeVar}
    constraints::Vector{String}
    path::String
end

_sort_string(s) = s isa String ? s : _serialize_sexpr(s)

function _parse_signature(form)::SynthFunSig
    name = Symbol(form[2]::String)
    params = Symbol[]
    param_sorts = String[]
    for p in form[3]
        (p isa Vector{Any} && length(p) == 2) ||
            error("Malformed parameter '$p' in $(form[1]) $(form[2])")
        push!(params, Symbol(p[1]::String))
        push!(param_sorts, _sort_string(p[2]))
    end
    ret_sort = form[1] == "synth-inv" ? "Bool" : _sort_string(form[4])
    return (name=name, params=params, param_sorts=param_sorts, ret_sort=ret_sort)
end

_apply(f::Symbol, args::Vector{Symbol})::String =
    isempty(args) ? String(f) : "($f $(join(args, " ")))"

"""
    parse_spec_file(path::AbstractString)::CompSpec

Parse a SyGuS-IF v1 specification file (`.sl`) from the SyGuS-Comp 2019
General/CLIA/Inv tracks into a [`CompSpec`](@ref).

Accepted top-level forms: `set-logic`, `define-fun`, `synth-fun` (with or
without a v1 grammar, one or more per file), `synth-inv`, `declare-var`,
`declare-primed-var`, `constraint`, `inv-constraint`, and `check-synth`.
`inv-constraint` is expanded into the three standard invariant clauses.
"""
function parse_spec_file(path::AbstractString)::CompSpec
    forms = _parse_sl_forms(read(path, String))

    logic = ""
    preamble = PreambleItem[]
    synth_funs = SynthFunSig[]
    grammar_sexprs = Any[]
    free_vars = FreeVar[]
    constraints = String[]

    for form in forms
        form isa Vector{Any} || error("Unexpected top-level atom '$form' in $path")
        isempty(form) && error("Empty top-level form in $path")
        head = form[1]
        if head == "set-logic"
            logic = form[2]::String
        elseif head == "define-fun"
            fixed = _fix_lets(form)
            push!(preamble, PreambleItem(:define_fun, _serialize_sexpr(fixed), Symbol(form[2]::String)))
        elseif head == "synth-fun" || head == "synth-inv"
            sig = _parse_signature(form)
            push!(synth_funs, sig)
            grammar_form_len = head == "synth-inv" ? 4 : 5
            push!(grammar_sexprs, length(form) >= grammar_form_len ? form[grammar_form_len] : nothing)
            push!(preamble, PreambleItem(:synth_fun, _serialize_sexpr(form), sig.name))
        elseif head == "declare-var"
            push!(free_vars, (name=Symbol(form[2]::String), sort=_sort_string(form[3])))
            push!(preamble, PreambleItem(:declare_var, _serialize_sexpr(form), nothing))
        elseif head == "declare-primed-var"
            sort = _sort_string(form[3])
            push!(free_vars, (name=Symbol(form[2]::String), sort=sort))
            push!(free_vars, (name=Symbol(form[2]::String * "!"), sort=sort))
            push!(preamble, PreambleItem(:declare_primed_var, _serialize_sexpr(form), nothing))
        elseif head == "constraint"
            length(form) == 2 || error("Malformed constraint form in $path")
            push!(constraints, _serialize_sexpr(_fix_lets(form[2])))
        elseif head == "inv-constraint"
            length(form) == 5 || error("Malformed inv-constraint form in $path")
            invf, pref, transf, postf = Symbol.(String.(form[2:5]))
            idx = findfirst(sf -> sf.name == invf, synth_funs)
            idx === nothing && error("inv-constraint references unknown synth-inv '$invf' in $path")
            vs = synth_funs[idx].params
            vps = [Symbol(String(v) * "!") for v in vs]
            push!(constraints, "(=> $(_apply(pref, vs)) $(_apply(invf, vs)))")
            push!(constraints,
                "(=> (and $(_apply(invf, vs)) $(_apply(transf, vcat(vs, vps)))) $(_apply(invf, vps)))")
            push!(constraints, "(=> $(_apply(invf, vs)) $(_apply(postf, vs)))")
        elseif head == "check-synth"
            # nothing to do
        else
            error("Unsupported top-level form '($head ...)' in $path")
        end
    end

    isempty(logic) && error("No set-logic form found in $path")
    isempty(synth_funs) && error("No synth-fun/synth-inv form found in $path")
    isempty(constraints) && error("No constraint forms found in $path")

    return CompSpec(logic, preamble, synth_funs, grammar_sexprs, free_vars,
        constraints, String(path))
end

"""
    _as_compspec(x)::CompSpec

Accept a [`CompSpec`](@ref), a `Problem`, an `SMTSpecification`, or the
NamedTuple stored as the specification formula in `data.jl` (anything with a
`spec_file` field). NamedTuples are resolved by (re)parsing their `spec_file`.
"""
_as_compspec(s::CompSpec)::CompSpec = s
function _as_compspec(x)::CompSpec
    hasproperty(x, :spec) && return _as_compspec(x.spec)        # Problem
    hasproperty(x, :formula) && return _as_compspec(x.formula)  # SMTSpecification
    hasproperty(x, :spec_file) && return parse_spec_file(x.spec_file)
    error("Cannot interpret $(typeof(x)) as a SyGuS-Comp 2019 specification")
end

"The unique BitVec width used by the spec, or `nothing` (every SyGuS-Comp 2019
file uses at most one BitVec width)."
function _bv_width(spec::CompSpec)::Union{Int,Nothing}
    widths = Set{Int}()
    scan(sort::String) = begin
        m = match(r"^\(BitVec (\d+)\)$", sort)
        m !== nothing && push!(widths, parse(Int, m.captures[1]))
    end
    for sf in spec.synth_funs
        scan(sf.ret_sort)
        foreach(scan, sf.param_sorts)
    end
    for v in spec.free_vars
        scan(v.sort)
    end
    isempty(widths) && return nothing
    length(widths) == 1 || error("Multiple BitVec widths in $(spec.path): $widths")
    return first(widths)
end

# ---------------------------------------------------------------------------
# expr_to_smt: Julia grammar expressions -> SMT-LIB terms
# ---------------------------------------------------------------------------

"""
    expr_to_smt(expr; ret_sort=nothing, bv_width=nothing, nt_sorts=nothing)::String

Convert a Julia expression produced by `HerbGrammar.rulenode2expr` on the
grammars of the SyGuS-Comp 2019 benchmark sets into an SMT-LIB term.

The grammars use function-call syntax with SMT operator names; the reverse
mapping applied here is: `eq` → `=`, `implies` → `=>`, `ite`/`ifelse` → `ite`,
`==` → `=`, and every other call head verbatim (`and`, `or`, `not`, `xor`,
`bvadd`, `+`, `<=`, `mod`, helper names like `shr1`, ...). Parameters appear
under their original names and are emitted verbatim (symbols such as
`var"x.end"` print as `x.end`).

Literals: `Int` prints as a decimal (negative as `(- n)`), `Bool` as
`true`/`false`, and unsigned integers (the grammars' BitVec literals, stored
as `UInt64`) as `#x...` padded to the problem's BitVec width. The width is
taken from `bv_width`, or derived from `ret_sort` / the values of `nt_sorts`
(a `Dict{Symbol,String}` mapping grammar nonterminals to sorts, shipped as the
`nt_sorts` field of each problem's specification formula).
"""
function expr_to_smt(expr; ret_sort::Union{AbstractString,Nothing}=nothing,
    bv_width::Union{Int,Nothing}=nothing, nt_sorts=nothing)::String
    w = bv_width
    if w === nothing
        for sort in Iterators.flatten(((ret_sort === nothing ? () : (ret_sort,)),
            (nt_sorts === nothing ? () : values(nt_sorts))))
            m = match(r"\(BitVec (\d+)\)", String(sort))
            if m !== nothing
                w = parse(Int, m.captures[1])
                break
            end
        end
    end
    return _to_smt(expr, w)
end

_to_smt(b::Bool, ::Union{Int,Nothing})::String = b ? "true" : "false"
_to_smt(n::Integer, ::Union{Int,Nothing})::String = n >= 0 ? string(n) : "(- $(-n))"

function _to_smt(v::Unsigned, w::Union{Int,Nothing})::String
    w === nothing &&
        error("Cannot print BitVec literal $v: no BitVec width available (pass bv_width/ret_sort/nt_sorts)")
    w % 4 == 0 || error("BitVec width $w is not a multiple of 4")
    return "#x" * string(UInt64(v), base=16, pad=w ÷ 4)
end

_to_smt(s::Symbol, ::Union{Int,Nothing})::String = String(s)

function _to_smt(e::Expr, w::Union{Int,Nothing})::String
    if e.head == :call
        op = e.args[1]
        args = [_to_smt(a, w) for a in e.args[2:end]]
        smt_op = op == :eq ? "=" :
                 op == :(==) ? "=" :
                 op == :implies ? "=>" :
                 op in (:ite, :ifelse) ? "ite" :
                 op isa Symbol ? String(op) :
                 error("Unsupported operator '$op' in expression '$e'")
        return "($smt_op $(join(args, " ")))"
    elseif e.head == :if
        args = [_to_smt(a, w) for a in e.args]
        length(args) == 3 || error("if expects 3 arguments, got $(length(args))")
        return "(ite $(args[1]) $(args[2]) $(args[3]))"
    else
        error("Unsupported expression head '$(e.head)' in '$e'")
    end
end

_to_smt(x, ::Union{Int,Nothing}) = error("Unsupported expression of type $(typeof(x)): $x")

# ---------------------------------------------------------------------------
# Query construction
# ---------------------------------------------------------------------------

# z3 does not know the SyGuS "SAT" logic name; ALL covers it.
_z3_logic(logic::String)::String = logic == "SAT" ? "ALL" : logic

# SyGuS-IF v1 writes bitvector sorts as `(BitVec n)`; SMT-LIB 2 (and z3)
# require the indexed form `(_ BitVec n)`. Applied to complete queries just
# before they are handed to z3 (`BitVec` occurs only in sort position in
# these benchmarks).
_smtlib2_sorts(s::String)::String = replace(s, r"\(BitVec (\d+)\)" => s"(_ BitVec \1)")

"""
    _candidate_bodies(spec, candidates)::Dict{Symbol,String}

Normalize a candidates argument into SMT body strings per synth-fun name.
`candidates` is a `Dict{Symbol,<body>}` keyed by synth-fun name (or a single
body when the spec has exactly one synth-fun). Bodies given as `AbstractString`
are used verbatim; anything else is converted with [`expr_to_smt`](@ref) using
the synth-fun's return sort and the spec's BitVec width.
"""
function _candidate_bodies(spec::CompSpec, candidates::AbstractDict)::Dict{Symbol,String}
    w = _bv_width(spec)
    bodies = Dict{Symbol,String}()
    for sf in spec.synth_funs
        haskey(candidates, sf.name) ||
            error("No candidate given for synth-fun '$(sf.name)' " *
                  "(required: $(join([s.name for s in spec.synth_funs], ", ")))")
        c = candidates[sf.name]
        bodies[sf.name] = c isa AbstractString ? String(c) :
                          expr_to_smt(c; ret_sort=sf.ret_sort, bv_width=w)
    end
    return bodies
end

function _candidate_bodies(spec::CompSpec, candidate)::Dict{Symbol,String}
    length(spec.synth_funs) == 1 ||
        error("Spec has $(length(spec.synth_funs)) synth-funs; pass a Dict{Symbol,<candidate>} keyed by name")
    return _candidate_bodies(spec, Dict(spec.synth_funs[1].name => candidate))
end

function _define_fun(sf::SynthFunSig, body::AbstractString)::String
    params = join(["($p $(σ))" for (p, σ) in zip(sf.params, sf.param_sorts)], " ")
    return "(define-fun $(sf.name) ($params) $(sf.ret_sort) $body)"
end

"""
    verification_query(spec, candidates)::String

Build a full-specification SMT-LIB verification query for candidate programs.

`spec` is anything `_as_compspec` accepts; `candidates` is a
`Dict{Symbol,<body>}` keyed by synth-fun name (or a single body if there is
exactly one synth-fun), where a body is an SMT term string or a Julia grammar
expression (see [`expr_to_smt`](@ref)).

The query declares every free variable as a constant, emits the preamble *in
source order* with each `synth-fun` replaced at its position by a `define-fun`
of the corresponding candidate (so later `define-fun`s that call the
synthesized function remain well-formed), and asserts the *negation* of the
conjunction of all constraint clauses. Semantics: `unsat` means the candidates
satisfy the specification universally; `sat` yields a counterexample model.
"""
function verification_query(spec, candidates)::String
    cspec = _as_compspec(spec)
    bodies = _candidate_bodies(cspec, candidates)
    parts = String[]
    push!(parts, "(set-logic $(_z3_logic(cspec.logic)))")
    for v in cspec.free_vars
        push!(parts, "(declare-const $(v.name) $(v.sort))")
    end
    for item in cspec.preamble
        if item.kind == :define_fun
            push!(parts, item.text)
        elseif item.kind == :synth_fun
            idx = findfirst(sf -> sf.name == item.fname, cspec.synth_funs)
            sf = cspec.synth_funs[idx]
            push!(parts, _define_fun(sf, bodies[sf.name]))
        end
        # :declare_var / :declare_primed_var already emitted as declare-consts
    end
    body = length(cspec.constraints) == 1 ? cspec.constraints[1] :
           "(and $(join(cspec.constraints, " ")))"
    push!(parts, "(assert (not $body))")
    push!(parts, "(check-sat)")
    if !isempty(cspec.free_vars)
        push!(parts, "(get-value ($(join([v.name for v in cspec.free_vars], " "))))")
    end
    return _smtlib2_sorts(join(parts, "\n") * "\n")
end

# ---------------------------------------------------------------------------
# Running z3 and parsing its output
# ---------------------------------------------------------------------------

"""
    _run_z3(query::String; z3_cmd="z3")::String

Write `query` to a temporary `.smt2` file, run the z3 binary on it, and return
its stdout. The exit status is ignored (z3 may exit nonzero); callers
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

# Parse a z3 model value: "5" -> 5, "(- 5)" -> -5, "true"/"false" -> Bool,
# "#x1f" / "#b101" -> UInt64. `v` is an atom String or a parsed s-expr list.
function _z3_value(v)
    if v isa String
        v == "true" && return true
        v == "false" && return false
        startswith(v, "#x") && return parse(UInt64, v[3:end], base=16)
        startswith(v, "#b") && return parse(UInt64, v[3:end], base=2)
        return parse(Int, v)
    end
    v isa Vector{Any} && length(v) == 2 && v[1] == "-" && return -_z3_value(v[2])
    error("Cannot parse z3 value '$v'")
end

# Parse z3 `(get-value ...)` output (e.g. "((x #x1f)\n (y (- 5)))") into a
# Dict{Symbol,Any}.
function _parse_model(text::AbstractString)::Dict{Symbol,Any}
    tokens = _tokenize_sl(String(text))
    pos = Ref(1)
    model = Dict{Symbol,Any}()
    while pos[] <= length(tokens)
        sexpr = _parse_sexpr(tokens, pos)
        sexpr isa Vector{Any} || continue
        for pair in sexpr
            (pair isa Vector{Any} && length(pair) == 2 && pair[1] isa String) || continue
            model[Symbol(pair[1])] = _z3_value(pair[2])
        end
    end
    return model
end

"""
    check_program(spec, candidates; z3_cmd="z3")

Check candidate programs against the full specification using the external z3
binary. `spec` and `candidates` are as in [`verification_query`](@ref) —
in particular, `candidates` can be a single `rulenode2expr` expression when
the spec has one synth-fun, or a `Dict{Symbol,<expr or SMT string>}` keyed by
synth-fun name for multi-synth-fun problems.

Returns a NamedTuple `(verified, counterexample)`:
- `(verified=true, counterexample=nothing)` if z3 reports `unsat` (the
  candidates satisfy every constraint for all inputs);
- `(verified=false, counterexample::Dict{Symbol,Any})` if z3 reports `sat`
  (a concrete assignment of the free variables violating the spec; Int values
  as `Int`, Bool as `Bool`, BitVec as `UInt64`).

Errors if z3 reports `unknown` or produces unparseable output.
"""
function check_program(spec, candidates; z3_cmd::AbstractString="z3")
    cspec = _as_compspec(spec)
    out = _run_z3(verification_query(cspec, candidates); z3_cmd=z3_cmd)
    lines = [strip(l) for l in split(out, '\n') if !isempty(strip(l))]
    verdict = isempty(lines) ? "" : lines[1]
    if verdict == "unsat"
        return (verified=true, counterexample=nothing)
    elseif verdict == "sat"
        return (verified=false, counterexample=_parse_model(join(lines[2:end], "\n")))
    else
        error("z3 did not return sat/unsat for '$(cspec.path)'. Raw output:\n$out")
    end
end

"""
    check_clauses(spec, candidates; z3_cmd="z3")::Vector{Bool}

Check, for each constraint clause of the specification separately, whether the
candidate programs satisfy it *universally*. All clauses are checked in a
single z3 process using assumption literals and `(check-sat-assuming ...)`
(the same "Method 2" as `Formal_CLIA_2026.check_clauses`): for clause `i` the
query asserts `(=> csat_i (not Ci))` and checks satisfiability assuming
`csat_i`; `unsat` means clause `i` holds for all inputs (`true` in the result).

For Inv-track problems the three clauses are, in order: pre ⟹ inv,
inv ∧ trans ⟹ inv', inv ⟹ post.
"""
function check_clauses(spec, candidates; z3_cmd::AbstractString="z3")::Vector{Bool}
    cspec = _as_compspec(spec)
    bodies = _candidate_bodies(cspec, candidates)
    n = length(cspec.constraints)
    parts = String[]
    push!(parts, "(set-logic $(_z3_logic(cspec.logic)))")
    for v in cspec.free_vars
        push!(parts, "(declare-const $(v.name) $(v.sort))")
    end
    for item in cspec.preamble
        if item.kind == :define_fun
            push!(parts, item.text)
        elseif item.kind == :synth_fun
            idx = findfirst(sf -> sf.name == item.fname, cspec.synth_funs)
            sf = cspec.synth_funs[idx]
            push!(parts, _define_fun(sf, bodies[sf.name]))
        end
    end
    for (i, c) in enumerate(cspec.constraints)
        push!(parts, "(declare-const csat_$i Bool)")
        push!(parts, "(assert (=> csat_$i (not $c)))")
    end
    for i in 1:n
        push!(parts, "(echo \"clause_$i\")")
        push!(parts, "(check-sat-assuming (csat_$i))")
    end
    out = _run_z3(_smtlib2_sorts(join(parts, "\n") * "\n"); z3_cmd=z3_cmd)

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
        error("z3 did not return sat/unsat for every clause of '$(cspec.path)'. Raw output:\n$out")
    return [v == :unsat for v in verdicts]
end

end # module SyGuSComp2019Common
