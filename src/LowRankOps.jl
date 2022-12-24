module LowRankOps

    using LinearAlgebra
    import Base: *
    import LinearAlgebra: diag

    export LowRankMultMat, LowRankDiagMat

    include("lowRankMultMat.jl")
    include("lowRankDiagMat.jl")

end
