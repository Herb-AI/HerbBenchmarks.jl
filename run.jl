using HerbData
using HerbCore

using HerbBenchmarks

# include("src/data/SyGuS/SyGuS.jl")
# using .SyGuS
include("src/data/DreamCoder_2021/List_tasks/List_tasks.jl")
using .List_tasks

path = "../BenchmarkHackathon/ec/data/"
problem_file = "list_tasks2.json"
# path = "../BenchmarkHackathon/benchmarks/comp/2019/PBE_BV_Track/from_2018/"

# module_path = "src/data/SyGuS/PBE_SLIA_Track_2019/"
# module_path = "src/data/SyGuS/PBE_BV_Track_2018/"
module_path = "src/data/DreamCoder_2021/List_tasks/"

for (n,p) in parse_list_problem(path*problem_file)
    write_problem(module_path*"data_large.jl", p, n, "a")
end


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

# enumerate_files(path, module_path)
