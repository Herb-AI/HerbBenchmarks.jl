using MLStyle

include("arc_types.jl")

"""
    The identity function. Returns its argument.
"""
function identity(x::Any)::Any
    x
end

function add(a::Union{Int, Tuple{Int, Int}}, b::Union{Int, Tuple{Int, Int}})
    a .+ b
end

"""
    Subtracts `Int` b from `Int` a.
"""
function subtract(a::Union{Int, Tuple{Int, Int}}, b::Union{Int, Tuple{Int, Int}})
    a .- b
end

# TODO: interpret function


# --------
# Questions:
#   Do we need identity(x)? Julia comes with an identity function.