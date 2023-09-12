#!/bin/sh
#SBATCH -p workq

path_data=$1
path_script=$2

threads=4
MINMAPQUAL=20
FILTER_PAIRED_END=TRUE
info_file=Eliurus_sp.info

cat ${info_file} | while read indv; do

sbatch -c $threads --mem=10G $path_script/sort_mapQual.sh ${indv} $path_data $MINMAPQUAL $threads $FILTER_PAIRED_END

done
