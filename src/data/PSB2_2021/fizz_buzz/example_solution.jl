
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