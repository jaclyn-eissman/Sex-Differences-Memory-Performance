#!/bin/bash
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--ntasks=1
#SBATCH--cpus-per-task=1
#SBATCH--time=16:00:00
#SBATCH--mem=10GB
#SBATCH--array=1-2340%65
#SBATCH--constraint=skylake
#SBATCH--job-name=ADSP_GNOVA_65
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A_%a.out

#Pull trait, analysis, pheno, comorbid, and dx
trait=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/GNOVA_Master_Trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $1}')
analysis=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/GNOVA_Master_Trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $2}')
pheno=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/GNOVA_Master_Trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $3}')
comorbid=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/GNOVA_Master_Trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $4}')
dx=$(cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/GNOVA_Master_Trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $5}')

#Run bash script 
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_ADSP_Sex_Diff_GNOVA_65.sh $trait $analysis $pheno $comorbid $dx
