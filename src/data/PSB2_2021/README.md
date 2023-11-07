# PSB2: The Second Program Synthesis Benchmark Suite

This dataset is comprised of 25 different tasks defined in PSB2. The following table (from [the paper](https://dl.acm.org/doi/abs/10.1145/3449639.3459285?casa_token=biEgaE8LwGkAAAAA%3AyObtJCr1MPh3ObTIh6RQUFP7Sx2E4isZAOpTHNWLkJuCcmOPRGnR94xTCddGkTJLwEbx_LpKfFv8) describes the tasks.

<img width="836" alt="afbeelding" src="https://github.com/Herb-AI/HerbBenchmarks.jl/assets/5456207/590487a8-10da-46b0-ad69-212d1c49a39c">

## Instruction Set
The instruction set used in the benchmark paper is PushGP, "a stack-based programming language built specifically for use in genetic programming". More information can be found in a paper on [Push3](https://dl.acm.org/doi/10.1145/1068009.1068292) and [PushGP](https://link.springer.com/article/10.1023/A:1014538503543). This directory includes a (work in progress) Julia reimplementation of the required instruction set. The translation from Clojure (the language that Push is implemented in) was completed partially by hand, but with the help of ChatGPT and Copilot.


For more information, see:
> T. Helmuth and P. Kelly, “PSB2: The Second Program Synthesis Benchmark Suite”. Zenodo, Apr. 10, 2021. doi: 10.5281/zenodo.5084812.
