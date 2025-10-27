# Linear Algebra Examples

using OpenEng
using OpenEng.LA

println("=" ^ 60)
println("OpenEng.jl - Linear Algebra Examples")
println("=" ^ 60)

# Example 1: Eigenvalues and Eigenvectors
println("\n1. Eigenvalue Decomposition")
println("-" ^ 40)
A = [4.0 1.0; 2.0 3.0]
println("Matrix A:")
display(A)

λ, V = eig(A)
println("\nEigenvalues: ", λ)
println("Eigenvectors:")
display(V)

# Verify: A*v = λ*v
println("\nVerification: A*v₁ = λ₁*v₁")
println("A*v₁: ", A * V[:, 1])
println("λ₁*v₁: ", λ[1] * V[:, 1])

# Example 2: SVD Decomposition
println("\n\n2. Singular Value Decomposition")
println("-" ^ 40)
B = rand(4, 3)
println("Matrix B (4×3 random):")
display(B)

U, S, Vt = svd(B)
println("\nSingular values: ", S)
println("Reconstructed matrix error: ", norm(U * Diagonal(S) * Vt - B))

# Example 3: Solving Linear Systems
println("\n\n3. Linear System Solving")
println("-" ^ 40)
A = [3.0 2.0 -1.0;
     2.0 -2.0 4.0;
     -1.0 0.5 -1.0]
b = [1.0, -2.0, 0.0]

println("System: Ax = b")
println("A:")
display(A)
println("b: ", b)

x = solve(A, b)
println("\nSolution x: ", x)
println("Verification Ax: ", A * x)
println("Error: ", norm(A * x - b))

# Example 4: Matrix Power
println("\n\n4. Matrix Powers")
println("-" ^ 40)
A = [0.8 0.3; 0.2 0.7]
println("Transition matrix A:")
display(A)

A10 = matrix_power(A, 10)
println("\nA^10:")
display(A10)

A100 = matrix_power(A, 100)
println("\nA^100 (steady state):")
display(A100)

# Example 5: Sparse Matrices
println("\n\n5. Sparse Matrix Operations")
println("-" ^ 40)
n = 100
I_idx = vcat(1:n, 1:n-1)
J_idx = vcat(1:n, 2:n)
V_vals = vcat(fill(2.0, n), fill(-1.0, n-1))
A_sparse = sparse(I_idx, J_idx, V_vals, n, n)

println("Sparse tridiagonal matrix: ", n, "×", n)
println("Number of non-zeros: ", nnz(A_sparse))
println("Sparsity: ", 100 * (1 - nnz(A_sparse)/(n*n)), "%")

# Solve sparse system
b = ones(n)
x = solve(A_sparse, b)
println("\nSolved sparse system")
println("Solution norm: ", norm(x))
println("Residual: ", norm(A_sparse * x - b))

# Example 6: Cholesky Decomposition
println("\n\n6. Cholesky Decomposition")
println("-" ^ 40)
A = [4.0 12.0 -16.0;
     12.0 37.0 -43.0;
     -16.0 -43.0 98.0]
println("Positive definite matrix A:")
display(A)

U = chol(A)
println("\nCholesky factor U:")
display(U)
println("\nReconstruction error: ", norm(U' * U - A))

println("\n" * "=" ^ 60)
println("Examples completed successfully!")
println("=" ^ 60)
