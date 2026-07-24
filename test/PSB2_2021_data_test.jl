@testitem "PSB2_2021 data matches the problem descriptions" begin
    import HerbBenchmarks: PSB2_2021

    # Independent implementations of the 25 problem statements of the PSB2
    # paper. They are deliberately written without the grammars and primitives
    # of the benchmark, so that they check the data rather than the code that
    # is tested elsewhere. The problem descriptions are in README.md.

    function basement(v)
        total = 0
        for (i, x) in enumerate(v)
            total += x
            total < 0 && return i - 1
        end
        return length(v)
    end

    function bouncing_balls(start_height, bounce_height, bounces)
        index = bounce_height / start_height
        total, current = start_height, start_height
        for i in 1:bounces
            current *= index
            total += (i == bounces ? current : 2current)
        end
        return total
    end

    function bowling(game)
        rolls = Int[]
        for c in game
            if c == 'X'
                push!(rolls, 10)
            elseif c == '/'
                push!(rolls, 10 - rolls[end])
            elseif c == '-'
                push!(rolls, 0)
            else
                push!(rolls, parse(Int, c))
            end
        end
        score, i = 0, 1
        for _ in 1:10
            if rolls[i] == 10                       # strike
                score += 10 + rolls[i+1] + rolls[i+2]
                i += 1
            elseif rolls[i] + rolls[i+1] == 10      # spare
                score += 10 + rolls[i+2]
                i += 2
            else
                score += rolls[i] + rolls[i+1]
                i += 2
            end
        end
        return score
    end

    function camel_case(s)
        out = IOBuffer()
        capitalize = false
        for c in s
            if c == '-'
                capitalize = true
            else
                print(out, capitalize ? uppercase(c) : c)
                capitalize = false
            end
        end
        return String(take!(out))
    end

    coin_sums(cents) = Dict{Symbol,Any}(
        :output1 => cents % 25 % 10 % 5, :output2 => (cents % 25 % 10) ÷ 5,
        :output3 => (cents % 25) ÷ 10, :output4 => cents ÷ 25)

    function cut_vector(v)
        best, at = nothing, 1
        for i in 1:length(v)
            difference = abs(sum(v[1:i]; init=0) - sum(v[i+1:end]; init=0))
            if best === nothing || difference < best
                best, at = difference, i
            end
        end
        return Dict{Symbol,Any}(:output1 => v[1:at], :output2 => v[at+1:end])
    end

    dice_game(n, m) = sum(min(i - 1, m) for i in 1:n) / (n * m)

    function find_pair(v, target)
        for i in 1:length(v), j in i+1:length(v)
            v[i] + v[j] == target && return Dict{Symbol,Any}(:output1 => v[i], :output2 => v[j])
        end
        return nothing
    end

    fizz_buzz(n) = n % 15 == 0 ? "FizzBuzz" : n % 3 == 0 ? "Fizz" : n % 5 == 0 ? "Buzz" : string(n)

    fuel_cost(v) = sum(mass ÷ 3 - 2 for mass in v)

    greatest_common_divisor(a, b) = gcd(a, b)

    function indices_of_substring(text, target)
        isempty(target) && return Any[]
        n, m = length(text), length(target)
        return Any[i - 1 for i in 1:(n-m+1) if text[i:i+m-1] == target]
    end

    leaders(v) = Any[v[i] for i in 1:length(v) if all(v[i] >= v[j] for j in i+1:length(v))]

    function luhn(digits)
        total = 0
        for (i, digit) in enumerate(digits)
            doubled = isodd(i) ? 2digit : digit
            doubled > 9 && (doubled -= 9)
            total += doubled
        end
        return total
    end

    function mastermind(code, guess)
        black = count(i -> code[i] == guess[i], 1:length(code))
        common = sum(min(count(==(c), code), count(==(c), guess)) for c in unique(code))
        return Dict{Symbol,Any}(:output1 => common - black, :output2 => black)
    end

    function middle_character(s)
        n = length(s)
        return isodd(n) ? string(s[(n+1)÷2]) : s[n÷2:n÷2+1]
    end

    paired_digits(s) = sum((s[i] == s[i+1] ? parse(Int, s[i]) : 0 for i in 1:length(s)-1), init=0)

    shopping_list(prices, discounts) =
        round(sum(p * (1 - d / 100) for (p, d) in zip(prices, discounts)), digits=2)

    function snow_day(hours, snow, rate, melt)
        for _ in 1:hours
            snow = snow * (1 - melt) + rate
        end
        return snow
    end

    function solve_boolean(s)
        result, i = s[1] == 't', 2
        while i < length(s)
            value = s[i+1] == 't'
            result = s[i] == '&' ? (result && value) : (result || value)
            i += 2
        end
        return result
    end

    spin_words(s) = join([length(w) >= 5 ? reverse(w) : w for w in split(s, ' ')], " ")

    square_digits(n) = join(string(parse(Int, c)^2) for c in string(n))

    substitution_cipher(from, to, text) = join([to[findfirst(==(c), from)] for c in text])

    function twitter(tweet)
        n = length(tweet)
        n == 0 && return "You didn't type anything"
        n > 140 && return "Too many characters"
        return "Your tweet has $(n) characters"
    end

    vector_distance(a, b) = sqrt(sum((x - y)^2 for (x, y) in zip(a, b)))

    descriptions = Dict(
        "basement" => basement, "bouncing_balls" => bouncing_balls, "bowling" => bowling,
        "camel_case" => camel_case, "coin_sums" => coin_sums, "cut_vector" => cut_vector,
        "dice_game" => dice_game, "find_pair" => find_pair, "fizz_buzz" => fizz_buzz,
        "fuel_cost" => fuel_cost, "gcd" => greatest_common_divisor,
        "indices_of_substring" => indices_of_substring, "leaders" => leaders, "luhn" => luhn,
        "mastermind" => mastermind, "middle_character" => middle_character,
        "paired_digits" => paired_digits, "shopping_list" => shopping_list,
        "snow_day" => snow_day, "solve_boolean" => solve_boolean, "spin_words" => spin_words,
        "square_digits" => square_digits, "substitution_cipher" => substitution_cipher,
        "twitter" => twitter, "vector_distance" => vector_distance)

    # The float problems of PSB2 are given to a limited precision.
    same(a::Real, b::Real) = isapprox(float(a), float(b); atol=1e-6, rtol=1e-6)
    same(a::AbstractDict, b::AbstractDict) = keys(a) == keys(b) && all(same(a[k], b[k]) for k in keys(a))
    same(a::AbstractVector, b::AbstractVector) = length(a) == length(b) && all(same(x, y) for (x, y) in zip(a, b))
    same(a, b) = a == b

    @test Set(keys(descriptions)) == Set(get_all_identifiers(PSB2_2021))

    @testset "$id" for (id, description) in descriptions
        problem = get_problem(PSB2_2021, id)
        for example in problem.spec
            arguments = [example.in[Symbol("_arg_$i")] for i in 1:length(example.in)]
            @test same(description(arguments...), example.out)
        end
    end
end
