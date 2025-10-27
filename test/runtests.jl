using OpenEng
using Test

@testset "OpenEng.jl" begin
    @testset "Basic functionality" begin
        # Test that the module loads
        @test OpenEng isa Module
        
        # Test version exists and is a valid version number
        @test OpenEng.VERSION isa VersionNumber
        @test OpenEng.VERSION >= v"0.1.0"
        
        # Test greet function exists
        @test isdefined(OpenEng, :greet)
        
        # Test greet function runs without error
        @test begin
            OpenEng.greet()
            true
        end
    end
end
