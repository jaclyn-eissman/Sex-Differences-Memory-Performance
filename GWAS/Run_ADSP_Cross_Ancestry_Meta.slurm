#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=10:00:00
#SBATCH--mem=12GB
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_CrossAncestry_Meta
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.out

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_ADSP_Cross_Ancestry_Meta.sh
