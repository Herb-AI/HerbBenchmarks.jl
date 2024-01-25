######### From gtm.clj #########
function init_gtm()
    return Dict(
        :gtm => Dict(
            :position => 1,
            :delay => 0,
            :tracks => [Dict(), Dict(), Dict()],
            :trace => []
        )
    )
end

function ensure_instruction_map(instr_map)
    if isa(instr_map, Dict)
        return instr_map
    else
        return merge(Dict(
            :instruction => :exec_noop,
            :close => 0,
            :silent => false,
            :random_insertion => false,
            :uuid => JavaUUID.randomUUID()
        ), instr_map)
    end
end

function load_track(push_state, track_index, genome)
    push_state[:gtm][:tracks][track_index] = Dict()
    for (i, instr_map) in enumerate(genome)
        push_state[:gtm][:tracks][track_index][i] = ensure_instruction_map(instr_map)
    end
    return push_state
end

function dump_track(push_state, track_index)
    return [instr_map for instr_map in values(push_state[:gtm][:tracks][track_index]) if !isempty(instr_map)]
end

function trace(trace_info, push_state)
    push_state[:gtm][:trace] = push_state[:gtm][:trace] * [trace_info]
    return push_state
end

############# From pushstate.clj ############
function keyword_to_symbol(kwd::Symbol)
    return Symbol(string(kwd)[2:end])  # Remove the ':' from the keyword
end

# TOOD: fix using namedtuple
# PushState = NamedTuple{empty::Vector{Any}, input::Vector{Any}, output::Vector{Any},
#              exec::Vector{Any}, code::Vector{Any}, boolean::Vector{Any}, character::Vector{Any},
#              float::Vector{Any}, integer::Vector{Any}, string::Vector{Any}, vector_boolean::Vector{Any},
#              vector_float::Vector{Any}, vector_integer::Vector{Any}, vector_string::Vector{Any}, environment::Vector{Any},
#              return_stack::Vector{Any}, auxiliary::Any, autoconstructing::Bool, state_explanations::Dict{Symbol, String}
# }

# function make_push_state()
#     return PushState(Vector{Any}(), Vector{Any}(), Vector{Any}(), Vector{Any}(),
#         Vector{Any}(), Vector{Any}(), Vector{Any}(), Vector{Any}(), Vector{Any}(),
#         Vector{Any}(), Vector{Any}(), Vector{Any}(), Vector{Any}(), Vector{Any}(),
#         Vector{Any}(), Vector{Any}(), Dict{Symbol, String}(), false)
# end

# function state_pretty_print(state::PushState)
#     for t in fieldnames(PushState)
#         println("$t = $(getfield(state, t))")
#     end
# end

# function push_item(value, type, state::PushState)
#     fieldname = Symbol(type)
#     new_stack = vcat(getfield(state, fieldname), value)
#     return setfield(state, fieldname, new_stack)
# end

# function top_item(type, state::PushState)
#     stack = getfield(state, Symbol(type))
#     if isempty(stack)
#         return :no_stack_item
#     else
#         return first(stack)
#     end
# end

# function stack_ref(type, position, state::PushState)
#     stack = getfield(state, Symbol(type))
#     if isempty(stack)
#         return :no_stack_item
#     else
#         return stack[position]
#     end
# end

# function stack_assoc(value, type, position, state::PushState)
#     fieldname = Symbol(type)
#     stack = getfield(state, fieldname)
#     if isempty(stack)
#         return state
#     else
#         stack[position] = value
#         return setfield(state, fieldname, stack)
#     end
# end

# function pop_item(type, state::PushState)
#     fieldname = Symbol(type)
#     stack = getfield(state, fieldname)
#     new_stack = isempty(stack) ? stack : stack[2:end]
#     return setfield(state, fieldname, new_stack)
# end

# function end_environment(state::PushState)
#     new_env = top_item(:environment, state)
#     new_exec = vcat(getfield(state, :exec), getfield(new_env, :exec))
    
#     function loop_function(old_return, new_state)
#         if isempty(old_return)
#             return new_state
#         else
#             first_return = first(old_return)
#             if getfield(first_return, :popper)
#                 return loop_function(rest(old_return), pop_item(getfield(first_return, :type), new_state))
#             else
#                 item = getfield(first_return, :item)
#                 item_type = getfield(first_return, :type)
#                 return loop_function(rest(old_return), push_item(item, item_type, new_state))
#             end
#         end
#     end
    
#     return loop_function(getfield(state, :return_stack), 
#         setfield(new_env, :exec, new_exec))
# end

registered_instructions = Set{Symbol}()

function register_instruction(name::Symbol)
    if name in registered_instructions
        throw(ArgumentError("Duplicate Push instruction defined: $name"))
    end
    push!(registered_instructions, name)
end

instruction_table = Dict{Symbol, Any}()

macro define_registered(instruction, definition)
    quote
        register_instruction($instruction)
        instruction_table[$instruction] = $definition
    end
end

function registered_for_type(type::Symbol, include_randoms::Bool=true)
    instructions_for_type = filter(instr -> startswith(string(instr), string(type)), registered_instructions)
    if include_randoms
        return instructions_for_type
    else
        return filter(instr -> !endswith(string(instr), "_rand"), instructions_for_type)
    end
end

function registered_nonrandom()
    return filter(instr -> !endswith(string(instr), "_rand"), registered_instructions)
end

function registered_for_stacks(types_list::Vector{Symbol})
    valid_instructions = filter(instruction -> begin
        instr_fn = instruction_table[instruction]
        if haskey(metadata(instr_fn), :stack_types)
            stack_types = Set(metadata(instr_fn)[:stack_types])
            return issubset(stack_types, Set(types_list))
        end
        return false
    end, registered_instructions)
    return valid_instructions
end

function push_state_from_stacks(stack_assignments...)
    return make_push_state() |> state -> begin
        for assignment in stack_assignments
            stack_name, stack_state = assignment
            stack_type = Symbol(stack_name)
            state = setfield(state, stack_type, stack_state)
        end
        return state
    end
end






########### From util.clj ##########
const literals = Dict(
    :integer => x -> typeof(x) == Int,
    :float => x -> typeof(x) == Float64,
    :char => x -> typeof(x) == Char,
    :string => x -> typeof(x) == String,
    :boolean => x -> x === true || x === false,
    :vector_integer => x -> typeof(x) == Vector{Int} || (typeof(x) == Vector && typeof(x[1]) == Int),
    :vector_float => x -> typeof(x) == Vector{Float64} || (typeof(x) == Vector && typeof(x[1]) == Float64),
    :vector_string => x -> typeof(x) == Vector{String} || (typeof(x) == Vector && typeof(x[1]) == String),
    :vector_boolean => x -> typeof(x) == Vector{Bool} || (typeof(x) == Vector && (x[1] === true || x[1] === false))
)

function recognize_literal(thing)
    for (type, pred) in literals
        if pred(thing)
            return type
        end
    end
    return false
end

debug_recent_instructions = []

function seq_zip(root)
    return Zippers.zipper(
        x -> typeof(x) == Vector,
        x -> typeof(x) == Vector ? x : Vector{Any}(x),
        x -> Meta(x),
        root
    )
end

list_concat(args...) = list(Iterators.flatten(args))

not_lazy(lst) = typeof(lst) == Vector ? lst : Vector{Any}(lst)

function ensure_list(thing)
    if typeof(thing) == Vector
        return not_lazy(thing)
    else
        return [thing]
    end
end

function print_return(thing)
    println(thing)
    return thing
end

function keep_number_reasonable(n)
    if typeof(n) == Int
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
            return 1.0 * max_number_magnitude
        elseif n == -Inf
            return 1.0 * -max_number_magnitude
        elseif n > max_number_magnitude
            return 1.0 * max_number_magnitude
        elseif n < -max_number_magnitude
            return 1.0 * -max_number_magnitude
        elseif n < min_number_magnitude && n > -min_number_magnitude
            return 0.0
        else
            return n
        end
    end
end

function round_to_n_decimal_places(f, n)
    if typeof(f) != Number
        return f
    end
    factor = 10 ^ n
    return Float64(round(f * factor) / factor)
end

function count_parens(tree)
    function iterate(remaining, total)
        if !typeof(remaining) == Vector
            return total
        elseif isempty(remaining)
            return total + 1
        elseif !typeof(remaining[1]) == Vector
            return iterate(rest(remaining), total)
        else
            return iterate(list_concat(remaining[1], rest(remaining)), total)
        end
    end
    iterate([tree], 0)
end

function count_points(tree)
    function iterate(remaining, total)
        if !typeof(remaining) == Vector
            return total + 1
        elseif isempty(remaining)
            return total + 1
        elseif !typeof(remaining[1]) == Vector
            return iterate(rest(remaining), total)
        else
            return iterate(list_concat(remaining[1], rest(remaining)), total)
        end
    end
    iterate([tree], 0)
end

function height_of_nested_list(tree)
    function iterate(zipper, height)
        if Zippers.end(zipper)
            return height
        else
            return iterate(Zippers.next(zipper), max(height, length(Zippers.path(zipper))))
        end
    end
    iterate(seq_zip(tree), 0)
end

function code_at_point(tree, point_index)
    index = mod(abs(point_index), count_points(tree))
    zipper = seq_zip(tree)
    function find_node(z, i)
        if i == 0
            return Zippers.node(z)
        else
            return find_node(Zippers.next(z), i - 1)
        end
    end
    return find_node(zipper, index)
end

function insert_code_at_point(tree, point_index, new_subtree)
    index = mod(abs(point_index), count_points(tree))
    zipper = seq_zip(tree)
    function replace_node(z, i)
        if i == 0
            return Zippers.root(Zippers.replace(z, new_subtree))
        else
            if i == 1 && typeof(Zippers.node(z)) == Vector && count(Zippers.node(z)) == 1
                return Zippers.root(Zippers.replace(z, []))
            else
                return replace_node(Zippers.next(z), i - 1)
            end
        end
    end
    return replace_node(zipper, index)
end

function remove_code_at_point(tree, point_index)
    index = mod(abs(point_index), count_points(tree))
    zipper = seq_zip(tree)
    if index == 0
        return tree
    else
        function remove_node(z, i)
            if i == 0
                return Zippers.root(Zippers.remove(z))
            else
                if i == 1 && typeof(Zippers.node(z)) == Vector && count(Zippers.node(z)) == 1
                    return Zippers.root(Zippers.replace(z, []))
                else
                    return remove_node(Zippers.next(z), i - 1)
                end
            end
        end
        return remove_node(zipper, index)
    end
end

function truncate(n)
    if n < 0
        return round(Int, ceil(n))
    else
        return round(Int, floor(n))
    end
end

function walklist(inner, outer, form)
    if typeof(form) == Vector
        return outer(list(map(inner, form)...)...)
    elseif typeof(form) == Vector
        return outer(map(inner, form)...)
    else
        return outer(form)
    end
end

function postwalklist(f, form)
    function postwalk(node)
        if typeof(node) == Vector
            return f(map(x -> postwalk(x), node)...)
        else
            return f(node)
        end
    end
    return walklist(x -> postwalk(x), x -> f(x), form)
end

function prewalkseq(f, s)
    function prewalk(z)
        if Zippers.end(z)
            return Zippers.root(z)
        else
            return Zippers.next(Zippers.replace(z, f(Zippers.node(z))))
        end
    end
    return prewalk(iterate(seq_zip(s)))
end

function postwalklist_replace(smap, form)
    return postwalklist(x -> haskey(smap, x) ? smap[x] : x, form)
end

function subst(this, that, lst)
    return postwalklist_replace([that => this], lst)
end

function contains_subtree(tree, subtree)
    return tree == subtree || !subst(gensym, subtree, tree) == tree
end

function containing_subtree(tree, subtree)
    if tree == subtree
        return nothing
    else
        function find_smallest_containing_subtree(t)
            if some(subtree -> containing_subtree(tree, subtree), t)
                return t
            end
        end
        return some(x -> find_smallest_containing_subtree(x), tree)
    end
end

function all_items(lst)
    if typeof(lst) == Vector
        return [lst]
    else
        return append!([lst], all_items(map(x -> all_items(x), lst)...))
    end
end

function remove_one(item, s)
    return list(filter(x -> x != item, s)...)
end

function list_to_open_close_sequence(lst)
    return prewalkseq(x -> typeof(x) == Vector ? [":open", x..., ":close"] : x, lst)
end

function open_close_sequence_to_list(sequence)
    if !typeof(sequence) == Vector
        return sequence
    elseif isempty(sequence)
        return []
    else
        opens = length(filter(x -> x == :open, sequence))
        closes = length(filter(x -> x == :close, sequence))
        @assert opens == closes "open-close sequence must have equal numbers of :open and :close; this one does not:\n$sequence"
        s = join(sequence)
        l = parse(replace(replace(s, ":open", " ( "), ":close", " ) "))
        if length(l) == 1 && typeof(l[1]) == Vector
            return l[1]
        else
            return l
        end
    end
end

function test_and_train_data_from_domains(domains)
    function concatenate_until_threshold(coll, threshold)
        function iterate(things)
            if length(things) >= threshold
                return things
            else
                return iterate(append!(things, coll))
            end
        end
        return iterate(coll, threshold)
    end
    one_each_instructions, inputs, constants = domains
    original_instruction_count = length(one_each_instructions)
    proportional_increase = length(inputs) + length(constants)
    final_instruction_count = original_instruction_count / (1 - proportional_increase)
    number_inputs = trunc(Int, proportion(inputs) * final_instruction_count)
    number_constants = trunc(Int, proportion(constants) * final_instruction_count)
    inputs_final = concatenate_until_threshold(inputs, number_inputs)
    constants_final = concatenate_until_threshold(constants, number_constants)
    return append!(one_each_instructions, inputs_final, constants_final)
end




####### From globals.clj ######## 

# The list of stacks used by the Push interpreter
const push_types = (:exec, :code, :integer, :float, :boolean, :char, :string, :zip,
:vector_integer, :vector_float, :vector_boolean, :vector_string,
:input, :output, :auxiliary, :tag, :return, :environment, :genome, :gtm)

# Used by instructions to keep computed values within limits or when using random instructions
const max_number_magnitude = 1.0E12
const min_number_magnitude = 1.0E-10
const max_string_length = 5000
const max_vector_length = 5000
const min_random_integer = -10
const max_random_integer = 10
const min_random_float = -1.0
const max_random_float = 1.0
const min_random_string_length = 1
const max_random_string_length = 10
const max_points_in_random_expressions = 50

# Used to count the number of times GP evaluates an individual
evaluations_count = 0

# Used to count the number of times GP runs a program once
program_executions_count = 0

# Used to count the number of instructions that have been executed
point_evaluations_count = 0

# Used for timing of different parts of PushGP
timer_atom = 0
timing_map = Dict(:initialization => 0, :reproduction => 0, :report => 0, :fitness => 0, :other => 0)

# Used in historically-assessed hardness
solution_rates = fill(0, 1)

# Used for elitegroup lexicase selection (will only work if lexicase-selection is off)
elitegroups = []

# Used in epsilon lexicase. Only calculated once per population
epsilons_for_epsilon_lexicase = []

# Used to store the number of selections for each individual, indexed by UUIDs
selection_counts = Dict{Any, Any}()

# Used to store the numbers of individuals that survive preselection in each selection event
preselection_counts = []

# Used for age-mediated-parent-selection
min_age = 0
max_age = 0

# Used for selection-delay
delay_archive = []

# Used for preserve-frontier
frontier = []

# These definitions may be reset by arguments to pushgp

# Used by Push instructions and must be global
global_atom_generators = Any[]

# The maximum size of a Push program. Also, the maximum size of code that can appear on the exec or code stacks
global_max_points = 100

# The maximum depth of nested code on the code or exec stacks. Needs to be small enough to avoid stack overflow errors
global_max_nested_depth = 200

# The size of the tag space
global_tag_limit = 10000

# A vector of the epigenetic markers that should be used in the individuals
global_epigenetic_markers = [:close]

# A vector of the probabilities for the number of parens ending at that position
global_close_parens_probabilities = [0.772, 0.206, 0.021, 0.001]

# If :silent is used as an epigenetic-marker, this is the probability of random instructions having :silent be true
global_silent_instruction_probability = 0.2

# These definitions are used by run-push (and functions it calls), and must be global since run-push is called by the problem-specific error functions

# When true, run-push will push the program's code onto the code stack prior to running
global_top_level_push_code = false

# When true, run-push will pop the code stack after running the program
global_top_level_pop_code = false

# The number of Push instructions that can be evaluated before stopping evaluation
global_evalpush_limit = 150

# The time in nanoseconds that a program can evaluate before stopping, 0 means no time limit
global_evalpush_time_limit = 0

# When true, tagging instructions will pop the exec stack when tagging; otherwise, the exec stack is not popped
global_pop_when_tagging = true

# The type of parent selection used
global_parent_selection = :lexicase

# This atom is used to convey information to clojush.pushgp.visualize
viz_data_atom = Dict{Any, Any}()