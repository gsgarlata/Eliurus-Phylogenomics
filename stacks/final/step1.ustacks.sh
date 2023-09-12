#!/bin/sh
#SBATCH -p workq

memory=10G
threads=3
info_file=Eliurus_sp.info

path_data=$1
scripts_path=$2
input_dir=$3

m=2
M=2

cat ${info_file} | while read indv;  do

count=$((count+1))

echo $indv $count

out_dir=$path_data/final/stacks.m$m.M$M

mkdir -p $out_dir

sbatch -c $threads --output=$out_dir/us.$indv.oe --mem=$memory $scripts_path/ustacks.sh $threads $input_dir/$indv.1.fq.gz $count $out_dir $m $M $indv 0.05
done
