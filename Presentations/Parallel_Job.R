## Date-Time ####
Date_Time <- format(Sys.time(),"%Y-%m-%d-%H-%M") #Used as a unique identifier

## Setting WD ####
setwd("~/rwork") # Setting working directory to rwork, were all the data is saved

## Install R Packages ####
# install.packages("mvtrnorm")

## Loading R Packages ####
library(parallel)
library(mvtnorm)

## Functions ####

data_sim <- function(seed, nobs, beta, sigma, xmeans, xsigs){ # Simulates the data set
  set.seed(seed) # Sets a seed
  xrn <- rmvnorm(nobs, mean = xmeans, sigma = xsigs) # Simulates Predictors
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
ncores <- 16 # Number of cpus to be used

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

parallel_results <- mclapply(standard_data, parallel_lm, # Using Multiple cores to process the data 
                             mc.cores = ncores) # Setting the number of cores to use

## Extracting Betas ####
parallel_beta <- matrix(ncol=4, nrow = N) # Creating a matrix for beta values 
for (i in 1:N){
  parallel_beta[i, ] <- parallel_results[[i]]$coef #Extracting coefficients from mclapply
}

## Saving Results ####
parallel_save <- list(lm_res = parallel_results, betas = parallel_beta) # Creating a list or results
params <- list(N = N, # Creating a list of simulation parameters
                nobs = nobs,
                beta = beta,
                xmeans = xmeans,
                xsigs = xsigs,
                sig = sig) 

results <- list(parallel = parallel_save, data = standard_data, # Combining list
                parameters = params, Date_Time = Date_Time)

save_dir <- paste("Results_", Date_Time, ".RData", sep="") # Creating file name, contains date-time
save(results, file = save_dir, version = 2) # Saving RData file, recommend using version 2
