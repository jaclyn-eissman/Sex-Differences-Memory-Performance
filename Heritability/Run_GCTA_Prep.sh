#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
###Prep for Heritability

###Make combined pheno Ffles
for i in NHW NHB; do
for j in MEM memslopes; do
cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/ACT_${i}_${j}_WithComorbidities_60plus.txt /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/ADNI_${i}_${j}_WithComorbidities_60plus.txt /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/NACC_${i}_${j}_WithComorbidities_60plus.txt /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/ROSMAP_${i}_${j}_WithComorbidities_60plus.txt >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/${i}/ADSP_${i}_${j}_WithComorbidities_60plus.txt ; done; done

###Set-up genetic data file merges -- NHW
for j in Men Women Interaction; do
for k in ALL Normals; do
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ACT_NHW_${j}_${k}_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADNI_NHW_${j}_${k}_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/NACC_NHW_${j}_${k}_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ROSMAP_NHW_${j}_${k}_ADSP_GWAS_Final\n" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_List.txt; done; done

for j in Men Women Interaction; do
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADNI_NHW_${j}_Impaired_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/NACC_NHW_${j}_Impaired_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ROSMAP_NHW_${j}_Impaired_ADSP_GWAS_Final\n" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_Impaired_List.txt; done

for j in Men Women Interaction; do
for k in ALL Normals; do
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ACT_NHB_${j}_${k}_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/NACC_NHB_${j}_${k}_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ROSMAP_NHB_${j}_${k}_ADSP_GWAS_Final\n" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_List.txt; done; done

for j in Men Women Interaction; do
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/NACC_NHB_${j}_Impaired_ADSP_GWAS_Final\n/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ROSMAP_NHB_${j}_Impaired_ADSP_GWAS_Final\n" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_Impaired_List.txt; done

###NHW Merges
for j in Men Women Interaction; do
for k in ALL Normals Impaired; do

plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_List.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_First_Pass --memory 30000

if [ -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_First_Pass-merge.missnp ] ; then 

   for file in `cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_List.txt` ; do 
  
   plink --bfile $file --exclude /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_First_Pass-merge.missnp --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${file}_no_missnps --memory 30000
   
   printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${file}_no_missnps\n" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_List_Two.txt; done

   plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_List_Two.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_Second_Pass --memory 30000

else
   
   plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_First_Pass --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_Second_Pass --memory 30000
   
fi

plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_Second_Pass --geno 0.05 --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHW/ADSP_NHW_${j}_${k}_Second_Pass_geno05 --memory 30000; done; done

###Set-up genetic data file merges -- NHB
for j in Men Women Interaction; do
for k in ALL Normals Impaired; do

plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_List.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_First_Pass --memory 30000

if [ -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_First_Pass-merge.missnp ] ; then 

   for file in `cat /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_List.txt` ; do 

   plink --bfile $file --exclude /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_First_Pass-merge.missnp --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${file}_no_missnps --memory 30000
   
   printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${file}_no_missnps\n" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_List_Two.txt; done

   plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_List_Two.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_Second_Pass --memory 30000

else
   
   plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_First_Pass --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_Second_Pass --memory 30000
   
fi

plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_Second_Pass --geno 0.05 --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GCTA/NHB/ADSP_NHB_${j}_${k}_Second_Pass_geno05 --memory 30000; done; done
