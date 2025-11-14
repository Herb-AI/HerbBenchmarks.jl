module Morpheus_2017

using HerbCore
using HerbSpecification
using HerbGrammar
using DataFrames



# include("string_primitives.jl")
include("data.jl")
include("grammar.jl")

export 
    parse_r_table

"""
    parse_r_table(block::AbstractString) -> DataFrame

Parse an R-style printed data.frame (as used in Morpheus benchmarks) into a
DataFrame. Drops the numeric row index column and uses the header line to
define column boundaries.
"""
function parse_r_table(block::AbstractString)
    # Split into non-empty lines
    lines = split(block, '\n'; keepempty=false)
    lines = filter(l -> !isempty(strip(l)), lines)
    isempty(lines) && error("Empty table block")

    header_line = lines[1]
    raw_data_lines = lines[2:end]
    isempty(raw_data_lines) && error("No data lines in table")

    # Strip row index: leading spaces + digits + at least one space
    data_lines = String[]
    for l in raw_data_lines
        s = strip(l)
        isempty(s) && continue
        push!(data_lines, replace(l, r"^\s*\d+\s+" => ""))
    end
    isempty(data_lines) && error("No non-empty data lines after stripping row indices")

    # Helper: positions where a non-space starts immediately after a space
    function col_starts_for(line::AbstractString)
        starts = Int[]
        in_word = false
        for (i, c) in enumerate(line)
            if !isspace(c) && !in_word
                push!(starts, i)
                in_word = true
            elseif isspace(c) && in_word
                in_word = false
            end
        end
        return starts
    end

    header_starts = col_starts_for(header_line)
    ncols = length(header_starts)
    ncols == 0 && error("No columns found in header line: '$header_line'")

    # Column names from header using its own boundaries
    colnames = String[]
    for j in 1:ncols
        start = header_starts[j]
        stop  = (j < ncols) ? header_starts[j+1] - 1 : lastindex(header_line)
        push!(colnames, strip(header_line[start:stop]))
    end

    # Prepare columns
    cols = Dict{String, Vector{String}}()
    for name in colnames
        cols[name] = String[]
    end

    # Choose a width big enough for all lines
    maxlen = maximum(lastindex, vcat([header_line], data_lines))

    # Slice data lines using header-based boundaries
    for line in data_lines
        linep = rpad(line, maxlen)
        vals = String[]
        for j in 1:ncols
            start = header_starts[j]
            stop  = (j < ncols) ? header_starts[j+1] - 1 : maxlen
            push!(vals, strip(linep[start:stop]))
        end
        for (name, v) in zip(colnames, vals)
            push!(cols[name], v)
        end
    end

    return DataFrame(cols)
end



function extract_all_tables(txt::AbstractString)
    # Find all InputX blocks
    inputs = Dict{Int, DataFrame}()

    # Regex matches: Input, Input1, Input2, ...
    pattern = r"(?s)(Input\s*\d*):\s*\n(.*?)(?=\n(?:Input\s*\d*:|Output:))"

    for m in eachmatch(pattern, txt)
        label = strip(m.captures[1])
        tabletxt = strip(m.captures[2])

        # Extract number: Input2 → 2, Input → 1
        mnum = match(r"Input\s*(\d*)", label)
        num = isempty(mnum.captures[1]) ? 1 : parse(Int, mnum.captures[1])

        inputs[num] = parse_r_table(tabletxt)
    end

    # Extract output
    mout = match(r"(?s)Output:\s*\n(.*?)(?=\n-+)", txt)
    mout === nothing && error("Output table not found")
    output = parse_r_table(strip(mout.captures[1]))

    return inputs, output
end

"""
    parse_benchmark_file(path::AbstractString) -> Problem

Parse a single Morpheus benchmark `benchmarkXX.txt` file into a `Problem`.
The `Problem` has a single `IOExample` whose input is a Dict mapping
"""
function parse_benchmark_file(path::AbstractString)
    txt = read(path, String)

    # Extract ID
    mid = match(r"ID\s*=\s*(\d+)", txt)
    mid === nothing && error("Missing ID in $path")
    id = parse(Int, mid.captures[1])

    name = "problem_$(id)"

    inputs_dict, output_df = extract_all_tables(txt)

    # Construct IOExample input dictionary
    args = Dict{Symbol, Any}()
    for k in sort(collect(keys(inputs_dict)))  # ensure Input1, Input2, ... order
        args[Symbol("_arg_$k")] = inputs_dict[k]
    end

    ex = IOExample(args, output_df)
    return Problem(name, [ex])
end

"""
    load_morpheus_benchmarks(dir::AbstractString) -> Dict{Int, Problem}

Walk `dir` (typically the `solutions` directory) and parse all `benchmark*.txt`
files into a dictionary mapping benchmark ID -> Problem.
"""
function load_morpheus_benchmarks(dir::AbstractString)
    problems = Dict{Int, Any}()

    for (root, _, files) in walkdir(dir)
        for f in files
            startswith(f, "benchmark") || continue
            endswith(f, ".txt") || continue

            file = joinpath(root, f)
            prob = parse_benchmark_file(file)

            # Re-extract ID
            txt = read(file, String)
            mid = match(r"ID\s*=\s*(\d+)", txt)
            id  = parse(Int, mid.captures[1])

            problems[id] = prob
        end
    end

    return problems
end

"""
    df_to_julia(df; indent="        ")

Return a string with valid Julia code constructing `df` as

    DataFrame(Dict(
        :col1 => [...],
        :col2 => [...],
        ...
    ))
"""
function df_to_julia(df::DataFrame; indent::AbstractString = " " ^ 8)
    io = IOBuffer()

    println(io, "DataFrame(Dict(")
    ncols = length(names(df))

    for (i, name) in enumerate(names(df))
        col = df[!, name]
        print(io, indent, ":", name, " => [")

        nrows = length(col)
        for (j, v) in enumerate(col)
            print(io, sprint(show, v))  # keeps strings quoted
            if j < nrows
                print(io, ", ")
            end
        end

        if i < ncols
            println(io, "],")
        else
            println(io, "]")
        end
    end

    print(io, "$indent))")   # closes Dict( and DataFrame(
    return String(take!(io))
end


"""
    write_problem(io, id, prob::Problem)

Write one `Problem` definition to `io` in Julia syntax, as

    problem_10 = Problem("problem_10", [
        IOExample(Dict(
            :_arg_1 => DataFrame(...),
            :_arg_2 => DataFrame(...)
        ), DataFrame(...))
    ])
"""
function write_problem(io::IO, id::Int, prob)
    name = prob.name              # e.g. "problem_10"
    examples = prob.spec          # Vector{IOExample}

    println(io, "problem_$id = Problem(\"$name\", [")

    for (ei, ex) in enumerate(examples)
        inputs = ex.in            # Dict{Symbol, Any}
        output_df = ex.out        # DataFrame

        println(io, "    IOExample(Dict(")

        ks = sort(collect(keys(inputs)), by = x -> String(x))
        nkeys = length(ks)

        for (j, k) in enumerate(ks)
            df = inputs[k]::DataFrame
            dfstr = df_to_julia(df; indent = " "^12)
            sep = j < nkeys ? "," : ""
            # NOTE: explicit ':' so we get :_arg_1, :_arg_2, ...
            println(io, "        :", k, " => ", dfstr, sep)
        end

        println(io, "    ), ")

        out_str = df_to_julia(output_df; indent = " "^8)
        # close IOExample; add comma between IOExamples if needed
        if ei < length(examples)
            println(io, "    ", out_str, "),")
        else
            println(io, "    ", out_str, ")")
        end
    end

    println(io, "])")
end


"""
    write_all_problems(problems::Dict{Int, Problem}, outfile::AbstractString)

Write all problems to `outfile` as top-level

    problem_1 = Problem("problem_1", [...])
    problem_2 = Problem("problem_2", [...])
    ...

sorted by benchmark ID.
"""
function write_all_problems(problems::Dict{Int, Any}, outfile::AbstractString)
    open(outfile, "w") do io
        ids = sort(collect(keys(problems)))
        for (idx, id) in enumerate(ids)
            write_problem(io, id, problems[id])
            if idx < length(ids)
                println(io)  # single blank line between problems
            end
        end
    end
end

end

