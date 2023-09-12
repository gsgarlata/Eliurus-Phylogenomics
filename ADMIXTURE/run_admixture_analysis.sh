#!/bin/sh
#SBATCH -p workq

scripts_path=./ADMIXTURE
input_dir=./input

infile=$input_dir/Eliurus_sp_npop125_pop5_p4_r0.80_all_sp_nova_proj_min100
maxK=6
nCV=20

#create an array with all K values to be tested
val=$(eval echo {1..$maxK})
#create an array with all repetitions (30 in this case)
nrep=($(echo {1..30}))

#create a replicate folder and symbolic links of the input files
for n in ${nrep[@]};do

#create a folder for a given replicate
mkdir -p $input_dir/replicate_${n}

#create the symbolic link of the input files
ln -s $input_dir/${infile}* $input_dir/replicate_${n}

#change the name of the input files, by adding the replicate ID
mv $input_dir/replicate_${n}/${infile}.ped $input_dir/replicate_${n}/${infile}_${n}.ped
mv $input_dir/replicate_${n}/${infile}.map $input_dir/replicate_${n}/${infile}_${n}.map

done

#perform ADMIXTURE analysis for each replicate and K value
for K in ${val[@]}; do

for n in ${nrep[@]};do

sbatch $scripts_path/admixture.sh $input_dir/replicate_${n}/${infile}_${n}.ped $K $nCV $input_dir/replicate_${n}/log${K}_${n}.out

done
done
