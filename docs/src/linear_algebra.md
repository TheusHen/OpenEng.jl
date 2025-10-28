# Linear Algebra

The `OpenEng.LA` module provides advanced linear algebra operations and matrix computations.

## Overview

This module offers convenient wrappers and extensions to Julia's LinearAlgebra and SparseArrays packages, with MATLAB-compatible naming where appropriate.

## Main Functions

### Eigenvalues and Eigenvectors

```julia
using OpenEng.LA

A = [3.0 2.0; 1.0 4.0]
λ, V = eig(A)  # Eigenvalues and eigenvectors
```

### Matrix Decompositions

- `svd(A)` - Singular Value Decomposition
- `qr(A)` - QR decomposition
- `lu(A)` - LU decomposition  
- `chol(A)` - Cholesky decomposition

### Linear Systems

- `solve(A, b)` - Solve linear system Ax = b
- `inv(A)` - Matrix inverse
- `pinv(A)` - Pseudoinverse

### Matrix Operations

- `matrix_power(A, n)` - Compute A^n
- `matrix_exp(A)` - Matrix exponential
- `frobenius_norm(A)` - Frobenius norm
- `spectral_norm(A)` - Spectral (2-norm)

### Sparse Matrices

- `sparse(I, J, V)` - Create sparse matrix
- `issparse(A)` - Check if sparse
- `nnz(A)` - Number of non-zeros

## Examples

See `examples/linear_algebra_examples.jl` for comprehensive examples.

## API Reference

```@docs
OpenEng.LA.eig
OpenEng.LA.svd
OpenEng.LA.chol
OpenEng.LA.solve
OpenEng.LA.matrix_power
```
