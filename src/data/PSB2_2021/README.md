# PSB2: The Second Program Synthesis Benchmark Suite

This dataset is comprised of 25 different tasks defined in PSB2. The following table (from [the paper](https://dl.acm.org/doi/abs/10.1145/3449639.3459285?casa_token=biEgaE8LwGkAAAAA%3AyObtJCr1MPh3ObTIh6RQUFP7Sx2E4isZAOpTHNWLkJuCcmOPRGnR94xTCddGkTJLwEbx_LpKfFv8)) describes the tasks.

<img width="836" alt="afbeelding" src="https://github.com/Herb-AI/HerbBenchmarks.jl/assets/5456207/590487a8-10da-46b0-ad69-212d1c49a39c">

## Instruction Set
The instruction set used in the benchmark paper is PushGP, "a stack-based programming language built specifically for use in genetic programming". More information can be found in a paper on [Push3](https://dl.acm.org/doi/10.1145/1068009.1068292) and [PushGP](https://link.springer.com/article/10.1023/A:1014538503543). This directory includes a (work in progress) Julia reimplementation of the required instruction set. The translation from Clojure (the language that Push is implemented in - original implementation can be found [here](https://github.com/thelmuth/Clojush/tree/psb2-v1.0/src/clojush/instructions)) was completed partially by hand, but with the help of ChatGPT and Copilot.

The table below shows the different input sets used for each problem in the benchmark, the sets of grammars that are available, as well as the constants.

![image](https://github.com/Herb-AI/HerbBenchmarks.jl/assets/23522361/2f7aac44-833f-4acd-b052-30bbb93bf561)


For more information, see:
> T. Helmuth and P. Kelly, “PSB2: The Second Program Synthesis Benchmark Suite”. Zenodo, Apr. 10, 2021. doi: 10.5281/zenodo.5084812.


## Structure of benchmark folder
The 25 tasks of the benchmark are added iteratively. The `data.jl` does already contain examples of all tasks, but the rest only for the already implemented ones, see below.

We do not keep all data in this repository. The `retrieve_all_tasks.jl` functionality can be used to retrieve larger problem examples. The `data.jl` file keeps a small list of IOExamples per task. 

- `grammars.jl` This file holds the grammars for each of the benchmark problems, it constructs the specific grammars defining the constants, inputs, and outputs, and it merges all necessary grammars into one for each problem.
- `base_grammars.jl` This file includes the base grammars with general functions for integers, strings, characters, booleans, lists, and execution statements. When an ephemeral random constant (ERC) is used, we interpret this as adding one character noise to the grammar.
- `psb2_primitives.jl` This file includes extra grammar functions, like functions used in the base grammars and `merge_grammar`.
- `data.jl` This file holds some example problems with a small set of IOExamples for each problem in the benchmark.
- `program_examples.jl` This file shows some example programs for each problem: possible outputs of the synthesis task.
- `retrieve_all_tasks.jl` This file shows the functionality for retrieving larger problems from the benchmark, which can be downloaded and written to a JSON file.
- `example_using_the_benchmark.jl` This file shows an example how to use the benchmarks: where to find the grammar and the data.

### Adding a PSB2 benchmark task

To add another task you have to define the following:
- The data format is already specified in `data.jl` which you can use to structure the rest.
- The program example should be added in the `program_examples.jl`, where you can check that the program is possible to make using the grammar you defined for the task. Use the naming convention `program_{problem_name}`.
- The grammar needs to be defined in the `grammars.jl`, which is a merge between functions of the `base_grammars.jl` and an `input_{problem_name}` input grammar defining the constants as defined in the Instruction Set table. If it specifies an ephemeral random constant (ERC) is used, we interpret this as adding one character of noise to the grammar. Use the naming convention `grammar_{problem_name}` for the output of the `merge_grammar` of the subgrammars from `grammars.jl` with the new input grammar. Also define a `minimal_grammar_{problem_name}` containing all the functions used by the program from `program_{problem_name}` as a small test case.