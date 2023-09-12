#!/bin/sh
#SBATCH -p workq

memory=10G
threads=3
info_file=Eliurus_sp.info

m=2
M=2
n=4

catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n

mkdir -p $catalog_dir

echo $catalog_dir

cat ${info_file} | while read indv_ID; do

sbatch -c $threads --output=$catalog_dir/sstacks.${indv_ID}.out --mem=$memory $scripts_path/sstacks.sh $catalog_dir ${info_file} $threads $indv_ID

done
