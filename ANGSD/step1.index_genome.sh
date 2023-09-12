#!/bin/bash
#SBATCH -c 8
#SBATCH -p workq

path_script=$1
catalog_dir=$2
reference_dir=$3

threads=4

mkdir -p $reference_dir

cp $catalog_dir/catalog.fa.gz $reference_dir

sbatch $path_script/index_genome.sh $reference_dir/catalog $threads
