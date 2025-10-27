#!/bin/bash
# Quick test script to verify OpenEng.jl installation

set -e

echo "Testing OpenEng.jl installation..."

julia --project=. -e '
using Test
using OpenEng

@testset "Quick Smoke Tests" begin
    println("\n=== Testing Package Loading ===")
    @test OpenEng.version() == v"0.1.0"
    
    println("\n=== Testing Linear Algebra ===")
    using OpenEng.LA
    A = [3.0 2.0; 1.0 4.0]
    λ, V = eig(A)
    @test length(λ) == 2
    println("✓ Eigenvalue computation works")
    
    println("\n=== Testing Signal Processing ===")
    using OpenEng.Signal
    x = randn(100)
    X = fft(x)
    @test length(X) == length(x)
    println("✓ FFT works")
    
    println("\n=== Testing GPU Module ===")
    using OpenEng.GPU
    @test gpu_available() isa Bool
    A = rand(10, 10)
    B = rand(10, 10)
    C = gpu_matmul(A, B)
    @test size(C) == (10, 10)
    println("✓ GPU module works (CPU fallback if no GPU)")
    
    println("\n=== Testing Utilities ===")
    using OpenEng.Utils
    @test PhysicalConstants.SPEED_OF_LIGHT ≈ 299792458.0
    println("✓ Physical constants available")
    
    println("\n=== All Quick Tests Passed! ===")
end
'

echo ""
echo "✓ OpenEng.jl is working correctly!"
echo ""
