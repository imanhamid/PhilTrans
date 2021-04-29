#!/bin/bash
#SBATCH -p scavenger
#SBATCH --job-name="localancestry"
#SBATCH -a 1-10
#SBATCH --mem=20G

c=$SLURM_ARRAY_TASK_ID

declare -i c10="${c}0"


for i in {0..9};
do

c_array[$i]=$((c10 - i))

done

for i in "${c_array[@]}"
do
#filename=$(ls /work/ih49/simulations/PhilTrans/Fst/wholeautosome_12gen_m-0.5_Fst-0*_seed-$i.trees | head -n 1)
#~/home/PhilTrans/localancestry_proportions_sample.py $filename

filename=$(ls /work/ih49/simulations/PhilTrans/Fst/wholeautosome_12gen_m-0.5_Fst-0.25*_seed-$i.trees | head -n 1)
~/home/PhilTrans/localancestry_proportions_sample.py $filename

filename=$(ls /work/ih49/simulations/PhilTrans/Fst/wholeautosome_12gen_m-0.5_Fst-0.6*_seed-$i.trees | head -n 1)
~/home/PhilTrans/localancestry_proportions_sample.py $filename

filename=$(ls /work/ih49/simulations/PhilTrans/Fst/wholeautosome_12gen_m-0.5_Fst-1*_seed-$i.trees | head -n 1)
~/home/PhilTrans/localancestry_proportions_sample.py $filename

done
