# Signal Processing Examples

using OpenEng
using OpenEng.Signal
using OpenEng.Viz

println("=" ^ 60)
println("OpenEng.jl - Signal Processing Examples")
println("=" ^ 60)

# Example 1: FFT of Sine Wave
println("\n1. FFT Analysis of Sine Wave")
println("-" ^ 40)

fs = 1000.0  # Sampling frequency
t = 0:1/fs:1-1/fs
f0 = 50.0  # Signal frequency
x = sin.(2π * f0 .* t)

X = fft(x)
freqs = fftfreq(length(x), 1/fs)

# Find peak frequency
pos_idx = freqs .>= 0
pos_freqs = freqs[pos_idx]
pos_mag = abs.(X[pos_idx])
peak_idx = argmax(pos_mag[2:end]) + 1
detected_freq = pos_freqs[peak_idx]

println("Sampling frequency: ", fs, " Hz")
println("True frequency: ", f0, " Hz")
println("Detected frequency: ", detected_freq, " Hz")
println("Error: ", abs(detected_freq - f0), " Hz")

# Example 2: Multi-Tone Signal
println("\n2. Multi-Tone Signal Analysis")
println("-" ^ 40)

f1, f2, f3 = 10.0, 25.0, 50.0
x = sin.(2π * f1 .* t) .+ 0.5 * sin.(2π * f2 .* t) .+ 0.3 * sin.(2π * f3 .* t)

X = fft(x)
freqs = fftfreq(length(x), 1/fs)

# Positive frequencies only
pos_idx = (freqs .>= 0) .& (freqs .<= fs/2)
pos_freqs = freqs[pos_idx]
pos_mag = abs.(X[pos_idx])

println("Signal components: ", f1, " Hz, ", f2, " Hz, ", f3, " Hz")
println("Spectrum computed with ", length(x), " samples")
println("Frequency resolution: ", fs/length(x), " Hz")

# Example 3: Noise Filtering
println("\n3. Lowpass Filtering of Noisy Signal")
println("-" ^ 40)

# Signal + noise
signal = sin.(2π * 5 .* t)
noise = 0.5 * randn(length(t))
x_noisy = signal .+ noise

# Design lowpass filter
cutoff = 0.05  # Normalized cutoff (0.05 * Nyquist)
b, a = butter(4, cutoff)

# Filter the signal
x_filtered = filter_signal(b, a, x_noisy)

using Statistics  # For var function
println("Original signal SNR: ", 10 * log10(var(signal) / var(noise)), " dB")
println("Filter order: 4")
println("Cutoff frequency: ", cutoff * fs/2, " Hz")
println("Filtered signal variance reduced from ", var(x_noisy), " to ", var(x_filtered))

# Example 4: Butterworth Filter Design
println("\n4. Filter Design Comparison")
println("-" ^ 40)

cutoff = 0.2
orders = [2, 4, 6, 8]

println("Butterworth filters at cutoff = ", cutoff)
for order in orders
    b, a = butter(order, cutoff)
    println("Order ", order, ": ", length(b), " coefficients")
end

# Example 5: Chebyshev Filters
println("\n5. Chebyshev Type I Filter")
println("-" ^ 40)

ripple = 0.5  # dB
b, a = cheby1(4, ripple, 0.3)

println("Filter order: 4")
println("Passband ripple: ", ripple, " dB")
println("Cutoff: 0.3 (normalized)")
println("Coefficients: ", length(b), " numerator, ", length(a), " denominator")

# Example 6: Power Spectrum Estimation
println("\n6. Power Spectral Density (Welch's Method)")
println("-" ^ 40)

# Generate signal with two frequency components plus noise
x = sin.(2π * 10 .* t) .+ 0.5 * sin.(2π * 25 .* t) .+ 0.2 * randn(length(t))

P, f = power_spectrum(x, fs=fs, method=:welch)

# Find peaks
peak_indices = findall(P .> 0.1 * maximum(P))
peak_freqs = f[peak_indices]

println("Number of frequency bins: ", length(f))
println("Frequency range: 0 to ", maximum(f), " Hz")
println("Detected peaks around: ", [round(pf, digits=1) for pf in peak_freqs[1:min(5, end)]])

# Example 7: Bandpass Filtering
println("\n7. Signal Extraction with Bandpass Filter")
println("-" ^ 40)

# Multi-component signal
f_low, f_mid, f_high = 5.0, 50.0, 200.0
x = sin.(2π * f_low .* t) .+ sin.(2π * f_mid .* t) .+ sin.(2π * f_high .* t)

# Extract middle component using bandpass filter
# Note: butter with vector argument needs btype specified
b, a = butter(4, [0.08, 0.12], btype=:bandpass)  # Bandpass
x_band = filter_signal(b, a, x)

println("Original signal has components at: ", f_low, ", ", f_mid, ", ", f_high, " Hz")
println("Bandpass filter: ", 0.08 * fs/2, " to ", 0.12 * fs/2, " Hz")
println("Extracted component dominant at ", f_mid, " Hz")

# Example 8: Spectrogram
println("\n8. Spectrogram Computation")
println("-" ^ 40)

# Chirp signal (frequency sweep)
t_chirp = 0:1/fs:2-1/fs
f_start, f_end = 10.0, 100.0
phase = 2π * (f_start * t_chirp .+ (f_end - f_start) / (2 * 2) .* t_chirp.^2)
x_chirp = sin.(phase)

S, f_spec, t_spec = compute_spectrogram(x_chirp, 256, 128, nothing, fs)

println("Signal: frequency sweep from ", f_start, " to ", f_end, " Hz")
println("Spectrogram size: ", size(S, 1), " frequencies × ", size(S, 2), " time bins")
println("Time resolution: ", t_spec[2] - t_spec[1], " s")
println("Frequency resolution: ", f_spec[2] - f_spec[1], " Hz")

# Example 9: FFT Shift for Centered Spectrum
println("\n9. FFT Shift and Frequency Centering")
println("-" ^ 40)

x = randn(128)
X = fft(x)
X_shifted = fftshift(X)
freqs_shifted = fftshift(fftfreq(length(x), 1/fs))

println("Original FFT range: DC to Nyquist, then negative frequencies")
println("Shifted FFT range: -Nyquist to +Nyquist (centered)")
println("Original first frequency: ", fftfreq(length(x), 1/fs)[1])
println("Shifted first frequency: ", freqs_shifted[1])

# Example 10: Real FFT for Memory Efficiency
println("\n10. Real FFT (rfft) vs Complex FFT")
println("-" ^ 40)

x = randn(1000)

X_complex = fft(x)
X_real = rfft(x)

println("Input signal length: ", length(x))
println("Complex FFT output length: ", length(X_complex))
println("Real FFT output length: ", length(X_real))
println("Memory saved: ", 100 * (1 - length(X_real)/length(X_complex)), "%")

println("\n" * "=" ^ 60)
println("Examples completed successfully!")
println("=" ^ 60)
