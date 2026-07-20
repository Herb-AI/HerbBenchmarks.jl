# Benchmark artifact generation

Offline tooling. Nothing in this directory is loaded by the package — it is run by hand when a
benchmark's data needs to be (re)built from its upstream source and published.

## Why the data is not in `src/`

Benchmark data used to be checked in as generated Julia source and `include`d at precompile time.
`src/data/SyGuS/PBE_BV_Track_2018/data.jl` alone was 15.6 MB / 188k lines and cost ~17.5 s of
precompile, with `grammars.jl` adding ~4.7 s. It is now published as a Zenodo artifact and downloaded
lazily on first use.

## What gets published

One artifact per track. Artifacts are downloaded and unpacked whole — `lazy` is per-artifact, not
per-file — so per-problem granularity is achieved at *load* time, by keeping one file per
problem-grammar pair inside the tarball:

```
<track>/problems/<id>.jl    bare `Problem(...)` expression; include() returns it
<track>/grammars/<id>.jl    bare `@cfgrammar begin ... end` expression
<track>/sources/<id>.sl     pristine upstream file — provenance, never parsed at runtime
<track>/MANIFEST.toml       upstream repo/commit, source dirs, problem count
```

`.jl` rather than JSON: BV inputs are 64-bit `UInt64` literals (`0xb3cac86be739e234` ≈ 1.3e19), well
past JSON's 2^53 safe-integer range, so a naive JSON round-trip would silently corrupt most of the
track. The `.jl` form round-trips exactly, stays human-readable, and needs no serializer. `sources/`
keeps the record readable and re-derivable without Julia.

## Regenerating SyGuS

Requires a checkout of [SyGuS-Org/benchmarks](https://github.com/SyGuS-Org/benchmarks) at the commit
pinned in `src/data/SyGuS/citation.bib` (`13c8deb`), pointed at its `comp/` directory.

```julia
using Pkg; Pkg.activate(".")
include("gen/sygus_artifacts.jl")
generate_all("/path/to/benchmarks/comp", "/tmp/sygus-artifacts")
```

Sources: `comp/2018/PBE_BV_Track` (753 files) for BV; `comp/2019/PBE_SLIA_Track/{euphony,from_2018}`
(210 files) for SLIA.

Then build the tarballs and record the hashes for `Artifacts.toml`:

```julia
using Pkg.Artifacts, SHA
hash = create_artifact() do dir
    for entry in readdir(src); cp(joinpath(src, entry), joinpath(dir, entry)); end
end
archive_artifact(hash, "PBE_BV_Track_2018.tar.gz")
bytes2hex(open(sha256, "PBE_BV_Track_2018.tar.gz"))
```

Upload both tarballs to a single Zenodo record so they share a DOI, then pin the **version** URL
(`https://zenodo.org/records/<ID>/files/<name>.tar.gz?download=1`) in `Artifacts.toml` — the sha256
is pinned, so a concept DOI resolving to "latest" would break. Cite the concept DOI in the README.

## Identifiers

Derived once, by `HerbBenchmarks.sanitize_name(first(splitext(basename(path))))`, and used for the
problem, the grammar and the source file alike. Problems and grammars are paired by exact string
equality on that identifier, so deriving it in one place is what keeps them paired.

`resolve_identifiers` qualifies colliding identifiers with their source directory. Four SLIA pairs
need this: `euphony/phone-5-short.sl` and `from_2018/phone-5_short.sl` differ only by a hyphen versus
an underscore and both sanitize to `phone_5_short`. They are different problems; appending both to
one `data.jl` silently kept only the last.

`generate_track` errors on a duplicate identifier rather than overwriting.

## Defects this tooling fixed

Kept here because each was silent, and a regression would be silent too. All are covered by
`test/sygus_generator_test.jl`.

- **Identifiers truncated at the first dot.** `benchmarks_io.jl` derived names with
  `split(file, '.')[1]`, so `PRE_icfp_gen_1.15.sl` became `PRE_icfp_gen_1`, collapsing 20 problems
  onto one name. It produced exactly 468 unique names for 753 files — matching the 468 unique
  grammars in the old `grammars.jl`, which is how the defect was confirmed.
- **Divergent sanitization.** `write_problem` replaced `-`, `.`, `=`, ` `; `append_cfgrammar`
  replaced only `-`, `.`. Both now call `sanitize_name`.
- **Data corruption.** SLIA `11604909` stored `ELl_arg_esmp` where upstream has `ELlargesmp` — a
  text-level `arg` → `_arg_` rewrite that leaked into a string literal.
- **SLIA grammars were unparseable.** 101 of 210 files threw `ParseError`, because
  `polish_function_calls` rendered calls back to strings for `Meta.parse`, which cannot take an
  operator in head position (`(= ntInt ntInt)` → `"=(ntInt, ntInt)"`). `sexpr_to_expr` now builds the
  `Expr` structurally.
- **`if0` missing from the BV operator map**, though `if0_cvc` exists in `bit_functions.jl`.
- **`module_path` undefined** in `enumerate_problem_files`; the parameter is `output_path`.

## Note on the old text rewriters

`format_bit_operations_grammars` and `format_string_grammars` (in the track modules) rewrite an
emitted `grammars.jl` line by line. That approach is what let grammar names drift away from problem
names, and what corrupted the string literal above. The generator here translates the grammar
**object** instead (`translate_rule`). The rewriters are retained only for compatibility and should
not be used for new data.
