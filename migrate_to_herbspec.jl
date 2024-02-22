using Pkg

Pkg.activate(; temp = true)
Pkg.add("Glob")
Pkg.add("MLStyle")
Pkg.add("HerbSpecification")

# We would like to migrate to HerbSpecification
# Old syntax:
# problem_00576224 = Problem(Example[
# 	IOExample(Dict{Symbol, Any}(:_arg_1 => Any[8, 6]), Any[8, 6, 8, 6, 8, 6]), 
# 	IOExample(Dict{Symbol, Any}(:_arg_1 => Any[6, 4]), Any[6, 4, 6, 4, 6, 4]), 
# 	IOExample(Dict{Symbol, Any}(:_arg_1 => Any[3, 2]), Any[3, 2, 3, 2, 3, 2]), 
# 	IOExample(Dict{Symbol, Any}(:_arg_1 => Any[7, 8]), Any[7, 8, 7, 8, 7, 8])])

# New syntax:
# problem_00576224 = Problem(
#   "problem_00576224",
#   [
#       IOExample(Dict{Symbol, Any}(:_arg_1 => Any[8, 6]), Any[8, 6, 8, 6, 8, 6]),
# 	    IOExample(Dict{Symbol, Any}(:_arg_1 => Any[6, 4]), Any[6, 4, 6, 4, 6, 4]), 
# 	    IOExample(Dict{Symbol, Any}(:_arg_1 => Any[3, 2]), Any[3, 2, 3, 2, 3, 2]), 
# 	    IOExample(Dict{Symbol, Any}(:_arg_1 => Any[7, 8]), Any[7, 8, 7, 8, 7, 8])
#   ]
# )


using Glob, MLStyle, HerbSpecification

cp("src/data/", "src/data_updated/")

files = glob("src/data/*/*/*data*.jl")
append!(files, glob("src/data/*/*data*.jl"))

for f in files
    if f == "src/data/Robots_2020/data_generation.jl"
        continue
    end
    
    println("Updating $f")
    contents = read(f, String)

    l = length(contents)
    curr = 1
    expressions = []

    while curr < l
        expr, curr = Meta.parse(contents, curr)
        expr = @match expr begin
            :($varname = Problem(Example[$(args...)])) => :($varname = Problem($"$varname", [$(args...)]))
            :(using HerbData) => :(using HerbSpecification)
            _ => expr
        end

        evaled_expr = eval(expr) # Sanity check to make sure we're not using HerbData anymore
        if evaled_expr isa Problem
            @assert typeof(evaled_expr.spec) == Vector{IOExample} # double check
        end
        push!(expressions, expr)
    end
    open(replace(f, "src/data" => "src/data_updated"), "w") do io
        join(io, expressions, "\n")
    end
end

mv("src/data", "src/data_old")
mv("src/data_updated", "src/data")
rm("src/data_old"; force = true, recursive = true)

# Now we can run the tests to make sure everything is still working
Pkg.activate(".")
Pkg.test()
