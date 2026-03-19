
function evaluate_synthesizer(synthesizer, instances)
    df = nothing

    for instance in instances
        stats = @timed synthesizer(instance)

        row = (
            stats.value...,
            :execution_time_sec => stats.time,
            :allocated_bytes => stats.bytes,
        )
        
        if isnothing(df)
            df = DataFrame([k => [v] for (k, v) in row]...)
        else
            push!(df, Dict(row), promote=true)
        end
    end

    df
end

function problems_solved_over_time(data)
    # Ensure that dataframe has columns "label" and "results"
    @assert "label" in names(data)
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
                label=row.label,
            )
    end

    # Return plot
    return p
end

function problems_solved_over_enumerations(data)
    # Ensure that dataframe has columns "label" and "results"
    @assert "label" in names(data)
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
                label=row.label,
            )
    end

    # Return plot
    return p
end