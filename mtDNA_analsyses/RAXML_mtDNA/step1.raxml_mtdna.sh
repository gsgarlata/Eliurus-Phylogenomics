#!/bin/sh
#SBATCH -p workq

input_file=Eliurus_cytb_aligned_haps.fas
data_dir=./input

output_name=Eliurus_spp_cytb_mtDNA_sequenced
threads=10
outgroup=EU349782.1

echo "run Raxml"

sbatch --cpus-per-task=$threads --mem=8G  -J rax.mt.$input_file -o ./raxml.mt.$input_file ./raxml_mt.sh $threads $input_file $data_dir $output_name $outgroup
