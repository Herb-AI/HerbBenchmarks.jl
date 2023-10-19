using HerbData
using HerbCore

using HerbBenchmarks

include("src/data/SyGuS/SyGuS.jl")
using .SyGuS

path = "../BenchmarkHackathon/benchmarks/comp/2019/PBE_BV_Track/from_2018/"

# module_path = "src/data/SyGuS/PBE_SLIA_Track_2019/"
module_path = "src/data/SyGuS/PBE_BV_Track_2018/"

# name = String(split(filename, '.')[1])

function enumerate_files(input_path::String, output_path::String)
    if !isdir(input_path)
        throw(ArgumentError("'$input_path' is not a directory."))
    end
    if !isdir(output_path)
        throw(ArgumentError("'$output_path' is not a directory."))
    end

    # List all files in the directory
    file_list = [string(file) for file in readdir(input_path)]

    for file in file_list
        println(file)
        name = string(split(file, '.')[1])
        append_cfgrammar(module_path*"grammars.jl", name, parse_sygus_grammar(input_path*file))
        write_problem(output_path*"data.jl", parse_sygus_problem(input_path*file), name, "a")
    end
end

# write_problem(module_path*"data.jl", parse_sygus_problem(path*filename), name)
# append_cfgrammar(module_path*"grammars.jl", name, parse_sygus_grammar(path*filename))

enumerate_files(path, module_path)
