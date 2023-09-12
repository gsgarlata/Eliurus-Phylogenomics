#!/bin/sh
#SBATCH -p workq

threads=3
memory=30G

info_file=Eliurus_sp.popmap

path_data=$1
scripts_path=$2

m=2
M=6
n=6

catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n

out_dir=$catalog_dir/$sub_dir

mkdir -p $out_dir

echo $catalog_dir

cat ${info_file} | cut -f 1 | while read id; do

ln -s $catalog_dir/${id}* $out_dir

done

sbatch -c $threads --output=$out_dir/gstacks.out --mem=$memory $scripts_path/gstacks.sh $out_dir ${info_file} $threads
