# Regenerating the Hacker's Delight benchmark

Requires Python 3 with `z3-solver`. Point `HD_SL_DIR` at the directory holding
`hd-01.sl` ... `hd-27.sl`.

```sh
export HD_SL_DIR=/path/to/sygus/benchmarks/bitvector/hackers-delight

python3 sample.py        # -> examples.json    (10 z3-sampled models per spec)
python3 check_nl.py      # -> spec-vs-comment equivalence report (see ../README.md)
python3 emit_julia.py    # -> ../grammars.jl, ../data.jl, ../solutions.jl
python3 gen_prim_test.py # -> test_primitives.jl, a z3 differential test of ../hd_primitives.jl
julia test_primitives.jl
```

`parse_sl.py` is the shared `.sl` parser. Sampling is deterministic (fixed
seeds), so re-running reproduces `data.jl` byte for byte.
