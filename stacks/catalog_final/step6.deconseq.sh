#!/bin/sh
#SBATCH -p workq

module load bioinfo/deconseq-standalone-0.4.3

memory=20G
threads=3

path_data=$1
scripts_path=$2

m=2
M=2
n=4

catalog_dir=$path_data/stacks.m$m.M$M/catalog.m$m.M$M.n$n
input=$catalog_dir/catalog.fa

output_dir=$catalog_dir/cleaning_catalog

mkdir -p $output_dir

cp ${input}.gz $output_dir

gunzip ${input}.gz

sbatch -c $threads --mem=$memory --output=$output_dir/deconseq.out $scripts_path/deconseq.sh $input $output_dir 95 94
