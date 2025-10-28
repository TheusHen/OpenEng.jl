# Simulation

The `OpenEng.Simulation` module provides tools for simulating ordinary differential equations (ODEs), partial differential equations (PDEs), and control systems.

## Overview

This module integrates DifferentialEquations.jl and ControlSystems.jl to provide comprehensive simulation capabilities.

## ODE Solvers

```julia
using OpenEng.Simulation

# Define ODE: dy/dt = -0.5*y
function exponential_decay!(du, u, p, t)
    du[1] = -0.5 * u[1]
end

u0 = [1.0]
tspan = (0.0, 10.0)
sol = solve_ode(exponential_decay!, u0, tspan)
```

## Control Systems

### Transfer Functions

```julia
# First-order system: H(s) = 1/(s+1)
sys = tf([1.0], [1.0, 1.0])

# Step response
t, y = step_response(sys, 5.0)

# Impulse response
t, y = impulse_response(sys, 5.0)

# Frequency response
ω = 10 .^ range(-2, 2, length=100)
mag, phase = frequency_response(sys, ω)
```

### State-Space Systems

```julia
A = [-1.0 0.0; 0.0 -2.0]
B = [1.0; 1.0]
C = [1.0 1.0]
D = [0.0]

sys = create_ss(A, B, C, D)
```

## Main Functions

- `solve_ode` - Solve ODE with default solver
- `solve_ode_adaptive` - Adaptive ODE solver
- `step_response` - System step response
- `impulse_response` - System impulse response
- `frequency_response` - Bode analysis
- `simulate_system` - System simulation with input

## Examples

See `examples/simulation_examples.jl` for comprehensive examples.
