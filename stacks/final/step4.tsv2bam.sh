#!/bin/sh
#SBATCH -p workq

threads=3
memory=10G
info_file=Eliurus_sp.popmap

path_data=$1
scripts_path=$2
samples_dir=$3

m=2
M=2
n=4

catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n

echo $catalog_dir

output_dir=$catalog_dir

sbatch -c $threads --output=$output_dir/tsv2bam.out --mem=$memory $scripts_path/tsv2bam.sh $output_dir ${info_file} $samples_dir $threads
