"""
    Synth

A struct containg problem specification, parameters and internal data for a synthesis process.
"""
struct Synth
    # Problem specifications
    problem::ProblemGrammarPair
    iterator::ProgramIterator
    benchmark_module::Module

    # Parameters
    shortcircuit::Bool
    allow_evaluation_errors::Bool
    max_time::Number
    max_enumerations::Number

    # Internal data
    vars::Dict{String, Any}
end

"""
    Synth(problem::ProblemGrammarPair, iterator::ProgramIterator, benchmark_module::Module; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time = typemax(Int), max_enumerations = typemax(Int))

Create a Synth struct for synthesising a program that satisfies the maximum number of examples in the problem.
        - problem                 - A ProblemGrammarPair to be solved
        - iterator                - The ProgramIterator that will be used
        - benchmark_mode          - The Benchmark/module to which the problem belongs
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - Maximum time that the iterator will run 
        - max_enumerations        - Maximum number of iterations that the iterator will run 
"""
Synth(
    # Problem specifications
    problem::ProblemGrammarPair,
    iterator::ProgramIterator,
    benchmark_module::Module;

    # Parameters
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time = typemax(Int),
    max_enumerations = typemax(Int),
) = Synth(
    # Problem specifications
    problem,
    iterator,
    benchmark_module,

    # Parameters
    shortcircuit, 
    allow_evaluation_errors,
    max_time,
    max_enumerations,

    # Internal data
    Dict{String, Any}(),
)

"""
    synthesize(synth::Synth) -> ProblemResult

Runs the synthesis process on a given Synth struct.
Returns a ProblemResult containg the results of the synthesis and metrics about the search process.
This method calls multiple subprocceses, that can be overloaded when needed.
It works as follows:
    1. `synth_init_meassures`                                   Initialise metrics
    2. `synth_init_process`                                     Initialise process variable
    3. iterate over candidate programs: 
        a. `synth_loop_eval_program`                            Evaluate candidate program and update process variabels
        b. `synth_loop_update_meassures`                        Update metrics
        c. break if `synth_loop_check_termination` is true      Check for termination conditions
    4. `synth_stop_meassures`                                   Stop meassuring metrics
    5. return `synth_return`                                    Return results in a ProblemResult
"""
function synthesize(synth::Synth)::ProblemResult
    mod = synth.benchmark_module
    
    # Setup process: setup meassures and other internal variables.
    synth_init_meassures(mod, synth)
    synth_init_process(mod, synth)
    
    # Loop over candidate programs.
    for candidate_program in synth.iterator
        synth.vars["candidate_program"] = candidate_program
        
        # For each, evaluate, update meassure and check for termination.
        synth_loop_eval_program(mod, synth)
        synth_loop_update_meassures(mod, synth)
        if synth_loop_check_termination(mod, synth)
            break
        end
    end

    # Termination process: stop meassures and return.
    synth_stop_meassures(mod, synth)
    return synth_return(mod, synth)
end

"""
    synth_init_meassures(mod::Module, synth::Synth)

First method called in the synthesis process.
Ment to setup meassures for metrics (e.g. store start time or start memory usage).
"""
function synth_init_meassures(mod::Module, synth::Synth)
    # Execution time
    synth.vars["start_time"] = time()

    # Memory usage
    synth.vars["start_memory"] = Ref{Int64}(0)
    Base.gc_bytes(synth.vars["start_memory"])
    
    # Programs evaluated
    synth.vars["programs_evaluated"] = 0 
end

"""
    synth_init_process(mod::Module, synth::Synth)

Method called after the starting meassuring metrics and before the iteration starts.
Ment to setup internal data for the synthesis process (e.g. create a symbol table or initialise variables tracking the best program found so far).
"""
function synth_init_process(mod::Module, synth::Synth)
    # Extract grammar and create SymbolTable
    synth.vars["grammar"] = HerbConstraints.get_grammar(synth.iterator.solver)
    synth.vars["symbol_table"] = SymbolTable(synth.vars["grammar"], mod)

    # Init variables keeping track of best program and its score
    synth.vars["best_program"] = nothing
    synth.vars["best_score"] = 0
end

"""
    synth_loop_eval_program(mod::Module, synth::Synth)

First method called within the program iteration. 
Ment to evaluate the candidate program and update the best program found so far.
"""
function synth_loop_eval_program(mod::Module, synth::Synth)
    # Create expression from rulenode representation of AST.
    expr = rulenode2expr(synth.vars["candidate_program"], synth.vars["grammar"])

    # Evaluate the expression
    score = HerbSearch.evaluate(
        synth.problem.problem, 
        expr, 
        synth.vars["symbol_table"], 
        shortcircuit=synth.shortcircuit, 
        allow_evaluation_errors=synth.allow_evaluation_errors)

    # If the score improved, update the best score and program.
    if score >= synth.vars["best_score"]
        synth.vars["best_program"] = freeze_state(synth.vars["candidate_program"])
        synth.vars["best_score"] = score
    end
end

"""
    synth_loop_update_meassures(mod::Module, synth::Synth)

A method called within the iteration.
Ment to update certain meassures of the process (e.g. number of programs evaluated).
"""
function synth_loop_update_meassures(mod::Module, synth::Synth)

    # Programs evaluated
    synth.vars["programs_evaluated"] += 1
end

"""
    synth_loop_check_termination(mod::Module, synth::Synth) -> Bool

A method called within the iteration to check for termination.
Ment to check for termination conditions, which include at least optimal program found, maximum number of enumerations reached, maximum execution time reached and iterator exhausted.
Should return `true` if any conditions was met, `false` otherwise.
"""
function synth_loop_check_termination(mod::Module, synth::Synth)::Bool
    # Problem solved
    if synth.vars["best_score"] == 1
        synth.vars["termination_cause"] = optimal_program_found

    # Maximum number of enumerations reached
    elseif synth.vars["programs_evaluated"] >= synth.max_enumerations
        synth.vars["termination_cause"] = max_enumerations_reached

    # Maximum execution time reached
    elseif time() - synth.vars["start_time"] > synth.max_time
        synth.vars["termination_cause"] = max_time_reached

    # Enumeration exhausted
    elseif isempty(synth.iterator)
        synth.vars["termination_cause"] = enumeration_exhausted
    end

    # Return true if any termination cause is set
    return "termination_cause" in keys(synth.vars)
end

"""
    synth_stop_meassures(mod::Module, synth::Synth)

The first method called after the iteration was completed.
Ment to stop meassuring certain metrics (e.g. store end time or end memory usage).
"""
function synth_stop_meassures(mod::Module, synth::Synth)

    # Execution time
    synth.vars["end_time"] = time()

    # Memory usage
    synth.vars["end_memory"] = Ref{Int64}(0)
    Base.gc_bytes(synth.vars["end_memory"])
end

"""
    function synth_return(mod::Module, synth::Synth)::ProblemResult

The last method called in the synthesize process.
Ment to compute the final metrics and return them within the corresponding structure.
Should return a ProblemResult.
"""
function synth_return(mod::Module, synth::Synth)::ProblemResult
    # Create metrics dictionary. If a solver already has SolverStatistics, start from there
    solver_statistics = synth.iterator.solver.statistics
    metrics = isnothing(solver_statistics) ? Dict{String, Any}() : solver_statistics
    
    # Add meassures
    metrics["programs_evaluated"] = synth.vars["programs_evaluated"]
    metrics["termination_cause"] = synth.vars["termination_cause"]
    metrics["execution_time_s"] = synth.vars["end_time"] - synth.vars["start_time"]
    metrics["memory_usage_bytes"] = synth.vars["end_memory"][] - synth.vars["start_memory"][]

    # Return result in a ProblemResult.
    return ProblemResult(
        synth.problem.identifier,
        synth.vars["best_program"],
        synth.vars["termination_cause"] == optimal_program_found ? optimal_program : suboptimal_program, 
        metrics
    )
end