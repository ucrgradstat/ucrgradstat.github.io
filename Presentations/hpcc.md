---
title: "Parallel Processing for Statistics"
author: "Isaac Quintanilla Salinas"
date: "12/18/2020"
output: 
  ioslides_presentation:
    keep_md: yes
    widescreen: yes
    df_print: paged
    incremental: true
subtitle: "with R Package Parallel"

---



## Outline  

- Introduction

- Cluster

- Parallel Processing in R

- Simulation Study


# Introduction

## Terminology

- job: A task a computer must complete

- bash script: tells the computer what to do

## My Cluster Usage

- Computationally Intensive

- Use R and C++ (via Rcpp)


# HPCC Cluster

## How do I view the cluster?

- Virtual Desktop Computer
  - Set number of cores (max 32 cpus)
  - Set RAM (max 128 GB)
  - Set storage (20 GB)

## How to access the cluster?

- RStudio Server
  - [https://rstudio.hpcc.ucr.edu/](https://rstudio.hpcc.ucr.edu/)

- Terminal
  - ssh

## RStudio Server

- Edit any text document

- Submit jobs

- Upload/Download Data or Documents

- Do not do computationally-intensive tasks in RStudio Server
  - Light Tasks
    - Submit Jobs

## Linux Commands

- `sbatch`: submit a job to the cluster

- `scancel`: cancel jobs

- `squeue`: view jobs status
  - [dashboard.hpcc.ucr.edu](https://dashboard.hpcc.ucr.edu/)
  
- `slurm_limits`: view what is available to you
  
## How I use the cluster?

- Code on my computer at a smaller scale

  - Parallelize using my computer's cores

- Scale it up for the cluster

- Have an R Script do everything for me

- Save all results in an RData file 

- Use the `try()` function to catch errors

- Use RProjects


## Submitting Jobs

- Use a bash script to specify the parameters for the cluster

- Add the following line at the end:


```bash
Rscript NAME_OF_FILE.R
```

- Submit the job with the line below:


```bash
sbatch NAME_OF_BASH.sh
```

## Anatomy of R Script


```r
# Obtain System Date and Time
date_time <- format(Sys.time(),"%Y-%m-%d-%H-%M")

# Set Working Directory
setwd("~/rwork")

# Load libraries and functions
library(parallel)
source("Fxs.R")

# Pre - Parallel Analysis
# Parallel Analysis
results <- mclapply(data, FUN, mc.cores = number_of_cores)
# Post - Parallel Analysis

# Save Results
file_name <- paste("Results_", date_time, ".RData",sep = "")
save(results, file = file_name, version = 2)
```


# Parallel Processing in R

## How to parallelize your R Code

- `mclapply()`

  - Recommended for the cluster
  
  - Has built-in `try()` function

- `parLapply()`

  - Use if multiple nodes are involved

## Where to parallelize?

- Identify loops or *apply functions

  - Iterations must be independent of each other
  
- Identify bottlenecks

  - Use benchmark R packages
  
## How to speed up you R Code

- Vectorize your R code

- Minimize loops

  - Use `*apply` functions 

- Use optimized functions

  - `colMeans()` and `rowMeans()`
  
- Implement c++ via Rcpp

- More Imformation: Advanced R ([adv-r.hadley.nz](https://adv-r.hadley.nz/)) 


# Simulation Study

## Simulation Study

- Show that Ordinary Least Squares provides consistent estimates

- Model: $Y = \boldsymbol X^\mathrm T \boldsymbol \beta + \epsilon$

  - $\boldsymbol \beta = (\beta_0, \beta_1, \beta_2, \beta_3)^\mathrm T = (5, 4, -5, -3)^\mathrm T$
  
  - $\epsilon \sim N(0,3)$

## Simulation Parameters

- Number of Data set: 10000

- Number of Observations: 200

- $\boldsymbol X \sim N\left(\left(-2,0,2\right)^\mathrm T, \boldsymbol I_3 \right)$

- $\boldsymbol I_3$: $3\times 3$ Identity Matrix

## Parallelization of Simulation

- 16 cores

- Each core will process around 625 data sets 

# Thank You!
