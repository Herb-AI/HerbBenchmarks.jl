using MLStyle

function get_relevant_tags(grammar::AbstractGrammar)
    tags = Dict{Int,Any}()
    for (ind, r) in pairs(grammar.rules)
        tags[ind] = if r isa Expr
            @match r.head begin
                :block => :OpSeq
                :call  => r.args[1]  # operator symbol
                :if    => :IF
                _      => r.head
            end
        else
            r
        end
    end
    return tags
end

"""
    build_match_cases(grammar::AbstractGrammar)

Generate `Expr` cases for MLStyle.@match based on the grammar.
"""
function build_match_cases(grammar::ContextSensitiveGrammar)
    tags = get_relevant_tags(grammar)
    cases = []

    for (ind, r) in pairs(grammar.rules)
        tag = tags[ind]
        if r isa Expr && r.head == :call
            fname = r.args[1]
            nargs = length(r.args) - 1
            args = [:(interpret(c[$i], grammar_tags)) for i in 1:nargs]
            # push!(cases, :($tag => $fname($(args...))))
            push!(cases, :( $(QuoteNode(tag)) => $fname($(args...)) ))
        elseif r isa Expr && r.head == :if
            push!(cases, :( :IF => interpret(c[1], grammar_tags) ? interpret(c[2], grammar_tags) : interpret(c[3], grammar_tags) ))
        elseif tag isa Symbol && tag in (:+, :-, :(==))
            lhs = :(interpret(c[1], grammar_tags))
            rhs = :(interpret(c[2], grammar_tags))
            op_expr = Expr(:call, tag, lhs, rhs)
            push!(cases, :($tag => $op_expr))
        end
    end

    push!(cases, :( _ => grammar_tags[r] ))

    return cases
end


function make_interpreter(grammar::AbstractGrammar)
    cases = build_match_cases(grammar)
    quote
        function interpret(prog::AbstractRuleNode, grammar_tags::Dict{Int,Any})
            r = get_rule(prog)
            c = get_children(prog)

            MLStyle.@match grammar_tags[r] begin
                $(cases...)
            end
        end
    end
end
