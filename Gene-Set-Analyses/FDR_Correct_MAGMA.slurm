#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=6:00:00
#SBATCH--mem=7GB
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_MAGMA_FDR_Correct
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.out

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/FDR_Correct_MAGMA.sh
