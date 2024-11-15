function program_basement(input1) 
    # Takes list of integers and returns 1 integer
    Dict(:output1 => 
        if getindex(input1, 1) < 0
            0
        else
            let state = Dict(:i => 0)
                while get(state, :i, "key not found") < length(input1) && sum(getindex(input1, 1:get(state, :i, "key not found"))) < 0
                    push!(state, :i => get(state, :i, "key not found"))
                end
                get(state, :i, "key not found")
            end
        end
    )
end

function program_coin_sums(input1)
    # Takes one integer and returns 4 integers
    Dict(
        :output4 => floor(input1 / 25), 
        :output3 => floor(input1 % 25 / 10), 
        :output2 => floor(input1 % 25 % 10 / 5), 
        :output1 => floor(input1 % 25 % 10 % 5))
end

function program_fizzbuzz(x)
    # Takes an integer and returns a string
    Dict(:output1 => 
        if x % 5 == 0 && x % 3 == 0
            "FizzBuzz"
        else
            if x % 3 == 0
                "Fizz"
            else
                if x % 5 == 0
                    "Buzz"
                else
                    string(x)
                end
            end
        end
    )
end

function program_fuel_cost(input1)
    # Takes a list of integers and returns an integer
    return Dict(:output1 => sum(map(x -> floor(x / 3) - 2, input1)))
end

function program_gcd(input1, input2)
    # Takes two integers and returns one integer
    Dict(:output1 => 
        let state = Dict(:x => input1, :y => input2)
            while state[:y] > 0
                merge!(state, Dict(:x => state[:y], :y => state[:x] % state[:y]))
            end
            get(state, :x, "key not found")
        end
    )
end

function program_gcd2(input1, input2)
    # Takes two integers and returns one integer
    Dict(:output1 => 
        let state = Dict(:x => input1, :y => input2)
            while get(state, :y, "key not found") > 0
                merge!(state, Dict(:x => get(state, :y, "key not found"), :y => get(state, :x, "key not found") % get(state, :y, "key not found")))
            end
            get(state, :x, "key not found")
        end
    )
end