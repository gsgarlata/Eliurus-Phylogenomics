#!/bin/bash
#SBATCH -c 8
#SBATCH -p workq

threads=4

path_bam=$1 #$proj_path/results/ANGSD/bam/${sub_proj}/${dataset}
catalog_dir=$2 #/home/lchikhi/save/RAD/eliurus/catalogs/${dataset}
reference_dir=$3 #$proj_path/results/ANGSD/reference/${dataset}
info_file=$4
path_input=$5

mkdir -p $reference_dir

cp $catalog_dir/catalog.fa.gz $reference_dir

mkdir -p $path_bam

cat ${info_file} | while read indv; do

read_group=$(echo "@RG\tID:group1\tSM:$indv\tPL:illumina\tLB:lib1")

sbatch $path_script/bwa_align.sh ${path_input}/${indv} ${path_bam}/${indv} $reference_dir/catalog $read_group $threads

done
