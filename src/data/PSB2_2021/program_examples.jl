function program_fizzbuzz(x)
    if x % 5 == 0 && x % 3 == 0
        return "FizzBuzz"
    else
        if x % 3 == 0
            return "Fizz"
        else
            if x % 5 == 0
                return "Buzz"
            else
                return string(x)
            end
        end
    end
end

function program_gcd(input1, input2)
    let state = Dict(:x => input1, :y => input2)
        while state[:y] > 0
            merge!(state, Dict(:x => state[:y], :y => state[:x] % state[:y]))
        end
        get!(state, :x, "key not found")
    end
end

function fuel_cost(input1)
    return sum(map(x -> floor(x / 3) - 2, input1))
end
