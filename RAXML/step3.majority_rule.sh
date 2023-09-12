#!/bin/bash
#SBATCH -p workq
#SBATCH -c 8
#SBATCH --time=2-24:00:00 #days-hh:mm:ss

module load bioinfo/standard-RAxML-8.2.11
module load compiler/gcc-4.8.5
module load mpi/openmpi-2.1.2


path_tree=$1
input_name=$2
trees=$3
output_name=$4

model=GTRCAT
n_threads=8

echo $input_name

raxmlHPC ­J MRE -z ${path_tree}/$trees -p $RANDOM -m $model -s $input_name -n $output_name
