#!/bin/sh
#SBATCH -p workq

module load bioinfo/samtools-1.12

indv=$1

samtools view -f 0x40 ${indv}.PE_filtered.bam | awk '$10 ~ /^TGCAGG/' | cut -f 3,4 | tr '\t' '_' | sort | uniq -c | sort -k1 -nr | sed -E 's/^ *//; s/ /\t/' > ${indv}.coverage.txt

