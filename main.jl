cd(@__DIR__) ## cd into current directory; @__DIR__ maco expands to a string with the absolute path to the directory of the file containing the macrocall.
push!(LOAD_PATH, pwd()) ## Add current directory to Julia's package LOAD_PATH

## Include scripts
include("hopfield.jl")

## Import modules
## Dot before module name imports module instead of package
using .Hopfield    ## Hopfield module

## Train hopfield network
v, δ = train_hopfield()