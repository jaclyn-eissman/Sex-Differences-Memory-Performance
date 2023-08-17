#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=10:00:00
#SBATCH--mem=12GB
#SBATCH--array=1-36
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_Meta_NHW
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A_%a.out

#Pull analysis, pheno, comorbid, and dx
analysis=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_Meta_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $1}')
pheno=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_Meta_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $2}')
comorbid=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_Meta_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $3}')
dx=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_Meta_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $4}')

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_ADSP_Sex_Diff_Meta_NHW.sh $analysis $pheno $comorbid $dx
