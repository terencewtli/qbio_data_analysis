#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=1:00:00

sleep 100

echo "Hello world!"
