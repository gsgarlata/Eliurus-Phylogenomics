#!/bin/bash
#SBATCH -p workq
#SBATCH -c 8
#SBATCH --time=2-24:00:00 #days-hh:mm:ss

module load bioinfo/standard-RAxML-8.2.11
module load compiler/gcc-4.8.5
module load mpi/openmpi-2.1.2


input_name=$1
output_name=$2
ASC_BIAS=TRUE

model=GTRCAT
n_threads=8

echo $input_name

if [[ "$ASC_BIAS" = TRUE ]]; then

raxmlHPC-MPI -f T -p $RANDOM --asc-corr=lewis -m $model -x $RANDOM -# autoMRE_IGN -s $input_name -n $output_name

else

raxmlHPC-MPI -f T -p $RANDOM -m $model -x $RANDOM -# autoMRE_IGN -s $input_name -n $output_name

fi
