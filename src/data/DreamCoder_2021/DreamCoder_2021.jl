"""
    DreamCoder_2021

The benchmark domains of DreamCoder (Ellis et al., 2021), grouped as
sub-benchmarks under one parent module. See `README.md` in this directory for
what each domain is, how it was translated, and where this formulation departs
from the original DSLs.

Each sub-benchmark is an ordinary HerbBenchmarks module — problems named
`problem_<identifier>`, grammars named `grammar_<identifier>` — so the usual
entry points work on them directly:

```julia
using HerbBenchmarks
import HerbBenchmarks.DreamCoder_2021: List_2021, Tower_2021

get_all_problem_grammar_pairs(List_2021)
get_problem(Tower_2021, "000_arch_leg_1")
```

| Sub-benchmark                | Tasks | Specification                        |
|:-----------------------------|------:|:-------------------------------------|
| [`List_2021`](@ref)          |   217 | 15 input/output examples over lists  |
| [`Text_2021`](@ref)          |   128 | 4 input/output examples over strings |
| [`LOGO_2021`](@ref)          |   160 | one target picture, a 28x28 bitmap   |
| [`Tower_2021`](@ref)         |   113 | one target tower of blocks           |
| [`Physics_2021`](@ref)       |    61 | 20 numerical examples of one law     |
"""
module DreamCoder_2021

include("List_2021/List_2021.jl")
include("Text_2021/Text_2021.jl")
include("LOGO_2021/LOGO_2021.jl")
include("Tower_2021/Tower_2021.jl")
include("Physics_2021/Physics_2021.jl")

"""
    SUB_BENCHMARKS

Every sub-benchmark module of DreamCoder_2021, in the order they appear in the
paper. Useful for iterating over the whole benchmark:

```julia
[get_benchmark(m) for m in DreamCoder_2021.SUB_BENCHMARKS]
```
"""
const SUB_BENCHMARKS = [List_2021, Text_2021, LOGO_2021, Tower_2021, Physics_2021]

export List_2021, Text_2021, LOGO_2021, Tower_2021, Physics_2021

end # module DreamCoder_2021
