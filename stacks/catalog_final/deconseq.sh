#!/bin/sh
#SBATCH -p workq


module load bioinfo/deconseq-standalone-0.4.3

input=$1
output_dir=$2
coverage=$3
identity=$4


deconseq.pl -f $input -out_dir $output_dir -dbs bact,vir,hsref -c $coverage -i $identity -keep_tmp_files


grep -o -E "^>\w+" $output_dir/*_cont.fa | tr -d ">" > $output_dir/decon_blacklist

mv $output_dir/decon_blacklist $output_dir/..

gzip $input
