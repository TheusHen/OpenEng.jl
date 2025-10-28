# Signal Processing

The `OpenEng.Signal` module provides digital signal processing tools including FFT, filtering, and spectral analysis.

## Overview

This module wraps FFTW.jl and DSP.jl to provide MATLAB-style signal processing functions.

## FFT Analysis

```julia
using OpenEng.Signal

# Generate signal
fs = 1000.0  # Sampling frequency
t = 0:1/fs:1-1/fs
x = sin.(2π * 50 .* t)  # 50 Hz sine wave

# Compute FFT
X = fft(x)
freqs = fftfreq(length(x), 1/fs)
```

## Filter Design

### Butterworth Filters

```julia
# Design 4th order lowpass filter
b, a = butter(4, 0.2)  # Cutoff at 0.2*Nyquist

# Apply filter
y = filter_signal(b, a, x)
```

### Chebyshev Filters

```julia
# Type I: passband ripple
b, a = cheby1(4, 0.5, 0.2)

# Type II: stopband attenuation
b, a = cheby2(4, 40, 0.2)
```

### Elliptic Filters

```julia
b, a = ellip(4, 0.5, 40, 0.2)
```

## Spectral Analysis

### Power Spectral Density

```julia
# Welch's method
P, f = power_spectrum(x, method=:welch, fs=1000)

# Periodogram
P, f = power_spectrum(x, method=:periodogram, fs=1000)
```

### Spectrogram

```julia
S, f, t = compute_spectrogram(x, 256, 128, fs=1000)
```

## Main Functions

- `fft`, `ifft` - Fast Fourier Transform
- `rfft`, `irfft` - Real FFT
- `fftfreq`, `rfftfreq` - Frequency bins
- `butter`, `cheby1`, `cheby2`, `ellip` - Filter design
- `filter_signal` - Apply filter
- `power_spectrum` - PSD estimation
- `compute_spectrogram` - Time-frequency analysis

## Examples

See `examples/signal_processing_examples.jl` for comprehensive examples.
