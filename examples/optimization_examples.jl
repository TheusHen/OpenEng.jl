# Optimization Examples

using OpenEng
using OpenEng.Optimization

println("=" ^ 60)
println("OpenEng.jl - Optimization Examples")
println("=" ^ 60)

# Example 1: Simple Linear Programming
println("\n1. Linear Programming - Production Planning")
println("-" ^ 40)

model = create_lp_model()
@variable(model, x >= 0)  # Product A
@variable(model, y >= 0)  # Product B

# Constraints
@constraint(model, labor, x + 2y <= 20)      # Labor hours
@constraint(model, material, 3x + y <= 30)   # Material units

# Objective: maximize profit
@objective(model, Max, 5x + 7y)

optimize!(model)

println("Production plan:")
println("  Product A: ", value(x), " units")
println("  Product B: ", value(y), " units")
println("  Maximum profit: \$", objective_value(model))
println("  Labor used: ", value(labor), " hours")
println("  Material used: ", value(material), " units")

# Example 2: Diet Problem
println("\n2. Diet Optimization")
println("-" ^ 40)

model = create_lp_model()

# Decision variables: servings of each food
@variable(model, bread >= 0)
@variable(model, milk >= 0)
@variable(model, cheese >= 0)

# Nutritional constraints (minimum daily requirements)
@constraint(model, calories, 65*bread + 150*milk + 115*cheese >= 2000)
@constraint(model, protein, 3*bread + 8*milk + 7*cheese >= 55)
@constraint(model, calcium, 20*bread + 285*milk + 200*cheese >= 800)

# Objective: minimize cost
@objective(model, Min, 0.50*bread + 1.20*milk + 2.50*cheese)

optimize!(model)

println("Optimal diet:")
println("  Bread: ", round(value(bread), digits=2), " servings")
println("  Milk: ", round(value(milk), digits=2), " servings")
println("  Cheese: ", round(value(cheese), digits=2), " servings")
println("  Minimum cost: \$", round(objective_value(model), digits=2))

# Example 3: Transportation Problem
println("\n3. Transportation Problem")
println("-" ^ 40)

model = create_lp_model()

# Supply from 2 warehouses to 3 stores
@variable(model, x[1:2, 1:3] >= 0)

# Supply constraints
@constraint(model, x[1,1] + x[1,2] + x[1,3] <= 100)  # Warehouse 1
@constraint(model, x[2,1] + x[2,2] + x[2,3] <= 150)  # Warehouse 2

# Demand constraints
@constraint(model, x[1,1] + x[2,1] >= 80)   # Store 1
@constraint(model, x[1,2] + x[2,2] >= 70)   # Store 2
@constraint(model, x[1,3] + x[2,3] >= 60)   # Store 3

# Transportation costs
costs = [4 6 8; 5 7 6]
@objective(model, Min, sum(costs[i,j] * x[i,j] for i in 1:2, j in 1:3))

optimize!(model)

println("Optimal transportation plan:")
for i in 1:2
    for j in 1:3
        if value(x[i,j]) > 0.01
            println("  Warehouse \$i → Store \$j: ", round(value(x[i,j]), digits=1), " units")
        end
    end
end
println("  Total cost: \$", round(objective_value(model), digits=2))

# Example 4: Nonlinear Optimization - Rosenbrock Function
println("\n4. Nonlinear Optimization - Rosenbrock Function")
println("-" ^ 40)

f(x) = (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2

x0 = [-1.2, 1.0]
x_opt = solve_nlp(f, x0)

println("Rosenbrock function: (1-x)² + 100(y-x²)²")
println("Starting point: ", x0)
println("Optimal point: [", round(x_opt[1], digits=6), ", ", round(x_opt[2], digits=6), "]")
println("Expected optimum: [1.0, 1.0]")
println("Objective value: ", f(x_opt))

# Example 5: Constrained Nonlinear Optimization
println("\n5. Constrained NLP - Circle Constraint")
println("-" ^ 40)

model = create_nlp_model()
@variable(model, x)
@variable(model, y)

# Constraint: x² + y² ≤ 1
@constraint(model, x^2 + y^2 <= 1)

# Objective: minimize distance to (2, 3)
@objective(model, Min, (x - 2)^2 + (y - 3)^2)

optimize!(model)

x_sol = value(x)
y_sol = value(y)

println("Minimize distance to point (2, 3)")
println("Subject to: x² + y² ≤ 1")
println("Solution: (", round(x_sol, digits=4), ", ", round(y_sol, digits=4), ")")
println("Distance from origin: ", round(sqrt(x_sol^2 + y_sol^2), digits=4))
println("On circle boundary: ", x_sol^2 + y_sol^2 ≈ 1.0)

# Example 6: Portfolio Optimization
println("\n6. Portfolio Optimization (Simplified)")
println("-" ^ 40)

model = create_nlp_model()

# Asset weights
@variable(model, 0 <= w[1:3] <= 1)

# Must sum to 1 (fully invested)
@constraint(model, sum(w) == 1)

# Expected returns
returns = [0.10, 0.15, 0.12]

# Minimize risk (simplified as variance of weights)
# Maximize return
@objective(model, Max, sum(returns[i] * w[i] for i in 1:3) - 0.1 * sum(w[i]^2 for i in 1:3))

optimize!(model)

println("Asset allocation:")
for i in 1:3
    println("  Asset \$i: ", round(100 * value(w[i]), digits=1), "%")
end
println("Expected return: ", round(100 * objective_value(model), digits=2), "%")

# Example 7: Parameter Estimation
println("\n7. Curve Fitting / Parameter Estimation")
println("-" ^ 40)

# Data: y = a*x² + b*x + c + noise
x_data = 0:0.5:10
y_true = 2 .* x_data.^2 .- 3 .* x_data .+ 1
y_data = y_true .+ 0.5 * randn(length(x_data))

model = create_nlp_model()
@variable(model, a)
@variable(model, b)
@variable(model, c)

# Minimize sum of squared errors
@objective(model, Min, sum((y_data[i] - (a*x_data[i]^2 + b*x_data[i] + c))^2 for i in 1:length(x_data)))

optimize!(model)

println("True parameters: a=2, b=-3, c=1")
println("Estimated parameters:")
println("  a = ", round(value(a), digits=4))
println("  b = ", round(value(b), digits=4))
println("  c = ", round(value(c), digits=4))

# Example 8: Resource Allocation
println("\n8. Resource Allocation with Integer Constraints")
println("-" ^ 40)

# Note: For true integer programming, would need integer variables
# This uses continuous relaxation

model = create_lp_model()
@variable(model, 0 <= workers[1:4] <= 10)  # Workers for 4 projects

# Total workers available
@constraint(model, sum(workers) <= 20)

# Minimum workers per project
@constraint(model, workers .>= 2)

# Productivity of each project
productivity = [3, 5, 4, 6]
@objective(model, Max, sum(productivity[i] * workers[i] for i in 1:4))

optimize!(model)

println("Worker allocation:")
for i in 1:4
    println("  Project \$i: ", round(value(workers[i]), digits=1), " workers")
end
println("Total productivity: ", round(objective_value(model), digits=2))

println("\n" * "=" ^ 60)
println("Examples completed successfully!")
println("=" ^ 60)
