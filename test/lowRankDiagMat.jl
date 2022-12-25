@testset "lowRankDiagMat.jl" begin
    seed!(123)
    n_big = 100
    n_lit = 2
    
    #this is just for testing
    #ideally Ctotinv would be a lowRankMultMat
    Ctotinv = randn(n_big,n_big) 
    Vi = randn(n_big,n_lit)
    Vj = randn(n_big,n_lit)
    
    function Cij_precomp_diag(matList)
        Ctotinv = matList[1]
        Vi = matList[2]
        Vj = matList[3]
        return [Vi'*(Ctotinv*Vj)]
    end

    function Cij_diag_map(matList,precompList)
        Vi = matList[2]
        Vj = matList[3]
        arg1 = precompList[1]
        return dropdims(sum(Vi'.*(arg1*Vj'),dims=1),dims=1)
    end
    
    M = Vi*((Vi'*(Ctotinv*Vj))*Vj')
    DMat = LowRankDiagMat([Ctotinv,Vi,Vj],Cij_precomp_diag,Cij_diag_map);
    
    @test DMat() ≈ diag(M)
    @test diag(DMat) ≈ diag(M)
end