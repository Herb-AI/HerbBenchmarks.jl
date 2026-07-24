"""
Retrieving larger versions of the PSB2 problems.

`data.jl` only holds the edge cases of every problem. The full training and
test sets are downloaded from the PSB2 website through the `psb2` python
package. That package is imported lazily, on the first call of
[`write_psb2_problems_to_file`](@ref): importing it at load time makes the
whole benchmark, and with it `HerbBenchmarks`, fail to load on a machine
without a working python environment.
"""

const _PSB2_PYTHON = Ref{Any}(nothing)

"""
    psb2_python()

The `psb2` python module, imported on first use.
"""
function psb2_python()
    if _PSB2_PYTHON[] === nothing
        try
            PythonCall = Base.require(Base.PkgId(
                Base.UUID("6099a3de-0909-46bc-b1f4-468b9a2dfc0d"), "PythonCall"))
            _PSB2_PYTHON[] = PythonCall.pyimport("psb2")
        catch e
            throw(ErrorException(
                "Could not import the `psb2` python package, which is needed to " *
                "download the full PSB2 problems. It is installed through the " *
                "CondaPkg.toml of HerbBenchmarks. Original error: $e"))
        end
    end
    return _PSB2_PYTHON[]
end

"""
    write_psb2_problems_to_file(problems, edge_or_random, n_train, n_test, format)

Download the given PSB2 `problems` and write them to
`src/data/PSB2_2021/datasets/<problem>`. Problem names use `-` as a separator,
for example `"fizz-buzz"`. With an empty list of problems, all 25 problems are
downloaded.

The downloaded files are json; use [`parse_line_json`](@ref) together with
`HerbBenchmarks.parse_to_julia` to turn them into `IOExample`s.
"""
function write_psb2_problems_to_file(
    problems::Vector{String}=String["fizz-buzz"],
    edge_or_random::String="random",
    n_train::Int64=200,
    n_test::Int64=2000,
    format::String="psb2"
)
    psb2 = psb2_python()
    available = [string(p) for p in psb2.PROBLEMS]
    if isempty(problems)
        problems = available
    end
    for name in problems
        if !(name in available)
            throw(ArgumentError("$(name) does not exist in the psb2 problems, the names use '-' as separator, not '_'."))
        end
        # This writes the json files to the datasets/<name> folder
        psb2.fetch_examples(dirname(@__FILE__), name, n_train, n_test, format)
    end
    return joinpath(dirname(@__FILE__), "datasets")
end
