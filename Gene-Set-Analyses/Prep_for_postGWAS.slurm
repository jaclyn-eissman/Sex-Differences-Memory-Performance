#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=18:00:00
#SBATCH--mem=18GB
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_postGWAS_prep
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.out

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Prep_for_postGWAS.sh
