# const max_number_magnitude = 1.0e9
# const min_number_magnitude = 1.0e-9

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

# from globals.clj

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