#!/bin/bash
#SBATCH -p scavenger
#SBATCH -a 1-10
#SBATCH --mem=10G

module load R/4.0.0

c=$SLURM_ARRAY_TASK_ID

~/home/PhilTrans/run_SLiM_Fst.R --seed=${c} --freq1=1 --freq2=0 -o /work/ih49/simulations/PhilTrans/Fst/\
 --slim_dir=/hpc/home/ih49/home/SLiM_build/slim\
 --slim_model=/hpc/home/ih49/home/PhilTrans/Fst_whole-autosome.slim
