"""
    synth(problem::ProblemGrammarPair, iterator::ProgramIterator, shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time = typemax(Int), max_enumerations = typemax(Int), benchmark::Module)::ProblemResult

Synthesize a program that satisfies the maximum number of examples in the problem.
        - problem                 - A ProblemGrammarPair to be solved
        - iterator                - The ProgramIterator that will be used
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - Maximum time that the iterator will run 
        - max_enumerations        - Maximum number of iterations that the iterator will run 
        - benchmark               - The Benchmark/module to which the problem belongs

Returns a ProblemResult containg the results of the synthesis and metrics about the search process.
"""
function synth(
    problem::ProblemGrammarPair,
    iterator::ProgramIterator;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time = typemax(Int),
    max_enumerations = typemax(Int),
    benchmark_module::Module
)::ProblemResult
    # Start meassure the time and the memory usage. 
    start_time = time()
    start_bytes = Ref{Int64}(0)
    Base.gc_bytes(start_bytes)

    # Extract the grammar and create a SymbolTable.
    grammar = HerbConstraints.get_grammar(iterator.solver)
    symboltable :: SymbolTable = SymbolTable(grammar, benchmark_module)

    # Initialise variables keeping track of the best program found so far.
    best_score = 0
    best_program = nothing

    # Initialise variables keeping track of the amount of programs evaluated, cause of termination and the final found program.
    programs_evaluated = 0
    termination_cause = nothing
    program = nothing
    
    # Start enumration.
    for (i, candidate_program) ∈ enumerate(iterator)
        # Create expression from rulenode representation of AST.
        expr = rulenode2expr(candidate_program, grammar)

        # Evaluate the expression and increase the amount of programs evaluated.
        score = HerbSearch.evaluate(problem.problem, expr, symboltable, shortcircuit=shortcircuit, allow_evaluation_errors=allow_evaluation_errors)
        programs_evaluated += 1

        # If every example was solved, freeze the program and set the cause of termination
        if score == 1
            program = freeze_state(candidate_program)
            termination_cause = optimal_program_found

        # Otherwise, if the score improved, update the best score and program.
        elseif score >= best_score
            best_score = score
            candidate_program = freeze_state(candidate_program)
            best_program = candidate_program
        end

        # If maximum number enumerator reached, set termination cause.
        if i > max_enumerations
            termination_cause = max_enumerations_reached

        # If maximum execution time reached, set termination cause.
        elseif time() - start_time > max_time
            termination_cause = max_time_reached
        end

        # Break if a termination cause was set.
        if !isnothing(termination_cause)
            break
        end
    end

    # The enumeration is exhausted, but an optimal problem was not found, set a termination cause.
    if isnothing(termination_cause)
        termination_cause = enumeration_exhausted
    end

    # Stop meassuring the memory usage.
    end_bytes = Ref{Int64}(0)
    Base.gc_bytes(end_bytes)

    # Create metrics dictionary. If a solver already has SolverStatistics, start from there
    metrics = isnothing(iterator.solver.statistics) ? Dict{String, Any}() : iterator.solver.statistics
    metrics["programs_evaluated"] = programs_evaluated
    metrics["execution_time_s"] = time() - start_time
    metrics["memory_usage_bytes"] = end_bytes[] - start_bytes[]
    metrics["termination_cause"] = termination_cause


    # Return result in a ProblemResult.
    return ProblemResult(
        problem.identifier,
        program,
        termination_cause == optimal_program_found ? optimal_program : suboptimal_program, 
        metrics
    )
end