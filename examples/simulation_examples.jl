# Simulation Examples

using OpenEng
using OpenEng.Simulation
using OpenEng.Viz

println("=" ^ 60)
println("OpenEng.jl - Simulation Examples")
println("=" ^ 60)

# Example 1: Simple ODE - Exponential Decay
println("\n1. Exponential Decay: dy/dt = -0.5y")
println("-" ^ 40)

function exponential_decay!(du, u, p, t)
    du[1] = -0.5 * u[1]
end

u0 = [1.0]
tspan = (0.0, 10.0)
sol = solve_ode(exponential_decay!, u0, tspan)

println("Initial value: ", u0[1])
println("Final value: ", sol.u[end][1])
println("Expected (e^(-0.5*10)): ", exp(-0.5 * 10))
println("Number of time steps: ", length(sol.t))

# Example 2: Harmonic Oscillator
println("\n2. Harmonic Oscillator: d²x/dt² = -x")
println("-" ^ 40)

function harmonic!(du, u, p, t)
    du[1] = u[2]      # dx/dt = v
    du[2] = -u[1]     # dv/dt = -x
end

u0 = [1.0, 0.0]  # x(0) = 1, v(0) = 0
tspan = (0.0, 4π)
sol = solve_ode(harmonic!, u0, tspan)

println("Initial position: ", u0[1])
println("Final position: ", sol.u[end][1])
println("Period: 2π ≈ ", 2π)
println("After 2 periods, x should return to ", u0[1])

# Example 3: Damped Oscillator
println("\n3. Damped Oscillator: d²x/dt² + 0.5dx/dt + x = 0")
println("-" ^ 40)

function damped_oscillator!(du, u, p, t)
    ζ = 0.2  # Damping ratio
    ω₀ = 1.0  # Natural frequency
    du[1] = u[2]
    du[2] = -2ζ*ω₀*u[2] - ω₀^2*u[1]
end

u0 = [1.0, 0.0]
tspan = (0.0, 20.0)
sol = solve_ode(damped_oscillator!, u0, tspan)

println("Initial amplitude: ", u0[1])
println("Final amplitude: ", abs(sol.u[end][1]))
println("Energy dissipated through damping")

# Example 4: Transfer Function and Step Response
println("\n4. First-Order System Step Response")
println("-" ^ 40)

# H(s) = 1/(s+1)
sys = tf([1.0], [1.0, 1.0])
t, y = step_response(sys, 10.0, dt=0.05)

println("System: H(s) = 1/(s+1)")
println("Time constant: 1.0 seconds")
println("Final value: ", y[end])
println("Expected steady-state: 1.0")
println("63.2% rise time: ≈1.0 second")

# Example 5: Second-Order System
println("\n5. Second-Order System Step Response")
println("-" ^ 40)

# H(s) = 1/(s²+2s+1)
sys = tf([1.0], [1.0, 2.0, 1.0])
t, y = step_response(sys, 10.0, dt=0.05)

println("System: H(s) = 1/(s²+2s+1)")
println("Damping ratio ζ = 1 (critically damped)")
println("Final value: ", y[end])
println("No overshoot (critically damped)")

# Example 6: Impulse Response
println("\n6. Impulse Response")
println("-" ^ 40)

sys = tf([1.0], [1.0, 1.0])
t, y = impulse_response(sys, 5.0, dt=0.05)

println("System: H(s) = 1/(s+1)")
println("Initial response: ", y[2])
println("Final response: ", y[end])
println("Impulse response decays exponentially")

# Example 7: Frequency Response
println("\n7. Frequency Response (Bode Analysis)")
println("-" ^ 40)

sys = tf([1.0], [1.0, 2.0, 1.0])
ω = 10 .^ range(-2, 2, length=50)
mag, phase = frequency_response(sys, ω)

println("System: H(s) = 1/(s²+2s+1)")
println("Low frequency gain: ", mag[1], " (≈1.0)")
println("High frequency roll-off: -40 dB/decade")
println("Phase at low frequency: ", rad2deg(phase[1]), "°")

# Example 8: State-Space Representation
println("\n8. State-Space System")
println("-" ^ 40)

A = [-1.0 0.0; 0.0 -2.0]
B = [1.0; 1.0]
C = [1.0 1.0]
D = [0.0]

sys_ss = create_ss(A, B, C, D)
t = 0:0.1:5
u = ones(length(t))
y = simulate_system(sys_ss, u, t)

println("State matrix eigenvalues: ", eigvals(A))
println("System is stable (all eigenvalues have negative real parts)")
println("Steady-state output: ", y[end])

# Example 9: Pendulum Simulation
println("\n9. Nonlinear Pendulum")
println("-" ^ 40)

function pendulum!(du, u, p, t)
    g, L = p
    du[1] = u[2]
    du[2] = -(g/L) * sin(u[1])
end

θ0 = π/4  # 45 degrees
u0 = [θ0, 0.0]
tspan = (0.0, 10.0)
p = (9.81, 1.0)  # g=9.81 m/s², L=1.0 m

sol = solve_ode_adaptive(pendulum!, u0, tspan, p=p)

println("Initial angle: ", rad2deg(θ0), "°")
println("Length: 1.0 m")
println("Period (small angle approx): ", 2π * sqrt(1.0/9.81), " s")
println("Number of adaptive steps: ", length(sol.t))

println("\n" * "=" ^ 60)
println("Examples completed successfully!")
println("=" ^ 60)
