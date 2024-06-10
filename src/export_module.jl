# adapted from https://github.com/Clemapfel/jlwrap
"""
    macro make_public(module_name::Symbol)

export all non-temporary, non-imported values (values not having a '#' at the
start of it's symbol when listed via Base.names) in a module

Example:
    module MyModule

        module SubModule
            _sub_variable
        end

        _variable
    end

    @make_public MyModule

    # exports:
    #   MyModule
    #   MyModule.SubModule
    #   MyModule._variable

See also: @make_public_rec
"""
macro make_public(module_name::Symbol)

    eval(Meta.parse("export " * string(module_name)))

    as_module = eval(module_name)
    @assert as_module isa Module

    for name in names(as_module; all = true)
        if (string(name)[1] != '#')
            # println("export " * string(name))
            if !(string(name) == "eval" || string(name) == "include")
                as_module.eval(Meta.parse("export " * string(name)))
            end
        end
    end

    return nothing
end
export make_public

"""
    macro make_public_rec(module_name::Symbol)

export all non-temporary, non-imported values (values not having a '#' at the
start of it's symbol when listed via Base.names) in a module and all
such values in any submodule, recursively

Example:
    module MyModule

        module SubModule
            _sub_variable
        end

        _variable
    end

    @make_public_rec MyModule

    # exports:
    #   MyModule
    #   MyModule.SubModule
    #   MyModule.SubModule._sub_variable
    #   MyModule._variable

See also: @make_public
"""
macro make_public_rec(module_name::Symbol)

    function make_public_aux(child_name::Symbol, super::Module) ::Nothing

        if (string(child_name)[1] != '#')
            #println("export " * string(child_name))
            if !(name == "eval" || name == "include")
                super.eval(Meta.parse("export " * string(child_name)))
            end
        end

        child = super.eval(child_name)
        if (child isa Module && child != super)
            for name in names(child; all = true)
                make_public_aux(name, child)
            end
        end

        return nothing
    end

    origin = eval(module_name)
    @assert origin isa Module

    for name in names(origin; all = true)
        make_public_aux(name, origin)
    end

    return nothing
end
export make_public_rec

"""

"""
function all_problems(module_name::Module)
    all_problems = [module_name.eval(var) for var in filter(v -> startswith(string(v), "problem_"), names(module_name; all=true))]
    return all_problems
end

"""

"""
function all_grammars(module_name::Module)
    all_grammars = [module_name.eval(var) for var in filter(v -> startswith(string(v), "grammar_"), names(module_name; all=true))]
    return all_grammars
end

"""

"""
function find_corresponding_grammar(problem_name::AbstractString, module_name::Module)
    # Extract the problem number from the problem identifier
    problem_number = match(r"_.*$", string(problem_name)).match

    # Construct the grammar identifier
    grammar_id = Symbol("grammar" * problem_number)

    # Check if this specific grammar exists in the module
    if isdefined(module_name, grammar_id)
        return grammar_id
    else
        # Find the default grammar that starts with "grammar_"
        for name in names(module_name; all=true)
            if startswith(string(name), "grammar_")
                return name
            end
        end
    end

    # Return nothing or throw an error if no grammar is found
    throw(KeyError("No corresponding grammar found for problem $problem"))
end

"""
    all_problem_grammar_pairs(module_name::Module)

Takes a module and returns a dict mapping from the problem name to a tuple of problem and grammar. If there is no grammar with a matching name it searches for the default grammar.
"""
function all_problem_grammar_pairs(module_name::Module)
    # Find the corresponding grammar for each problem
    problem_grammar_dict = Dict(string(var) => (module_name.eval(var), module_name.eval(find_corresponding_grammar(string(var), module_name))) for var in filter(v -> startswith(string(v), "problem_"), names(module_name; all=true)))

    return problem_grammar_dict
end
