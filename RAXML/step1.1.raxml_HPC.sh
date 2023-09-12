#!/bin/bash
#SBATCH -p workq
#SBATCH -N 1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --time=3-24:00:00 #days-hh:mm:ss

module load bioinfo/standard-RAxML-8.2.11
module load compiler/gcc-4.8.5
module load mpi/openmpi-2.1.2

input_name=$1
output_name=$2
script_path=$3

threads=20
ASC_BIAS=FALSE

model=GTRCAT

if [[ "$ASC_BIAS" = TRUE ]]; then

raxmlHPC-MPI -f a -p $RANDOM -T $threads -m $model --asc-corr=lewis -x $RANDOM -# autoMRE_IGN -s $input_name -n $output_name

else

raxmlHPC-MPI -f a -p $RANDOM -T $threads -m $model -x $RANDOM -# autoMRE_IGN -s $input_name -n $output_name

fi
