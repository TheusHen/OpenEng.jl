# Examples

OpenEng.jl includes comprehensive examples demonstrating all major features.

## Running Examples

All examples are located in the `examples/` directory and can be run directly:

```bash
julia --project examples/linear_algebra_examples.jl
julia --project examples/signal_processing_examples.jl
julia --project examples/optimization_examples.jl
julia --project examples/simulation_examples.jl
```

## Linear Algebra Examples

The `linear_algebra_examples.jl` file demonstrates:

1. **Eigenvalue Decomposition** - Computing eigenvalues and eigenvectors
2. **SVD** - Singular value decomposition and matrix reconstruction
3. **Linear Systems** - Solving Ax = b
4. **Matrix Powers** - Computing A^n efficiently
5. **Sparse Matrices** - Working with large sparse systems
6. **Cholesky Decomposition** - For positive definite matrices
7. **Matrix Norms** - Frobenius and spectral norms

## Signal Processing Examples

The `signal_processing_examples.jl` file demonstrates:

1. **FFT Analysis** - Frequency detection in signals
2. **Multi-tone Signals** - Analyzing composite signals
3. **Filtering** - Lowpass, highpass, bandpass filters
4. **Filter Design** - Butterworth, Chebyshev, Elliptic filters
5. **Power Spectral Density** - Using Welch's method
6. **Spectrograms** - Time-frequency analysis
7. **Convolution and Correlation** - Signal operations

## Optimization Examples

The `optimization_examples.jl` file demonstrates:

1. **Linear Programming** - Production planning problems
2. **Diet Optimization** - Meeting nutritional requirements
3. **Transportation** - Minimizing shipping costs
4. **Nonlinear Optimization** - Rosenbrock function
5. **Constrained NLP** - Circle constraint problems
6. **Portfolio Optimization** - Asset allocation
7. **Curve Fitting** - Parameter estimation
8. **Integer Programming** - Resource allocation

## Simulation Examples

The `simulation_examples.jl` file demonstrates:

1. **ODE Integration** - Exponential decay
2. **Harmonic Oscillators** - Undamped and damped systems
3. **Control Systems** - Transfer functions
4. **Step Response** - First and second-order systems
5. **Impulse Response** - System characterization
6. **Frequency Response** - Bode analysis
7. **State-Space Systems** - Multi-variable systems

## Quick Start Example

Here's a complete example combining multiple modules:

```julia
using OpenEng

# 1. Generate a noisy signal
fs = 1000.0  # Sampling rate
t = 0:1/fs:1-1/fs
signal = sin.(2π * 50 .* t)  # 50 Hz sine
noisy = signal + 0.5 * randn(length(signal))

# 2. Design and apply filter
b, a = OpenEng.Signal.butter(4, 0.15)
filtered = OpenEng.Signal.filter_signal(b, a, noisy)

# 3. Analyze spectrum
X = OpenEng.Signal.fft(filtered)
freqs = OpenEng.Signal.fftfreq(length(filtered), 1/fs)

# 4. Visualize results
OpenEng.Viz.plot_signal(t, noisy, title="Noisy Signal")
OpenEng.Viz.plot_signal(t, filtered, title="Filtered Signal")
OpenEng.Viz.plot_spectrum(freqs[1:end÷2], abs.(X[1:end÷2]))

# 5. Save results
data = Dict("time" => t, "signal" => filtered)
OpenEng.Utils.write_mat("output.mat", data)
```

## Best Practices

1. **Import specific modules** when you only need certain functionality
2. **Use type-stable code** for best performance
3. **Profile your code** using the Timer utilities
4. **Save intermediate results** using the I/O functions
5. **Visualize frequently** to verify correctness

## Additional Resources

- See the individual module documentation for detailed API references
- Check the test files in `test/` for additional usage examples
- Refer to the source code in `src/` for implementation details
