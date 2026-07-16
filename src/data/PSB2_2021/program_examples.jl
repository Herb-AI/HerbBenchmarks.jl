function program_basement(_arg_1) 
    # Takes list of integers and returns 1 integer
    if getindex(_arg_1, 1) < 0
        0
    else
        let state = Dict(:i => 0)
            while get(state, :i, "key not found") < length(_arg_1) && sum(getindex(_arg_1, 1:get(state, :i, "key not found"))) < 0
                push!(state, :i => get(state, :i, "key not found"))
            end
            get(state, :i, "key not found")
        end
    end
end

function program_coin_sums(input1)
    # Takes one integer and returns 4 integers
    (pennies=floor(input1 % 25 % 10 % 5),
    nickles=floor(input1 % 25 % 10 / 5), 
    dimes=floor(input1 % 25 / 10), 
    quarters=floor(input1 / 25))
end

function program_fizzbuzz(x)
    # Takes an integer and returns a string
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