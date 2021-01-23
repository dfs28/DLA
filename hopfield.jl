module Hopfield

using Distributions: sample, shuffle
using Random: seed!
using Parameters: @with_kw ## Decorates a type definition to allow default values and a keyword constructor

export train_hopfield ## Export function

## Set random seed
seed!(100)

## Define network parameters within mutable struct
@with_kw mutable struct Params
    N::Int64 = 10
    p::Int64 = 3
end

## Define function to update weights
function init_weights(args)
    ## Initialise model weights and patterns
    weights = zeros(Float32, args.N, args.N)
    patterns = [sample([-1,1], args.N, replace = true) for i in 1:args.p]

    #= Adjust weights
    Since Julia is column-oriented, construct for-loop column wise to improve performance
    Macro @inbounds removes boundary checking, which further improves performance
    Macro Threads.@threads allows multi-threading =#
    @inbounds Threads.@threads for j in 1:args.N
        for i in 1:args.N 
            if i != j 
                ## w_ij = 1/N sum x_i_mu*x_j_mu
                weights[i, j] = sum([patterns[μ][i] * patterns[μ][j] for μ in 1:args.p]) / args.N
            end
        end
    end

    return weights
end

## Define function to train hopfield network
function train_hopfield()
    ## Define args from Params constructor
    args = Params()

    ## Initialise weights
    weights = init_weights(args)

    ## Test network
    v = sample([-1,1], args.N, replace = true)
    for j in 1:10
        order = shuffle(1:args.N)
        δ = 0
  
        ## Work through units in random order
        for i in order
            sgn_sum = sum(v .* weights[i,:])
            
            #= Set new_v = 1 if sgn_sum > 0, otherwise -1
            A very julia way to perform actions based on condition
            condition ? x : y where if condition is true, do x otherwise do y =#
            sgn_sum > 0 ? new_v = 1 : new_v = -1
    
            ## Update units if necessary
            if new_v != v[i]
                δ += 1
                v[i] = new_v
            end
        end
  
        return v, δ
    end
end

end #module