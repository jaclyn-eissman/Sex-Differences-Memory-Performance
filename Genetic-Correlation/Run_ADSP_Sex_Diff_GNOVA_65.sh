#!/bin/bash

#Set up job array
trait=$1
analysis=$2
pheno=$3
comorbid=$4
dx=$5

#Load correct modules and source virtual environment
module restore gnova_python2
source /data/h_vmac/eissmajm/python2/bin/activate

#Directories
Trait_dir=/data/h_vmac/eissmajm/SUMSTATS/Munged_Traits
Main_dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW

#####Sets up a GNOVA job array for all traits 
/data/h_vmac/eissmajm/GNOVA-2.0/gnova.py $Trait_dir/${trait}.sumstats.gz $Main_dir/ADSP_NHW_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01_noAPOE_rs.sumstats.gz --bfile /data/h_vmac/eissmajm/GNOVA-2.0/genotype_1KG_eur_SNPmaf5/eur_chr@_SNPmaf5 --out $Main_dir/${analysis}/ADSP_NHW_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01_noAPOE_${trait}.txt
