"""
# OpenEng.LA (LinearAlgebra)

Advanced linear algebra operations and matrix computations.

This module provides convenient wrappers and extensions to Julia's LinearAlgebra
and SparseArrays packages, with MATLAB-compatible naming where appropriate.

## Main Functions

- `eig`: Compute eigenvalues and eigenvectors
- `svd`: Singular value decomposition
- `qr`: QR decomposition
- `lu`: LU decomposition
- `chol`: Cholesky decomposition
- Matrix operations: `inv`, `det`, `rank`, `norm`, `cond`
- Sparse matrices: `sparse`, `issparse`, `nnz`

## Examples

```julia
using OpenEng.LA

A = [3.0 2.0; 1.0 4.0]
λ, V = eig(A)  # Eigenvalues and eigenvectors

U, S, Vt = svd(A)  # SVD decomposition

# Sparse matrices
S = sparse([1, 2, 3], [1, 2, 3], [1.0, 2.0, 3.0])
```
"""
module LA

using LinearAlgebra
using SparseArrays
using LinearAlgebra: checksquare

# Re-export standard functions
export dot, cross, norm, normalize, normalize!
export tr, det, rank, cond, inv, pinv
export diag, diagm, Diagonal, I
export lu, lu!, qr, qr!  # Note: svd exported separately below as custom wrapper
export eigvals, eigvecs, eigen, eigen!
export cholesky, cholesky!
export issymmetric, ishermitian, isposdef

# Sparse array exports
export sparse, spzeros, spdiagm, issparse, nnz, dropzeros!, dropzeros

# Custom functions
export eig, eig!, chol, chol!
export svd  # Custom MATLAB-style wrapper (returns tuple not object)
export solve, solve!
export matrix_power, matrix_exp
export frobenius_norm, spectral_norm

# Override svd to return tuple instead of SVD object (MATLAB-style)
"""
    svd(A) -> (U, S, Vt)

Compute the singular value decomposition of matrix A.

Returns MATLAB-style tuple `(U, S, Vt)` where A ≈ U * Diagonal(S) * Vt.

# Arguments
- `A`: Matrix to decompose

# Returns
- `U`: Left singular vectors (m × k matrix for thin SVD)
- `S`: Singular values (vector of length k)
- `Vt`: Right singular vectors transposed (k × n matrix)

# Examples
```julia
A = rand(5, 3)
U, S, Vt = svd(A)
@assert A ≈ U * Diagonal(S) * Vt
```
"""
function svd(A::AbstractMatrix)
    F = LinearAlgebra.svd(A)
    return F.U, F.S, F.Vt
end

"""
    eig(A) -> (λ, V)

Compute eigenvalues and eigenvectors of matrix A.

Returns a tuple `(λ, V)` where `λ` is a vector of eigenvalues and `V` is a matrix
whose columns are the corresponding eigenvectors.

# Arguments
- `A`: A square matrix

# Returns
- `λ`: Vector of eigenvalues
- `V`: Matrix of eigenvectors (columns)

# Examples
```julia
A = [3.0 2.0; 1.0 4.0]
λ, V = eig(A)
```
"""
function eig(A::AbstractMatrix)
    result = eigen(A)
    return result.values, result.vectors
end

"""
    eig!(A) -> (λ, V)

In-place version of `eig`. Modifies the input matrix.
"""
function eig!(A::AbstractMatrix)
    result = eigen!(A)
    return result.values, result.vectors
end

"""
    chol(A) -> U

Compute the Cholesky decomposition of a positive definite matrix A.

Returns the upper triangular matrix U such that A = U'U.

# Arguments
- `A`: A positive definite matrix

# Returns
- `U`: Upper triangular Cholesky factor

# Examples
```julia
A = [4.0 2.0; 2.0 3.0]
U = chol(A)
@assert A ≈ U'U
```
"""
function chol(A::AbstractMatrix)
    return cholesky(A).U
end

"""
    chol!(A) -> U

In-place version of `chol`. Modifies the input matrix.
"""
function chol!(A::AbstractMatrix)
    return cholesky!(A).U
end

"""
    solve(A, b) -> x

Solve the linear system Ax = b.

# Arguments
- `A`: Coefficient matrix
- `b`: Right-hand side vector or matrix

# Returns
- `x`: Solution vector or matrix

# Examples
```julia
A = [3.0 2.0; 1.0 4.0]
b = [1.0, 2.0]
x = solve(A, b)
@assert A * x ≈ b
```
"""
function solve(A::AbstractMatrix, b::AbstractVecOrMat)
    return A \ b
end

"""
    solve!(A, b) -> x

In-place version of `solve`. May modify input arrays.
"""
function solve!(A::AbstractMatrix, b::AbstractVecOrMat)
    return ldiv!(lu!(A), b)
end

"""
    matrix_power(A, n) -> A^n

Compute the n-th power of a matrix A.

# Arguments
- `A`: A square matrix
- `n`: Integer exponent

# Returns
- `A^n`: Matrix power

# Examples
```julia
A = [1.0 1.0; 0.0 1.0]
A2 = matrix_power(A, 2)
```
"""
function matrix_power(A::AbstractMatrix, n::Integer)
    checksquare(A)
    if n == 0
        return Matrix{eltype(A)}(I, size(A))
    elseif n == 1
        return copy(A)
    elseif n < 0
        return matrix_power(inv(A), -n)
    else
        # Use repeated squaring for efficiency
        result = Matrix{eltype(A)}(I, size(A))
        base = copy(A)
        exp = n
        while exp > 0
            if exp % 2 == 1
                result = result * base
            end
            base = base * base
            exp = exp ÷ 2
        end
        return result
    end
end

"""
    matrix_exp(A) -> exp(A)

Compute the matrix exponential of A using eigenvalue decomposition.

# Arguments
- `A`: A square matrix

# Returns
- `exp(A)`: Matrix exponential

# Examples
```julia
A = [0.0 1.0; -1.0 0.0]
expA = matrix_exp(A)
```
"""
function matrix_exp(A::AbstractMatrix)
    return exp(A)
end

"""
    frobenius_norm(A) -> ||A||_F

Compute the Frobenius norm of matrix A.

# Arguments
- `A`: A matrix

# Returns
- Frobenius norm (square root of sum of squared elements)

# Examples
```julia
A = [1.0 2.0; 3.0 4.0]
nrm = frobenius_norm(A)
```
"""
function frobenius_norm(A::AbstractMatrix)
    return norm(A)  # Default norm is Frobenius for matrices
end

"""
    spectral_norm(A) -> ||A||_2

Compute the spectral norm (2-norm) of matrix A.

# Arguments
- `A`: A matrix

# Returns
- Spectral norm (largest singular value)

# Examples
```julia
A = [1.0 2.0; 3.0 4.0]
nrm = spectral_norm(A)
```
"""
function spectral_norm(A::AbstractMatrix)
    return norm(A, 2)
end

end # module LA
