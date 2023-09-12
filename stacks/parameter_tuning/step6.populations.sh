#!/bin/sh
#SBATCH -p workq

threads=3
memory=10G
popmap=catalog_Eliurus_sp.popmap

path_data=$1
scripts_path=$2

#####START: run iteration on "M", that is the number of mismatches allowed between stacks (putative alleles)
#####to merge them into a putative locus
for M in 2 3 4 5 6 7 8; do

n=1
m=3

stacks_dir=$path_data/parameter_tuning/stacks.m$m.M$M
catalog_dir=$stacks_dir/catalog.m$m.M$M.n$n

for perc_ind in 0.40 0.60 0.80; do

output_dir=$catalog_dir/population.r.$perc_ind

mkdir -p $output_dir

sbatch -c $threads --mem=$memory $scripts_path/populations.sh $catalog_dir ${popmap} $output_dir $perc_ind $threads FALSE $catalog_dir/decon_blacklist 0.05 0.70
done
done
#####END: run iteration on "M", that is the number of mismatches allowed between stacks (putative alleles)

#####START: run iteration on "m", that is the minimum depth value for a stack
#####
for m in 2 4 5 6 7 8; do

M=2
n=1

stacks_dir=$path_data/parameter_tuning/stacks.m$m.M$M
catalog_dir=$stacks_dir/catalog.m$m.M$M.n$n

for perc_ind in 0.40 0.60 0.80; do

output_dir=$catalog_dir/population.r.$perc_ind

mkdir -p $output_dir

sbatch -c $threads --mem=$memory $scripts_path/populations.sh $catalog_dir ${popmap} $output_dir $perc_ind $threads FALSE $catalog_dir/decon_blacklist 0.05 0.70
done
done
#####END: run iteration on "m", that is the minimum depth value for a stack

#####START: run iteration on "n", that is the number of mismatches allowed between stacks
#####
for n in 2 3 4 5 6 7 8; do

M=2
m=3

stacks_dir=$path_data/parameter_tuning/stacks.m$m.M$M
catalog_dir=$stacks_dir/catalog.m$m.M$M.n$n

for perc_ind in 0.40 0.60 0.80; do

output_dir=$catalog_dir/population.r.$perc_ind

mkdir -p $output_dir

sbatch -c $threads --mem=$memory $scripts_path/populations.sh $catalog_dir ${popmap} $output_dir $perc_ind $threads FALSE $catalog_dir/decon_blacklist 0.05 0.70
done
done
#####END: run iteration on "n", that is the number of mismatches allowed between stacks
