using LinearAlgebra, SparseArrays

"""
    Grid2D

Discretisation of space

# Initialization

    Grid2D(x::AbstractRange, y::AbstractRange)

# Fields

* 'x': this is a n_x long range
* 'y'
* 'h_x'
* 'h_y'
* 'n': number of grid points along one side
* 'N': total number of grid points 
* 'x_grid': this is a n_x x n_y matrix 
* 'y_grid'
"""
struct Grid2D 
    x # this is a n_x long range
    y
    h_x
    h_y
    n # number of grid points along one side
    N # total number of grid points 
    x_grid # this is a n_x x n_y matrix 
    y_grid
end 

function Grid2D(x::AbstractRange, y::AbstractRange)
    h_x = abs(x[2] - x[1])
    h_y = abs(y[2] - y[1])
    n_x = length(x)
    n_y = length(y)
    @assert n_x == n_y                  #check if this is correct
    
    N = n_x * n_y 
    x_grid = ones(n_x) * x'
    y_grid = y * ones(n_y)'
    
    Grid2D(x, y, h_x, h_y, n_x, N, x_grid, y_grid)
end 

"""
    Laplacian2D

Discretized Laplace operator

# Initialization

    Laplacian2D(g::Grid2D)

Initializes Laplace operator for a given Grid2D

# Fields

* 'M'
"""
struct Laplacian2D 
    M 
 end 
 
 function Laplacian2D(g::Grid2D)
     n = g.n
     N = g.N 
     
     # these are the neighbours in x-direction 
     M = diagm(0=>-4*ones(N), 1=>ones(N-1), -1=>ones(N-1))
     
     # these are the neighbours in y-direction
     M += diagm(n=>ones(N-n), -n=>ones(N-n))

     # implement periodic boundary conditions
     M += diagm(N-n=>ones(n), n-N=>ones(n), N-1=>[1.], 1-N=>[1.])
     
     Laplacian2D(sparse(M./(g.h_x^2)))
 end
 
 (Δ::Laplacian2D)(x) = Δ.M * x