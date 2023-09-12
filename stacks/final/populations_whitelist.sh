#!/bin/sh
#SBATCH -p workq

module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2

stacks_dir=$1
popmap=$2
output_dir=$3
perc_ind=$4
threads=$5
list_decon=$6
min_maf=$7
max_obs_het=$8
min_pop=$9


populations -P $stacks_dir -M $popmap -O $output_dir -p $min_pop -r $perc_ind --min_maf $min_maf --max_obs_het $max_obs_het -t $threads -B $list_decon --write_random_snp --verbose

