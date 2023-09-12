#!/bin/bash
#SBATCH -p workq

#Load modules
module load bioinfo/partitionfinder-2.1.1

PartitionFinder.py -p 5 ./partitionfinder_mtDNA
