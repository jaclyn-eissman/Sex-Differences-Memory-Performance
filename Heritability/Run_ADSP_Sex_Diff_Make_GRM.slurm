#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=6
#SBATCH--constraint=skylake
#SBATCH--time=36:00:00
#SBATCH--mem=32GB
#SBATCH--array=1-18
#SBATCH--job-name=ADSP_GRM
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A_%a.out

#Pull race, analysis, and dx
race=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GCTA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $1}')
analysis=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GCTA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $2}')
dx=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GCTA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $3}')

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_ADSP_Sex_Diff_Make_GRM.sh $race $analysis $dx
