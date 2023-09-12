#!/bin/sh
#SBATCH -c 8
#SBATCH --mem=10G
#SBATCH -p workq

module load bioinfo/samtools-1.12

ID=$1
path_data=$2
MINMAPQUAL=$3
threads=$4
FILTER_PAIRED_END=$5

indv=$path_data/${ID}


NRSEQS_ALIGN=$(samtools view -c ${indv}.bam)

samtools view -bhu -q $MINMAPQUAL -@ $threads ${indv}.bam | samtools sort -@ $threads -m 4G -T tmp -O bam > ${indv}.MQ_only.bam

NRSEQS_MAPQUALITY=$(samtools view -c ${indv}.MQ_only.bam)

if [ "$FILTER_PAIRED_END" = TRUE ]; then

samtools view -f 0x2 ${indv}.MQ_only.bam -O bam > ${indv}.PE_filtered.bam

NRSEQS_POSTPAIR=$(samtools view -c ${indv}.PE_filtered.bam)

else

echo "no Paired-end filtering"

fi


echo -e "ID\tBAMreads\tMQreads\tPEreads" > ${indv}_bam_stats.tsv

echo -e "${ID}\t${NRSEQS_ALIGN}\t${NRSEQS_MAPQUALITY}\t${NRSEQS_POSTPAIR}" >> ${indv}_bam_stats.tsv

samtools index -b ${indv}.PE_filtered.bam

rm ${indv}.MQ_only.bam
rm ${indv}.bam


