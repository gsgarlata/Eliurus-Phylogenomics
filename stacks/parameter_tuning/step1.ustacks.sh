#!/bin/sh
#SBATCH -p workq

memory=10G
threads=3
input_dir=$1
path_output=$2
scripts_path=$3
info_file=catalog_Eliurus_sp_info.tsv

#####START: run iteration on "M", that is the number of mismatches allowed between stacks (putative alleles)
#####to merge them into a putative locus
for M in 2 3 4 5 6 7 8; do

m=3
count=0

cat $info_file | while read indv;  do

count=$((count+1))

echo $indv $count

out_dir=$path_output/parameter_tuning/stacks.m$m.M$M

mkdir -p $out_dir

sbatch -c $threads --output=$out_dir/us.$indv.oe --mem=$memory $scripts_path/ustacks.sh $threads $input_dir/${indv}.1.fq.gz $count $out_dir $m $M $indv

done
done
#####END: iteration on "M"

#####START: run iteration on "m", that is the minimum depth value for a stack
#####
for m in 2 4 5 6 7 8; do

M=2
count=0

cat $info_file | while read indv;  do

count=$((count+1))

echo $indv $count

out_dir=$path_output/parameter_tuning/stacks.m$m.M$M

mkdir -p $out_dir

sbatch -c $threads --output=$out_dir/us.$indv.oe --mem=$memory $scripts_path/ustacks.sh $threads $input_dir/${indv}.1.fq.gz $count $out_dir $m $M $indv

done
done
#####END: run iteration on "m", that is the minimum depth value for a stack
