## Date-Time ####
Date_Time <- format(Sys.time(),"%Y-%m-%d-%H-%M") #Used as a unique identifier

## Setting WD ####
# ("~/rwork") # Setting working directory to rwork, were all the data is saved

## Loading R Packages ####
library(parallel)


## Functions ####

data_sim <- function(seed, nobs, beta, sigma, xmeans, xsigs){ # Simulates the data set
  set.seed(seed) # Sets a seed
  xrn <- cbind(rnorm(nobs, mean = xmeans[1], sd = xsigs[1,1]),
               rnorm(nobs, mean = xmeans[2], sd = xsigs[2,2]),
               rnorm(nobs, mean = xmeans[3], sd = xsigs[3,3])) # Simulates Predictors
  xped <- cbind(rep(1,nobs),xrn) # Creating Design Matrix
  y <- xped %*% beta + rnorm(nobs ,0, sigma) # Simulating Y
  df <- data.frame(x=xrn, y=y) # Creating Data Frame
  return(df)
}


parallel_lm <- function(data){ # Applying a Ordinary Least Squares to data frame
  lm_res <- lm(y ~ x.1 + x.2 + x.3, data = data) # Find OLS Estimates
  return(list(coef=coef(lm_res), lm_results=lm_res))
}


## Parallel Parameters ####
ncores <- 8 # Number of cpus to be used

## Simulation Parameters ####
N <- 10000 # Number of Data sets
nobs <- 200 # Number of observations
beta <- c(5, 4, -5, -3) # beta parameters
xmeans <- c(-2, 0, 2) # Means for predictors
xsigs <-diag(rep(1, 3)) # Variance for predictor
sig <- 3 # Variance for error term
  
## Simulating Data ####

standard_data <- lapply(c(1:N), data_sim, # Using data_sim function to simulate N data sets
                        nobs = nobs, beta = beta, sigma = sig, # Model Parameters
                        xmeans = xmeans, xsigs = xsigs) # Predictor Parameters for simulation


## Obtaining Estimates ####
start <- Sys.time()# Used for timing process
standard_results <- lapply(standard_data, parallel_lm) # Using 1 core to process the data 
print("Standard lapply")
Sys.time()-start# Time it took

start <- Sys.time()# Used for timing process
parallel_results <- mclapply(standard_data, parallel_lm, # Using Multiple cores to process the data 
                             mc.cores = ncores) # Setting the number of cores to use
print("mclapply")
Sys.time()-start# Time it took

## Extracting Betas ####

standard_beta <- matrix(ncol=4, nrow = N) # Creating a matrix for beta values 
parallel_beta <- matrix(ncol=4, nrow = N) # Creating a matrix for beta values 
for (i in 1:N){
  standard_beta[i, ] <- standard_results[[i]]$coef #Extracting coefficients from lapply
}
for (i in 1:N){
  parallel_beta[i, ] <- parallel_results[[i]]$coef #Extracting coefficients from mclapply
}

## Average results
print("From Standard lapply")
colMeans(standard_beta)
print("From mclapply")
colMeans(parallel_beta)


## Saving Results ####
standard_save <- list(lm_res = standard_results, betas = standard_beta) # Creating a list or results from mclapply
parallel_save <- list(lm_res = parallel_results, betas = parallel_beta) # Creating a list or results from mclapply
params <- list(N = N, # Creating a list of simulation parameters
                nobs = nobs,
                beta = beta,
                xmeans = xmeans,
                xsigs = xsigs,
                sig = sig) 

results <- list(standard = standard_save, parallel = parallel_save, data = standard_data, # Combining list
                parameters = params, Date_Time = Date_Time)

save_dir <- paste("Results_", Date_Time, ".RData", sep="") # Creating file name, contains date-time
save(results, file = save_dir, version = 2) # Saving RData file, recommend using version 2
