#
# Offline generator: builds the Zenodo artifact payload for the SyGuS tracks.
#
# This is NOT part of the package. It is run by hand, against a local checkout of
# SyGuS-Org/benchmarks (the commit pinned in src/data/SyGuS/citation.bib), and its output is what
# gets tarballed and uploaded. See gen/README.md.
#
# Layout produced per track:
#
#   <track>/problems/<id>.jl    bare `Problem(...)` expression  (include() returns it)
#   <track>/grammars/<id>.jl    bare `@cfgrammar begin ... end` expression
#   <track>/sources/<id>.sl     pristine upstream file, never parsed at runtime
#   <track>/MANIFEST.toml       provenance
#
# Identifiers are derived once, by `HerbBenchmarks.sanitize_name(first(splitext(file)))`, and used
# for all three files. Problems and grammars are paired by that identifier, so deriving it in one
# place is what keeps them paired.
#

using HerbBenchmarks
using HerbSpecification
using HerbGrammar

include(joinpath(@__DIR__, "..", "src", "data", "SyGuS", "SyGuS.jl"))
using .SyGuS

const UPSTREAM_COMMIT = "13c8deb"

# SMT-LIB / ICFP operator -> the Julia semantics in bit_functions.jl.
# `if0` is present here but absent from the legacy text-rewriter in PBE_BV_Track_2018.jl, which is
# why regenerating with that rewriter would emit calls to an undefined `if0`.
const BV_FUNCTIONS = Dict{Symbol,Symbol}(
    :bvneg => :bvneg_cvc, :bvnot => :bvnot_cvc, :bvadd => :bvadd_cvc, :bvsub => :bvsub_cvc,
    :bvxor => :bvxor_cvc, :bvand => :bvand_cvc, :bvor => :bvor_cvc, :bvshl => :bvshl_cvc,
    :bvlshr => :bvlshr_cvc, :bvashr => :bvashr_cvc, :bvnand => :bvnand_cvc, :bvnor => :bvnor_cvc,
    :ehad => :ehad_cvc, :arba => :arba_cvc, :shesh => :shesh_cvc, :smol => :smol_cvc,
    :im => :im_cvc, :if0 => :if0_cvc,
)

# SMT-LIB string/int operators -> the Julia semantics in string_functions.jl.
const SLIA_FUNCTIONS = Dict{Symbol,Symbol}(
    Symbol("str.++") => :concat_cvc, Symbol("str.replace") => :replace_cvc,
    Symbol("str.at") => :at_cvc, Symbol("int.to.str") => :int_to_str_cvc,
    Symbol("str.substr") => :substr_cvc, Symbol("str.len") => :len_cvc,
    Symbol("str.to.int") => :str_to_int_cvc, Symbol("str.indexof") => :indexof_cvc,
    Symbol("str.prefixof") => :prefixof_cvc, Symbol("str.suffixof") => :suffixof_cvc,
    Symbol("str.contains") => :contains_cvc, Symbol("str.<") => :lt_cvc,
    Symbol("str.<=") => :leq_cvc, Symbol("str.isdigit") => :isdigit_cvc,
    Symbol("=") => :(==),
)

"""
    translate_rule(rule, functions)

Rewrites one parsed `synth-fun` production into its Herb form: SMT-LIB literals become Julia values
and operators are renamed to their `*_cvc` implementations. `ite` becomes a ternary, and `=`/`+`/`-`
stay as Julia infix calls.

Operates on the grammar rule itself rather than on emitted text — the legacy
`format_bit_operations_grammars` rewrote the written file line-by-line, which is how grammar names
drifted away from problem names in the first place.
"""
function translate_rule(rule, functions::Dict{Symbol,Symbol})
    if rule isa Expr
        rule.head == :call || return rule
        args = [translate_rule(a, functions) for a in rule.args[2:end]]
        head = rule.args[1]
        # (ite c a b) is a conditional, not a call: `c ? a : b` is Expr(:if, c, a, b).
        head === :ite && length(args) == 3 && return Expr(:if, args...)
        return Expr(:call, get(functions, head, head), args...)
    end
    # Parameters were already renamed to _arg_N by the parser, via the synth-fun signature.
    rule isa Symbol && return SyGuS.sygus_value(rule)   # #x… -> UInt64, "true" -> Bool, "2" -> Int
    return rule
end

"""
    render_rule(rule) -> String

Renders a translated rule as the one-line Julia source that `@cfgrammar` should read back.

Conditionals must be emitted in ternary form. `string(Expr(:if, …))` renders a multi-line `if … end`
block, which re-parses to `Expr(:if, cond, Expr(:block, …), Expr(:block, …))` — block-wrapped and
therefore not `==` to the ternary AST the grammar is supposed to hold, even though it looks
identical when printed.
"""
function render_rule(rule)
    if rule isa Expr && rule.head == :if && length(rule.args) == 3
        return string(render_rule(rule.args[1]), " ? ", render_rule(rule.args[2]), " : ",
                      render_rule(rule.args[3]))
    end
    return rule isa Expr || rule isa Symbol ? string(rule) : repr(rule)
end

"""
    grammar_source(grammar, functions) -> String

Renders a parsed grammar as a bare `@cfgrammar begin … end` expression. `repr` is used for atomic
right-hand sides so that `UInt64`s round-trip exactly as `0x…` literals and strings keep their
quotes.
"""
function grammar_source(grammar, functions::Dict{Symbol,Symbol})
    io = IOBuffer()
    println(io, "@cfgrammar begin")
    for (type, rule) in zip(grammar.types, grammar.rules)
        println(io, "    ", type, " = ", render_rule(translate_rule(rule, functions)))
    end
    println(io, "end")
    return String(take!(io))
end

"""
    problem_source(id, problem) -> String

Renders a `Problem` as a bare expression. `repr` guarantees an exact round-trip: BV inputs are 64-bit
`UInt64`s, and anything lossy here would corrupt the data silently.
"""
function problem_source(id::AbstractString, problem::Problem)
    io = IOBuffer()
    println(io, "Problem(", repr("problem_" * id), ", [")
    n = length(problem.spec)
    for (i, ex) in enumerate(problem.spec)
        inputs = join(("$(repr(k)) => $(repr(v))" for (k, v) in sort(collect(ex.in), by = first)), ", ")
        println(io, "    IOExample(Dict{Symbol, Any}(", inputs, "), ", repr(ex.out), ")", i == n ? "" : ",")
    end
    println(io, "])")
    return String(take!(io))
end

"""
    resolve_identifiers(source_dirs) -> Vector{Pair{String, String}}

Maps every upstream `.sl` path to the identifier it will be published under.

Distinct files can sanitize to the same identifier: `euphony/phone-5-short.sl` and
`from_2018/phone-5_short.sl` differ only by a hyphen versus an underscore, and both become
`phone_5_short`. Four SLIA pairs collide this way, and appending them to one `data.jl` silently kept
only whichever came last. Colliding identifiers are therefore qualified with their source directory;
unique ones are left alone.
"""
function resolve_identifiers(source_dirs::Vector{String})
    paths = [joinpath(dir, file) for dir in source_dirs for file in sort(readdir(dir))
             if endswith(file, ".sl")]

    counts = Dict{String,Int}()
    for path in paths
        id = HerbBenchmarks.sanitize_name(first(splitext(basename(path))))
        counts[id] = get(counts, id, 0) + 1
    end

    resolved = Pair{String,String}[]
    for path in paths
        id = HerbBenchmarks.sanitize_name(first(splitext(basename(path))))
        if counts[id] > 1
            id = HerbBenchmarks.sanitize_name(basename(dirname(path))) * "_" * id
        end
        push!(resolved, path => id)
    end
    return resolved
end

"""
    generate_track(; source_dirs, output_dir, functions, track) -> Vector{String}

Parses every `.sl` under `source_dirs` and writes the artifact payload for one track.

Throws on a duplicate identifier rather than letting a later file overwrite an earlier one.
"""
function generate_track(; source_dirs::Vector{String}, output_dir::AbstractString,
                        functions::Dict{Symbol,Symbol}, track::AbstractString)
    for sub in ("problems", "grammars", "sources")
        mkpath(joinpath(output_dir, sub))
    end

    seen = Dict{String,String}()
    skipped = String[]
    written = String[]
    qualified = String[]

    for (path, id) in resolve_identifiers(source_dirs)
        haskey(seen, id) && error("duplicate identifier '$id': '$(seen[id])' and '$path'")

        local problem, grammar
        try
            problem = SyGuS.parse_sygus_problem(path)
            grammar = SyGuS.parse_sygus_grammar(path)
        catch err
            push!(skipped, "$(basename(path)) [$(first(split(sprint(showerror, err), '\n')))]")
            continue
        end
        isempty(problem.spec) && (push!(skipped, "$(basename(path)) [no constraints]"); continue)

        seen[id] = path
        endswith(id, HerbBenchmarks.sanitize_name(first(splitext(basename(path))))) &&
            id != HerbBenchmarks.sanitize_name(first(splitext(basename(path)))) &&
            push!(qualified, id)

        write(joinpath(output_dir, "problems", "$id.jl"), problem_source(id, problem))
        write(joinpath(output_dir, "grammars", "$id.jl"), grammar_source(grammar, functions))
        cp(path, joinpath(output_dir, "sources", "$id.sl"); force = true)
        push!(written, id)
    end

    open(joinpath(output_dir, "MANIFEST.toml"), "w") do io
        println(io, "track = ", repr(track))
        println(io, "upstream_repo = \"https://github.com/SyGuS-Org/benchmarks\"")
        println(io, "upstream_commit = ", repr(UPSTREAM_COMMIT))
        println(io, "upstream_dirs = [", join((repr(basename(d)) for d in source_dirs), ", "), "]")
        println(io, "problem_count = ", length(written))
    end

    println("[$track] wrote $(length(written)) problem-grammar pairs -> $output_dir")
    isempty(qualified) || println("[$track] disambiguated $(length(qualified)): ", join(qualified, ", "))
    isempty(skipped) || println("[$track] skipped $(length(skipped)): ", join(skipped, ", "))
    return written
end

"""
    generate_all(upstream, output_dir)

Regenerates both SyGuS tracks. `upstream` is a checkout of SyGuS-Org/benchmarks at
[`UPSTREAM_COMMIT`], pointing at its `comp` directory.
"""
function generate_all(upstream::AbstractString, output_dir::AbstractString)
    generate_track(
        source_dirs = [joinpath(upstream, "2018", "PBE_BV_Track")],
        output_dir = joinpath(output_dir, "PBE_BV_Track_2018"),
        functions = BV_FUNCTIONS,
        track = "PBE_BV_Track_2018",
    )
    generate_track(
        source_dirs = [joinpath(upstream, "2019", "PBE_SLIA_Track", "euphony"),
                       joinpath(upstream, "2019", "PBE_SLIA_Track", "from_2018")],
        output_dir = joinpath(output_dir, "PBE_SLIA_Track_2019"),
        functions = SLIA_FUNCTIONS,
        track = "PBE_SLIA_Track_2019",
    )
end
