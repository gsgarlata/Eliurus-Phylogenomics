#!/bin/bash
#SBATCH  -p workq

module load bioinfo/bwa-0.7.17
module load bioinfo/samtools-1.12
module load bioinfo/picard-2.20.7


input=$1
output=$2
genome=$3
READGROUP_STRING=$4
threads=$5


java -Xmx4g -jar $PICARD CreateSequenceDictionary REFERENCE=${genome}.fa OUTPUT=${genome}.dict


bwa mem ${genome}.fa -aM -R $READGROUP_STRING -t $threads ${input}.1.fq.gz ${input}.2.fq.gz | samtools view -b -h > ${output}.bam
