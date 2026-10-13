# Point the benchmark environment at the local checkouts rather than at
# registered releases.
#
# The whole purpose of this directory is to measure the interpreters in
# ../../HerbInterpret.jl and the benchmarks in .., so a plain `Pkg.instantiate()`
# on a fresh clone would silently measure the wrong code. `Manifest.toml` is
# gitignored, so this has to be re-established per checkout.

using Pkg

Pkg.activate(@__DIR__)

const BENCH_ROOT = dirname(@__DIR__)
const HERB_SIBLINGS = dirname(BENCH_ROOT)

"""
    local_checkouts() -> Dict{String,String}

Packages that should be used from the working tree, mapped to their paths. A
sibling checkout that is not there is skipped, and its registered release is used
instead.
"""
function local_checkouts()
    wanted = Dict("HerbBenchmarks" => BENCH_ROOT)
    interpret = joinpath(HERB_SIBLINGS, "HerbInterpret.jl")
    if isdir(interpret)
        wanted["HerbInterpret"] = interpret
    else
        @warn "HerbInterpret.jl not found next to this repository; measuring the registered release" interpret
    end
    return wanted
end

"""
    ensure_local_checkouts()

`develop` anything that is not already tracking the right path, then instantiate.
"""
function ensure_local_checkouts()
    wanted = local_checkouts()
    installed = try
        Pkg.dependencies()
    catch
        nothing   # unresolved manifest: just develop everything
    end

    stale = String[]
    for (name, path) in wanted
        tracked = installed !== nothing && any(values(installed)) do info
            info.name == name && info.is_tracking_path &&
                realpath(info.source) == realpath(path)
        end
        tracked || push!(stale, path)
    end

    isempty(stale) || Pkg.develop([PackageSpec(path = path) for path in stale])
    Pkg.instantiate()
    return nothing
end

ensure_local_checkouts()
