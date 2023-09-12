#!/bin/sh
#SBATCH -J launchCoverage
#SBATCH -o launchCoverage.out
#SBATCH --mem=30G
#SBATCH -c 6

module load system/R-3.5.2 libraries/gdal-2.3.0 libraries/proj-4.9.3

path_angsd=$1
path_coverage=$2
scripts_path=$3

info_file=Eliurus_sp.info
threads=6

mkdir -p $path_coverage

mv $path_angsd/*coverage.txt $path_coverage

Rscript --vanilla $scripts_path/comb_coverage.R $info_file $path_coverage $threads
