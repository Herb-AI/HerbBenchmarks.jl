const max_number_magnitude = 1.0e9
const min_number_magnitude = 1.0e-9

function keep_number_reasonable(n)
    if isa(n, Int)
        if n > max_number_magnitude
            return max_number_magnitude
        elseif n < -max_number_magnitude
            return -max_number_magnitude
        else
            return n
        end
    else
        if isnan(n)
            return 0.0
        elseif n == Inf
            return copysign(max_number_magnitude, n)
        elseif n == -Inf
            return copysign(-max_number_magnitude, n)
        elseif n > max_number_magnitude
            return copysign(max_number_magnitude, n)
        elseif n < -max_number_magnitude
            return copysign(-max_number_magnitude, n)
        elseif n > min_number_magnitude && n < -min_number_magnitude
            return 0.0
        else
            return n
        end
    end
end