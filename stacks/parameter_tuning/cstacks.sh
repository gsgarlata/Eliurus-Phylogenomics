#!/bin/sh
#SBATCH -p workq


module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2

stacks_dir=$1
pop_dir=$2
n=$3
threads=$4


#-P: path to the directory containing Stacks files; -M: path to a population map file;
#-n: number of mismatches allowed between sample loci when build the catalog;
#-p: enable parallel execution with num_threads threads.

cstacks -P $stacks_dir -M $pop_dir -n $n -p $threads  --report_mmatches
