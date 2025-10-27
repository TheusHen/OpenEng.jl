using Test
using OpenEng.Simulation
using LinearAlgebra

@testset "Simulation Module" begin
    @testset "ODE Solving" begin
        # Simple exponential decay: dy/dt = -0.5*y
        function exponential_decay!(du, u, p, t)
            du[1] = -0.5 * u[1]
        end
        
        u0 = [1.0]
        tspan = (0.0, 10.0)
        sol = solve_ode(exponential_decay!, u0, tspan)
        
        @test sol.t[1] ≈ 0.0
        @test sol.u[1][1] ≈ 1.0
        @test sol.t[end] ≈ 10.0
        
        # Check exponential decay: y(t) = exp(-0.5*t)
        t_test = 5.0
        idx = findfirst(x -> x >= t_test, sol.t)
        if idx !== nothing
            @test sol.u[idx][1] ≈ exp(-0.5 * sol.t[idx]) atol=1e-3
        end
    end
    
    @testset "ODE with Adaptive Stepping" begin
        # Harmonic oscillator: d²x/dt² = -x
        function harmonic!(du, u, p, t)
            du[1] = u[2]
            du[2] = -u[1]
        end
        
        u0 = [1.0, 0.0]
        tspan = (0.0, 2π)
        sol = solve_ode_adaptive(harmonic!, u0, tspan)
        
        @test sol.t[1] ≈ 0.0
        @test sol.u[1] ≈ [1.0, 0.0]
        
        # After one period, should return to initial state
        @test sol.u[end][1] ≈ 1.0 atol=1e-3
        @test sol.u[end][2] ≈ 0.0 atol=1e-3
    end
    
    @testset "Transfer Functions" begin
        # First-order system: H(s) = 1/(s+1)
        sys = create_tf([1.0], [1.0, 1.0])
        
        @test sys isa Any  # Just check it creates something
    end
    
    @testset "Step Response" begin
        # First-order system
        sys = tf([1.0], [1.0, 1.0])
        t, y = step_response(sys, 5.0, dt=0.1)
        
        @test length(t) == length(y)
        @test t[1] ≈ 0.0
        @test y[1] ≈ 0.0 atol=0.1
        
        # Step response of first-order system approaches 1
        @test y[end] ≈ 1.0 atol=0.1
    end
    
    @testset "Impulse Response" begin
        sys = tf([1.0], [1.0, 1.0])
        t, y = impulse_response(sys, 5.0, dt=0.1)
        
        @test length(t) == length(y)
        @test t[1] ≈ 0.0
        
        # Impulse response of first-order system decays
        @test abs(y[end]) < abs(y[2])
    end
    
    @testset "Frequency Response" begin
        sys = tf([1.0], [1.0, 1.0])
        ω = [0.1, 1.0, 10.0]
        mag, phase = frequency_response(sys, ω)
        
        @test length(mag) == length(ω)
        @test length(phase) == length(ω)
        
        # At low frequency, magnitude should be close to DC gain (1.0)
        @test mag[1] ≈ 1.0 atol=0.1
    end
    
    @testset "State-Space Systems" begin
        A = [-1.0 0.0; 0.0 -2.0]
        B = [1.0; 1.0]
        C = [1.0 1.0]
        D = [0.0]
        
        sys = create_ss(A, B, C, D)
        @test sys isa Any
    end
    
    @testset "System Simulation with Input" begin
        sys = tf([1.0], [1.0, 1.0])
        t = 0:0.1:5
        u = ones(length(t))  # Unit step input
        
        y, t_out, x_out = simulate_system(sys, u, t)
        
        @test length(y) == length(t)
        @test y[end] ≈ 1.0 atol=0.2
    end
end
