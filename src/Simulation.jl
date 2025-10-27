"""
# OpenEng.Simulation

Dynamic system modeling and numerical simulation.

This module provides tools for simulating ordinary differential equations (ODEs),
partial differential equations (PDEs), and control systems.

## Main Functions

- `solve_ode`: Solve ordinary differential equations
- `tf`: Create transfer function
- `step_response`: Compute step response of a system
- `impulse_response`: Compute impulse response
- `frequency_response`: Compute frequency response

## Examples

```julia
using OpenEng.Simulation

# Solve an ODE
function pendulum!(du, u, p, t)
    du[1] = u[2]
    du[2] = -sin(u[1])
end
u0 = [π/4, 0.0]
tspan = (0.0, 10.0)
sol = solve_ode(pendulum!, u0, tspan)

# Transfer function
sys = tf([1.0], [1.0, 2.0, 1.0])
t, y = step_response(sys, 5.0)
```
"""
module Simulation

using DifferentialEquations
using ControlSystems
using LinearAlgebra

# Re-export control systems functions
export tf, ss, zpk
export step, impulse, bode, nyquist
export lsim, stepinfo

# Custom exports
export solve_ode, solve_ode_adaptive
export step_response, impulse_response, frequency_response
export create_ss, create_tf
export simulate_system

"""
    solve_ode(f!, u0, tspan; kwargs...) -> sol

Solve an ordinary differential equation.

# Arguments
- `f!`: In-place function defining the ODE: `f!(du, u, p, t)`
- `u0`: Initial condition
- `tspan`: Time span tuple `(t0, tf)`
- `kwargs...`: Additional arguments passed to the ODE solver

# Returns
- `sol`: Solution object with fields `t` (time) and `u` (state)

# Examples
```julia
function exponential_decay!(du, u, p, t)
    du[1] = -0.5 * u[1]
end
u0 = [1.0]
tspan = (0.0, 10.0)
sol = solve_ode(exponential_decay!, u0, tspan)
```
"""
function solve_ode(f!, u0, tspan; p=nothing, alg=Tsit5(), kwargs...)
    prob = ODEProblem(f!, u0, tspan, p)
    return solve(prob, alg; kwargs...)
end

"""
    solve_ode_adaptive(f!, u0, tspan; kwargs...) -> sol

Solve an ODE with adaptive time stepping and error control.

Uses high-order Runge-Kutta methods with automatic step size adjustment.

# Arguments
- `f!`: In-place function defining the ODE
- `u0`: Initial condition
- `tspan`: Time span tuple
- `kwargs...`: Solver options (reltol, abstol, etc.)

# Returns
- Solution object

# Examples
```julia
function stiff_system!(du, u, p, t)
    du[1] = -1000 * u[1] + u[2]
    du[2] = u[1] - u[2]
end
u0 = [1.0, 0.0]
tspan = (0.0, 1.0)
sol = solve_ode_adaptive(stiff_system!, u0, tspan, reltol=1e-6)
```
"""
function solve_ode_adaptive(f!, u0, tspan; p=nothing, reltol=1e-6, abstol=1e-8, kwargs...)
    prob = ODEProblem(f!, u0, tspan, p)
    return solve(prob, AutoTsit5(Rosenbrock23()); reltol=reltol, abstol=abstol, kwargs...)
end

"""
    step_response(sys, tfinal; dt=0.01) -> (t, y)

Compute the step response of a linear system.

# Arguments
- `sys`: Transfer function or state-space system
- `tfinal`: Final time for simulation
- `dt`: Time step (optional)

# Returns
- `t`: Time vector
- `y`: Response vector

# Examples
```julia
sys = tf([1.0], [1.0, 2.0, 1.0])
t, y = step_response(sys, 5.0)
```
"""
function step_response(sys, tfinal; dt=0.01)
    t = 0:dt:tfinal
    y, t_out, _ = step(sys, t)
    return collect(t_out), vec(y)
end

"""
    impulse_response(sys, tfinal; dt=0.01) -> (t, y)

Compute the impulse response of a linear system.

# Arguments
- `sys`: Transfer function or state-space system
- `tfinal`: Final time for simulation
- `dt`: Time step (optional)

# Returns
- `t`: Time vector
- `y`: Response vector

# Examples
```julia
sys = tf([1.0], [1.0, 2.0, 1.0])
t, y = impulse_response(sys, 5.0)
```
"""
function impulse_response(sys, tfinal; dt=0.01)
    t = 0:dt:tfinal
    y, t_out, _ = impulse(sys, t)
    return collect(t_out), vec(y)
end

"""
    frequency_response(sys, ω) -> (mag, phase)

Compute the frequency response of a linear system.

# Arguments
- `sys`: Transfer function or state-space system
- `ω`: Vector of frequencies (rad/s)

# Returns
- `mag`: Magnitude response
- `phase`: Phase response (radians)

# Examples
```julia
sys = tf([1.0], [1.0, 2.0, 1.0])
ω = 10 .^ range(-2, 2, length=100)
mag, phase = frequency_response(sys, ω)
```
"""
function frequency_response(sys, ω)
    mag, phase, _ = bode(sys, ω)
    return vec(mag), vec(phase)
end

"""
    create_tf(num, den) -> sys

Create a transfer function from numerator and denominator coefficients.

# Arguments
- `num`: Numerator polynomial coefficients (highest degree first)
- `den`: Denominator polynomial coefficients (highest degree first)

# Returns
- Transfer function system

# Examples
```julia
sys = create_tf([1.0], [1.0, 2.0, 1.0])  # 1/(s^2 + 2s + 1)
```
"""
function create_tf(num, den)
    return tf(num, den)
end

"""
    create_ss(A, B, C, D) -> sys

Create a state-space system from matrices A, B, C, D.

# Arguments
- `A`: State matrix
- `B`: Input matrix
- `C`: Output matrix
- `D`: Feedthrough matrix

# Returns
- State-space system

# Examples
```julia
A = [-1.0 0.0; 0.0 -2.0]
B = [1.0; 1.0]
C = [1.0 1.0]
D = [0.0]
sys = create_ss(A, B, C, D)
```
"""
function create_ss(A, B, C, D)
    return ss(A, B, C, D)
end

"""
    simulate_system(sys, u, t) -> (y, t, x)

Simulate a linear system with input signal u.

# Arguments
- `sys`: Transfer function or state-space system
- `u`: Input signal (function or vector)
- `t`: Time vector

# Returns
- `y`: Output signal
- `t`: Time vector
- `x`: State trajectory

# Examples
```julia
sys = tf([1.0], [1.0, 1.0])
t = 0:0.01:5
u = sin.(t)
y, t_out, x = simulate_system(sys, u, t)
```
"""
function simulate_system(sys, u, t)
    if u isa Function
        u_vec = u.(t)
    else
        u_vec = u
    end
    
    # Convert vector to matrix format (ninputs x nsamples) for lsim
    if u_vec isa Vector
        u_mat = reshape(u_vec, 1, :)
    else
        u_mat = u_vec
    end
    
    y, t_out, x = lsim(sys, u_mat, t)
    # Return y as a vector (lsim returns matrix, extract first row for SISO)
    y_vec = size(y, 1) == 1 ? vec(y) : y
    return y_vec, t_out, x
end

end # module Simulation
