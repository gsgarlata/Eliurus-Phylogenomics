#!/bin/sh
#SBATCH -p workq

memory=10G
threads=3
info_file=catalog_Eliurus_sp_info.tsv

input_dir=$1
scripts_path=$2
path_out=$3

m=2
M=2

cat ${info_file} | while read indv;  do

count=$((count+1))

echo $indv $count

out_dir=$path_out/catalog_final/stacks.m$m.M$M

mkdir -p $out_dir

sbatch -c $threads --output=$out_dir/us.$indv.oe --mem=$memory $scripts_path/ustacks.sh $threads $input_dir/$indv.1.fq.gz $count $out_dir $m $M $indv 0.05
done
