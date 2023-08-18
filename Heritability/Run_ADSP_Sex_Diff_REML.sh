#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
###Heritability Calcs -- GRM already made

#Calculate heritability 
for i in NHW NHB; do
for j in Men Women Interaction; do 
for k in ALL Normals Impaired; do
for l in MEM memslopes; do
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/${i}/ADSP_${i}_${j}_${k}_Chrs1_22 --pheno /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/${i}/ADSP_${i}_${l}_WithComorbidities_60plus.txt --mpheno 1 --reml --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/${i}/ADSP_${i}_${j}_${k}_Chrs1_22_${l} --thread-num 10; done; done; done; done
