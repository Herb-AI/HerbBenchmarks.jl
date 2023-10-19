include("grammar_util.jl")

function adder(type)
    return function (state)
        if length(type(state)) >= 2
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            result = keep_number_reasonable(first + second)
            return push_item(result, type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_add = adder(:integer)
float_add = adder(:float)

function subtracter(type)
    return function (state)
        if length(type(state)) >= 2
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            result = keep_number_reasonable(second - first)
            return push_item(result, type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_sub = subtracter(:integer)
float_sub = subtracter(:float)

function multiplier(type)
    return function (state)
        if length(type(state)) >= 2
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            result = keep_number_reasonable(second * first)
            return push_item(result, type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_mult = multiplier(:integer)
float_mult = multiplier(:float)

function divider(type)
    return function (state)
        if length(type(state)) >= 2 && stack_ref(type(state), 0) != 0
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            if type == :integer
                result = truncate(keep_number_reasonable(second / first))
            else
                result = keep_number_reasonable(second / first)
            end
            return push_item(result, type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_div = divider(:integer)
float_div = divider(:float)

function modder(type)
    return function (state)
        if length(type(state)) >= 2 && stack_ref(type(state), 0) != 0
            frst = stack_ref(type(state), 0)
            scnd = stack_ref(type(state), 1)
            if type == :integer
                result = truncate(keep_number_reasonable(mod(scnd, frst)))
            else
                result = keep_number_reasonable(mod(scnd, frst))
            end
            return push_item(result, type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_mod = modder(:integer)
float_mod = modder(:float)

function comparer(type, comparator)
    return function (state)
        if length(type(state)) >= 2
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            return push_item(comparator(second, first), :boolean, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_lt = comparer(:integer, <)
integer_lte = comparer(:integer, <=)
integer_gt = comparer(:integer, >)
integer_gte = comparer(:integer, >=)
float_lt = comparer(:float, <)
float_lte = comparer(:float, <=)
float_gt = comparer(:float, >)
float_gte = comparer(:float, >=)

function integer_fromboolean(state)
    if !isempty(state[:boolean])
        item = stack_ref(:boolean, 0, state)
        return push_item(item == 1 ? 0 : :integer, pop_item(state, :boolean))
    end
    return state
end

function float_fromboolean(state)
    if !isempty(state[:boolean])
        item = stack_ref(:boolean, 0, state)
        return push_item(item == 1.0 ? 0.0 : :float, pop_item(state, :boolean))
    end
    return state
end

function integer_fromfloat(state)
    if !isempty(state[:float])
        item = stack_ref(:float, 0, state)
        return push_item(truncate(item), :integer, pop_item(state, :float))
    end
    return state
end

function float_frominteger(state)
    if !isempty(state[:integer])
        item = stack_ref(:integer, 0, state)
        return push_item(item * 1.0, :float, pop_item(state, :integer))
    end
    return state
end

function integer_fromstring(state)
    if !isempty(state[:string])
        try
            item = parse(Int, top_item(:string, state))
            return push_item(keep_number_reasonable(item), :integer, pop_item(:string, state))
        catch e
            return state
        end
    end
    return state
end

function float_fromstring(state)
    if !isempty(state[:string])
        try
            item = parse(Float64, top_item(:string, state))
            return push_item(keep_number_reasonable(item), :float, pop_item(:string, state))
        catch e
            return state
        end
    end
    return state
end

function integer_fromchar(state)
    if !isempty(state[:char])
        item = Int(stack_ref(:char, 0, state))
        return push_item(item, :integer, pop_item(state, :char))
    end
    return state
end

function float_fromchar(state)
    if !isempty(state[:char])
        item = float(stack_ref(:char, 0, state))
        return push_item(item, :float, pop_item(state, :char))
    end
    return state
end

function minner(type)
    return function (state)
        if length(type(state)) >= 2
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            return push_item(min(second, first), type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_min = minner(:integer)
float_min = minner(:float)

function maxer(type)
    return function (state)
        if length(type(state)) >= 2
            first = stack_ref(type(state), 0)
            second = stack_ref(type(state), 1)
            return push_item(max(second, first), type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_max = maxer(:integer)
float_max = maxer(:float)

function float_sin(state)
    if !isempty(state[:float])
        result = keep_number_reasonable(sin(stack_ref(:float, 0, state)))
        return push_item(result, :float, pop_item(state, :float))
    end
    return state
end

function float_cos(state)
    if !isempty(state[:float])
        result = keep_number_reasonable(cos(stack_ref(:float, 0, state)))
        return push_item(result, :float, pop_item(state, :float))
    end
    return state
end

function float_tan(state)
    if !isempty(state[:float])
        result = keep_number_reasonable(tan(stack_ref(:float, 0, state)))
        return push_item(result, :float, pop_item(state, :float))
    end
    return state
end

function integer_inc(state)
    if !isempty(state[:integer])
        result = keep_number_reasonable(stack_ref(:integer, 0, state) + 1)
        return push_item(result, :integer, pop_item(state, :integer))
    end
    return state
end

function integer_dec(state)
    if !isempty(state[:integer])
        result = keep_number_reasonable(stack_ref(:integer, 0, state) - 1)
        return push_item(result, :integer, pop_item(state, :integer))
    end
    return state
end

function float_inc(state)
    if !isempty(state[:float])
        result = keep_number_reasonable(stack_ref(:float, 0, state) + 1.0)
        return push_item(result, :float, pop_item(state, :float))
    end
    return state
end

function float_dec(state)
    if !isempty(state[:float])
        result = keep_number_reasonable(stack_ref(:float, 0, state) - 1.0)
        return push_item(result, :float, pop_item(state, :float))
    end
    return state
end

function negater(type)
    return function (state)
        if !isempty(type(state))
            result = keep_number_reasonable(-stack_ref(type(state), 0))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

integer_negate = negater(:integer)
float_negate = negater(:float)

function abser(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(abs(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

integer_abs = abser(:integer)
float_abs = abser(:float)

function safe_expt(base, exp, type)
    result = ifelse(base == 0, 0, ifelse(base == 1 || base == -1, 1, keep_number_reasonable(base^exp)))
    return (type == :integer) ? trunc(Int, result) : result
end

function power(type)
    return function (state)
        if length(type(state)) >= 2
            base = stack_ref(type(state), 1)
            exp = stack_ref(type(state), 0)
            result = safe_expt(base, exp, type)
            return push_item(keep_number_reasonable(result), type, pop_item(pop_item(state, type), type))
        end
        return state
    end
end

integer_pow = power(:integer)
float_pow = power(:float)


function squareer(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(num * num)
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_square = squareer(:float)

function sqrter(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(sqrt(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_sqrt = sqrter(:float)

function ceilinger(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(ceil(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_ceiling = ceilinger(:float)

function floorer(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(floor(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_floor = floorer(:float)

function arccoser(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(acos(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_arccos = arccoser(:float)

function arcsiner(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(asin(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_arcsin = arcsiner(:float)

function arctaner(type)
    return function (state)
        if !isempty(type(state))
            num = stack_ref(type(state), 0)
            result = keep_number_reasonable(atan(num))
            return push_item(result, type, pop_item(state, type))
        end
        return state
    end
end

float_arctan = arctaner(:float)

function log2(x)
    return log(x) / log(2)
end

function loger(type, base)
    return function (state)
        if length(type(state)) >= 1
            num = stack_ref(type(state), 0)
            if base == 10
                result = log10(num)
            elseif base == 2
                result = log2(num)
            else
                # Handle other bases as needed
                result = log(num) / log(base)
            end
            return push_item(keep_number_reasonable(result), type, pop_item(state, type))
        end
        return state
    end
end

float_log10 = loger(:float, 10)
float_log2 = loger(:float, 2)

