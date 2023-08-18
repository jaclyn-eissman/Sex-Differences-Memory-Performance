#By Jaclyn Eissman, March 30, 2023
#!/bin/bash

#Set to fail if error copying
set -e

#Make NHW and NHB directories
if [[ ! -d /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW ]]; then mkdir /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW && echo "Making directory..."; else echo "Directory exists."; fi
if [[ ! -d /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB ]]; then mkdir /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB && echo "Making directory..."; else echo "Directory exists."; fi

#Copy data NHW data
rsync -avh /nfs/DATA/ACT/GWAS/Imputed/TOPMed/Cleaned/ACT_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/
rsync -avh /nfs/DATA/ADNI/GWAS/Imputed/TOPMed/Cleaned/ADNI_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/
rsync -avh /nfs/DATA/NACC/GWAS/Imputed/TOPMed/Cleaned/NACC_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/
rsync -avh /nfs/DATA/ROSMAP/GWAS/Imputed/TOPMed/Cleaned/ROSMAP_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/

#Copy data All Races data
rsync -avh /nfs/DATA/ACT/GWAS/Imputed/TOPMed/Cleaned/ACT_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
rsync -avh /nfs/DATA/ADNI/GWAS/Imputed/TOPMed/Cleaned/ADNI_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
rsync -avh /nfs/DATA/NACC/GWAS/Imputed/TOPMed/Cleaned/NACC_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
rsync -avh /nfs/DATA/ROSMAP/GWAS/Imputed/TOPMed/Cleaned/ROSMAP_AllRaces_final_updatedIDs.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/

#Rename ROSMAP
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ROSMAP_AllRaces_final_updatedIDs --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ROSMAP_AllRaces_imputed_final --memory 18000
