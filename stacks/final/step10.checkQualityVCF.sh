#!/bin/sh
#SBATCH -p workq

module load bioinfo/tabix-0.2.5
module load bioinfo/vcftools-0.1.15

path_data=$1

m=2
M=5
n=6

input_path=$path_data/final/stacks.m$m.M$M/catalog.m$m.M$M.n$n
input_data=$path_data/populations.snps.vcf
output_data=$path_data/populations.snps

vcftools --vcf $input_data --freq2 --out $output_data

vcftools --vcf $input_data --depth --out $output_data

vcftools --vcf $input_data --site-mean-depth --out $output_data

vcftools --vcf $input_data --site-quality --out $output_data

vcftools --vcf $input_data --missing-indv --out $output_data

vcftools --vcf $input_data --missing-site --out $output_data

vcftools --vcf $input_data --het --out $output_data
