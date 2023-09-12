#!/bin/sh
#SBATCH -p workq


module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2

stacks_dir=$1
popmap=$2
threads=$3


gstacks -P $stacks_dir -M $popmap -t $threads --var-alpha 0.01 --gt-alpha 0.01


stacks-dist-extract $stacks_dir/gstacks.log.distribs effective_coverages_per_sample | sed -e '1,2d' > $stacks_dir/effective_coverage.tsv
