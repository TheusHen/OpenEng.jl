using OpenEng
using Test

@testset "OpenEng.jl" begin
    @testset "Basic functionality" begin
        # Test that the module loads
        @test OpenEng isa Module
        
        # Test version
        @test OpenEng.VERSION == v"0.1.0"
        
        # Test greet function exists
        @test isdefined(OpenEng, :greet)
        
        # Test greet function runs without error
        @test begin
            OpenEng.greet()
            true
        end
    end
end
