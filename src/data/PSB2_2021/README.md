# PSB2: The Second Program Synthesis Benchmark Suite

## Usage

The benchmark consists of 25 problems. For every problem `<problem>` there is

- `problem_<problem>` in `data.jl`: the edge cases of the problem as `IOExample`s,
- `grammar_<problem>` in `grammar.jl`: the grammar the programs are searched in,
  built by `get_grammar_<problem>(; minimal=false, seed=nothing)`,
- and, for the implemented problems, `program_<problem>` and `solution_<problem>`
  in `program_examples.jl`: an example solution as a Julia function and as a
  `RuleNode` of `grammar_<problem>`.

They are reachable through the usual `HerbBenchmarks` interface:

```julia
using HerbBenchmarks, HerbBenchmarks.PSB2_2021, HerbSearch, HerbConstraints

problem = get_problem(PSB2_2021, "fizz_buzz")
grammar = get_grammar(PSB2_2021, "fizz_buzz")
interpret = get_interpreter("fizz_buzz")            # HerbInterpret.make_interpreter

# Evaluate a program on an example, on all examples, or on a raw input
interpret(solution_fizz_buzz, problem.spec[1])                        # "1"
interpret(solution_fizz_buzz, problem.spec)                           # every output
interpret(solution_fizz_buzz, Dict{Symbol,Any}(:_arg_1 => 15))        # "FizzBuzz"

# Search the grammar, evaluating candidates with the same interpreter
for candidate in BFSIterator(grammar, :Return, max_depth=4)
    program = freeze_state(candidate)
    solved = count(e -> interpret(program, e.in) == e.out, problem.spec)
    solved == length(problem.spec) && break
end
```

See `example_using_the_benchmark.jl` for a runnable version.

Only the edge cases of every problem are kept in this repository. Larger
training and test sets are downloaded from the PSB2 website with

```julia
write_psb2_problems_to_file(
  problems::Vector{String}=String["fizz-buzz"],
  edge_or_random::String="random",
  n_train::Int64=200,
  n_test::Int64=2000,
  format::String="psb2")
```

which needs the `psb2` python package (installed through `CondaPkg.toml`). It is
imported lazily, only when this function is called.

## Conventions

- **Inputs** of a problem are `_arg_1, _arg_2, ...`, both in the `IOExample`s and
  in the grammar. `HerbInterpret.make_interpreter` reads every terminal
  containing `_arg_` from the input dictionary.
- **Outputs** are the bare value for the 21 problems with one output. The four
  problems with several outputs (coin sums, cut vector, find pair, mastermind)
  return a `Dict` with the keys `:output1, :output2, ...`.
- **Indices** are 1-based inside the grammar, since the primitives are Julia
  functions. Problems whose *output* is an index (basement, indices of
  substring) are 0-based, following the PSB2 data.
- **All primitives are total.** Dividing by zero, indexing out of bounds or
  parsing a non-number returns a neutral value instead of throwing, mirroring
  PushGP, where such instructions are no-ops. This matters for search: a
  benchmark whose grammar produces exceptions forces every search algorithm to
  handle them, and the tests check that enumerating any of the 25 grammars
  never throws.
- **Loops and lambdas.** `make_interpreter` compiles every grammar rule on its
  own, so a variable bound by a lambda in one rule is not visible in the
  sub-expressions of another rule. The rule that introduces a lambda therefore
  binds its argument with `bind_var!`, and the sub-expressions read it back
  with `int_var`, `float_var`, `string_var` or `list_var`:

  ```julia
  List = map(x -> begin bind_var!(:x, x); IntRule end, List)
  IntRule = int_var(:x)
  IntRule = while_loop(IntRule, s -> begin bind_var!(:s, s); Boolean end,
                                s -> begin bind_var!(:s, s); IntRule end)
  IntRule = int_var(:s)
  ```

  `:x` and `:y` are element variables of `map`, `filter` and `map_pairs`, `:s`
  is the accumulator of `while_loop`, which is bounded to 1000 iterations. A
  loop over several variables carries them in a list accumulator, see
  `program_gcd`.

## Dataset

This dataset comprises the 25 problems defined in PSB2. The following table
(from [the paper](https://dl.acm.org/doi/abs/10.1145/3449639.3459285)) describes
the problems.

<img width="836" alt="afbeelding" src="https://github.com/Herb-AI/HerbBenchmarks.jl/assets/5456207/590487a8-10da-46b0-ad69-212d1c49a39c">

The data of all 25 problems is checked against an independent implementation of
each of these descriptions in `test/PSB2_2021_data_test.jl`.

## Instruction Set

The instruction set used in the benchmark paper is PushGP, "a stack-based
programming language built specifically for use in genetic programming". More
information can be found in the papers on
[Push3](https://dl.acm.org/doi/10.1145/1068009.1068292) and
[PushGP](https://link.springer.com/article/10.1023/A:1014538503543). This
directory uses Julia native functions without the stack-based implementation.

The table below shows the input sets used for each problem in the benchmark, the
grammars that are available, and the constants.

![image](https://github.com/Herb-AI/HerbBenchmarks.jl/assets/23522361/2f7aac44-833f-4acd-b052-30bbb93bf561)

For more information, see:
> T. Helmuth and P. Kelly, “PSB2: The Second Program Synthesis Benchmark Suite”. Zenodo, Apr. 10, 2021. doi: 10.5281/zenodo.5084812.

## Structure of the benchmark folder

- `data.jl` holds the edge cases of each of the 25 problems as `IOExample`s.
- `psb2_primitives.jl` holds the functions the grammars are built from
  (`safe_div`, `sublist`, `while_loop`, ...) and the helpers to build grammars
  (`merge_grammar`, `prune_grammar`, `expr_to_rulenode`).
- `base_grammars.jl` holds the type-generic instruction sets: `grammar_integer`,
  `grammar_float`, `grammar_boolean`, `grammar_character`, `grammar_string`,
  `grammar_list_integer`, `grammar_list_float`, `grammar_list_string` and the
  `grammar_loop_*` grammars.
- `problem_grammars.jl` holds the problem specific parts: the inputs, the
  constants of the instruction set of the paper, and the `Return` rule that
  fixes the output type. It also holds the `minimal_grammar_<problem>`s.
- `grammar.jl` merges those into the grammar of each problem and adds the
  ephemeral random constants.
- `program_examples.jl` holds the example solutions.
- `retrieve_all_tasks.jl` downloads the larger versions of the problems.
- `example_using_the_benchmark.jl` shows how to use the benchmark.

A grammar is the merge of `input_<problem>` with the base grammars of the types
that problem uses. `merge_grammar` then *prunes* the result: rules that mention
a non-terminal without productions are dropped, which is what makes the base
grammars composable. For example `grammar_string` contains
`String = string(Float)`, and that rule disappears in a problem that has no
floats. Every grammar is therefore complete, i.e. every non-terminal in it can
be expanded, which the tests check.

When a problem uses an ephemeral random constant (ERC), one random constant is
drawn from the range of the inputs of that problem and added to the grammar.
Pass `seed` to `get_grammar_<problem>` to make that draw reproducible; the
`grammar_<problem>` objects use seed 42.

### Adding a PSB2 benchmark problem

The 25 problems all have data and a grammar; what the problems in the list below
are missing is an example solution, and with it the guarantee that the problem
*is* solvable within its grammar. To add one:

1. Write `program_<problem>` in `program_examples.jl` as a plain Julia function,
   using only functions from `psb2_primitives.jl`, and `expression_<problem>` as
   the same program in expression form.
2. Turn it into a `RuleNode` with
   `expr_to_rulenode(grammar_<problem>, :Return, expression_<problem>)`. This
   throws when the program is not derivable from the grammar, which tells you
   which instruction the grammar is still missing.
3. Add it to `PSB2_SOLUTIONS`. The tests then check it against *every* example
   of the problem.
4. Optionally add a `minimal_grammar_<problem>` in `problem_grammars.jl` with
   just the instructions the solution uses, and add it to
   `PSB2_MINIMAL_SOLUTIONS`. It is a small, well-understood search space for
   testing a search algorithm.

## Problems with an example solution

- [x] Basement
- [ ] Bouncing Balls
- [ ] Bowling
- [ ] Camel Case
- [x] Coin Sums
- [ ] Cut Vector
- [ ] Dice Game
- [ ] Find Pair
- [x] Fizz Buzz
- [x] Fuel Cost
- [x] GCD
- [ ] Indices of Substring
- [ ] Leaders
- [ ] Luhn
- [ ] Mastermind
- [ ] Middle Character
- [ ] Paired Digits
- [ ] Shopping List
- [ ] Snow Day
- [ ] Solve Boolean
- [ ] Spin Words
- [ ] Square Digits
- [ ] Substitution Cipher
- [ ] Twitter
- [ ] Vector Distance
