function program_fizzbuzz(x)
    # Takes an integer and returns a string
    if x % 5 == 0 && x % 3 == 0
        return Dict(:output1 => "FizzBuzz")
    else
        if x % 3 == 0
            return Dict(:output1 => "Fizz")
        else
            if x % 5 == 0
                return Dict(:output1 => "Buzz")
            else
                return Dict(:output1 => string(x))
            end
        end
    end
end

program_fizzbuzz_rulenodes = begin # depth 6, using minimal_grammar_fizz_buzz
    rulenode2expr(
           RuleNode(12, [
               RuleNode(13, [
                   RuleNode(11, [
                       RuleNode(10, [
                           RuleNode(1),
                           RuleNode(4)
                       ]),
                       RuleNode(2)
                   ]),
                   RuleNode(11, [
                       RuleNode(10, [
                           RuleNode(1),
                           RuleNode(3)
                       ]),
                       RuleNode(2)
                   ])
               ]),
               RuleNode(9, [
                   RuleNode(7)
               
               ]),
               RuleNode(12, [
                   RuleNode(11, [
                       RuleNode(10, [
                           RuleNode(1),
                           RuleNode(3),
                       ]),
                       RuleNode(2)
                   ]),
                   RuleNode(9, [
                       RuleNode(5)
                   ]),
                   RuleNode(12, [
                       RuleNode(11, [
                           RuleNode(10, [
                               RuleNode(1),
                               RuleNode(4)
                           ]),
                           RuleNode(2)
                       ]),
                       RuleNode(9, [
                           RuleNode(6)
                       ]),
                       RuleNode(9, [
                           RuleNode(8, [
                                RuleNode(1)
                            ])
                       ])
                   ])
               ])
           ]), minimal_grammar_fizz_buzz)
end

function program_gcd(input1, input2)
    # Takes two integers and returns one integer
    let state = Dict(:x => input1, :y => input2)
        while state[:y] > 0
            merge!(state, Dict(:x => state[:y], :y => state[:x] % state[:y]))
        end
        Dict(:output1 => get!(state, :x, "key not found"))
    end
end

function program_fuel_cost(input1)
    # Takes a list of integers and returns an integer
    return Dict(:output1 => sum(map(x -> floor(x / 3) - 2, input1)))
end

function program_coin_sums(input1)
    # Takes one integer and returns 4 integers
    Dict(
        :output4 => floor(input1 / 25), 
        :output3 => floor(input1 % 25 / 10), 
        :output2 => floor(input1 % 25 % 10 / 5), 
        :output1 => floor(input1 % 25 % 10 % 5))
end
