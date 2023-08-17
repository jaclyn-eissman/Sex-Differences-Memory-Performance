#!/bin/bash

#Define vars
race=$1
analysis=$2
dx=$3

#Build relatedness matrix
gcta64 --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/${race}/ADSP_${race}_${analysis}_${dx}_Second_Pass_geno05 --make-grm --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/${race}/ADSP_${race}_${analysis}_${dx}_Chrs1_22 --thread-num 10