#!/bin/bash
#By Jaclyn Eissman, March 30, 2023

#Set up for loop -- EasyStrata does not work with job arrays
for j in Men Women Interaction; do
for k in MEM memslopes; do
for l in WithComorbidities WithoutComorbidities; do
for m in ALL Normals Impaired; do

#Need to be in WD for plots
cd /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/Cross_Ancestry

#Combine GWAS + XWAS Files
tail -n +2 ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset.out > ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited.out
tail -n +2 /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/XWAS/Cross_Ancestry/ADSP_X_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset.out > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/XWAS/Cross_Ancestry/ADSP_X_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited.out

cat ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited.out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/XWAS/Cross_Ancestry/ADSP_X_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited.out > ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited_withX.out

#Add headers in R
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Add_Headers_Meta.R ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited_withX.out

#Plot
module restore R_v3_3_3
sh /data/h_vmac/eissmajm/scripts/EasyStrata_Manhattan_Plot_Axis_Break.sh ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited_withX.out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/All_Cohorts_AllRaces_withX_Merged_No_Filter.txt ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited_withX

#Print
echo "Done plotting ADSP_Cross_Ancestry_${k}_${l}_60plus_${j}_${m}_subset_edited_withX.out"; done; done; done; done
