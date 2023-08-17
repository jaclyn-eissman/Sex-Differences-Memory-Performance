#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=2
#SBATCH--time=20:00:00
#SBATCH--mem=12GB
#SBATCH--constraint=skylake
#SBATCH--job-name=Manhattan_Cross_Ancestry
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.out

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_Manhattan_AxisBreak_withX_Cross_Ancestry.sh
