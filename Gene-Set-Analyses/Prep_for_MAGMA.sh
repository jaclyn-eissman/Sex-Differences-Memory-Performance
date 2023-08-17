#!/bin/bash

###Rename final file set for post-GWAS
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/No_Relateds_Merged_First_Pass --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHW/All_Cohorts_NHW_Merged_No_Filter --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_NHB --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHB/All_Cohorts_NHB_Merged_No_Filter --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/No_Relateds_Merged_First_Pass --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/Cross_Ancestry/All_Cohorts_Cross_Ancestry_Merged_No_Filter --memory 1800

#Make annotation files
magma --annotate --snp-loc /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHW/All_Cohorts_NHW_Merged_No_Filter.bim --gene-loc /data/h_vmac/Programs/magma/NCBI38.gene.loc.symbols --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHW/All_Cohorts_NHW_Merged_No_Filter
magma --annotate --snp-loc /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHB/All_Cohorts_NHB_Merged_No_Filter.bim --gene-loc /data/h_vmac/Programs/magma/NCBI38.gene.loc.symbols --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/NHB/All_Cohorts_NHB_Merged_No_Filter
magma --annotate --snp-loc /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/Cross_Ancestry/All_Cohorts_Cross_Ancestry_Merged_No_Filter.bim --gene-loc /data/h_vmac/Programs/magma/NCBI38.gene.loc.symbols --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/MAGMA/Cross_Ancestry/All_Cohorts_Cross_Ancestry_Merged_No_Filter
