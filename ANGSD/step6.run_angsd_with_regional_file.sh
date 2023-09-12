#!/bin/sh
#SBATCH -p workq

path_genome=$1
path_angsd=$2
res_dir=$3
path_script=$4
out_name=$5


bamList=Eliurus_sp_bamList.tsv
cov_min=250
cov_max=5582
mindepthind=5
maxdepthind=81
minind=100
threads=2
memory=50G
loci_set_size=10000

genome=$path_genome/catalog.fa

mkdir -p $res_dir

pre_out_data=$res_dir/${out_name}

ls $path_angsd/*.PE_filtered.bam > $path_angsd/$bamList

sed "s,$path_angsd/,,g" $path_angsd/$bamList | sed 's/.PE_filtered.bam//g' > $path_angsd/list_BAM_ordered.tsv


grep ">" $genome | cut -d " " -f1 | sed 's/[>]//g' | sort -n > $path_genome/catalog_list_loci

n_loci=$(cat $path_genome/catalog_list_loci | wc -l)

count=1
setN=1

for i in $(seq $loci_set_size $loci_set_size $n_loci);do

sed -n "${count},${i}p" $path_genome/catalog_list_loci > $path_angsd/list_loci_set${setN}

count=$((i + 1))
setN=$((setN + 1))
done

if [[ "$i" < "$n_loci" ]]; then

count=$((i + 1))
sed -n "${count},${n_loci}p" $path_genome/catalog_list_loci > $path_angsd/list_loci_set${setN}
else

echo 'everything is fine'

fi


for region_file in $path_angsd/list_loci_set*; do

id_out=$(echo $region_file | sed "s,$path_angsd/list_loci_,,g")

out_data=${pre_out_data}_${id_out}

sbatch -c $threads --error=angsd_${dataset_angsd}_${id_out} --mem=$memory --job-name=angsd_${dataset_angsd}_${id_out} $path_script/angsd.sh $path_angsd/$bamList $cov_min $cov_max $mindepthind $maxdepthind $minind $genome $threads $out_data $region_file

done
