"""
    @benchmark IteratorType params=... problem=... grammar=...
    @benchmark IteratorType params=... benchmark=...

Benchmark an iterator on a specific 'problem' and 'grammar' or an entire 'benchmark' module.
The iterator is supplied by its 'IteratorType', with all additional hyperparameters specified in the 'params' argument.
By default a 'default_synthesizer' is used to solve problems, but this can be easily overwritten and supplied in the params (see 'default_synthesizer').

"""
macro benchmark(arg, kws...)
    for kw in kws
        if !(kw isa Expr && kw.head == :(=))
            error("Expected keyword argument like benchmark=..., got $kw")
        end
    end
    return esc(:(_benchmark($arg; $(kws...))))
end

macro params(iter, kwargs)
    esc(:(($iter, $kwargs)))
end

_benchmark(iterator_type::Type{<:ProgramIterator}; kwargs...) = _benchmark([iterator_type]; kwargs...)

function _benchmark(iterator_types::Vector{}; kwargs...)
    args = Dict(kwargs)

    # Obtain path to store data, or a temporary file if not supplied (will be deleted afterwards)
    args[:no_path_supplied] = !haskey(args, :path)
    path = get!(args, :path, "__temp_results.jld2")

    # Create empty dataframe with column structure at path
    df = DataFrame(iterator=DataType[],params=Dict[],results=DataFrame[])
    @save path df

    # Obtain default parameters
    params = Dict{Symbol,Any}(pairs(get!(args, :params, ())))

    # Loop over all iterators
    for (iterator_index, iterator_type) in enumerate(iterator_types)
        # Obtain iterator/synth hyperparameters, or empty NamedTuple if not supplied
        specific_params = Dict{Symbol,Any}(pairs(get!(args, :specific_params, fill((), length(iterator_types)))[iterator_index]))
        params = merge(params, specific_params)
        params[:iterator_type] = iterator_type
        params[:iterator_index] = iterator_index

        # Obtain problem/grammar-pairs to benchmark with; throws exception if no source is supplied
        problem_grammar_pairs = get_problem_grammar_pairs(params, args)

        # Lock for read/write operations to results file
        io_lock = ReentrantLock()

        # Loop over all problem grammar pairs
        Threads.@threads for (problem, grammar) in problem_grammar_pairs
            # Obtain synth function
            params[:problem] = problem
            params[:grammar] = grammar
            synth = build_synth(params)

            # Call the synthesizer on arguemnts provided by it, while collecting statistics
            stats = @timed synth()

            # Create row dataframe
            result = Dict(
                [k => [v] for (k, v) in pairs(stats.value)]...,
                :execution_time_sec => [stats.time],
                :allocated_bytes => [stats.bytes],
            )
            
            lock(io_lock) do
                # Load dataframe
                @load path df

                # If this is the first problem, create a new dataframe
                if size(df)[1] < iterator_index
                    row = Dict(
                        :iterator => iterator_type,
                        :params => params,
                        :results => DataFrame(result...),
                    )
                    push!(df, row, promote=true)
                else
                    push!(df.results[iterator_index], result, promote=true)
                end

                @show df
                
                # Safe dataframe
                @save path df
            end
        end
    end

    # Obtain the dataframe and potentially remove tempory file
    @load path df
    args[:no_path_supplied] && rm(path)

    return df
end

# Builds the iterator given the hyperparameters
function build_iterator(params)
    # Obtain iterator parameters
    # Excuse me for these monstrosity, but it filters out the named keywords for the iterator such that we can extract these from the parameters
    get!(params, :starting_symbol, :Start)
    iterator_param_names = Base.kwarg_decl(first(filter(x -> :grammar in Base.method_argnames(x) && :start_symbol in Base.method_argnames(x), methods(params[:iterator_type]))))
    iterator_params = Dict(k => v for (k, v) in pairs(params) if k in iterator_param_names)

    # Call iterator constructor
    return params[:iterator_type](params[:grammar], params[:starting_symbol]; iterator_params...)
end

# Builds the call to the synthesize function given the hyperparameters
function build_synth(params)
    # Obtain synthesize function and parameters
    get!(params, :synth, default_synthesizer)
    synth_params = Dict(k => v for (k, v) in pairs(params) if k in Base.kwarg_decl(first(methods(params[:synth]))))

    return () -> params[:synth](
        iterator = build_iterator(params),
        problem = params[:problem];
        synth_params...,
    )
end

# Returns the problem/grammar pairs given arguments. Ensures that problems that are already run are not run again
function get_problem_grammar_pairs(params, args)
    problem_grammar_pairs = nothing

    # Case 1: user supplied benchmark
    if :benchmark in keys(args)
        problem_grammar_pairs = [(pg.problem, pg.grammar) for pg in get_all_problem_grammar_pairs(args[:benchmark])]
    
    # Case 2: user supplied problem and grammar
    elseif :problem in keys(args) && :grammar in keys(args)
        problem_grammar_pairs = [(args[:problem], args[:grammar])]

    # Case 3: user supplied problems and grammars
    elseif :problems in keys(args) && :grammars in keys(args)
        problem_grammar_pairs = collect(zip(args[:problems], args[:grammars]))
    
    # Case 4: user supplied problems and single grammar
    elseif :problems in keys(args) && :grammars in keys(args)
        problem_grammar_pairs = [(problem, args[:grammar]) for problem in args[:problem]]

    # Case 5: user supplied problem-grammar pairs
    elseif :problem_grammar_pairs in keys(args)
        problem_grammar_pairs = args[:problem_grammar_pairs]

    # Case 6: user failed
    else
        throw("Must supply problems to benchmark either through 'problem(s)=... grammar(s)=...', 'benchmark=...' or 'problem_grammar_pairs=...'") 
    end

    # ------------------------
    # Make sure to only return problems that are not solved yet.
    # ------------------------

    # If no path was supplied or file doesn't exists, return all propblems
    (args[:no_path_supplied] || !isfile(args[:path])) && return problem_grammar_pairs

    # Otherwise, obtain problems solved and filter pairs
    @load args[:path] df

    # Check if this iterator has been attempted at all
    size(df.results)[1] < params[:iterator_index] && return problem_grammar_pairs

    # Otherwise, obtain problems solved and filter
    problems_solved = df.results[params[:iterator_index]].problem_name
    filter!(pg -> !(first(pg).name in problems_solved), problem_grammar_pairs)

    # If the length is zero, warn user
    if length(problem_grammar_pairs) == 0
        @warn "No problems found; are all problems already solved in $(args[:path])"
    end

    return problem_grammar_pairs
end

"""
    default_synthesizer(; iterator::ProgramIterator, problem::Problem, max_enumerations::Number = Inf)

This functions serves as a default or template synthesizer for the '@benchmark' macro.
The macro calls a synthesizer function with keyword arguments 'iterator', 'problem' and all specified hyperparameters through the 'param' argument.
The macro expects a named tuple to be returned, that contains at least the fields 'problem_name', 'solved', 'program_enumerated'.
"""
function default_synthesizer(;
    iterator::ProgramIterator,
    problem::Problem,
    max_enumerations::Number = Inf,
)
    # Get grammar and build interpreter
    grammar = HerbSearch.get_grammar(iterator)
    interpreter = HerbInterpret.make_interpreter(grammar)

    # Collect stats: program enumerated and solution
    programs_enumerated = 0
    solution = missing

    # Loop over programs
    for program in iterator
        programs_enumerated += 1

        # Success: all I/O examples solved
        all(interpreter(program, io) == io.out for io in problem.spec) && (solution = freeze_state(program); break)

        # If max enumerations has been reached: break the loop
        programs_enumerated >= max_enumerations && break
    end

    # Return results
    (
        :problem_name => problem.name,
        :solved => !ismissing(solution),
        :solution => solution,
        :programs_enumerated => programs_enumerated,
    )
end
