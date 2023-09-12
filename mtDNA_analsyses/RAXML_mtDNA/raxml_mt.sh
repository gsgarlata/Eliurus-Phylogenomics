#!/bin/sh
#SBATCH -p workq
#SBATCH -N 1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2-24:00:00 #days-hh:mm:ss

threads=$1
input_file=$2
data_dir=$3
output_name=$4
outgroup=$5

echo "run Raxml"
cd $data_dir

module load bioinfo/standard-RAxML-8.2.11
module load compiler/gcc-4.8.5
module load mpi/openmpi-2.1.2


raxmlHPC-MPI -f a -m GTRCAT -o $outgroup -p $RANDOM -x $RANDOM -# autoMRE -s $input_file -n $output_name
