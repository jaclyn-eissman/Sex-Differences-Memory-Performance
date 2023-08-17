#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=18:00:00
#SBATCH--mem=12GB
#SBATCH--array=1-288%50
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_XWAS
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A_%a.out

#Pull cohort, race, analysis, pheno, comorbid, and dx
cohort=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GWAS_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $1}')
race=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GWAS_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $2}')
analysis=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GWAS_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $3}')
pheno=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GWAS_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $4}')
comorbid=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GWAS_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $5}')
dx=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/ADSP_GWAS_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $6}')

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_ADSP_Sex_Diff_XWAS.sh $cohort $race $analysis $pheno $comorbid $dx
