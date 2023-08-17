#!/bin/bash
###Script to Prep GWAS Files for Post-GWAS

###Rename final file set for post-GWAS
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/No_Relateds_Merged_First_Pass --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/All_Cohorts_NHW_Merged_No_Filter --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_NHB --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/All_Cohorts_NHB_Merged_No_Filter --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/No_Relateds_Merged_First_Pass --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/All_Cohorts_AllRaces_Merged_No_Filter --memory 1800

###Remove APOE
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Remove_APOE_1Mb_NHW.R
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Remove_APOE_1Mb_NHB.R
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Remove_APOE_1Mb_Cross_Ancestry.R

###Gzip files for LocusZoom
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in ALL Normals Impaired; do
for l in NHW NHB Cross_Ancestry; do
for m in WithComorbidities WithoutComorbidities; do
gzip -c /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/${l}/ADSP_${l}_${j}_${m}_60plus_${i}_${k}_subset_MAF01_noAPOE.out > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/${l}/ADSP_${l}_${j}_${m}_60plus_${i}_${k}_subset_MAF01_noAPOE.gz; done; done; done; done; done

for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in ALL Normals Impaired; do
for l in NHW NHB Cross_Ancestry; do
for m in WithComorbidities WithoutComorbidities; do
gzip -c /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/XWAS/${l}/ADSP_X_${l}_${j}_${m}_60plus_${i}_${k}_subset.out > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/XWAS/${l}/ADSP_X_${l}_${j}_${m}_60plus_${i}_${k}_subset.gz; done; done; done; done; done
