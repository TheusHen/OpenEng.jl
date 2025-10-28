# Visualization

The `OpenEng.Viz` module provides convenient plotting functions for scientific visualization.

## Overview

This module wraps Plots.jl with sensible defaults for engineering applications.

## Basic Plotting

```julia
using OpenEng.Viz

# Plot a signal
t = 0:0.01:10
y = sin.(t)
plot_signal(t, y, title="Sine Wave")
```

## Multiple Signals

```julia
t = 0:0.01:10
y1 = sin.(t)
y2 = cos.(t)
plot_signals(t, [y1 y2], labels=["sin" "cos"])
```

## Frequency Spectrum

```julia
using OpenEng.Signal
x = sin.(2π * 5 .* (0:0.001:1))
X = fft(x)
freqs = fftfreq(length(x), 1000)
plot_spectrum(freqs[1:end÷2], abs.(X[1:end÷2]))
```

## 3D Surface Plots

```julia
x = -3:0.1:3
y = -3:0.1:3
z = [sin(sqrt(xi^2 + yi^2)) for xi in x, yi in y]
plot_surface(x, y, z)
```

## Heatmaps

```julia
z = rand(20, 20)
plot_heatmap(z, title="Random Data")
```

## Spectrograms

```julia
using OpenEng.Signal
x = randn(10000)
S, f, t = compute_spectrogram(x, 256, 128, fs=1000)
plot_spectrogram(S, f, t)
```

## System Responses

```julia
using OpenEng.Simulation
sys = tf([1.0], [1.0, 1.0])
t, y = step_response(sys, 5.0)
plot_response(t, y, response_type="Step")
```

## Saving Plots

```julia
p = plot_signal(t, y)
save_plot(p, "output.png", size=(800, 600), dpi=300)
```

## Main Functions

- `plot_signal` - Plot time-domain signal
- `plot_signals` - Plot multiple signals
- `plot_spectrum` - Plot frequency spectrum
- `plot_surface` - 3D surface plot
- `plot_heatmap` - 2D heatmap
- `plot_spectrogram` - Time-frequency plot
- `plot_response` - System response plot
- `save_plot` - Save plot to file
- `set_default_backend` - Set plotting backend

## Backends

```julia
set_default_backend(:gr)      # Default
set_default_backend(:pyplot)  # Matplotlib
set_default_backend(:plotly)  # Interactive
```
