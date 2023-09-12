#!/bin/sh
#SBATCH -p workq

module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2

stacks_dir=$1
pop_dir=$2
samples_dir=$3
threads=$4

#-P: input directory, where the results of ustacks,cstacks and sstacks are included.
#-M: population map. -R: directory where to find the paired-end reads files (in fastq/fasta/bam (gz) format).
#-t: number of threads to use.

tsv2bam -P $stacks_dir -M $pop_dir -R $samples_dir -t $threads
