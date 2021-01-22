#### DLA 3 -------

### 1) Set up ----
library(ggplot2)

### 2) Make hopfield network ----

#Set up some parameters

N <- 10
p <- 3
#mu <- rep(-1, times = N)

weights <- matrix(nrow = N, ncol = N)

#Make random pattern
patterns <- replicate(p, sample(c(1,-1), size = N, replace = TRUE))

#Set the weights - work through the matrix
for (i in 1:N) {
  for (j in 1:N) {
    if (i != j) {
      
      #w_ij = 1/N sum x_i_mu*x_j_mu
      weights[i, j] <- sum(sapply(1:p, function(mu) (patterns[i, mu]*patterns[j, mu])))/N
    } else {
      
      #Zero off self connections
      weights[i, j] <- 0
        }
  }
}

#Now test the system
v <- sample(c(1,-1), size = N, replace = TRUE)

#Could try running this an arbitrary number of times?
#while (delta > 0) {
for (j in 1:10) {
  
  #Set order to take
  order <- sample(1:N)
  delta <- 0
  
  #Work through the units in a random order
  for (i in order) {
    sgn_sum <- sum(v * weights[i,])
    
    #Do sgn_sum
    if (sgn_sum > 0) {new_v <- 1
    #} else if (sgn_sum == 0) {new_v <- 0
    } else {new_v <- -1}
    
    #Check if need to keep updating units, update them
    if (new_v != v[i]) {
      delta <- delta + 1
      v[i] <- new_v
    }
  }
  
  print(delta)
}
print(v)
t(patterns)




