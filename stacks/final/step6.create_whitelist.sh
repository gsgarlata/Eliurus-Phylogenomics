#!/bin/sh
#SBATCH -p workq

threads=3
memory=50G
popmap=Eliurus_sp.popmap

path_data=$1
scripts_path=$2
npop=$3
min_pop=$4

m=2
M=5
n=6

perc_ind=0.80
min_all_fr=0.05
max_obs_het=0.70


catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n
out_dir=$catalog_dir

white_list_path=$catalog_dir/White_list_dir

echo $catalog_dir

mkdir -p $white_list_path

sbatch -c $threads --mem=$memory $scripts_path/populations_whitelist.sh $out_dir ${popmap} $white_list_path $perc_ind $threads $catalog_dir/decon_blacklist $min_all_fr $max_obs_het $min_pop
