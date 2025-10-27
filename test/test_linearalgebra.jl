using Test
using OpenEng.LA
using LinearAlgebra
using SparseArrays

@testset "LinearAlgebra Module" begin
    @testset "Eigenvalues and Eigenvectors" begin
        A = [3.0 2.0; 1.0 4.0]
        λ, V = eig(A)
        
        @test length(λ) == 2
        @test size(V) == (2, 2)
        
        # Verify eigenvalue equation: A*v = λ*v
        for i in 1:2
            @test A * V[:, i] ≈ λ[i] * V[:, i] atol=1e-10
        end
    end
    
    @testset "SVD Decomposition" begin
        A = rand(5, 3)
        U, S, Vt = LA.svd(A)
        
        # Julia's svd returns thin SVD by default: U is 5x3, not 5x5
        @test size(U, 1) == 5
        @test size(U, 2) == 3  # This is the key fix
        @test length(S) == 3
        @test size(Vt, 1) == 3
        @test size(Vt, 2) == 3
        
        # Reconstruct matrix
        @test U * Diagonal(S) * Vt ≈ A atol=1e-10
    end
    
    @testset "Cholesky Decomposition" begin
        A = [4.0 2.0; 2.0 3.0]
        U = chol(A)
        
        @test U' * U ≈ A atol=1e-10
    end
    
    @testset "Linear System Solving" begin
        A = [3.0 2.0; 1.0 4.0]
        b = [1.0, 2.0]
        x = solve(A, b)
        
        @test A * x ≈ b atol=1e-10
    end
    
    @testset "Matrix Power" begin
        A = [1.0 1.0; 0.0 1.0]
        A2 = matrix_power(A, 2)
        
        @test A2 ≈ A * A
        
        A0 = matrix_power(A, 0)
        @test A0 ≈ Matrix{Float64}(I, 2, 2)
    end
    
    @testset "Matrix Norms" begin
        A = [1.0 2.0; 3.0 4.0]
        
        fnorm = frobenius_norm(A)
        @test fnorm ≈ sqrt(1 + 4 + 9 + 16)
        
        snorm = spectral_norm(A)
        @test snorm > 0
    end
    
    @testset "Sparse Matrices" begin
        I_idx = [1, 2, 3]
        J_idx = [1, 2, 3]
        V_vals = [1.0, 2.0, 3.0]
        S = sparse(I_idx, J_idx, V_vals)
        
        @test issparse(S)
        @test nnz(S) == 3
        @test S[1, 1] == 1.0
        @test S[2, 2] == 2.0
    end
    
    @testset "Basic Matrix Operations" begin
        A = rand(3, 3)
        
        @test det(A) isa Number
        @test rank(A) <= 3
        @test cond(A) > 0
        
        # Test inverse
        if det(A) != 0
            Ainv = inv(A)
            @test Ainv * A ≈ I(3) atol=1e-10
        end
    end
end
