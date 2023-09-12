#!/bin/bash
#SBATCH  -p workq

module load bioinfo/bwa-0.7.17
module load bioinfo/samtools-1.12

genome=$1

gunzip ${genome}.fa.gz

bwa index ${genome}.fa
samtools faidx ${genome}.fa

