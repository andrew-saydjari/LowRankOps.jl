struct LowRankDiagMat{T,pT,F<:Function}
    matList::T
    precompList::pT
    diagFunc::F
end
LowRankDiagMat(M,pf::Function,mf::Function) = LowRankDiagMat(M,pf(M),mf)

diag(W::LowRankDiagMat) = W.diagFunc(W.matList,W.precompList)
(W::LowRankDiagMat)() = W.diagFunc(W.matList,W.precompList)