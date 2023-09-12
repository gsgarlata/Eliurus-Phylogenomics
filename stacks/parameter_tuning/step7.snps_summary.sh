#!/bin/sh
#SBATCH -p workq


echo -e '#par_set\tm\tM\tn\tr\tn_snps\tn_loci' > $path_data/parameter_tuning/n_snps_per_locus.tsv

for stacks_dir in $path_data/parameter_tuning/stacks.m* ; do

for catalog_dir in $stacks_dir/catalog.m* ; do

for population_dir in $catalog_dir/population.r.0.* ; do

sed -n '/BEGIN snps_per_loc_postfilters/,/END snps_per_loc_postfilters/ p' $population_dir/populations.log.distribs | grep -E '^[0-9]' > $population_dir/snps_per_loc.log

paramet_comb=$(echo $catalog_dir | sed "s,${stacks_dir}/catalog.,,g")
vabe=$(echo $population_dir | sed "s,${catalog_dir}/population.r.0.,,g")
paramet_comb=$(echo $paramet_comb.r$vabe)
paramet_comb_new=$(echo $paramet_comb | sed "s,\.,-,g")
test=$(echo $paramet_comb_new | grep -o -E '[0-9]+')
test=(${test[@]})

line_prefix=$(echo $paramet_comb_new\\t${test[0]}\\t${test[1]}\\t${test[2]}\\t${test[3]}\\t)

sed -r "s/^/$line_prefix/" $population_dir/snps_per_loc.log >> $path_data/parameter_tuning/n_snps_per_locus.tsv

done
done
done


echo -e '#par_set\tm\tM\tn\tr\tTotalSites\tVariantSites\tFixedSites' > $path_data/parameter_tuning/count_fixed_variant.tsv

for stacks_dir in $path_data/parameter_tuning/stacks.m* ; do

for catalog_dir in $stacks_dir/catalog.m* ; do

population_dir=$catalog_dir/population.r.0.80

paramet_comb=$(echo $catalog_dir | sed "s,${stacks_dir}/catalog.,,g")
vabe=$(echo $population_dir | sed "s,${catalog_dir}/population.r.0.,,g")
paramet_comb=$(echo $paramet_comb.r$vabe)
paramet_comb_new=$(echo $paramet_comb | sed "s,\.,-,g")

test=$(echo $paramet_comb_new | grep -o -E '[0-9]+')
test=(${test[@]})

values=$(sed -e '1,5d' $population_dir/populations.sumstats_summary.tsv | awk '{print $3,$4}')

values=(${values[@]})

fixed="$((${values[0]}-${values[1]}))"

echo -e $paramet_comb_new\\t${test[0]}\\t${test[1]}\\t${test[2]}\\t${test[3]}\\t${values[0]}\\t${values[1]}\\t${fixed} >> $path_data/parameter_tuning/count_fixed_variant.tsv

done
done
