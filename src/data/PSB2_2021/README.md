# PSB2: The Second Program Synthesis Benchmark Suite

This dataset is comprised of 25 different problems defined in PSB2. The following table (from [the paper](https://dl.acm.org/doi/abs/10.1145/3449639.3459285?casa_token=biEgaE8LwGkAAAAA%3AyObtJCr1MPh3ObTIh6RQUFP7Sx2E4isZAOpTHNWLkJuCcmOPRGnR94xTCddGkTJLwEbx_LpKfFv8)) describes the problems.

<img width="836" alt="afbeelding" src="https://github.com/Herb-AI/HerbBenchmarks.jl/assets/5456207/590487a8-10da-46b0-ad69-212d1c49a39c">

## Instruction Set
The instruction set used in the benchmark paper is PushGP, "a stack-based programming language built specifically for use in genetic programming". More information can be found in a paper on [Push3](https://dl.acm.org/doi/10.1145/1068009.1068292) and [PushGP](https://link.springer.com/article/10.1023/A:1014538503543). This directory includes a uses Julia native functions without the stack-based implementation.

The table below shows the different input sets used for each problem in the benchmark, the sets of grammars that are available, as well as the constants.

![image](https://github.com/Herb-AI/HerbBenchmarks.jl/assets/23522361/2f7aac44-833f-4acd-b052-30bbb93bf561)


For more information, see:
> T. Helmuth and P. Kelly, “PSB2: The Second Program Synthesis Benchmark Suite”. Zenodo, Apr. 10, 2021. doi: 10.5281/zenodo.5084812.


## Structure of benchmark folder
The 25 problems of the benchmark are added iteratively. The `data.jl` does already contain examples of all problems, but the rest only for the already implemented ones, see below.

We do not keep all data in this repository. The `retrieve_all_tasks.jl` functionality can be used to retrieve more tasks for a problem example. The `data.jl` file keeps a small list of IOExamples per problem. 

- `grammar.jl` This file holds the actual grammars for each of the benchmark problems based on functions. These are combinations of specific input grammars per problem (from `problem_grammars.jl`) and default grammar for different data types (from `base_grammars.jl`). These are merged together to form the `grammar_{problem_name}` object using `merge_grammar()`.
  - When an ephemeral random constant (ERC) is used, we interpret this as adding one character noise to the grammar.
  - This is added within the function so it is not evaluated within the grammar, therefore there are no grammar objects, only functions
  - Each input grammar should have a `Return` symbol as the return type returning a dict with the correct number of outputs
- `problem_grammars.jl` This file constructs the specific grammars defining the constants, inputs, and outputs.
- `base_grammars.jl` This file includes the base grammars with general functions for integers, strings, characters, Booleans, lists, and execution statements. 
- `psb2_primitives.jl` This file includes extra grammar functions, like functions used in the base grammars (like a custom `command_while()` that has a limit) and `merge_grammar`.
- `data.jl` This file holds some example problems with a small set of IOExamples for each problem in the benchmark.
- `program_examples.jl` This file shows some example programs for each problem: possible outputs of the synthesis.
- `retrieve_all_tasks.jl` This file shows the functionality for retrieving larger problems from the benchmark, which can be downloaded and written to a JSON file. We distinguish a problem (defined by a set of IOExamples) which can have many tasks (each IOExample).
- `example_using_the_benchmark.jl` This file shows an example how to use the benchmarks: where to find the grammar and the data.

### Adding a PSB2 benchmark problem

To add another problem you have to define the following:
- The data format is already specified in `data.jl` which you can use to structure the rest.
- The program example should be added in the `program_examples.jl`, where you can check that the program is possible to make using the grammar you defined for the problem. Use the naming convention `program_{problem_name}`.
- The grammar needs to be defined in the `grammar.jl`, which should be a function. The function takes in a minimal boolean to allow the inclusion of an ERC in the minimal grammar as well as the full one. The full grammar is a merge between functions of the `base_grammars.jl` and an `input_{problem_name}` defined in `problem_grammars.jl` defining the constants as defined in the Instruction Set table.
  - If it specifies an ephemeral random constant (ERC) is used, we interpret this as adding one character of noise to the grammar. This is done by adding a specific rule with the random character.
  - Use the naming convention `grammar_{problem_name}` for the output of the `merge_grammar` of the sub-grammars from `grammars.jl` with the new input grammar. 
  - Define a `minimal_grammar_{problem_name}` in `problem_grammars.jl` containing all the functions used by the program from `program_{problem_name}` as a small test case. 
  - Check that all required functionality is implemented in the `base_grammars.jl`, considering the list or state changes for different input types (like `String`).