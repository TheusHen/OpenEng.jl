# 🧠 OpenEng.jl

**OpenEng.jl** is an open-source scientific and engineering toolbox built in Julia, designed to provide a modern, free, high-performance alternative to MATLAB and its proprietary toolboxes.

[![Build Status](https://github.com/TheusHen/OpenEng.jl/workflows/CI/badge.svg)](https://github.com/TheusHen/OpenEng.jl/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 🌍 Mission

> Democratize access to high-performance scientific engineering tools — replacing MATLAB with a modern open-source ecosystem in Julia.

OpenEng.jl combines:

* **Compiled-code performance (C/C++ level)**
* **Intuitive, expressive syntax (like MATLAB and Python)**
* **Julia's open-source ecosystem**
* **Integration with GPU, AI, optimization, and physical simulation**

---

## ⚙️ Modules

OpenEng.jl is designed as a **modular framework**, where each component represents a pillar of modern engineering. Each module can be used independently or together, similar to MATLAB toolboxes.

### 📘 OpenEng.LinearAlgebra

Mathematical foundation of the package.

**Features:**
- Advanced matrix operations (`dot`, `cross`, `inv`, `det`, etc.)
- Eigenvalues and eigenvectors (`eigvals`, `eigvecs`)
- Decompositions (`LU`, `QR`, `SVD`, `Cholesky`)
- Sparse and structured matrices
- Compatible with Julia's `LinearAlgebra.jl` and `SparseArrays.jl`

### 🔬 OpenEng.Simulation

Modeling dynamic systems and numerical simulation.

**Features:**
- **ODE (Ordinary Differential Equations)** solvers with `DifferentialEquations.jl`
- **PDE (Partial Differential Equations)** simulation interfaces
- Classical and modern control:
  - Transfer functions, block diagrams
  - Stability analysis (Bode, Nyquist, Root Locus)
- Discrete-time and continuous-time system simulation

### 🔊 OpenEng.Signal

Signal and image processing.

**Features:**
- FFT, DFT, and fast transforms (`FFTW.jl`)
- Digital filters (Butterworth, Chebyshev, FIR, IIR)
- Wavelet transforms
- Audio, ECG, sensor, and image processing
- MATLAB-style functions (`fft`, `ifft`, `spectrogram`, `filter`)

### 🧩 OpenEng.Optimization

Optimization problem solving.

**Based on:** `JuMP.jl`, `Ipopt.jl`, `GLPK.jl`

**Features:**
- Linear, integer, and nonlinear programming
- Convex and constrained optimization
- Parameter tuning and model calibration
- Multi-objective optimization support

### 🖥️ OpenEng.Viz (Visualization)

Graphical visualization and analysis.

**Based on:** `Plots.jl`, `Makie.jl`

**Features:**
- Interactive 2D and 3D graphics
- Surfaces, vectors, parametric curves
- Real-time simulation and signal visualization
- Export to PNG, SVG, and videos

### ⚡ OpenEng.GPU

Parallel GPU computing (NVIDIA and AMD).

**Features:**
- Massively parallel matrix operations
- Accelerated simulations and optimizations
- Automatic CPU fallback when GPU unavailable
- CUDA.jl support for NVIDIA GPUs (optional)

### 🧮 OpenEng.Utils

Auxiliary tools and integration.

**Features:**
- Unit conversion and physical constants
- Read/write CSV, MAT, HDF5 files
- Python, C, MATLAB interfaces
- Performance logging and monitoring

---

## 💻 Installation

### Prerequisites

- Julia 1.10 or higher ([Download Julia](https://julialang.org/downloads/))

### Install from GitHub

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

---

## 🚀 Quick Start

```julia
using OpenEng

# Linear algebra
A = [3.0 2.0; 1.0 4.0]
λ, V = OpenEng.LA.eig(A)

# System simulation
using OpenEng.Simulation
sys = tf([1.0], [1.0, 3.0, 2.0])
t, y = step_response(sys, 10.0)

# Signal processing
using OpenEng.Signal
x = sin.(2π * 5 .* (0:0.001:1))  # 5 Hz sine wave
X = fft(x)

# Optimization
using OpenEng.Optimization
model = create_lp_model()
result = solve_optimization(model)

# Visualization
using OpenEng.Viz
plot_signal(t, y, title="Step Response")
```

---

## 📚 Examples

Explore complete examples in the [`examples/`](examples/) directory:

- **Linear Algebra:** Matrix decompositions and eigenvalue problems
- **Control Systems:** PID controllers, state-space models
- **Signal Processing:** FFT analysis, filter design
- **Optimization:** Linear programming, nonlinear optimization
- **GPU Computing:** Accelerated matrix operations

---

## 🧪 Running Tests

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

---

## 📖 Documentation

Full documentation is available at [OpenEng.jl Documentation](https://theushen.github.io/OpenEng.jl/) (coming soon).

For now, explore:
- [`docs/`](docs/) - Documentation source files
- [`examples/`](examples/) - Usage examples
- [`notebooks/`](notebooks/) - Interactive Jupyter/Pluto notebooks

---

## 🔁 Comparison with MATLAB

| Area | MATLAB | OpenEng.jl |
|------|--------|------------|
| Language | Proprietary, interpreted | Open-source, JIT-compiled (LLVM) |
| Performance | Good, but license-limited | Extremely fast (native LLVM, real parallelism) |
| Cost | Paid and restricted | 100% free |
| Toolboxes | Paid separately | Modular and free |
| GPU | Special licenses | Native with CUDA.jl (optional) |
| Integration | Excellent, but closed | Open: Python, C, R, Fortran |
| Community | Established academic | Growing, global open-source |

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📈 Use Cases

- Physical simulations (mechanical, civil, electrical engineering)
- Control and automation (PID, LQR, dynamic systems)
- Biomedical signal analysis (EEG, ECG)
- Structural and trajectory optimization
- Industrial image processing
- Engineering and numerical methods education

---

## 🔮 Roadmap

- [ ] Interactive GUI (Electron + WebGL) for visual modeling
- [ ] 3D simulations of fluids, structures, and circuits
- [ ] Collaborative notebook portal (OpenEng Hub)
- [ ] AI integration for automatic physical model generation
- [ ] Web extension (OpenEng Cloud) for browser-based execution

---

## ⚖️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

OpenEng.jl builds upon the incredible Julia ecosystem, including:
- `DifferentialEquations.jl`
- `ControlSystems.jl`
- `JuMP.jl`
- `FFTW.jl`
- `Plots.jl`
- And many more!

---

## 📧 Contact

For questions, suggestions, or collaborations:
- **GitHub Issues:** [github.com/TheusHen/OpenEng.jl/issues](https://github.com/TheusHen/OpenEng.jl/issues)
- **Discussions:** [github.com/TheusHen/OpenEng.jl/discussions](https://github.com/TheusHen/OpenEng.jl/discussions)

---

**Made with ❤️ by the OpenEng.jl community**