#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=18:00:00
#SBATCH--mem=12GB
#SBATCH--array=37-108
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_MAGMA_AllRaces
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A_%a.out

#Pull race, analysis, pheno, comorbid, and dx
race=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_MAGMA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $1}')
analysis=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_MAGMA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $2}')
pheno=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_MAGMA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $3}')
comorbid=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_MAGMA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $4}')
dx=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_MAGMA_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $5}')

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_ADSP_Sex_Diff_MAGMA.sh $race $analysis $pheno $comorbid $dx
