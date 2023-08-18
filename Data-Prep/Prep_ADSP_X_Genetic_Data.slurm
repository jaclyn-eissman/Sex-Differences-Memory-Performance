#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
#SBATCH--nodes=1
#SBATCH--ntasks=1
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--mem=12G
#SBATCH--time=12:00:00
#SBTACH--restraint=skylake
#SBATCH--job-name=prep_X_data
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.log

#Run script
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Prep_ADSP_X_Genetic_Data.sh
