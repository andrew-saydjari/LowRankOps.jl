struct LowRankMultMat{T,pT,F<:Function}
    matList::T
    precompList::pT
    multFunc::F
end
LowRankMultMat(M,pf::Function,mf::Function) = LowRankMultMat(M,pf(M),mf)

*(W::LowRankMultMat,B::Union{Vector,AbstractMatrix}) = W.multFunc(W.matList,W.precompList,B)
(W::LowRankMultMat)(B::Union{Vector,AbstractMatrix}) = W.multFunc(W.matList,W.precompList,B)