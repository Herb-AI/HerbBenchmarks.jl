using HerbData
using HerbCore

include("PBE_SLIA_Track_2019.jl")
using .PBE_SLIA_Track_2019

include("../../../benchmarks_io.jl")

sygus_input = """(synth-fun f ((name String)) String
    ((Start String (ntString))
     (ntString String (name " "
                       (str.++ ntString ntString)
                       (str.replace ntString ntString ntString)
                       (str.at ntString ntInt)
                       (int.to.str ntInt)
                       (str.substr ntString ntInt ntInt)))
      (ntInt Int (0 1 2 3 4 5
                  (+ ntInt ntInt)
                  (- ntInt ntInt)
                  (str.len ntString)
                  (str.to.int ntString)
                  (str.indexof ntString ntString ntInt)))
      (ntBool Bool (true false
                    (str.prefixof ntString ntString)
                    (str.suffixof ntString ntString)
                    (str.contains ntString ntString)))))"""


path = "../../../../../BenchmarkHackathon/benchmarks/comp/2017/PBE_Strings_Track/"
filename = "bikes_small.sl"

name = String(split(filename, '.')[1])
sygus_to_julia(path*filename, name)
