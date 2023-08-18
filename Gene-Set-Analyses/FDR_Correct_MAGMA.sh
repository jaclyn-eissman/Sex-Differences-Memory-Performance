#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
#FDR Correct MAGMA Results

#NHW
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
Rscript /data/h_vmac/eissmajm/scripts/magma_FDR_correction_and_threshold.R /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.genes.out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.gsa.out; done; done; done; done

#NHB
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
Rscript /data/h_vmac/eissmajm/scripts/magma_FDR_correction_and_threshold.R /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHB/ADSP_NHB_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.genes.out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHB/ADSP_NHB_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.gsa.out; done; done; done; done

#Cross-Ancestry
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
Rscript /data/h_vmac/eissmajm/scripts/magma_FDR_correction_and_threshold.R /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/Cross_Ancestry/ADSP_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.genes.out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/Cross_Ancestry/ADSP_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.gsa.out; done; done; done; done
