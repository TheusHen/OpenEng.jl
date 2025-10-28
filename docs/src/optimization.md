# Optimization

The `OpenEng.Optimization` module provides interfaces for linear programming, nonlinear programming, and constrained optimization.

## Overview

This module uses JuMP.jl with GLPK and Ipopt solvers for optimization problems.

## Linear Programming

```julia
using OpenEng.Optimization

# Create LP model
model = create_lp_model()

# Define variables
@variable(model, x >= 0)
@variable(model, y >= 0)

# Add constraints
@constraint(model, x + y <= 10)

# Set objective
@objective(model, Max, 3x + 5y)

# Solve
optimize!(model)

# Get solution
println("x = ", value(x))
println("y = ", value(y))
println("Objective = ", objective_value(model))
```

## Nonlinear Programming

```julia
# Create NLP model
model = create_nlp_model()

# Define variables
@variable(model, x)
@variable(model, y)

# Add nonlinear constraint
@constraint(model, x^2 + y^2 <= 1)

# Set nonlinear objective
@objective(model, Min, (x - 2)^2 + (y - 3)^2)

# Solve
optimize!(model)
```

## Convenience Functions

### solve_lp

```julia
c = [-3.0, -5.0]
A = [1.0 1.0]
b = [10.0]
lb = [0.0, 0.0]
ub = [Inf, Inf]

x = solve_lp(c, A, b, lb, ub)
```

### solve_nlp

```julia
f(x) = (x[1] - 1)^2 + (x[2] - 2)^2
x0 = [0.0, 0.0]
x_opt = solve_nlp(f, x0)
```

## Main Functions

- `create_model` - Create optimization model
- `create_lp_model` - Linear programming model
- `create_nlp_model` - Nonlinear programming model
- `solve_lp` - Solve LP in standard form
- `solve_nlp` - Solve NLP from function
- `get_solution` - Extract solution as Dict
- `get_objective` - Get objective value

## Examples

See `examples/optimization_examples.jl` for comprehensive examples including:
- Production planning
- Diet optimization
- Transportation problems
- Portfolio optimization
- Parameter estimation
