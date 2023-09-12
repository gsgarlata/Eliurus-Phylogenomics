#!/bin/sh
#SBATCH -p workq




module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2

stacks_dir=$1
popmap=$2
output_dir=$3
perc_ind=$4
threads=$5
black_list_path=$6
min_maf=$7
max_obs_het=$8
min_pop=$9

#-P: path to the directory containing the Stacks files; -O: path to a directory where to write the output files (default: the same as -P);
#-M: path to a population map; -t: umber of threads to run in parallel sections of code; -r : minimum percentage of individuals
# in a population required to process a locus for that population; --max_obs_het:
#--verbose: turn on additional logging. --write_single_snp: restrict data analysis to only the first SNP per locus;
# --write_random_snp: restrict data analysis to one random SNP per locus.
#--fasta_loci: output locus consensus sequences in FASTA format; --fasta_samples: output the sequences of the two haplotypes of each
#(diploid) sample, for each locus, in FASTA format. --vcf:output SNPs in Variant Call Format (VCF);
#--phylip: output nucleotides that are fixed-within, and variant among populations in Phylip format for phylogenetic tree construction;
#--phylip_var: include variable sites in the phylip output encoded using IUPAC notation;
#--fasta_samples_raw: output all haplotypes observed in each sample, for each locus, in FASTA format.

populations -P $stacks_dir -M $popmap -O $output_dir -p $min_pop -r $perc_ind --min_maf $min_maf --max_obs_het $max_obs_het -t $threads -B $black_list_path --write_random_snp --plink --phylip_var --phylip-var-all --vcf --phylip --verbose
