using Test
using OpenEng.Viz
using Plots

@testset "Viz Module" begin
    @testset "Backend Setting" begin
        @test_nowarn set_default_backend(:gr)
    end
    
    @testset "Signal Plotting" begin
        t = 0:0.01:10
        y = sin.(t)
        
        p = plot_signal(t, y)
        @test p isa Plots.Plot
        
        # Test with custom options
        p2 = plot_signal(t, y, title="Test Signal", xlabel="Time (s)")
        @test p2 isa Plots.Plot
    end
    
    @testset "Multiple Signals" begin
        t = 0:0.01:10
        y1 = sin.(t)
        y2 = cos.(t)
        
        # Matrix input
        Y = [y1 y2]
        p = plot_signals(t, Y, labels=["sin" "cos"])
        @test p isa Plots.Plot
        
        # Vector of vectors input
        p2 = plot_signals(t, [y1, y2])
        @test p2 isa Plots.Plot
    end
    
    @testset "Spectrum Plotting" begin
        freqs = 0:0.1:100
        magnitude = exp.(-(freqs .- 10).^2 / 20)
        
        p = plot_spectrum(freqs, magnitude)
        @test p isa Plots.Plot
        
        # Test with log scale
        p2 = plot_spectrum(freqs, magnitude, xscale=:log10, yscale=:log10)
        @test p2 isa Plots.Plot
    end
    
    @testset "Surface Plotting" begin
        x = -3:0.5:3
        y = -3:0.5:3
        z = [sin(sqrt(xi^2 + yi^2)) for xi in x, yi in y]
        
        p = plot_surface(x, y, z)
        @test p isa Plots.Plot
    end
    
    @testset "Heatmap Plotting" begin
        z = rand(20, 20)
        
        p = plot_heatmap(z)
        @test p isa Plots.Plot
        
        p2 = plot_heatmap(z, color=:plasma)
        @test p2 isa Plots.Plot
    end
    
    @testset "Spectrogram Plotting" begin
        # Create dummy spectrogram data
        S = rand(100, 50)
        freqs = range(0, 500, length=100)
        times = range(0, 10, length=50)
        
        p = plot_spectrogram(S, freqs, times)
        @test p isa Plots.Plot
    end
    
    @testset "Response Plotting" begin
        t = 0:0.01:5
        y = 1 .- exp.(-t)
        
        p = plot_response(t, y, response_type="Step")
        @test p isa Plots.Plot
        
        p2 = plot_response(t, y, response_type="Impulse")
        @test p2 isa Plots.Plot
    end
    
    @testset "Plot Saving" begin
        t = 0:0.01:1
        y = sin.(2π .* t)
        p = plot_signal(t, y)
        
        # Save to temporary location
        tmpfile = tempname() * ".png"
        # In headless mode (CI/containers), GKS warnings are expected - just check file creation
        save_plot(p, tmpfile)
        @test isfile(tmpfile)
        
        # Clean up
        rm(tmpfile, force=true)
    end
    
    @testset "Plot Composition" begin
        # Test that we can create plots and modify them
        t = 0:0.01:1
        y = sin.(2π .* t)
        
        p = plot(t, y, label="original")
        plot!(p, t, 2 .* y, label="doubled")
        
        @test p isa Plots.Plot
    end
end
