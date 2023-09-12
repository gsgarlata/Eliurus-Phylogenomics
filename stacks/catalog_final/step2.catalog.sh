#!/bin/sh
#SBATCH -p workq

threads=3
memory=30G
info_file=catalog_Eliurus_sp.popmap

path_data=$1
scripts_path=$2

m=2
M=2
n=4

stacks_dir=$path_data/catalog_final/stacks.m$m.M$M
catalog_dir=$stacks_dir/catalog.m$m.M$M.n$n

echo $catalog_dir

mkdir -p $catalog_dir

ln -s $stacks_dir/*.gz $catalog_dir

sbatch -c $threads --output=$catalog_dir/cstacks.out --mem=$memory $scripts_path/cstacks.sh $catalog_dir ${info_file} $n $threads
