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

function program_gcd(x, y)
    while y > 0
        x, y = y, x % y
    end
    x
end

function program_gcd(x, y)
    while y > 0
        t = y
        y = x % y
        x = t
    end
    x
end

# Can't do this because recursion
function program_gcd(x, y)
    if y == 0
        return x
    else
        return program_gcd(y, x % y)
    end
end

# Fuel costs

function fuel_cost(input1)
    return sum(map(x -> floor(x / 3) - 2, input1))
end

# below is the rulenode version of above

rulenode_version_fuel_cost = begin
    rulenode2expr(
        RuleNode(10, [
            RuleNode(14, [
                RuleNode(15, [
                    RuleNode(9, [
                        RuleNode(8, [RuleNode(7, [RuleNode(16)])])
                    ])
                ]),
                RuleNode(1)
            ])
        ]
        ),
        input_fuel_cost
    )
end