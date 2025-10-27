using Test
using OpenEng.GPU
using LinearAlgebra

@testset "GPU Module" begin
    @testset "GPU Availability" begin
        # Should not error even if GPU not available
        @test_nowarn gpu_available()
        @test_nowarn has_cuda()
        @test_nowarn gpu_enabled()
        
        available = gpu_available()
        @test available isa Bool
    end
    
    @testset "CPU Fallback - Array Transfer" begin
        A = rand(10, 10)
        
        # to_gpu should work even without GPU (returns original array)
        A_device = to_gpu(A)
        @test A_device isa AbstractArray
        
        # to_cpu should work
        A_cpu = to_cpu(A_device)
        @test A_cpu ≈ A
    end
    
    @testset "CPU Fallback - Matrix Multiplication" begin
        A = rand(50, 50)
        B = rand(50, 50)
        
        C = gpu_matmul(A, B)
        C_expected = A * B
        
        @test C ≈ C_expected atol=1e-10
    end
    
    @testset "CPU Fallback - Element-wise Operations" begin
        A = rand(20, 20)
        B = rand(20, 20)
        
        # Multiplication
        C = gpu_multiply(A, B)
        @test C ≈ A .* B
        
        # Addition
        C = gpu_add(A, B)
        @test C ≈ A .+ B
        
        # Subtraction
        C = gpu_subtract(A, B)
        @test C ≈ A .- B
    end
    
    @testset "CPU Fallback - Transpose" begin
        A = rand(30, 20)
        At = gpu_transpose(A)
        
        @test size(At) == (20, 30)
        @test At ≈ transpose(A)
    end
    
    @testset "Device Array" begin
        A = rand(10, 10)
        A_device = device_array(A)
        
        @test A_device isa AbstractArray
        # Should be equivalent to original in CPU-only mode
        @test to_cpu(A_device) ≈ A
    end
    
    @testset "Round-trip GPU Transfer" begin
        A = rand(15, 15)
        
        A_gpu = to_gpu(A)
        A_back = to_cpu(A_gpu)
        
        @test A_back ≈ A
    end
    
    @testset "Large Matrix Operations" begin
        # Test that operations work with larger matrices
        n = 200
        A = rand(n, n)
        B = rand(n, n)
        
        # This should work with CPU fallback
        C = gpu_matmul(A, B)
        
        @test size(C) == (n, n)
        @test C ≈ A * B atol=1e-8
    end
    
    @testset "Vector Operations" begin
        x = rand(100)
        y = rand(100)
        
        # Element-wise operations should work with vectors too
        z = gpu_multiply(x, y)
        @test z ≈ x .* y
        
        z = gpu_add(x, y)
        @test z ≈ x .+ y
    end
end
