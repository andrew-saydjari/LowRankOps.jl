@testset "lowRankMultMat.jl" begin
    seed!(123)
    n_big = 100
    n_lit = 2
    
    A = Diagonal(randn(n_big))
    Ainv = inv(A)
    V = randn(n_big,n_lit)
    x = randn(n_big)
    
    function wood_precomp_mult(matList)
        Ainv = matList[1]
        V = matList[2]
        AinvV = Ainv*V
        return [(AinvV)*inv(I+V'*(AinvV))]
    end

    function wood_fxn_mult(matList,precompList,x)
        Ainv = matList[1]
        V = matList[2]
        arg1 = precompList[1]
        return Ainv*(x - V*(arg1'*x))
    end
    
    M = A + V*V'
    Minv = inv(M)
    Ctotinv = LowRankMultMat([Ainv,V],wood_precomp_mult,wood_fxn_mult);
    
    @test Ctotinv*x ≈ Minv*x
    @test Ctotinv(x) ≈ Minv*x
end
