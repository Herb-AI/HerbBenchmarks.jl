"""
    function get_all_benchmarks()::Vector{Benchmark}

Gets all Benchmarks currently in the package. 
"""
function get_all_benchmarks()::Vector{Benchmark}
    # Map all benchmark modules to the benchmark datastructure and return
    modules = [Abstract_Reasoning_2019, Pixels_2020, Robots_2020, String_transformations_2020, PBE_BV_Track_2018, PBE_SLIA_Track_2019]
    return [Benchmark(m) for m in modules]
end


"""
    get_problem_grammar_pairs(mod::Module; problem_id_filter::Regex) -> Vector{Tuple{Problem, AbstractGrammar}}

Gets problems and their grammars of a benchmark 'Module'. 
A problem_id_filter can be specified to only include a selection of problems.
If any problem has no corresponding or default grammar, a 'KeyError' is thrown.
"""
function get_problem_grammar_pairs(mod::Module; problem_id_filter::Regex=r".*")::Vector{ProblemGrammarPair}

    # Fetch problem grammar pairs given the filter
    return [get_problem_grammar_pair(mod, identifier) for identifier in get_identifiers(mod, problem_id_filter=problem_id_filter)]
end


"""
    get_all_problems(module_name::Module)::Vector{Problem}

Get all problems of a benchmark 'Module'.
"""
function get_all_problems(module_name::Module)::Vector{Problem}
    return [get_problem(module_name, identifier) for identifier in get_all_identifiers(module_name)]
end

"""
    get_identifiers(mod::Module; problem_id_filter::Regex=r".*")

Gets problem identifiers of a benchmark 'Module'.
A problem_id_filter can be specified to only include a selection of problem ids.
Identifierss are the suffix of problem names. For example, the identifier of 'problem_100' is '101'.
"""
function get_identifiers(mod::Module; problem_id_filter::Regex=r".*")::Vector{String}

    # Fetch all problem identifiers
    ids = [String(name)[9:end] for name in filter(v -> startswith(string(v), "problem_"), names(mod; all=true))]

    # Return the identifiers that adhere to the filter
    return [id for id in ids if !isnothing(match(problem_id_filter, id))]
end

"""
    get_problem_grammar_pair(mod::Module, identifier::AbstractString) -> Tuple{Problem, AbstractGrammar}

Get a problem and its grammar identified with a 'identifier' of a benchmark 'Module'. 
If no problem or grammar with the 'identifier' exists, a 'KeyError' is thrown.
'identifier's are the suffix of problem names. For example, the 'identifier' of 'problem_100' is '101'.
"""
function get_problem_grammar_pair(mod::Module, identifier::AbstractString)::ProblemGrammarPair

    # Fetch problem grammar pair
    return ProblemGrammarPair(mod, identifier, get_problem(mod, identifier), get_grammar(mod, identifier))
end

"""
    get_problem(mod::Module, identifier::AbstractString) -> Problem

Get the problem identified with a 'identifier' of a benchmark 'Module'. 
If no problem with the 'identifier' exists, a 'KeyError' is thrown.
'identifier's are the suffix of problem names. For example, the 'identifier' of 'problem_100' is '101'.
"""
function get_problem(mod::Module, identifier::AbstractString)::Problem

    # Define problem identifier
    problem_identifier = Symbol("problem_" * identifier)

    # Check if the problem is defined
    if isdefined(mod, problem_identifier)
        return mod.eval(problem_identifier)
    else
        throw(KeyError("No problem found with identifier $problem_identifier"))
    end
end

"""
    get_grammar(mod::Module, identifier::AbstractString) -> AbstractGrammar

Get the grammar corresponding to the problem identified with a 'identifier' of a benchmark 'Module'. 
If the problem has a corresponding grammar, that will be returned.
Otherwise, the default grammar of the benchmark 'Module' is returned.
If no corresponding or default grammar exists, a 'KeyError' is thrown.
'identifier's are the suffix of problem names. For example, the 'identifier' of 'problem_100' is '101'.
"""
function get_grammar(mod::Module, identifier::AbstractString)::AbstractGrammar

    # Define grammar identifier
    grammar_identifier = Symbol("grammar_" * identifier)

    # Check if a grammar is defined
    if isdefined(mod, grammar_identifier)

        # If it has a corresponding grammar, fetch it
        return mod.eval(grammar_identifier)
    else
        # Otherwise, try finding the default grammar
        try
            return get_default_grammar(mod)
        catch
            throw(KeyError("No grammar found for problem $identifier and $mod has no default grammar"))
        end
    end
end

"""
    get_default_grammar(mod::Module) -> AbstractGrammar

Get the default grammar of a benchmark 'Module'. 
It finds a name starting with '_grammar' within the benchmark 'Module'. 
If no such name exists, a 'KeyError' is thrown.
"""
function get_default_grammar(mod::Module)::AbstractGrammar
    
    # Fetch all names in the module
    all_names = names(mod; all=true)

    # Find the first name that starts with grammar
    id = findfirst(name -> startswith(string(name), "grammar_"), all_names)
    
    # Throw error if no such name exists
    if typeof(id) == Nothing
        throw(KeyError("No default grammar found for $mod"))
    else
        # Otherwise, return the grammar
        return mod.eval(all_names[id])
    end
end
