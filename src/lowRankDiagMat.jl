"""
This is a `LowRankDiagMat` object.
It can be constructed from a set of matrix factors and a diagonal function.
Implemented methods include `diag()`.

# Fields
- matList: list of (low-rank) matrix factors that underlie the matrix
- precompList: list of precomputed matrix products
- diagFunc: function defining fast computation of matrix diagonal
"""
struct LowRankDiagMat{T,pT,F<:Function}
    matList::T
    precompList::pT
    diagFunc::F
end
LowRankDiagMat(M,pf::Function,mf::Function) = LowRankDiagMat(M,pf(M),mf)

diag(W::LowRankDiagMat) = W.diagFunc(W.matList,W.precompList)
(W::LowRankDiagMat)() = W.diagFunc(W.matList,W.precompList)