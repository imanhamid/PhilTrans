#!/bin/bash
#SBATCH -p scavenger
#SBATCH --job-name="Rstats"
#SBATCH -a 1-10
#SBATCH --mem=10G

module load R/4.0.0

for file in /work/ih49/simulations/PhilTrans/Fst/*.csv

do

~/home/PhilTrans/calcpercentile.R $file >>\
 /work/ih49/Rstats/PhilTrans/Fst/Rstats.out

done
