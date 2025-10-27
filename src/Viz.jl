"""
# OpenEng.Viz

Visualization and plotting tools.

This module provides convenient wrappers for creating scientific plots using
Plots.jl with sensible defaults for engineering applications.

## Main Functions

- `plot_signal`: Plot time-domain signal
- `plot_spectrum`: Plot frequency spectrum
- `plot_surface`: Plot 3D surface
- `plot_heatmap`: Plot 2D heatmap
- `save_plot`: Save plot to file

## Examples

```julia
using OpenEng.Viz

# Plot a signal
t = 0:0.01:10
y = sin.(t)
plot_signal(t, y, title="Sine Wave")

# Plot spectrum
X = fft(y)
freqs = fftfreq(length(y), 100)
plot_spectrum(freqs, abs.(X))
```
"""
module Viz

using Plots
using LinearAlgebra

# Re-export Plots functions
export plot, plot!, scatter, scatter!
export xlabel!, ylabel!, title!, xlims!, ylims!
export savefig, display
export @layout, subplot
export gr, pyplot, plotly

# Custom exports
export plot_signal, plot_signals
export plot_spectrum, plot_spectrogram
export plot_surface, plot_heatmap
export plot_response
export save_plot
export set_default_backend

"""
    set_default_backend(backend=:gr)

Set the default plotting backend.

# Arguments
- `backend`: Backend to use (`:gr`, `:pyplot`, `:plotly`)

# Examples
```julia
set_default_backend(:gr)
```
"""
function set_default_backend(backend::Symbol=:gr)
    if backend == :gr
        gr()
    elseif backend == :pyplot
        pyplot()
    elseif backend == :plotly
        plotly()
    else
        @warn "Unknown backend: $backend, using :gr"
        gr()
    end
end

# Set default backend on module load
function __init__()
    set_default_backend(:gr)
end

"""
    plot_signal(t, y; kwargs...) -> plot

Plot a time-domain signal.

# Arguments
- `t`: Time vector
- `y`: Signal values
- `kwargs...`: Additional plotting options (title, xlabel, ylabel, etc.)

# Returns
- Plots.jl plot object

# Examples
```julia
t = 0:0.01:10
y = sin.(2π * t)
plot_signal(t, y, title="Sine Wave", xlabel="Time (s)", ylabel="Amplitude")
```
"""
function plot_signal(t, y; title="Signal", xlabel="Time", ylabel="Amplitude", 
                     linewidth=2, kwargs...)
    return plot(t, y; 
                title=title, 
                xlabel=xlabel, 
                ylabel=ylabel,
                linewidth=linewidth,
                legend=false,
                kwargs...)
end

"""
    plot_signals(t, Y; labels=nothing, kwargs...) -> plot

Plot multiple signals on the same axes.

# Arguments
- `t`: Time vector
- `Y`: Matrix where each column is a signal, or vector of signal vectors
- `labels`: Signal labels
- `kwargs...`: Additional plotting options

# Returns
- Plots.jl plot object

# Examples
```julia
t = 0:0.01:10
y1 = sin.(t)
y2 = cos.(t)
plot_signals(t, [y1 y2], labels=["sin" "cos"])
```
"""
function plot_signals(t, Y; labels=nothing, title="Signals", 
                      xlabel="Time", ylabel="Amplitude", linewidth=2, kwargs...)
    if Y isa AbstractMatrix
        p = plot(t, Y; 
                 title=title,
                 xlabel=xlabel,
                 ylabel=ylabel,
                 linewidth=linewidth,
                 label=labels,
                 kwargs...)
    else
        # Y is a vector of vectors
        p = plot(title=title, xlabel=xlabel, ylabel=ylabel)
        for (i, y) in enumerate(Y)
            lbl = labels === nothing ? "Signal $i" : labels[i]
            plot!(p, t, y, linewidth=linewidth, label=lbl, kwargs...)
        end
    end
    return p
end

"""
    plot_spectrum(freqs, magnitude; kwargs...) -> plot

Plot frequency spectrum (magnitude).

# Arguments
- `freqs`: Frequency vector
- `magnitude`: Magnitude values
- `kwargs...`: Additional plotting options

# Returns
- Plots.jl plot object

# Examples
```julia
using FFTW
x = sin.(2π * 5 .* (0:0.001:1))
X = fft(x)
freqs = fftfreq(length(x), 1000)
plot_spectrum(freqs[1:length(freqs)÷2], abs.(X[1:length(X)÷2]))
```
"""
function plot_spectrum(freqs, magnitude; title="Frequency Spectrum",
                       xlabel="Frequency (Hz)", ylabel="Magnitude",
                       xscale=:identity, yscale=:identity, kwargs...)
    return plot(freqs, magnitude;
                title=title,
                xlabel=xlabel,
                ylabel=ylabel,
                xscale=xscale,
                yscale=yscale,
                linewidth=2,
                legend=false,
                kwargs...)
end

"""
    plot_surface(x, y, z; kwargs...) -> plot

Plot a 3D surface.

# Arguments
- `x`: X coordinates (vector or matrix)
- `y`: Y coordinates (vector or matrix)
- `z`: Z values (matrix)
- `kwargs...`: Additional plotting options

# Returns
- Plots.jl plot object

# Examples
```julia
x = -3:0.1:3
y = -3:0.1:3
z = [sin(sqrt(xi^2 + yi^2)) for xi in x, yi in y]
plot_surface(x, y, z, title="3D Surface")
```
"""
function plot_surface(x, y, z; title="Surface Plot", 
                      xlabel="X", ylabel="Y", zlabel="Z",
                      camera=(30, 45), kwargs...)
    return surface(x, y, z;
                   title=title,
                   xlabel=xlabel,
                   ylabel=ylabel,
                   zlabel=zlabel,
                   camera=camera,
                   kwargs...)
end

"""
    plot_heatmap(z; kwargs...) -> plot

Plot a 2D heatmap.

# Arguments
- `z`: Matrix of values
- `kwargs...`: Additional plotting options

# Returns
- Plots.jl plot object

# Examples
```julia
z = rand(20, 20)
plot_heatmap(z, title="Heatmap")
```
"""
function plot_heatmap(z; title="Heatmap", xlabel="X", ylabel="Y",
                      color=:viridis, kwargs...)
    return heatmap(z;
                   title=title,
                   xlabel=xlabel,
                   ylabel=ylabel,
                   color=color,
                   kwargs...)
end

"""
    plot_spectrogram(S, freqs, times; kwargs...) -> plot

Plot a spectrogram.

# Arguments
- `S`: Spectrogram matrix (frequency × time)
- `freqs`: Frequency vector
- `times`: Time vector
- `kwargs...`: Additional plotting options

# Returns
- Plots.jl plot object

# Examples
```julia
using OpenEng.Signal
x = randn(10000)
S, f, t = compute_spectrogram(x)
plot_spectrogram(S, f, t)
```
"""
function plot_spectrogram(S, freqs, times; title="Spectrogram",
                         xlabel="Time", ylabel="Frequency (Hz)",
                         color=:viridis, kwargs...)
    return heatmap(times, freqs, 10 * log10.(abs.(S) .+ eps());
                   title=title,
                   xlabel=xlabel,
                   ylabel=ylabel,
                   color=color,
                   colorbar_title="Power (dB)",
                   kwargs...)
end

"""
    plot_response(t, y; response_type="Step", kwargs...) -> plot

Plot system response (step, impulse, etc.).

# Arguments
- `t`: Time vector
- `y`: Response values
- `response_type`: Type of response ("Step", "Impulse", etc.)
- `kwargs...`: Additional plotting options

# Returns
- Plots.jl plot object

# Examples
```julia
using OpenEng.Simulation
sys = tf([1.0], [1.0, 2.0, 1.0])
t, y = step_response(sys, 5.0)
plot_response(t, y, response_type="Step")
```
"""
function plot_response(t, y; response_type="Step", kwargs...)
    return plot_signal(t, y;
                      title="$response_type Response",
                      xlabel="Time (s)",
                      ylabel="Output",
                      kwargs...)
end

"""
    save_plot(p, filename; kwargs...)

Save a plot to file.

# Arguments
- `p`: Plot object
- `filename`: Output filename
- `kwargs...`: Additional save options (size, dpi, etc.)

# Examples
```julia
p = plot_signal(t, y)
save_plot(p, "signal.png", size=(800, 600), dpi=300)
```
"""
function save_plot(p, filename::String; kwargs...)
    savefig(p, filename; kwargs...)
    @info "Plot saved to $filename"
end

end # module Viz
