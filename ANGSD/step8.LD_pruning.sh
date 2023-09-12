#!/bin/sh
#SBATCH -p workq
#SBATCH -c 10

path_angsd=$1
pre_file=$2
path_bam=$3
path_ngsLD=$4

for file_id in ${pre_file}_set10; do

beagle_file=${file_id}.beagle.gz
output_file=${file_id}_no_miss.ld

NIND=$(cat $path_bam/list_BAM_ordered.tsv | wc -l)

zcat $beagle_file | cut -f 1 | tail -n +2 | sed 's/_/\t/g' > ${file_id}.pos

NSITES=$(cat ${file_id}.pos | wc -l)

$path_ngsLD/ngsLD --n_threads 10 --verbose 1 --n_ind $NIND --n_sites $NSITES --geno $beagle_file --probs --pos ${file_id}.pos --max_kb_dist 0 --max_snp_dist 0 --min_maf 0.05 --extend_out --call_geno --N_thresh 0.4 --call_thresh 0.9 --ignore_miss_data | sort -k 1,1V -k 2,2V > $output_file

done
