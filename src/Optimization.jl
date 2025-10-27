"""
# OpenEng.Optimization

Optimization problem solving and mathematical programming.

This module provides interfaces for linear programming, nonlinear programming,
and constrained optimization using JuMP.jl and various solvers.

## Main Functions

- `create_model`: Create optimization model
- `solve_lp`: Solve linear programming problem
- `solve_nlp`: Solve nonlinear programming problem
- `optimize!`: Solve optimization model

## Examples

```julia
using OpenEng.Optimization

# Linear programming
model = create_model()
@variable(model, x >= 0)
@variable(model, y >= 0)
@constraint(model, x + y <= 10)
@objective(model, Max, 3x + 5y)
optimize!(model)
```
"""
module Optimization

using JuMP
import Ipopt
import GLPK

# Re-export JuMP functions
export Model, @variable, @constraint, @objective, @expression
export optimize!, value, objective_value, dual, shadow_price
export termination_status, primal_status, dual_status
export set_optimizer, set_silent, unset_silent

# Custom exports
export create_model, create_lp_model, create_nlp_model
export solve_lp, solve_nlp
export get_solution, get_objective

"""
    create_model(; solver=nothing, silent=true) -> model

Create an optimization model.

# Arguments
- `solver`: Solver to use (`:ipopt`, `:glpk`, or nothing for auto-detect)
- `silent`: Suppress solver output

# Returns
- JuMP model

# Examples
```julia
model = create_model(solver=:glpk)
@variable(model, x >= 0)
```
"""
function create_model(; solver::Union{Symbol,Nothing}=nothing, silent::Bool=true)
    if solver === nothing
        # Default to GLPK for LP, Ipopt for NLP
        model = Model(GLPK.Optimizer)
    elseif solver == :glpk
        model = Model(GLPK.Optimizer)
    elseif solver == :ipopt
        model = Model(Ipopt.Optimizer)
    else
        error("Unknown solver: $solver. Use :glpk or :ipopt")
    end
    
    if silent
        set_silent(model)
    end
    
    return model
end

"""
    create_lp_model(; silent=true) -> model

Create a linear programming model using GLPK.

# Arguments
- `silent`: Suppress solver output

# Returns
- JuMP model configured for LP

# Examples
```julia
model = create_lp_model()
@variable(model, x >= 0)
@variable(model, y >= 0)
@constraint(model, x + 2y <= 10)
@objective(model, Max, 3x + 4y)
optimize!(model)
println("x = ", value(x), ", y = ", value(y))
```
"""
function create_lp_model(; silent::Bool=true)
    return create_model(solver=:glpk, silent=silent)
end

"""
    create_nlp_model(; silent=true) -> model

Create a nonlinear programming model using Ipopt.

# Arguments
- `silent`: Suppress solver output

# Returns
- JuMP model configured for NLP

# Examples
```julia
model = create_nlp_model()
@variable(model, x)
@variable(model, y)
@NLconstraint(model, x^2 + y^2 <= 1)
@NLobjective(model, Min, (x - 1)^2 + (y - 2)^2)
optimize!(model)
```
"""
function create_nlp_model(; silent::Bool=true)
    return create_model(solver=:ipopt, silent=silent)
end

"""
    solve_lp(c, A, b, lb, ub) -> x

Solve a linear program in standard form:
    minimize    c'x
    subject to  Ax ≤ b
                lb ≤ x ≤ ub

# Arguments
- `c`: Objective coefficients
- `A`: Constraint matrix
- `b`: Constraint bounds
- `lb`: Lower bounds on variables
- `ub`: Upper bounds on variables

# Returns
- `x`: Optimal solution

# Examples
```julia
c = [-3.0, -5.0]
A = [1.0 1.0]
b = [10.0]
lb = [0.0, 0.0]
ub = [Inf, Inf]
x = solve_lp(c, A, b, lb, ub)
```
"""
function solve_lp(c::AbstractVector, A::AbstractMatrix, b::AbstractVector, 
                  lb::AbstractVector, ub::AbstractVector)
    n = length(c)
    m = length(b)
    
    model = create_lp_model()
    @variable(model, lb[i] <= x[i=1:n] <= ub[i])
    @constraint(model, A * x .<= b)
    @objective(model, Min, c' * x)
    
    optimize!(model)
    
    if termination_status(model) == MOI.OPTIMAL
        return value.(x)
    else
        error("Optimization did not converge: $(termination_status(model))")
    end
end

"""
    solve_nlp(f, x0; constraints=nothing, bounds=nothing) -> x

Solve a nonlinear programming problem.

# Arguments
- `f`: Objective function (must accept vector input: f(x))
- `x0`: Initial guess
- `constraints`: Optional constraint functions
- `bounds`: Optional variable bounds

# Returns
- `x`: Optimal solution

# Examples
```julia
f(x) = (x[1] - 1)^2 + (x[2] - 2)^2
x0 = [0.0, 0.0]
x_opt = solve_nlp(f, x0)
```
"""
function solve_nlp(f::Function, x0::AbstractVector; 
                   constraints=nothing, bounds=nothing)
    n = length(x0)
    model = create_nlp_model()
    
    if bounds === nothing
        @variable(model, x[i=1:n], start=x0[i])
    else
        lb, ub = bounds
        @variable(model, lb[i] <= x[i=1:n] <= ub[i], start=x0[i])
    end
    
    # Use @objective instead of @NLobjective (deprecated in JuMP v1.0+)
    @objective(model, Min, f(x))
    
    # Add constraints if provided
    if constraints !== nothing
        for (i, constraint_fn) in enumerate(constraints)
            register(model, Symbol("g_$i"), n, constraint_fn, autodiff=true)
            @NLconstraint(model, constraint_fn(x...) <= 0)
        end
    end
    
    # Set initial values (already done via start= in @variable)
    
    optimize!(model)
    
    if termination_status(model) == MOI.OPTIMAL || 
       termination_status(model) == MOI.LOCALLY_SOLVED
        return value.(x)
    else
        @warn "Optimization may not have converged: $(termination_status(model))"
        return value.(x)
    end
end

"""
    get_solution(model) -> Dict

Extract solution from an optimized model.

# Arguments
- `model`: Optimized JuMP model

# Returns
- Dictionary with solution values

# Examples
```julia
optimize!(model)
sol = get_solution(model)
```
"""
function get_solution(model::Model)
    if termination_status(model) != MOI.OPTIMAL && 
       termination_status(model) != MOI.LOCALLY_SOLVED
        @warn "Model may not be optimal: $(termination_status(model))"
    end
    
    vars = all_variables(model)
    sol = Dict{String, Float64}()
    
    for var in vars
        sol[string(var)] = value(var)
    end
    
    return sol
end

"""
    get_objective(model) -> Float64

Get the objective value of an optimized model.

# Arguments
- `model`: Optimized JuMP model

# Returns
- Objective value

# Examples
```julia
optimize!(model)
obj_val = get_objective(model)
```
"""
function get_objective(model::Model)
    return objective_value(model)
end

end # module Optimization
