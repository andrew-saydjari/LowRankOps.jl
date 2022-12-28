# LowRankOps

[![][action-img]][action-url]
[![][codecov-img]][codecov-url]

Type/method defintions for speeding up matrix computations for matrices built from low rank components.

## Installation

Currently, installation is directly from the GitHub

```julia
import Pkg
Pkg.add(url="https://github.com/andrew-saydjari/LowRankOps.jl")
```

## Examples

### Multiplication

A classic example of low rank factorization is the Woodbury form where $M = A + VV^T$. Here we show how to leverage the type in this package to do fast multiplication of $M^{-1}$ times a vector.

We define two functions, one that defines a set of factors (matrices) to precompute upon object creation and one that defines the multiplication, using the precomputed factors and ordering the operations for speed.

```julia
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
```

Then, creating the object is simple from $A^{-1}$ and $V$ 

```julia
Ctotinv = LowRankMultMat([Ainv,V],wood_precomp_mult,wood_fxn_mult);
```

and matrix multiplication is then fast via

```julia
y = Ctotinv*x
```

This is as performant as matrix multiplication in [Woodbury.jl](https://github.com/timholy/WoodburyMatrices.jl), but the point is that it works for any matrix that can be expressed as a low rank product. For example, $M = C_i - C_i * C^{-1}_{tot} * C_i$, where the $C_i = V_i * V_i^{T}$ and the $V_i$ are low rank.

### Diagonal

Obtaining the diagonal of a low-rank factorization with speed can be obtained through a second type. For example, given a matrix $M = C_i * C^{-1}_{tot} * C_j$, we can once again define two functions

```julia
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
```

which define the precomputation and fast diagonal map. We can construct 

```julia
CMat = LowRankDiagMat([Ctotinv,Vi,Vj],Cij_precomp_diag,Cij_diag_map);
```

Notice that we have used `Ctotinv` from above, which implements fast matrix multiplication via the `LowRankMultMat` type, as part of the matrix listed passed in creating the `LowRankMultMat` object. Then, the diagonal cam be obtained quickly via

```julia
y = diag(CMat)
```

<img width="0" src="https://visitor-badge.glitch.me/badge?page_id=andrew-saydjari.LowRankOps.jl" />

<!-- URLS -->
[action-img]: https://github.com/andrew-saydjari/LowRankOps.jl/workflows/CI/badge.svg
[action-url]: https://github.com/andrew-saydjari/LowRankOps.jl/actions

[codecov-img]: https://codecov.io/github/andrew-saydjari/LowRankOps.jl/coverage.svg?branch=main
[codecov-url]: https://codecov.io/github/andrew-saydjari/LowRankOps.jl?branch=main
