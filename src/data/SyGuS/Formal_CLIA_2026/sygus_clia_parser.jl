# Self-contained s-expression parser for the SyGuS v2 CLIA specification files
# in `specifications/*.sl`. Handles exactly the fragment used by these
# benchmarks: `set-logic`, `synth-fun`, `declare-var`, `declare-fun` (Int-sorted
# helper signatures such as `min`/`max`), `constraint`, and `check-synth`.

"""
    CLIASpec

A parsed SyGuS CLIA specification (formal, universally quantified constraints —
no IO examples).

# Fields
- `logic::String`: the `set-logic` argument (always `"LIA"` here).
- `fname::Symbol`: name of the function to synthesize (`synth-fun`).
- `params::Vector{Symbol}`: `synth-fun` formal parameter names, in order.
- `free_vars::Vector{Symbol}`: universally quantified `declare-var` names, in order.
- `constraints::Vector{String}`: each `constraint` body as a canonical SMT-LIB
  string (single spaces between tokens).
- `path::String`: path of the `.sl` file the spec was parsed from.
"""
struct CLIASpec
    logic::String
    fname::Symbol
    params::Vector{Symbol}
    free_vars::Vector{Symbol}
    constraints::Vector{String}
    path::String
end

"""
    _tokenize_sl(text::String)::Vector{String}

Tokenize SMT-LIB/SyGuS source: parentheses are single tokens, everything else is
split on whitespace. `;` line comments are stripped. (String literals do not
occur in these benchmarks.)
"""
function _tokenize_sl(text::String)::Vector{String}
    # Strip ; line comments
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
    _serialize_sexpr(sexpr)::String

Serialize an s-expression tree back to a canonical SMT-LIB string
(single spaces between tokens).
"""
_serialize_sexpr(sexpr::String) = sexpr
_serialize_sexpr(sexpr::Vector{Any}) = "(" * join(map(_serialize_sexpr, sexpr), " ") * ")"

"""
    parse_spec(path::AbstractString)::CLIASpec

Parse a SyGuS v2 CLIA specification file (`.sl`) into a [`CLIASpec`](@ref).

Only the fragment used by this benchmark set is supported: all sorts must be
`Int`, there must be exactly one `synth-fun`, and the only accepted top-level
forms are `set-logic`, `synth-fun`, `declare-var`, `declare-fun` (Int-sorted
helper signatures), `constraint`, and `check-synth`. Anything else (e.g.
`define-fun`, non-Int sorts) raises an error.
"""
function parse_spec(path::AbstractString)::CLIASpec
    tokens = _tokenize_sl(read(path, String))
    pos = Ref(1)
    forms = Any[]
    while pos[] <= length(tokens)
        push!(forms, _parse_sexpr(tokens, pos))
    end

    logic = ""
    fname = nothing
    params = Symbol[]
    free_vars = Symbol[]
    constraints = String[]

    for form in forms
        form isa Vector{Any} || error("Unexpected top-level atom '$form' in $path")
        isempty(form) && error("Empty top-level form in $path")
        head = form[1]
        if head == "set-logic"
            logic = form[2]::String
        elseif head == "synth-fun"
            fname === nothing ||
                error("Multiple synth-fun forms in $path; only one is supported")
            length(form) == 4 ||
                error("Unsupported synth-fun form (grammar templates are not supported) in $path")
            fname = Symbol(form[2]::String)
            form[4] == "Int" ||
                error("Unsupported synth-fun return sort '$(form[4])' in $path; only Int is supported")
            for p in form[3]
                (p isa Vector{Any} && length(p) == 2) ||
                    error("Malformed synth-fun parameter '$p' in $path")
                p[2] == "Int" ||
                    error("Unsupported parameter sort '$(p[2])' in $path; only Int is supported")
                push!(params, Symbol(p[1]::String))
            end
        elseif head == "declare-var"
            form[3] == "Int" ||
                error("Unsupported declare-var sort '$(form[3])' in $path; only Int is supported")
            push!(free_vars, Symbol(form[2]::String))
        elseif head == "declare-fun"
            # A few specs declare helper signatures `(declare-fun min (Int Int) Int)`
            # and `(declare-fun max (Int Int) Int)`. We accept (and validate) them
            # here; the checking layer gives `min`/`max` their standard LIA
            # semantics (see `spec_checking.jl`).
            all(s -> s == "Int", form[3]) && form[4] == "Int" ||
                error("Unsupported declare-fun sorts in '$(_serialize_sexpr(form))' in $path; only Int is supported")
            form[2] in ("min", "max") ||
                error("Unsupported uninterpreted function '$(form[2])' in $path; only min/max helpers are supported")
        elseif head == "constraint"
            length(form) == 2 || error("Malformed constraint form in $path")
            push!(constraints, _serialize_sexpr(form[2]))
        elseif head == "check-synth"
            # nothing to do
        else
            error("Unsupported top-level form '($head ...)' in $path")
        end
    end

    fname === nothing && error("No synth-fun form found in $path")
    isempty(constraints) && error("No constraint forms found in $path")

    return CLIASpec(logic, fname, params, free_vars, constraints, String(path))
end
