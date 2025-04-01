using Artifacts
using LazyArtifacts
using .SExpressionParser


function get_sygus_path()
    root_path = artifact"sygus"
    # within the root_path there should be some directory that is itself the root
    # of the git project, we want to return _that_ path
    sygus_path = only(filter(isdir, readdir(root_path; join=true)))

    return sygus_path
end

function get_bv_paths(year)
    sygus_path = get_sygus_path()
    yeardir = joinpath(sygus_path, "comp", "$year")
    
    @assert isdir(yeardir) "$yeardir doesn't exist"

    bv_path = joinpath(yeardir, "PBE_BV_Track")

    return filter(x -> splitext(x)[2] == ".sl", readdir(bv_path; join=true))
end

function extract_bv()
    
end
