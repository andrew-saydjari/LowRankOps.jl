module LowRankOps

    using LinearAlgebra
    import Base: *
    import LinearAlebgra: diag

    export LowRankMultMat, LowRankDiagMat

    include("lowRankMultMat.jl")
    include("lowRankDiagMat.jl")

end
