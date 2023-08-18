#By Jaclyn Eissman, March 30, 2023

#Set to fail if error
set -e 

#Copy NHW
rsync -avh /nfs/DATA/ACT/GWAS/Imputed/TOPMed/Cleaned/ACT_X_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/
rsync -avh /nfs/DATA/ADNI/GWAS/Imputed/TOPMed/Cleaned/ADNI_X_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/
rsync -avh /nfs/DATA/NACC/GWAS/Imputed/TOPMed/Cleaned/NACC_X_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/
rsync -avh /nfs/DATA/ROSMAP/GWAS/Imputed/TOPMed/Cleaned/ROSMAP_X_NHW_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/

#Copy All Races
rsync -avh /nfs/DATA/ACT/GWAS/Imputed/TOPMed/Cleaned/ACT_X_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
rsync -avh /nfs/DATA/ADNI/GWAS/Imputed/TOPMed/Cleaned/ADNI_X_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
rsync -avh /nfs/DATA/NACC/GWAS/Imputed/TOPMed/Cleaned/NACC_X_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
rsync -avh /nfs/DATA/ROSMAP/GWAS/Imputed/TOPMed/Cleaned/ROSMAP_X_AllRaces_imputed_final.* /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/
