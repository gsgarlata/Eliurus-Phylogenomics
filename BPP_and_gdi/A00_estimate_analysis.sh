data_dir=output_dir
phylip_data=BPP_Emyox_Emin_Espnova_npop15_pop5_p4_3ind_per_species_min15.phy
imap_data=BPP_Emyox_Emin_Espnova_3ind_per_species_Imap.txt
analysis_type=estimate_template

number_loci=$(cat list_partitions | wc -l)



###START: Generate input files from template###
###The input file are generated for 4 replicates for each of the###
###six combinations of alpha and beta values.###
for i in $(seq 1 6); do

for j in $(seq 1 4); do

run_dir=combination${i}/run${j}

mkdir -p $run_dir

cp template_dir/${analysis_type}/A00.bpp${i}.ctl $run_dir/A00.bpp${i}_run${j}.ctl

cp $phylip_data $data_dir

cp ${imap_data} $data_dir

sed -i "s,template_input_path,${data_dir},g" $run_dir/A00.bpp${i}_run${j}.ctl
sed -i "s/seq_file_name/${phylip_data}/g" $run_dir/A00.bpp${i}_run${j}.ctl
sed -i "s/Imap_file_name/${imap_data}/g" $run_dir/A00.bpp${i}_run${j}.ctl

sed -i "s,template_output_path,${run_dir},g" $run_dir/A00.bpp${i}_run${j}.ctl
sed -i "s/n_partitions/${number_loci}/g" $run_dir/A00.bpp${i}_run${j}.ctl

done
done
###END: Generate input files from template###



###START: Run AO1 species delimitation analysis in BPP###
###Analysis is repeated 4 times for each combination of alpha and beta parameters###

for i in $(seq 1 6); do

for j in $(seq 1 4); do

run_dir=combination${i}/run${j}

control_file=$run_dir/A00.bpp${i}_run${j}.ctl

cd $run_dir

sbatch --job-name=comb${i}_run${j}_A00 ./run_bpp.sh $control_file

done
done
###END: Run AO1 species delimitation analysis in BPP###
