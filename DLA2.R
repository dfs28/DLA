#### DLA 3 -------

### 1) Set up ----
library(ggplot2)

### 2) Make hopfield network ----

#Set up some parameters
N <- 10
p <- 1

#Make random pattern
patterns <- replicate(p, sample(c(1,-1), size = N, replace = TRUE))

#More efficient way of setting weights
make_weights <- function(patterns, N, p) {
  
  #Initialise weight matrix
  weights <- matrix(0, nrow = N, ncol = N)

  for (i in 1:p) {
  
    #Multiply through the patterns to make matrix, add them together
    weights <- weights + patterns[,p] %*% t(patterns[,p])

    }

  #Divide by N
  weights <- weights/N

  #Zero off self connections
  for (i in 1:N) {weights[i,i] <- 0}
  
  return(weights)
}

weights <- make_weights(patterns, N, p)

#Now test the system
v <- sample(c(1,-1), size = N, replace = TRUE)

#Calculate energy
energy <- -0.5 * sum(weights[1:N, 1:N] * (v[1:N] %*% t(v[1:N])))
delta_E <- 10

#Frame to track energy
energies <- c()
delta_Es <- c()
deltas <- c()
iterator <- 1

while (delta_E != 0) {
  
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
  
  #Calculate energy
  new_energy <- -0.5 * sum(weights[1:N, 1:N] * (v[1:N] %*% t(v[1:N])))
  delta_Es[iterator] <- delta_E <- new_energy - energy
  energies[iterator] <- energy <- new_energy
  
  #If it doesn't match one of the patterns switch the sign
  
  print(delta)
  print(delta_E)
  
  #Iterate
  iterator <- iterator + 1
  
  if (delta_E == 0) {
    
   #Check if any patterns identical to current units
   is_identical <- min(apply(patterns, 2, function(x) (length(which(x != v)))))
   
   if (is_identical != 0) {
     
     #Invert and increeas energy
     v <- -v
     delta_E <- 1
     
   }
  }
}
print(v)
t(patterns)

# initialize the weights using Hebb rule # loop L times
N <- 10
p <- 3

#Make random pattern
patterns <- replicate(p, sample(c(1,-1), size = N, replace = TRUE))

#Weights
w <- make_weights(patterns, N, p)

#Make t function
do_t <- function(x) {
  sapply(x, function(y) (ifelse(y == 1, 1, 0)))
}

for (l in 1:L) {
  
  #Calculate al activations
  a <- x %*% w
  
  #Do sigmoidal (compute outputs)
  y <- 1/(1+exp(-a)) 
  
  #Calculate t function
  t <- apply(x, 2, do_t)
  e <- t - y
  gw <- t(x) %*% e
  gw <- gw + t(gw)
  
  w <- w + epsilon * (gw - alpha*w) #makestep
  
  #Enforce all self weights to be zero
  for (i in 1:N) {
    w[i,i] <-  0
  }
  
}




