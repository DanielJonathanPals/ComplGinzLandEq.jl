using DifferentialEquations, Logging, Plots

include("structs.jl")


"""
    GinzLand(g::Grid2D, u0::AbstractArray; tspan = (0.,15.), α=2, β=-1)

Solves the Ginzburg Landau differential equation.

# Arguments

* 'g::Grid2D'
* 'u0::AbstractArray'

# Key word Arguments

* 'tspan = (0.,15.)'
* 'α=2'
* 'β=-1'
"""
function GinzLand(g::Grid2D, u0::AbstractArray; tspan = (0.,15.), α=2., β=-1.)
    if !(size(g.y_grid) == size(u0))
        @error "The Grid g and the initial conditions u0 are not compatible due to different sizes"
    end
    Δ = Laplacian2D(g)
    u0 = reshape(u0, :)
    function f!(du,u,p,t)
        α,β = p
        du .= (1+(α)im) .* Δ(u) - (1-(β)im) * u' * u .* u
    end
    prob = ODEProblem(f!, u0, tspan, [α,β])
    sol = solve(prob)
    return sol
end

function animateSol(sol,name = "GinzburgLandauAnimation")
    tspan = sol.t[1]:0.1:sol.t[end]
    n = sqrt(length(sol.u[1,:][1]))

    anim = Plots.@animate for t ∈ tspan
        Plots.heatmap(reshape(real.(sol(t)),Int(n),Int(n)),clims=(-0.003,0.003))
    end
    
    gif(anim, name*".gif",fps=10)
end

function GinzLandDemo(sol;L=75,n=50)
    u0 = 0.01*(rand(ComplexF64, (n,n)) .- (0.5 + 0.5im))
    g = Grid2D(range(0,L,length=n),range(0,L,length=n))
    sol = GinzLand(g,u0)
    animateSol(sol)
end
