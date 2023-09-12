#!/bin/sh
#SBATCH -p workq

threads=3
memory=20G
info_file=catalog_Eliurus_sp.popmap

path_data=$1
scripts_path=$2
samples_dir=$3

m=2
M=2
n=4

catalog_dir=$path_data/stacks.m$m.M$M/catalog.m$m.M$M.n$n

echo $catalog_dir

sbatch -c $threads --output=$catalog_dir/tsv2bam.out --mem=$memory $scripts_path/tsv2bam.sh $catalog_dir ${info_file} $samples_dir $threads
