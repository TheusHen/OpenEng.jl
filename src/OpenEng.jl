"""
# OpenEng.jl

Open-source scientific and engineering toolbox for Julia.

OpenEng.jl provides a modular framework for scientific computing, numerical simulation,
signal processing, optimization, and visualization - a modern, high-performance alternative
to MATLAB and its toolboxes.

## Modules

- `OpenEng.LA` (LinearAlgebra): Advanced linear algebra operations
- `OpenEng.Simulation`: Dynamic system modeling and ODE/PDE solvers
- `OpenEng.Signal`: Signal and image processing
- `OpenEng.Optimization`: Optimization problem solving
- `OpenEng.Viz`: Visualization and plotting
- `OpenEng.GPU`: GPU-accelerated computing with CPU fallback
- `OpenEng.Utils`: Utilities, I/O, and unit conversions

## Quick Start

```julia
using OpenEng

# Linear algebra
A = [3.0 2.0; 1.0 4.0]
λ, V = OpenEng.LA.eig(A)

# Signal processing
x = sin.(2π * 5 .* (0:0.001:1))
X = OpenEng.Signal.fft(x)
```

See the documentation and examples for more details.
"""
module OpenEng

# Version information
const VERSION = v"0.1.0"

# Core dependencies
using Reexport

# Include submodules
include("LinearAlgebra_module.jl")
include("Simulation.jl")
include("Signal.jl")
include("Optimization.jl")
include("Viz.jl")
include("GPU.jl")
include("Utils.jl")

# Re-export commonly used functions
@reexport using .LA
@reexport using .Simulation
@reexport using .Signal
@reexport using .Optimization
@reexport using .Viz
@reexport using .GPU
@reexport using .Utils

# Package information
"""
    version()

Return the version of OpenEng.jl.
"""
version() = VERSION

"""
    info()

Display information about OpenEng.jl modules and capabilities.
"""
function info()
    println("OpenEng.jl v$VERSION")
    println("=" ^ 50)
    println("Available Modules:")
    println("  - LA (LinearAlgebra): Matrix operations and decompositions")
    println("  - Simulation: ODE/PDE solvers and control systems")
    println("  - Signal: Signal processing and FFT")
    println("  - Optimization: Linear and nonlinear optimization")
    println("  - Viz: Plotting and visualization")
    println("  - GPU: GPU acceleration (with CPU fallback)")
    println("  - Utils: Utilities, I/O, and conversions")
    println("=" ^ 50)
    println("GPU Support:")
    println("  CUDA available: ", GPU.has_cuda())
    println("  GPU enabled: ", GPU.gpu_enabled())
    println("=" ^ 50)
end

# Export main functions
export version, info

end # module OpenEng
