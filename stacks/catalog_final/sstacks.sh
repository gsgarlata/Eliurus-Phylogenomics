#!/bin/sh
#SBATCH -p workq

module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2


stacks_dir=$1
pop_dir=$2
threads=$3

#-P: path to the directory containing Stacks files; -M: path to a population map file from which to take sample names.
#-p: enable parallel execution with num_threads threads.

sstacks -P $stacks_dir -M $pop_dir -p $threads
