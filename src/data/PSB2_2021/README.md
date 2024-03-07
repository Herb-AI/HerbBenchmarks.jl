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

- `grammars.jl` This files holds the grammars for each of the benchmark problems, it constructs the specific grammars defining the constants, inputs, and outputs, and it merges all necessary grammars into one for each problem.
- `base_grammars.jl` This file includes the base grammars with general functions for integers, strings, characters, booleans, lists, and execution statements. When a ephemeral random constant (ERC) is used, we interpret this as adding one character noise to the grammar.
- `grammar_util.jl` This file includes extra grammar functions, like functions used in the base grammars and `merge_grammar`.
- `data.jl` This file holds some example problems with a small set of of IOExamples for each problem in the benchmark.
- `example_using_the_benchmark.jl` This file shows an example how to use the benchmarks: where to find the grammar and the data.
- `program_examples.jl` This file shows some example programs for each problem: possible outputs of the synthesis task.
- `retrieve_all_tasks.jl` This file shows the functionality for retrieving larger problems from the benchmark, which can be downloaded and written to a json file.
- `working_example.jl` This file is used for creating all the necessary grammar and testing the different problems in the benchmark. 
