# OpenEng.jl Documentation

```@meta
CurrentModule = OpenEng
```

# OpenEng.jl

**OpenEng.jl** is an open-source scientific and engineering toolbox built in Julia, designed to provide a modern, free, high-performance alternative to MATLAB and its proprietary toolboxes.

## Features

- **High Performance**: Julia's JIT compilation provides C/C++ level performance
- **Modern Design**: Clean, modular API with intuitive function names
- **GPU Acceleration**: Optional CUDA support with automatic CPU fallback
- **Comprehensive**: Covers linear algebra, simulation, signal processing, optimization, and more
- **Open Source**: MIT licensed, free for all uses

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/TheusHen/OpenEng.jl")
```

## Quick Example

```julia
using OpenEng

# Linear algebra
A = [3.0 2.0; 1.0 4.0]
λ, V = OpenEng.LA.eig(A)

# Signal processing
x = sin.(2π * 5 .* (0:0.001:1))
X = OpenEng.Signal.fft(x)

# System simulation
using OpenEng.Simulation
sys = tf([1.0], [1.0, 2.0, 1.0])
t, y = step_response(sys, 5.0)
```

## Modules

OpenEng.jl is organized into specialized modules:

- **[LA (LinearAlgebra)](@ref)**: Advanced linear algebra operations
- **[Simulation](@ref)**: ODE/PDE solvers and control systems
- **[Signal](@ref)**: Signal and image processing
- **[Optimization](@ref)**: Linear and nonlinear optimization
- **[Viz](@ref)**: Visualization and plotting
- **[GPU](@ref)**: GPU-accelerated computing
- **[Utils](@ref)**: Utilities and I/O operations

## Getting Help

- [GitHub Issues](https://github.com/TheusHen/OpenEng.jl/issues)
- [GitHub Discussions](https://github.com/TheusHen/OpenEng.jl/discussions)

## Contributing

Contributions are welcome! Please see the [Contributing Guide](https://github.com/TheusHen/OpenEng.jl/blob/main/CONTRIBUTING.md).

## License

OpenEng.jl is released under the MIT License. See [LICENSE](https://github.com/TheusHen/OpenEng.jl/blob/main/LICENSE) for details.
