using Test
using OpenEng

@testset "OpenEng.jl" begin
    @testset "Package Loading" begin
        @test OpenEng.version() isa VersionNumber
        @test OpenEng.version() == v"0.1.0"
        
        # Test that info() runs without error
        @test_nowarn OpenEng.info()
    end
    
    # Include module-specific tests
    include("test_linearalgebra.jl")
    include("test_simulation.jl")
    include("test_signal.jl")
    include("test_optimization.jl")
    include("test_viz.jl")
    include("test_gpu.jl")
    include("test_utils.jl")
end
