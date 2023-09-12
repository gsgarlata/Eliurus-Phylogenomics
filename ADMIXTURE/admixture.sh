#!/bin/sh
#SBATCH -p workq

module load bioinfo/admixture_linux-1.3.0

input=$1
nCV=$4
K=$3
out_summary=$5

admixture -s $RANDOM --cv=$nCV $input $K | tee $out_summary