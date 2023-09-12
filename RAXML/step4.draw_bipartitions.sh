#!/bin/bash
#SBATCH -p workq
#SBATCH -c 8
#SBATCH --time=2-24:00:00 #days-hh:mm:ss

module load bioinfo/standard-RAxML-8.2.11
module load compiler/gcc-4.8.5
module load mpi/openmpi-2.1.2

best_tree_file=$1
bootstrap_trees_file=$2
output_name=$3

model=GTRCAT
n_threads=8

raxmlHPC -f b -t $best_tree_file -z $bootstrap_trees_file -m $model -n $output_name
