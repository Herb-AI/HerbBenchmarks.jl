"""
    get_all_problem_grammar_pairs(module_name::Module) -> AbstractVector{Tuple{AbstractGrammar, Problem}}

Get all problems and their grammars of a benchmark 'Module'. 
If any problem has no corresponding or default grammar, a 'KeyError' is thrown.
"""
function get_all_problem_grammar_pairs(module_name::Module)

    # Fetch all problem grammar pairs
    return [get_problem_grammar_pair(module_name, identifier) for identifier in get_all_identifiers(module_name)]
end

"""
    get_all_identifiers(module_name::Module) -> AbstractVector{AbstractString}

Get all problem identifiers of a benchmark 'Module'.
Identifierss are the suffix of problem names. For example, the identifier of 'problem_100' is '101'.
"""
function get_all_identifiers(module_name::Module)

    # Fetch all identifiers
    return [String(var)[9:end] for var in filter(v -> startswith(string(v), "problem_"), names(module_name; all=true))]
end

"""
    get_problem_grammar_pair(module_name::Module, identifier::AbstractString) -> Tuple{AbstractGrammar, Problem}

Get a problem and its grammar identified with a 'identifier' of a benchmark 'Module'. 
If no problem or grammar with the 'identifier' exists, a 'KeyError' is thrown.
'identifier's are the suffix of problem names. For example, the 'identifier' of 'problem_100' is '101'.
"""
function get_problem_grammar_pair(module_name::Module, identifier::AbstractString)

    # Fetch problem grammar pair
    return (get_problem(module_name, identifier), get_grammar(module_name, identifier))
end

"""
    get_problem(module_name::Module, identifier::AbstractString) -> Problem

Get the problem identified with a 'identifier' of a benchmark 'Module'. 
If no problem with the 'identifier' exists, a 'KeyError' is thrown.
'identifier's are the suffix of problem names. For example, the 'identifier' of 'problem_100' is '101'.
"""
function get_problem(module_name::Module, identifier::AbstractString)

    # Define problem identifier
    problem_identifier = Symbol("problem_" * identifier)

    # Check if the problem is defined
    if isdefined(module_name, problem_identifier)
        return module_name.eval(problem_identifier)
    else
        throw(KeyError("No problem found with identifier $problem_identifier"))
    end
end

"""
    get_grammar(module_name::Module, identifier::AbstractString) -> AbstractGrammar

Get the grammar corresponding to the problem identified with a 'identifier' of a benchmark 'Module'. 
If the problem has a corresponding grammar, that will be returned.
Otherwise, the default grammar of the benchmark 'Module' is returned.
If no corresponding or default grammar exists, a 'KeyError' is thrown.
'identifier's are the suffix of problem names. For example, the 'identifier' of 'problem_100' is '101'.
"""
function get_grammar(module_name::Module, identifier::AbstractString)

    # Define grammar identifier
    grammar_identifier = Symbol("grammar_" * identifier)

    # Check if a grammar is defined
    if isdefined(module_name, grammar_identifier)

        # If it has a corresponding grammar, fetch it
        return module_name.eval(grammar_identifier)
    else
        # Otherwise, try finding the default grammar
        try
            return get_default_grammar(module_name)
        catch
            throw(KeyError("No grammar found for problem $identifier and $module_name has no default grammar"))
        end
    end
end

"""
    get_default_grammar(module_name::Module) -> AbstractGrammar

Get the default grammar of a benchmark 'Module'. 
It finds a name starting with '_grammar' within the benchmark 'Module'. 
If no such name exists, a 'KeyError' is thrown.
"""
function get_default_grammar(module_name::Module)
    
    # Fetch all names in the module
    all_names = names(module_name; all=true)

    # Find the first name that starts with grammar
    id = findfirst(name -> startswith(string(name), "grammar_"), all_names)
    
    # Throw error if no such name exists
    if typeof(id) == Nothing
        throw(KeyError("No default grammar found for $module_name"))
    else
        # Otherwise, return the grammar
        return module_name.eval(all_names[id])
    end
end