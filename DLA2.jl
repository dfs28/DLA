### 1) Set up ----
using Distributions
using Random

### 2) Make hopfield network ----

#Set up some parameters

N = 10
p = 1
#mu <- rep(-1, times = N)

weights = Array{Float32}(undef, N, N)


#Make random pattern
patterns = wsample([-1,1], [0.5,0.5], 10 )

#Set the weights - work through the matrix
for i in 1:N
  for j in 1:N 
    if i != j 
      
      #w_ij = 1/N sum x_i_mu*x_j_mu
      weights[i, j] = sum(patterns[i, mu]*patterns[j, mu] for mu in 1:p)/N
    else 

      #Zero off self connections
      weights[i, j] = 0
    end
  end
end


#Now test the system
v = wsample([-1,1], [0.5,0.5], N )

#Could try running this an arbitrary number of times?
#while (delta > 0) {
for j in 1:10
  
  #Set order to take
  order = shuffle(1:N)
  delta = 0
  
  #Work through the units in a random order
  for i in order
    sgn_sum = sum(v * weights[i,])
    
    #Do sgn_sum
    if sgn_sum > 0 
        new_v = 1
    #} else if (sgn_sum == 0) {new_v <- 0
    else 
        new_v = -1
    end
    
    #Check if need to keep updating units, update them
    if new_v != v[i]
      delta = delta + 1
      v[i] = new_v
    end
  end
  
  delta

end
print(v)
t(patterns)