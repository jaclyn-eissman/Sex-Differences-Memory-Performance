#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
#SBATCH--nodes=1
#SBATCH--ntasks=6
#SBATCH--mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH--mail-type=ALL
#SBATCH--mem=20G
#SBATCH--time=28:00:00
#SBTACH--restraint=skylake
#SBATCH--job-name=relateds_nhw
#SBATCH--output=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/logs/%A.log

#Run script
sh /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Run_Relatedness_ADSP_NHW.sh
