#!/bin/sh
#SBATCH -p workq

module load compiler/gcc-4.9.1
module load bioinfo/stacks-2.2
#-f: input file path; -i: a unique integer ID for this sample; -o: output path to write results; 
#-m: Minimum depth of coverage required to create a stack; -M: Maximum distance (in nucleotides) allowed between stacks;
#-p: enable parallel execution with num_threads threads; -t: input file type, in our case 'gzfastq';
#-d: enable the Deleveraging algorithm, used for resolving over merged stacks (when more than 2 alleles are detected per locus)



threads=$1
indv=$2
id=$3
out_dir=$4
mm=$5
MM=$6
sample=$7

ustacks -f $indv -i $id -o $out_dir -m $mm -M $MM -p $threads -d -t gzfastq --max_locus_stacks 3 --name $sample
