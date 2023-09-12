#!/bin/sh
#SBATCH -p workq


threads=3
info_file=Eliurus_sp.info

path_data=$1
path_catalog=$2

m=2
M=2
n=4

catalog_dir=$path_catalog/catalog_final/stacks.m$m.M$M/catalog.m$m.M$M.n$n
output_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n
stacks_dir=$path_data/final/stacks.m$m.M$M

mkdir -p $output_dir

ln -s $catalog_dir/catalog* $output_dir
ln -s $catalog_dir/decon_blacklist $output_dir

ln -s $stacks_dir/*.gz $output_dir
