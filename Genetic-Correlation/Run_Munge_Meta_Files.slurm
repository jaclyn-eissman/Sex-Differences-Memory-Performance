#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=12:00:00
#SBATCH--mem=15GB
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_Munge_Meta
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.out

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_Munge_Meta_Files.sh
