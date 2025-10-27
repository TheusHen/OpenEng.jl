# Getting Started with OpenEng.jl

This guide will help you get started with OpenEng.jl.

## Installation

### Requirements

- Julia 1.10 or later
- Recommended: 4GB RAM for typical usage
- Optional: NVIDIA GPU for GPU acceleration

### Installing Julia

Download Julia from [julialang.org](https://julialang.org/downloads/).

On Ubuntu/Debian:
```bash
wget https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10-latest-linux-x86_64.tar.gz
tar -xvzf julia-1.10-latest-linux-x86_64.tar.gz
sudo mv julia-1.10 /opt/
sudo ln -s /opt/julia-1.10/bin/julia /usr/local/bin/julia
```

### Installing OpenEng.jl

```julia
using Pkg
Pkg.add(url="https://github.com/TheusHen/OpenEng.jl")
```

### Development Installation

```bash
git clone https://github.com/TheusHen/OpenEng.jl.git
cd OpenEng.jl
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

## First Steps

### Loading the Package

```julia
using OpenEng
```

### Package Information

```julia
OpenEng.info()
```

This displays available modules and GPU status.

### Your First Computation

```julia
using OpenEng.LA

# Create a matrix
A = [3.0 2.0; 1.0 4.0]

# Compute eigenvalues
λ, V = eig(A)

println("Eigenvalues: ", λ)
```

## Basic Workflows

### Linear Algebra

```julia
using OpenEng.LA

# Matrix operations
A = rand(5, 5)
B = rand(5, 5)
C = A * B

# Solve linear system
b = rand(5)
x = solve(A, b)

# Decompositions
U, S, Vt = svd(A)
```

### Signal Processing

```julia
using OpenEng.Signal

# Generate signal
fs = 1000.0
t = 0:1/fs:1-1/fs
x = sin.(2π * 10 .* t)

# Compute FFT
X = fft(x)
freqs = fftfreq(length(x), 1/fs)

# Filter design
b, a = butter(4, 0.2)
y = filter_signal(b, a, x)
```

### System Simulation

```julia
using OpenEng.Simulation

# Define ODE
function exponential!(du, u, p, t)
    du[1] = -0.5 * u[1]
end

# Solve
u0 = [1.0]
tspan = (0.0, 10.0)
sol = solve_ode(exponential!, u0, tspan)
```

### Optimization

```julia
using OpenEng.Optimization

# Linear programming
model = create_lp_model()
@variable(model, x >= 0)
@variable(model, y >= 0)
@constraint(model, x + y <= 10)
@objective(model, Max, 3x + 5y)
optimize!(model)

println("x = ", value(x))
println("y = ", value(y))
```

### Visualization

```julia
using OpenEng.Viz

t = 0:0.01:10
y = sin.(t)
plot_signal(t, y, title="Sine Wave")
```

## GPU Computing

OpenEng.jl automatically detects GPU availability:

```julia
using OpenEng.GPU

if gpu_available()
    A = rand(1000, 1000)
    B = rand(1000, 1000)
    C = gpu_matmul(A, B)
else
    println("GPU not available, using CPU")
end
```

## Next Steps

- Explore the [Examples](examples.md)
- Read module-specific documentation:
  - [Linear Algebra](linear_algebra.md)
  - [Simulation](simulation.md)
  - [Signal Processing](signal.md)
  - [Optimization](optimization.md)
- Check the [API Reference](api.md)

## Getting Help

- **Documentation**: You're reading it!
- **Examples**: See the `examples/` directory
- **Issues**: [GitHub Issues](https://github.com/TheusHen/OpenEng.jl/issues)
- **Discussions**: [GitHub Discussions](https://github.com/TheusHen/OpenEng.jl/discussions)

## Common Issues

### Package Not Found

If you get a "package not found" error, make sure you're using the correct URL:

```julia
Pkg.add(url="https://github.com/TheusHen/OpenEng.jl")
```

### CUDA Not Available

GPU acceleration is optional. OpenEng.jl works fine without CUDA:

```julia
# To add CUDA support (optional):
using Pkg
Pkg.add("CUDA")
```

### Test Failures

To run the test suite:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```
