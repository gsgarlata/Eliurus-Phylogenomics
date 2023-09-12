#!/bin/sh
#SBATCH -p workq

module load compiler/gcc-9.3.0
module load bioinfo/angsd-0.935


bamList=$1
gmin=$2
gmax=$3
mindepthind=$4
maxdepthind=$5
minind=$6
genome=$7
threads=$8
out_data=$9

#doCounts: Count the number A,C,G,T. All sites, All samples. If '1', it going to count the bases, '0' otherwise.
#setMinDepth: Discard site if total sequencing depth (all individuals added together) is below INT
#setMaxDepth: Discard site if total sequencing depth (all individuals added together) is above INT
#setMinDepthInd: Discard individual if sequencing depth for an individual is below INT. This filter is only applied to analysis which are based on counts of alleles.
#setMaxDepthInd: Discard individual if sequencing depth for an individual is above INT. This filter is only applied to analysis which are based on counts of alleles i.e. analysis that uses -doCounts.
#minInd: Only keep sites with at least $mindepthind from at least N individuals.
#GL: Defines the method used to compute genotype likelihood. 1. SAMtools model; 2. GATK model; 3. SOAPsnp model; 4. SYK model.
#out: it defines the name prefix of the output file
#nThreads: number of threads for parallelization.
#ref: specify the reference genome. In our case,we do not have a reference genome, therefore we will use the catalog file constructed in STACKS.
#doGlf: Output the log genotype likelihoods to a file. 0. don't output the genotype likelihoods (default); 1. binary all 10 log genotype likelihood; 2. beagle genotype likelihood format (use directly for imputation); 3. beagle binary; 4. textoutput of all 10 log genotype likelihoods.
#doMajorMinor: From input sequencing data like bam files, it infers he major and minor allele. They use a maximum likelihood approach to choose the major and minor alleles (Skotte, 2012).
#SNP_pval: Remove sites with a pvalue larger than FLOAT.
#doMaf: If '1' both the major and minor allele is assumed to be known (inferred or given by user).
#bam: provides the list of bam files to analyse.

angsd -doCounts 1 -setMinDepth $gmin -setMaxDepth $gmax -setMaxDepthInd $maxdepthind -setMinDepthInd $mindepthind -minInd $minind -GL 1 -out $out_data -ref $genome -P $threads -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1 -bam $bamList  -minQ 20 -minMapQ 30 -minMaf 0.05 -uniqueOnly 1 -remove_bads 1 -C 50 -baq 1 -skipTriallelic 1 -only_proper_pairs 1 > ${out_data}.out
