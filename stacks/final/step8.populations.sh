#!/bin/sh
#SBATCH -p workq
#SBATCH -c 8
#SBATCH --mem=200G
path_data=$1
scripts_path=$2

threads=8
memory=100G
popmap=Eliurus_sp.popmap #E_carletoni_1inds_site_p62.popmap #E_carletoni_10inds_species_p48.popmap
npop=1
min_pop=1

m=2
M=5
n=6

perc_ind=0.80
min_all_fr=0.05
max_obs_het=0.70

black_list_path=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n/White_list_dir/black_list
catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n

echo $catalog_dir

output_dir=$catalog_dir

mkdir -p $output_dir

sbatch -c $threads --mem=$memory $scripts_path/populations.sh $catalog_dir ${popmap} $output_dir $perc_ind $threads $black_list_path $min_all_fr $max_obs_het $min_pop
