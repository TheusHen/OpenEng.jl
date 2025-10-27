using Test
using OpenEng.Signal
using FFTW
using Statistics  # For var() function

@testset "Signal Module" begin
    @testset "FFT Frequency Bins" begin
        n = 100
        fs = 1000.0
        freqs = Signal.fftfreq(n, 1/fs)
        
        @test length(freqs) == n
        @test freqs[1] ≈ 0.0
        
        # Check Nyquist frequency location
        @test maximum(abs.(freqs)) ≈ fs/2 atol=fs/n
    end
    
    @testset "RFFT Frequency Bins" begin
        n = 100
        fs = 1000.0
        freqs = Signal.rfftfreq(n, 1/fs)
        
        @test length(freqs) == n÷2 + 1
        @test freqs[1] ≈ 0.0
        @test all(freqs .>= 0)
    end
    
    @testset "FFT Peak Detection" begin
        # Create a sine wave at 5 Hz
        fs = 1000.0
        t = 0:1/fs:1-1/fs
        f0 = 5.0
        x = sin.(2π * f0 .* t)
        
        X = fft(x)
        freqs = Signal.fftfreq(length(x), 1/fs)
        
        # Find peak in positive frequencies
        pos_idx = freqs .>= 0
        pos_freqs = freqs[pos_idx]
        pos_mag = abs.(X[pos_idx])
        
        peak_idx = argmax(pos_mag[2:end]) + 1  # Skip DC
        detected_freq = pos_freqs[peak_idx]
        
        @test detected_freq ≈ f0 atol=fs/length(x)
    end
    
    @testset "Butterworth Filter Design" begin
        b, a = butter(4, 0.2)
        
        @test length(b) > 0
        @test length(a) > 0
        @test length(b) == length(a)
    end
    
    @testset "Chebyshev Filter Design" begin
        b, a = cheby1(4, 0.5, 0.2)
        
        @test length(b) > 0
        @test length(a) > 0
    end
    
    @testset "Signal Filtering" begin
        # Create signal with noise
        fs = 1000.0
        t = 0:1/fs:1-1/fs
        x = sin.(2π * 5 .* t) .+ 0.1 * randn(length(t))
        
        # Apply lowpass filter
        b, a = butter(4, 0.1)
        y = filter_signal(b, a, x)
        
        @test length(y) == length(x)
        
        # Filtered signal should have less variance
        @test var(y) < var(x)
    end
    
    @testset "Power Spectrum" begin
        fs = 1000.0
        t = 0:1/fs:1-1/fs
        x = sin.(2π * 10 .* t) .+ 0.1 * randn(length(t))
        
        P, f = power_spectrum(x, fs=fs)
        
        @test length(P) > 0
        @test length(f) == length(P)
        @test all(f .>= 0)
        
        # Peak should be near 10 Hz
        peak_idx = argmax(P[2:end]) + 1
        @test f[peak_idx] ≈ 10.0 atol=2.0
    end
    
    @testset "Spectrogram" begin
        fs = 1000.0
        t = 0:1/fs:1-1/fs
        x = sin.(2π * 10 .* t) .+ randn(length(t)) * 0.1
        
        S, f, t_spec = compute_spectrogram(x, 128, 64, nothing, fs)
        
        @test size(S, 1) > 0  # Frequency bins
        @test size(S, 2) > 0  # Time bins
        @test length(f) == size(S, 1)
        @test length(t_spec) == size(S, 2)
    end
    
    @testset "Basic FFT/IFFT" begin
        x = randn(100)
        X = fft(x)
        x_reconstructed = real.(ifft(X))
        
        @test x ≈ x_reconstructed atol=1e-10
    end
    
    @testset "RFFT for Real Signals" begin
        x = randn(100)
        X = rfft(x)
        x_reconstructed = irfft(X, length(x))
        
        @test x ≈ x_reconstructed atol=1e-10
    end
end
