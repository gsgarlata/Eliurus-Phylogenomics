#!/bin/sh
#SBATCH -p workq

path_data=$1

m=2
M=5
n=8

perc_ind=0.80
min_all_fr=0.05
max_obs_het=0.70

catalog_dir=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n
output_dir=$catalog_dir

sed -n '/positions/,// p' $output_dir/populations.sumstats_summary.tsv | tail -n +2 | sed '$d' > $output_dir/summary_stat_variant_sites.tsv

sed -n '/All/,// p' $output_dir/populations.sumstats_summary.tsv | tail -n +2 > $output_dir/summary_stat_all_sites.tsv
