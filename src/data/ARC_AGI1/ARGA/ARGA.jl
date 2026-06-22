module ARGA

using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

import ..ARC_AGI1: ARC_AGI1_TRAINING

include("primitives.jl")
include("grammar.jl")

interpret = make_interpreter(grammar_arga; target_module = ARGA, cache_module = ARGA)

"""
    ARGA_TASK_IDS

The 160 OBJECT-ARC task names (`:problem_<hash>`, matching
`HerbBenchmarks.ARC_AGI1`'s problem-naming convention) -- the union of
`dataset/subset/{augmentation,movement,recolor}.txt` from
https://github.com/khalil-research/ARGA-AAAI23, the testing subset this
benchmark is built from. Embedded as a literal (rather than read from
those files at load time) so this package doesn't depend on that repo's
checkout path at runtime.
"""
const ARGA_TASK_IDS = Set([
    :problem_00d62c1b, :problem_025d127b, :problem_05f2a901, :problem_08ed6ac7,
    :problem_0962bcdd, :problem_0ca9ddb6, :problem_0d3d703e, :problem_0e206a2e,
    :problem_150deff5, :problem_1a07d186, :problem_1b60fb0c, :problem_1caeab9d,
    :problem_1e0a9b12, :problem_1f0c79e5, :problem_2204b7a8, :problem_22168020,
    :problem_22233c11, :problem_228f6490, :problem_22eb0ac0, :problem_25d487eb,
    :problem_25d8a9c8, :problem_25ff71a9, :problem_272f95fa, :problem_29c11459,
    :problem_2c608aff, :problem_31aa019c, :problem_321b1fc6, :problem_32597951,
    :problem_3618c87e, :problem_363442ee, :problem_36d67576, :problem_36fdfd69,
    :problem_3906de3d, :problem_39e1d7f9, :problem_3aa6fb7a, :problem_3bdb4ada,
    :problem_3c9b0459, :problem_3e980e27, :problem_3eda0437, :problem_4093f84a,
    :problem_41e4d17e, :problem_4258a5f9, :problem_42a50994, :problem_4347f46a,
    :problem_444801d8, :problem_447fd412, :problem_44d8ac46, :problem_4612dd53,
    :problem_50846271, :problem_50cb2852, :problem_5168d44c, :problem_543a7ed5,
    :problem_54d9e175, :problem_5521c0d9, :problem_5582e5ca, :problem_57aa92db,
    :problem_5c0a986e, :problem_60b61512, :problem_6150a2bd, :problem_63613498,
    :problem_6455b5f5, :problem_67385a82, :problem_67a3c6ac, :problem_67a423a3,
    :problem_6855a6e4, :problem_68b16354, :problem_694f12f3, :problem_6a1e5592,
    :problem_6aa20dc0, :problem_6c434453, :problem_6d58a25d, :problem_6d75e8bb,
    :problem_6e82a1ae, :problem_72322fa7, :problem_7447852a, :problem_74dd1130,
    :problem_776ffc46, :problem_794b24be, :problem_7b6016b9, :problem_7ddcd7ec,
    :problem_7e0986d6, :problem_7f4411dc, :problem_810b9b61, :problem_83302e8f,
    :problem_855e0971, :problem_85c4e7cd, :problem_868de0fa, :problem_88a10436,
    :problem_890034e9, :problem_8d510a79, :problem_913fb3ed, :problem_91714a58,
    :problem_941d9a10, :problem_952a094c, :problem_9565186b, :problem_95990924,
    :problem_98cf29f8, :problem_99fa7670, :problem_9dfd6313, :problem_9edfc990,
    :problem_a1570a43, :problem_a48eeaf7, :problem_a5313dff, :problem_a5f85a15,
    :problem_a61f2674, :problem_a699fb00, :problem_a79310a0, :problem_a9f96cdd,
    :problem_aabf363d, :problem_ae3edfdc, :problem_aedd82e4, :problem_b1948b0a,
    :problem_b230c067, :problem_b27ca6d3, :problem_b2862040, :problem_b527c5c6,
    :problem_b548a754, :problem_b60334d2, :problem_b6afb2da, :problem_b7249182,
    :problem_b775ac94, :problem_b8cdaf2b, :problem_ba26e723, :problem_bb43febb,
    :problem_bda2d7a6, :problem_beb8660c, :problem_c0f76784, :problem_c8f0f002,
    :problem_c9f8e694, :problem_ce22a75a, :problem_ce9e57f2, :problem_d037b0a7,
    :problem_d23f8c26, :problem_d2abd087, :problem_d364b489, :problem_d406998b,
    :problem_d43fd935, :problem_d511f180, :problem_d5d6de2d, :problem_d687bc17,
    :problem_d89b689b, :problem_d90796e8, :problem_d9f24cd1, :problem_db93a21d,
    :problem_dc1df850, :problem_dc433765, :problem_ddf7fa4f, :problem_e21d9049,
    :problem_e26a3af2, :problem_e40b9e2f, :problem_e509e548, :problem_e73095fd,
    :problem_e76a88a6, :problem_e8593010, :problem_e8dc4411, :problem_ea32f347,
    :problem_ea786f4a, :problem_ed36ccf7, :problem_f76d97a5, :problem_f8a8fe49,
])

"""
    arga_problems()

The 160 `HerbBenchmarks.ARC_AGI1` training `Problem`s ([`ARGA_TASK_IDS`](@ref))
that make up the OBJECT-ARC benchmark -- each already has the standard ARC
"2-7 train pairs + 1 test pair" structure (`ARC_AGI1.train_examples`/
`test_examples`), reused as-is rather than re-parsing the raw JSON.
"""
function arga_problems()
    return filter(p -> Symbol(p.name) in ARGA_TASK_IDS, ARC_AGI1_TRAINING)
end

end # module ARGA
