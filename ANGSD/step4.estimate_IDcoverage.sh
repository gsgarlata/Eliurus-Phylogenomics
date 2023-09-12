#!/bin/sh
#SBATCH -p workq

info_file=Eliurus_sp_nova_add.info

path_angsd=$1
path_script=$2

cat ${info_file} | while read indv; do

sbatch $path_script/coverage_ind.sh $path_angsd/${indv}

done
