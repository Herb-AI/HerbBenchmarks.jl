const MORPHEUS_TEMPORARY_COLUMNS = Symbol[Symbol("tmp", i) for i in 1:4]

function morpheus_identifiers()
    ids = [
        String(name)[9:end]
        for name in names(@__MODULE__; all=true)
        if startswith(String(name), "problem_")
    ]
    return sort(ids)
end

function _symcall(fn::Symbol, value)
    return Expr(:call, fn, value isa Symbol ? QuoteNode(value) : value)
end

function _add_terminal!(g::AbstractGrammar, typ::Symbol, fn::Symbol, value)
    add_rule!(g, Expr(:(=), typ, _symcall(fn, value)))
end

function _spread_column_candidates(tables)
    cols = Symbol[]
    for table in tables, row in table.rows, value in row
        if value isa AbstractString && occursin(r"^[A-Za-z_][A-Za-z0-9_.]*$", value)
            push!(cols, Symbol(value))
        end
    end
    return unique(cols)
end

function add_problem_terminals!(g::AbstractGrammar, identifier::AbstractString)
    problem = getfield(@__MODULE__, Symbol("problem_", identifier))
    example = only(problem.spec)
    input_columns = Symbol[]
    input_tables = collect(values(example.in))
    for table in input_tables
        append!(input_columns, table.columns)
    end
    # Starting available columns
    for c in unique(vcat(input_columns, example.out.columns,
        _spread_column_candidates(vcat(input_tables, [example.out])),
        MORPHEUS_TEMPORARY_COLUMNS))
        _add_terminal!(g, :Col, :col, c)
    end
    # Newly created columns
    for c in unique(vcat(example.out.columns, MORPHEUS_TEMPORARY_COLUMNS))
        _add_terminal!(g, :NewCol, :newcol, c)
    end
    # Literals
    literals = Any[]
    for table in vcat(input_tables, [example.out])
        for row in table.rows, value in row
            if value isa AbstractString || value isa Number
                push!(literals, value)
            end
        end
    end
    for value in unique(literals)
        _add_terminal!(g, :Value, :lit, value)
    end
    return g
end

function make_morpheus_grammar(identifier::AbstractString,
    base_grammar::AbstractGrammar=base_grammar_morpheus)
    g = deepcopy(base_grammar)
    add_rule!(g, Expr(:(=), :Table, :_arg_1))
    add_problem_terminals!(g, identifier)
    return g
end

for identifier in morpheus_identifiers()
    @eval $(Symbol("grammar_", identifier)) = make_morpheus_grammar($identifier)
end
