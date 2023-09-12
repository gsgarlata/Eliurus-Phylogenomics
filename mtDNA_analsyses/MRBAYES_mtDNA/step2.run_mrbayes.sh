#!/bin/bash
#SBATCH -p workq
#SBATCH -t 04-00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
#SBATCH --constraint broadwell
#SBATCH --nodes=4
#SBATCH --mem=10G

#Load modules
#Need Openmpi and compiler
module load compiler/gcc-4.8.5 mpi/openmpi-2.1.2

module load bioinfo/MrBayes-3.2.7-MPI

mpirun mb_mpi ./mtDNA_Eliurus_command.nex >  ./output/log.txt
