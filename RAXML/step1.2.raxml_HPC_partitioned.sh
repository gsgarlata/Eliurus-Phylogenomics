#!/bin/bash
#SBATCH -p workq
#SBATCH -N 1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --time=3-24:00:00 #days-hh:mm:ss

module load compiler/gcc-4.8.5
module load mpi/openmpi-2.1.2

input_name=$1
output_name=$2
partition_file=$3
script_path=$4
path_RAXML=$5

ASC_BIAS=FALSE
threads=10

model=GTRCAT

if [[ "$ASC_BIAS" = TRUE ]]; then

$path_RAXML/raxmlHPC-MPI -f a -p $RANDOM -T $threads -M -m $model --asc-corr=lewis -q $partition_file -x $RANDOM -# autoMRE_IGN -s $input_name -n $output_name

else

$path_RAXML/raxmlHPC-MPI -f a -p $RANDOM -T $threads -M -m $model -q $partition_file -x $RANDOM -# autoMRE_IGN -s $input_name -n $output_name

fi
