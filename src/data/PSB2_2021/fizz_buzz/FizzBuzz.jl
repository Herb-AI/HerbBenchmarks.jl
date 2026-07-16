module FizzBuzz
using HerbCore
using HerbGrammar
using HerbSpecification
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("data.jl")
include("grammar.jl")

interpret_fizzbuzz = make_stateful_interpreter(minimal_grammar_fizz_buzz; target_module=FizzBuzz, cache_module=FizzBuzz)

export interpret_fizzbuzz

end # end module
