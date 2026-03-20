
function benchmark(iterator_type::Type{<:ProgramIterator}; kwargs...)
    # ---------------------------------------------------------------
    #   Obtain problem grammar pairs
    # ---------------------------------------------------------------

    # Case 1: user supplied benchmark
    if :benchmark in keys(kwargs)
        problem_grammar_pairs = [(pg.problem, pg.grammar) for pg in get_all_problem_grammar_pairs(kwargs[:benchmark])]
    
    # Case 2: user supplied problem and grammar
    elseif :problem in keys(kwargs) && :grammar in keys(kwargs)
        problem_grammar_pairs = [(kwargs[:problem], kwargs[:grammar])]

    # Case 3: user failed
    else
        throw("Must supply problems to benchmark either through 'problem=... grammar=...' or 'benchmark=...'") 
    end

    # ---------------------------------------------------------------
    #   Obtain other parameters
    # ---------------------------------------------------------------
    params = :params in keys(kwargs) ? kwargs[:params] : ()
    path = :path in keys(kwargs) ? kwargs[:path] : nothing

    # Arguments:
    #  - Starting symbol: by default :Start
    #  - Solver function: by default default_solver
    starting_symbol = hasproperty(params, :starting_symbol) ? params.starting_symbol : :Start
    solver = hasproperty(params, :solver) ? params.solver : default_solver

    # Excuse me for these monstrosity, but it filters out the named keywords for the iterator/solver such that we can extract these from the parameters
    iterator_param_names = Base.kwarg_decl(first(filter(x -> :grammar in Base.method_argnames(x) && :start_symbol in Base.method_argnames(x), methods(BFSIterator))))
    iterator_params = Dict(k => v for (k, v) in pairs(params) if k in iterator_param_names)
    solver_params = Dict(k => v for (k, v) in pairs(params) if k in Base.kwarg_decl(first(methods(solver))))


    # ---------------------------------------------------------------
    #   Actual functionality
    # ---------------------------------------------------------------

    # Prevent overwritting results by checking if a file already exists at the path
    !isnothing(path) && isfile(path) && throw("Cannot overwrite existing results at location $path.")
    df = nothing

    # Loop over all problem grammar pairs
    for (problem, grammar) in problem_grammar_pairs
        # Build synth call
        # This is extracted from the call so that people can build these on their own if needed
        solver_call = (
            iterator = iterator_type(grammar, starting_symbol; iterator_params...),
            problem = problem,
            solver_params...,
        )
        
        # Call the synthesizer on arguemnts provided by it, while collecting statistics
        stats = @timed solver(; solver_call...)

        # Create row dataframe
        result = (
            stats.value...,
            :execution_time_sec => stats.time,
            :allocated_bytes => stats.bytes,
        )

        # Build new dataframe if this is the first problem, otherwise push to existing
        if isnothing(df)
            df = DataFrame(
                :iterator => iterator_type,
                :params => params,
                :results => DataFrame(result...),
            )
        else
            push!(df.results[1], Dict(result), promote=true)
        end

        # Store the dataframe after each instance
        # Ensures that expensive results are not lost if this function is interrupted
        !isnothing(path) && CSV.write(path, df)
    end

    return df
end

#=
    TODO: this practially does the same as the existing 'synth' function.
    We can change that fuction to return a more informative result in the same format.
    Then we can use that synth function and don't have two practially identical functions.
=#
function default_solver(;
    iterator::ProgramIterator,
    problem::Problem,
    max_enumerations::Number = Inf,
)
    grammar = HerbSearch.get_grammar(iterator)

    interpreter = HerbInterpret.make_interpreter(grammar)
    programs_enumerated = 0
    solution = missing

    for program in iterator
        programs_enumerated += 1

        # Success: all I/O examples solved
        all(interpreter(program, io) == io.out for io in problem.spec) && (solution = freeze_state(program); break)

        programs_enumerated >= max_enumerations && break
    end

    (
        :problem_name => problem.name,
        :solved => !ismissing(solution),
        :solution => solution,
        :programs_enumerated => programs_enumerated,
    )
end

function problems_solved_over_time(datas::Vector{DataFrame}; label=r->r.iterator)
    problems_solved_over_time(vcat(datas...), label=label)
end

function problems_solved_over_time(data::DataFrame; label=r->r.iterator)
    # Ensure that dataframe has column "results"
    @assert "results" in names(data)

    # Find the longest execution time for any solved problem to scale the graph
    longest_execution_time = maximum(
        maximum(df.execution_time_sec[df.solved])
        for df in data.results
        if any(df.solved)
    )

    # Init empty plot
    p = plot(
        seriestype = :steppost,
        xlabel = "Execution time (s)",
        ylabel = "Problems solved",
        xlims = (0, longest_execution_time * 1.1)
    )

    for row in eachrow(data)
        # Assert that each results dataframe has columns "solved" and "execution_time_sec"
        @assert "solved" in names(row.results)
        @assert "execution_time_sec" in names(row.results)

        # Data process pipeline:
        row.results |>
            # Sort on execution time
            @orderby(_.execution_time_sec) |>

            # Take the cummulative sum 
            DataFrame |>
            (df -> let df = df
                df.cumulative_solved = cumsum(df.solved)
                df
            end) |>

            # Add to plot
            @df plot!(p,
                :execution_time_sec, 
                :cumulative_solved, 
                label=label(row),
            )
    end

    # Return plot
    return p
end

function problems_solved_over_enumerations(datas::Vector{DataFrame}; label=r->r.iterator)
    problems_solved_over_time(vcat(datas...), label=label)
end

function problems_solved_over_enumerations(data::DataFrame; label=r->r.iterator)
    # Ensure that dataframe has column "results"
    @assert "results" in names(data)

    # Find the maximum amount of enumerations for any solved problem to scale the graph
    maximum_enumerations = maximum(
        maximum(df.programs_enumerated[df.solved])
        for df in data.results
        if any(df.solved)
    )

    # Init empty plot
    p = plot(
        seriestype = :steppost,
        xlabel = "Programs enumerated",
        ylabel = "Problems solved",
        xlims = (0, maximum_enumerations * 1.1),
    )

    for row in eachrow(data)
        # Assert that each results dataframe has columns "solved" and "programs_enumerated"
        @assert "solved" in names(row.results)
        @assert "programs_enumerated" in names(row.results)

        # Data process pipeline:
        row.results |>
            # Sort on enumerated programs
            @orderby(_.programs_enumerated) |>

            # Take the cummulative sum 
            DataFrame |>
            (df -> let df = df
                df.cumulative_solved = cumsum(df.solved)
                df
            end) |>

            # Add to plot
            @df plot!(p,
                :programs_enumerated, 
                :cumulative_solved, 
                label=label(row),
            )
    end

    # Return plot
    return p
end