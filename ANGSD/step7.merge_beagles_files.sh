#!/bin/sh
#SBATCH -p workq

path_bam=$1
path_out=$2
output_angsd=$3

mkdir -p $path_out

end_beagle_file=$path_out/${output_angsd}.beagle
end_maf_file=$path_out/${output_angsd}.mafs

touch $path_out/${output_angsd}.arg

cd $path_bam

list_setID=$(ls list_loci_set* | sed 's,list_loci_set,,g' | sort -n)

zcat $path_out/${output_angsd}_set1.beagle.gz | head -n 1 > $end_beagle_file
zcat $path_out/${output_angsd}_set1.mafs.gz | head -n 1 > $end_maf_file

mkdir -p $path_out/set_files

for setID in $list_setID; do

zcat $path_out/${output_angsd}_set${setID}.beagle.gz | tail -n +2 >> $end_beagle_file
zcat $path_out/${output_angsd}_set${setID}.mafs.gz | tail -n +2 >> $end_maf_file
cat $path_out/${output_angsd}_set${setID}.arg >> $path_out/${output_angsd}.arg

mv $path_out/${output_angsd}_set${setID}.* $path_out/set_files

done

gzip $end_beagle_file
gzip $end_maf_file


zcat $end_maf_file | cut -f 1 | sort -nu | tail -n +2 > $path_out/list_unique_loci
