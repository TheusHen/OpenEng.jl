"""
# OpenEng.Signal

Signal and image processing tools.

This module provides functions for digital signal processing, including FFT,
filtering, spectral analysis, and more.

## Main Functions

- `fft`, `ifft`: Fast Fourier Transform
- `rfft`, `irfft`: Real FFT
- `fftshift`, `ifftshift`: FFT frequency shifting
- `filter`: Apply digital filter
- `butter`, `cheby1`: Filter design
- `spectrogram`: Compute spectrogram
- `welch`: Welch's power spectral density estimate

## Examples

```julia
using OpenEng.Signal

# FFT example
x = sin.(2π * 5 .* (0:0.001:1))  # 5 Hz sine
X = fft(x)
freqs = fftfreq(length(x), 1/0.001)

# Filter design
b, a = butter(4, 0.5)  # 4th order Butterworth
y = filter(b, a, x)
```
"""
module Signal

using FFTW
using DSP
using LinearAlgebra

# Re-export FFTW functions
export fft, ifft, rfft, irfft, fftshift, ifftshift
export plan_fft, plan_ifft, plan_rfft, plan_irfft

# Re-export DSP functions
export filt, filtfilt, resample
export conv, xcorr, hilbert
export periodogram, welch, spectrogram

# Custom exports
export fftfreq, rfftfreq
export butter, cheby1, cheby2, ellip
export filter_signal
export compute_spectrogram
export power_spectrum

"""
    fftfreq(n, d=1.0) -> freqs

Compute FFT frequency bins.

# Arguments
- `n`: Number of samples
- `d`: Sample spacing (inverse of sampling rate)

# Returns
- `freqs`: Frequency vector

# Examples
```julia
n = 1000
fs = 1000.0  # 1 kHz sampling rate
freqs = fftfreq(n, 1/fs)
```
"""
function fftfreq(n::Integer, d::Real=1.0)
    val = 1.0 / (n * d)
    results = zeros(n)
    N = (n - 1) ÷ 2 + 1
    results[1:N] = range(0, N-1) * val
    results[N+1:end] = range(-(n÷2), -1) * val
    return results
end

"""
    rfftfreq(n, d=1.0) -> freqs

Compute RFFT frequency bins (positive frequencies only).

# Arguments
- `n`: Number of samples
- `d`: Sample spacing

# Returns
- `freqs`: Positive frequency vector

# Examples
```julia
n = 1000
fs = 1000.0
freqs = rfftfreq(n, 1/fs)
```
"""
function rfftfreq(n::Integer, d::Real=1.0)
    val = 1.0 / (n * d)
    N = n ÷ 2 + 1
    return range(0, N-1) * val
end

"""
    butter(n, Wn; btype=:lowpass, analog=false) -> (b, a)

Design an nth-order Butterworth filter.

# Arguments
- `n`: Filter order
- `Wn`: Cutoff frequency (normalized to Nyquist if digital)
- `btype`: Filter type (`:lowpass`, `:highpass`, `:bandpass`, `:bandstop`)
- `analog`: If true, design analog filter

# Returns
- `b`: Numerator coefficients
- `a`: Denominator coefficients

# Examples
```julia
b, a = butter(4, 0.2)  # 4th order lowpass at 0.2*Nyquist
y = filt(b, a, x)
```
"""
function butter(n::Integer, Wn; btype::Symbol=:lowpass, analog::Bool=false)
    if btype == :lowpass
        responsetype = Lowpass(Wn)
    elseif btype == :highpass
        responsetype = Highpass(Wn)
    elseif btype == :bandpass && length(Wn) == 2
        responsetype = Bandpass(Wn[1], Wn[2])
    elseif btype == :bandstop && length(Wn) == 2
        responsetype = Bandstop(Wn[1], Wn[2])
    else
        error("Invalid filter type or cutoff specification")
    end
    
    designmethod = Butterworth(n)
    zpk_filter = digitalfilter(responsetype, designmethod)
    return coefb(zpk_filter), coefa(zpk_filter)
end

"""
    cheby1(n, rp, Wn; btype=:lowpass) -> (b, a)

Design an nth-order Chebyshev Type I filter.

# Arguments
- `n`: Filter order
- `rp`: Passband ripple (dB)
- `Wn`: Cutoff frequency
- `btype`: Filter type

# Returns
- `b`, `a`: Filter coefficients

# Examples
```julia
b, a = cheby1(4, 0.5, 0.2)  # 0.5 dB ripple
```
"""
function cheby1(n::Integer, rp::Real, Wn; btype::Symbol=:lowpass)
    if btype == :lowpass
        responsetype = Lowpass(Wn)
    elseif btype == :highpass
        responsetype = Highpass(Wn)
    else
        error("Only lowpass and highpass supported in this version")
    end
    
    designmethod = Chebyshev1(n, rp)
    zpk_filter = digitalfilter(responsetype, designmethod)
    return coefb(zpk_filter), coefa(zpk_filter)
end

"""
    cheby2(n, rs, Wn; btype=:lowpass) -> (b, a)

Design an nth-order Chebyshev Type II filter.

# Arguments
- `n`: Filter order
- `rs`: Stopband attenuation (dB)
- `Wn`: Cutoff frequency
- `btype`: Filter type

# Returns
- `b`, `a`: Filter coefficients
"""
function cheby2(n::Integer, rs::Real, Wn; btype::Symbol=:lowpass)
    if btype == :lowpass
        responsetype = Lowpass(Wn)
    elseif btype == :highpass
        responsetype = Highpass(Wn)
    else
        error("Only lowpass and highpass supported in this version")
    end
    
    designmethod = Chebyshev2(n, rs)
    zpk_filter = digitalfilter(responsetype, designmethod)
    return coefb(zpk_filter), coefa(zpk_filter)
end

"""
    ellip(n, rp, rs, Wn; btype=:lowpass) -> (b, a)

Design an nth-order Elliptic (Cauer) filter.

# Arguments
- `n`: Filter order
- `rp`: Passband ripple (dB)
- `rs`: Stopband attenuation (dB)
- `Wn`: Cutoff frequency
- `btype`: Filter type

# Returns
- `b`, `a`: Filter coefficients

# Examples
```julia
b, a = ellip(4, 0.5, 40, 0.2)
```
"""
function ellip(n::Integer, rp::Real, rs::Real, Wn; btype::Symbol=:lowpass)
    if btype == :lowpass
        responsetype = Lowpass(Wn)
    elseif btype == :highpass
        responsetype = Highpass(Wn)
    else
        error("Only lowpass and highpass supported in this version")
    end
    
    designmethod = Elliptic(n, rp, rs)
    zpk_filter = digitalfilter(responsetype, designmethod)
    return coefb(zpk_filter), coefa(zpk_filter)
end

"""
    filter_signal(b, a, x) -> y

Apply a digital filter to signal x.

# Arguments
- `b`: Numerator coefficients
- `a`: Denominator coefficients
- `x`: Input signal

# Returns
- `y`: Filtered signal

# Examples
```julia
b, a = butter(4, 0.2)
y = filter_signal(b, a, x)
```
"""
function filter_signal(b, a, x)
    return filt(b, a, x)
end

"""
    compute_spectrogram(x, n=256, noverlap=128, window=nothing) -> (S, f, t)

Compute the spectrogram of signal x.

# Arguments
- `x`: Input signal
- `n`: FFT length
- `noverlap`: Number of overlapping samples
- `window`: Window function (default: Hamming)

# Returns
- `S`: Spectrogram matrix (frequency × time)
- `f`: Frequency vector
- `t`: Time vector

# Examples
```julia
x = randn(10000)
S, f, t = compute_spectrogram(x, 256)
```
"""
function compute_spectrogram(x::AbstractVector, n::Int=256, noverlap::Int=128, 
                             window=nothing, fs::Real=1.0)
    if window === nothing
        window = hamming(n)
    end
    
    spec = spectrogram(x, n, noverlap; window=window, fs=fs)
    return power(spec), freq(spec), time(spec)
end

"""
    power_spectrum(x; method=:welch, kwargs...) -> (P, f)

Compute the power spectral density of signal x.

# Arguments
- `x`: Input signal
- `method`: Method to use (`:welch` or `:periodogram`)
- `kwargs...`: Additional arguments for the method

# Returns
- `P`: Power spectral density
- `f`: Frequency vector

# Examples
```julia
x = sin.(2π * 10 .* (0:0.001:1)) + randn(1001) * 0.1
P, f = power_spectrum(x, fs=1000)
```
"""
function power_spectrum(x::AbstractVector; method::Symbol=:welch, 
                        fs::Real=1.0, kwargs...)
    if method == :welch
        result = welch_pgram(x; fs=fs, kwargs...)
    elseif method == :periodogram
        result = periodogram(x; fs=fs, kwargs...)
    else
        error("Unknown method: $method")
    end
    return power(result), freq(result)
end

end # module Signal
