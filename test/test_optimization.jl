using Test
using OpenEng.Optimization
using JuMP
import MathOptInterface as MOI

@testset "Optimization Module" begin
    @testset "Model Creation" begin
        model = create_model()
        @test model isa Model
        
        lp_model = create_lp_model()
        @test lp_model isa Model
        
        nlp_model = create_nlp_model()
        @test nlp_model isa Model
    end
    
    @testset "Linear Programming" begin
        # Simple LP: maximize 3x + 5y subject to x + y <= 10, x,y >= 0
        model = create_lp_model()
        @variable(model, x >= 0)
        @variable(model, y >= 0)
        @constraint(model, x + y <= 10)
        @objective(model, Max, 3x + 5y)
        
        optimize!(model)
        
        @test termination_status(model) == MOI.OPTIMAL
        @test value(x) >= 0
        @test value(y) >= 0
        @test value(x) + value(y) <= 10.01  # Small tolerance
        
        # Optimal solution should be at (0, 10)
        @test value(x) ≈ 0.0 atol=1e-4
        @test value(y) ≈ 10.0 atol=1e-4
        @test objective_value(model) ≈ 50.0 atol=1e-4
    end
    
    @testset "solve_lp Function" begin
        # minimize -3x - 5y subject to x + y <= 10, x,y >= 0
        c = [-3.0, -5.0]
        A = [1.0 1.0]
        b = [10.0]
        lb = [0.0, 0.0]
        ub = [Inf, Inf]
        
        x = solve_lp(c, A, b, lb, ub)
        
        @test length(x) == 2
        @test x[1] >= 0
        @test x[2] >= 0
        @test x[1] + x[2] <= 10.01
    end
    
    @testset "Nonlinear Programming" begin
        # Minimize (x-1)^2 + (y-2)^2
        model = create_nlp_model()
        @variable(model, x)
        @variable(model, y)
        # @NLobjective is deprecated in JuMP v1.0+, use @objective instead
        @objective(model, Min, (x - 1)^2 + (y - 2)^2)
        
        optimize!(model)
        
        @test termination_status(model) in [MOI.OPTIMAL, MOI.LOCALLY_SOLVED]
        @test value(x) ≈ 1.0 atol=1e-4
        @test value(y) ≈ 2.0 atol=1e-4
    end
    
    @testset "NLP with Constraints" begin
        # Minimize (x-2)^2 + (y-3)^2 subject to x^2 + y^2 <= 1
        model = create_nlp_model()
        @variable(model, x)
        @variable(model, y)
        # @NLconstraint is deprecated in JuMP v1.0+, use @constraint instead
        @constraint(model, x^2 + y^2 <= 1)
        @objective(model, Min, (x - 2)^2 + (y - 3)^2)
        
        optimize!(model)
        
        @test termination_status(model) in [MOI.OPTIMAL, MOI.LOCALLY_SOLVED]
        
        # Solution should be on the circle boundary
        @test value(x)^2 + value(y)^2 <= 1.01
    end
    
    @testset "solve_nlp Function" begin
        f(x) = (x[1] - 1)^2 + (x[2] - 2)^2
        x0 = [0.0, 0.0]
        
        x_opt = solve_nlp(f, x0)
        
        @test length(x_opt) == 2
        @test x_opt[1] ≈ 1.0 atol=1e-3
        @test x_opt[2] ≈ 2.0 atol=1e-3
    end
    
    @testset "Get Solution and Objective" begin
        model = create_lp_model()
        @variable(model, x >= 0)
        @variable(model, y >= 0)
        @constraint(model, x + y <= 5)
        @objective(model, Max, x + 2y)
        
        optimize!(model)
        
        sol = get_solution(model)
        @test sol isa Dict
        @test haskey(sol, "x")
        @test haskey(sol, "y")
        
        obj_val = get_objective(model)
        @test obj_val isa Number
        @test obj_val ≈ 10.0 atol=1e-4  # Optimal: x=0, y=5, obj=10
    end
    
    @testset "Bounded Variables" begin
        model = create_lp_model()
        @variable(model, 0 <= x <= 5)
        @variable(model, 0 <= y <= 3)
        @objective(model, Max, 2x + 3y)
        
        optimize!(model)
        
        @test termination_status(model) == MOI.OPTIMAL
        @test 0 <= value(x) <= 5.01
        @test 0 <= value(y) <= 3.01
    end
end
