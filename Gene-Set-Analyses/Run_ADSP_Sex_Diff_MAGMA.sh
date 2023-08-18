#!/bin/bash
#By Jaclyn Eissman, March 30, 2023

#Set up job array
race=$1
analysis=$2
pheno=$3
comorbid=$4
dx=$5

#Set main directory
dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS

#Run MAGMA gene test 
magma --bfile $dir/MAGMA/$race/All_Cohorts_${race}_Merged_No_Filter --pval $dir/GWAS/$race/ADSP_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01_noAPOE.out use=rs_number,p-value ncol=n_samples --gene-annot $dir/MAGMA/$race/All_Cohorts_${race}_Merged_No_Filter.genes.annot --out $dir/MAGMA/$race/ADSP_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01_noAPOE

#Run MAGMA pathway test
magma --gene-results $dir/MAGMA/$race/ADSP_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01_noAPOE.genes.raw --set-annot /data/h_vmac/Programs/magma/custom_pathways.txt --out $dir/MAGMA/$race/ADSP_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01_noAPOE
