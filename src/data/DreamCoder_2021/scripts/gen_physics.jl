# Generates src/data/DreamCoder_2021/Physics_2021/data.jl
#
# Ports the 60 physical laws and identities of DreamCoder's `bin/scientificLaws.py`
# and samples input/output examples with the same scheme (N=20 examples,
# D=3-dimensional vectors, magnitudes drawn from [-S, S] or [0, S] with S=20).
using Random
using Printf

const N_EXAMPLES = 20
const D = 3

# --- vector helpers, matching scientificLaws.py -----------------------------
vnorm(v) = sqrt(sum(x * x for x in v))
vunit(v) = vscale(1 / vnorm(v), v)
vscale(a, v) = [a * x for x in v]
vdot(a, b) = sum(x * y for (x, y) in zip(a, b))
vcross(a, b) = [a[2] * b[3] - a[3] * b[2],
    a[3] * b[1] - a[1] * b[3],
    a[1] * b[2] - a[2] * b[1]]
vadd(u, v) = [a + b for (a, b) in zip(u, v)]
vsub(u, v) = [a - b for (a, b) in zip(u, v)]

const PI = 3.14  # scientificLaws.py: "I think this is close enough to pi"

# --- input sampling ---------------------------------------------------------
# Argument kinds: :real, :positive, :vector, :vectors (list of vectors),
# :positives (list of positives)
function sample_arg(rng, kind, S, listlen)
    kind === :real && return round(rand(rng) * S * 2 - S; digits=4)
    kind === :positive && return round(rand(rng) * S; digits=4)
    kind === :vector && return [round(rand(rng) * S * 2 - S; digits=4) for _ in 1:D]
    kind === :vectors && return [sample_arg(rng, :vector, S, listlen) for _ in 1:listlen]
    kind === :positives && return [sample_arg(rng, :positive, S, listlen) for _ in 1:listlen]
    error("unknown argument kind $kind")
end

struct Law
    name::String
    args::Vector{Symbol}
    f::Function
    S::Float64
end
Law(name, args, f) = Law(name, args, f, 20.0)

const LAWS = Law[
    # --- linear algebra (parallel distributed processing) -------------------
    Law("vector addition (2)", [:vector, :vector], vadd),
    Law("vector addition (many)", [:vectors], vs -> reduce(vadd, vs)),
    Law("vector norm", [:vector], v -> vdot(v, v)^0.5),

    # --- MCAT ---------------------------------------------------------------
    Law("freefall velocity", [:positive], h -> (2 * 9.8 * h)^0.5),
    Law("v^2 = v0^2 + 2a(x-x0)", [:real, :real, :real, :real], (v0, a, x, x0) -> v0^2 + 2 * a * (x - x0)),
    Law("v = (vx^2 + vy^2)^0.5", [:real, :real], (vx, vy) -> (vx^2 + vy^2)^0.5),
    Law("a_r = v^2/R", [:real, :positive], (v, r) -> v * v / r),
    Law("e = mc^2", [:positive, :positive], (m, c) -> m * c * c),
    Law("COM (general scalar)", [:vector, :vector], (ms, xs) -> sum(m * x for (m, x) in zip(ms, xs)) / sum(ms)),
    Law("COM (2 vectors)", [:vector, :vector, :positive, :positive],
        (x1, x2, m1, m2) -> vscale(1 / (m1 + m2), vadd(vscale(m1, x1), vscale(m2, x2)))),
    Law("density = mass/volume", [:real, :real], (m, v) -> m / v),
    Law("pressure = force/area", [:real, :real], (f, a) -> f / a),
    Law("P = I^2R", [:real, :real], (i, r) -> i * i * r),
    Law("P = V^2/R", [:real, :real], (v, r) -> v * v / r),
    Law("V_rms = V/sqrt2", [:real], v -> v / (2.0^0.5)),
    Law("U = 1/2CV^2", [:real, :real], (c, v) -> 0.5 * c * v * v),
    Law("U = 1/2QV", [:real, :real], (q, v) -> 0.5 * q * v),
    Law("U = 1/2Q^2/C", [:real, :positive], (q, c) -> 0.5 * q * q / c),
    Law("P = 1/f", [:positive], f -> 1 / f),
    Law("c = 1/2*r", [:real], r -> r / 2),

    # --- AP physics ---------------------------------------------------------
    Law("Fnet = sum(F)", [:vectors], vs -> reduce(vadd, vs)),
    Law("a = sum(F)/m", [:positive, :vectors], (m, vs) -> vscale(1 / m, reduce(vadd, vs))),
    Law("work = F.d", [:vector, :vector], vdot),
    Law("P = F.v", [:vector, :vector], vdot),
    Law("F = qvxB (3d)", [:real, :vector, :vector], (q, v, b) -> vscale(q, vcross(v, b))),
    Law("F = qvxB (2d)", [:real, :real, :real, :real, :real], (q, a1, a2, b1, b2) -> q * (a1 * b2 - a2 * b1)),
    Law("tau = rxF (3d)", [:vector, :vector], vcross),
    Law("tau = rxF (2d)", [:real, :real, :real, :real], (a1, a2, b1, b2) -> a1 * b2 - a2 * b1),
    Law("v(t)", [:real, :real, :real], (v0, a, t) -> v0 + a * t),
    Law("x(t)", [:real, :real, :real, :real], (x0, v0, a, t) -> x0 + v0 * t + 0.5 * a * t * t),
    Law("p=mv", [:positive, :vector], (m, v) -> vscale(m, v)),
    Law("dp=Fdt", [:real, :vector], (dt, f) -> vscale(dt, f)),
    Law("K=1/2mv^2", [:positive, :vector], (m, v) -> 0.5 * m * vnorm(v)^2),
    Law("K=1/2Iw^2", [:positive, :positive], (i, w) -> 0.5 * i * w^2),
    Law("E=pJ", [:real, :vector], (p, j) -> vscale(p, j)),
    Law("Fs=kx", [:real, :vector], (k, x) -> vscale(k, x)),
    Law("P=dE/dt", [:real, :real], (de, dt) -> de / dt),
    Law("theta(t)", [:real, :real, :real, :real], (x0, v0, a, t) -> x0 + v0 * t + 0.5 * a * t * t),
    Law("omega(t)", [:real, :real, :real], (v0, a, t) -> v0 + a * t),
    Law("T=2pi/w", [:positive], w -> 2 * PI / w),
    Law("Ts=2pi(m/k)^1/2", [:positive, :positive], (m, k) -> 2 * PI * (m / k)^0.5),
    Law("Tp=2pi(l/g)^1/2", [:positive, :positive], (l, g) -> 2 * PI * (l / g)^0.5),
    Law("Coulomb's law (2 vectors)", [:positive, :positive, :vector, :vector],
        (q1, q2, r1, r2) -> vscale(q1 * q2 / vnorm(vsub(r1, r2))^2, vunit(vsub(r1, r2)))),
    Law("Newtonian gravitation (vector)", [:positive, :positive, :vector],
        (m1, m2, r) -> vscale(m1 * m2 / vnorm(r)^2, vunit(r))),
    Law("Coulomb's law (vector)", [:positive, :positive, :vector],
        (q1, q2, r) -> vscale(q1 * q2 / vnorm(r)^2, vunit(r))),
    Law("Newtonian gravitation (scalar)", [:positive, :positive, :vector],
        (m1, m2, r) -> m1 * m2 / vnorm(r)^2),
    Law("Coulomb's law (scalar)", [:positive, :positive, :vector],
        (q1, q2, r) -> q1 * q2 / vnorm(r)^2),
    Law("Hook's law", [:real, :positive], (k, x) -> -k * x * x),
    Law("Hook's law (2 vectors)", [:real, :vector, :vector], (k, u, v) -> k * vnorm(vsub(u, v))),
    Law("Ohm's law", [:positive, :positive], (r, i) -> r * i),
    Law("power/current/voltage relation", [:positive, :positive], (i, v) -> v * i),
    Law("gravitational potential energy", [:positive, :real], (m, h) -> 9.8 * m * h),
    Law("time/frequency relation", [:positive], t -> 1 / t, 2.0),
    Law("Plank relation", [:positive], p -> 1 / p, 2.0),
    Law("capacitance from charge and voltage", [:positive, :positive], (v, q) -> v / q),
    Law("series resistors", [:positives], cs -> sum(cs)),
    Law("parallel resistors", [:positives], cs -> sum(c^(-1) for c in cs)^(-1)),
    Law("parallel capacitors", [:positives], cs -> sum(cs)),
    Law("series capacitors", [:positives], cs -> sum(c^(-1) for c in cs)^(-1)),
    Law("A = pir^2", [:positive], r -> PI * r * r),
    Law("c^2 = a^2 + b^2", [:positive, :positive], (a, b) -> a * a + b * b),
]

# --- emission ---------------------------------------------------------------
jlval(x::Float64) = @sprintf("%.10g", x)
jlval(x::Vector{Float64}) = "[" * join(jlval.(x), ", ") * "]"
jlval(x::Vector{Vector{Float64}}) = "[" * join(jlval.(x), ", ") * "]"

sanitize(s) = strip(replace(lowercase(s), r"[^a-z0-9]+" => "_"), '_')

const NONTERMINAL = Dict(
    :real => :Num, :positive => :Num,
    :vector => :Vec, :vectors => :VecList, :positives => :NumList,
)

function main(outfile)
    rng = Xoshiro(20210608)
    sigs = IOBuffer()
    println(sigs, """
\"""
Argument signature of every physical-law task: a vector of grammar
nonterminals, one per `_arg_i`. Auto-generated alongside `data.jl`.
\"""
const PROBLEM_SIGNATURES = Dict{String,Vector{Symbol}}(""")
    io = IOBuffer()
    println(io, "# Auto-generated: DreamCoder's physical-law equation-discovery tasks")
    println(io, "# (`bin/scientificLaws.py`, Ellis et al., 2021). Each task gives $N_EXAMPLES")
    println(io, "# numerical examples of one law; vectors are $D-dimensional and are")
    println(io, "# represented as lists of reals, as in the original.")
    println(io)

    for (i, law) in enumerate(LAWS)
        ident = @sprintf("%03d_%s", i - 1, sanitize(law.name))
        println(sigs, "    \"$ident\" => [", join(repr.(getindex.(Ref(NONTERMINAL), law.args)), ", "), "],")
        examples = String[]
        for _ in 1:N_EXAMPLES
            listlen = rand(rng, 1:4)
            xs = [sample_arg(rng, k, law.S, listlen) for k in law.args]
            y = law.f(xs...)
            ins = join([":_arg_$j => $(jlval(xs[j]))" for j in eachindex(xs)], ", ")
            push!(examples, "\tIOExample(Dict{Symbol, Any}($ins), $(jlval(y)))")
        end
        println(io, "problem_$ident = Problem(\"problem_$ident\", [")
        println(io, join(examples, ",\n"))
        println(io, "])\n")
    end
    write(outfile, String(take!(io)))
    println(sigs, ")")
    write(joinpath(dirname(outfile), "signatures.jl"), String(take!(sigs)))
    println("wrote $(length(LAWS)) problems to $outfile (+ signatures.jl)")
end

main(ARGS[1])
