#!/bin/bash

#SBATCH --nodes=1 # Setting the number of nodes, usually 1 node is used
#SBATCH --ntasks=1 # Setting the number of tasks, usually 1 task is used
#SBATCH --cpus-per-task=8 # Setting the number of cpus per task, this is the number of cores you specify
#SBATCH --mem-per-cpu=1G # How much ram per cpu, usually 1 GB
#SBATCH --time=0-00:15:00    # Time to run task, changes based on predicted time of task, set to 1 hour
#SBATCH --output=my.stdout # Where to store the output, usually a standard output, I don't use it
#SBATCH --mail-user=NETID@ucr.edu # Where to email information about job
#SBATCH --mail-type=ALL # Not Sure
#SBATCH --job-name="Cluster Job 1" # Name of the job, can be anything
#SBATCH -p statsdept # statsdept is the only one the department of statistics students can use

Rscript Parallel_Job.R # The command that tells Linux to process your R Script
