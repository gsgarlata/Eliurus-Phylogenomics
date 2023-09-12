#!/bin/sh
#SBATCH -p workq

path_data=$1
npop=1
min_pop=1

m=2
M=5
n=6

perc_ind=0.80
min_all_fr=0.05
max_obs_het=0.70

catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n
white_list_path=$catalog_dir/White_list_dir

out_dir=$catalog_dir

zgrep ">" $out_dir/catalog.fa.gz | cut -d " " -f1 | sed 's/[>]//g' | sort > $out_dir/catalog_loci_list

grep -v "^#" $white_list_path/populations.sumstats.tsv | cut -f 1 | sort -V | uniq > $white_list_path/white_list

sort $white_list_path/white_list > $white_list_path/white_list_temp
comm -3 $out_dir/catalog_loci_list $white_list_path/white_list_temp > $white_list_path/black_list

rm $out_dir/catalog_loci_list
rm $white_list_path/white_list_temp
