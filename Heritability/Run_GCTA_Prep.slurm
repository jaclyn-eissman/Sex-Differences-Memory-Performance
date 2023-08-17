#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=6
#SBATCH--cpus-per-task=1
#SBATCH--time=18:00:00
#SBATCH--mem=48GB
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_GCTA_prep
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.out

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_GCTA_Prep.sh
