"""
This is a `LowRankMultMat` object.
It can be constructed from a set of matrix factors and a multiplication function.
Implemented methods include `*`.

# Fields
- matList: list of (low-rank) matrix factors that underlie the matrix
- precompList: list of precomputed matrix products
- multFunc: function defining fast matrix multiplication
"""
struct LowRankMultMat{T,pT,F<:Function}
    matList::T
    precompList::pT
    multFunc::F
end
LowRankMultMat(M,pf::Function,mf::Function) = LowRankMultMat(M,pf(M),mf)

*(W::LowRankMultMat,B::Union{Vector,AbstractMatrix}) = W.multFunc(W.matList,W.precompList,B)
(W::LowRankMultMat)(B::Union{Vector,AbstractMatrix}) = W.multFunc(W.matList,W.precompList,B)