#!/bin/bash
#By Jaclyn Eissman, March 30, 2023
######Run Cross-Ancestry X Meta-Analyses

#Directory
dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/XWAS

#Prep GWAMA files
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
for m in NHW NHB; do
awk '{ print $1" "$2" "$3" "$5" "$6" "$16" "$4" +" }' $dir/${m}/ADSP_X_${m}_${j}_${k}_60plus_${i}_${l}_subset_MAF01.out | sed '1s/rs_number/MARKERNAME/g; 1s/reference_allele/EA/g; 1s/other_allele/NEA/g; 1s/n_samples/N/g; 1s/eaf/EAF/g; 1s/+/STRAND/g; 1s/beta/BETA/g; 1s/se/SE/g' > $dir/Cross_Ancestry/ADSP_X_${m}_${j}_${k}_60plus_${i}_${l}_subset_MAF01.GWAMA; done; done; done; done; done

#Check for .GWAMA output file
if [[ ! -f $dir/Cross_Ancestry/ADSP_X_${m}_${j}_${k}_60plus_${i}_${l}_subset_MAF01.GWAMA ]]; then exit 1 ; fi

#Run Cross-Ancestry X-Meta-Analysis
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
printf "$dir/Cross_Ancestry/ADSP_X_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01.GWAMA
$dir/Cross_Ancestry/ADSP_X_NHB_${j}_${k}_60plus_${i}_${l}_subset_MAF01.GWAMA" > $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}.in
GWAMA --filelist $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}.in --output $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l} --quantitative --name_marker MARKERNAME
awk '{if (($15 > 1) || (NR==1)) print}' $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}.out > $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}_subset.out; done; done; done; done

#Check for .GWAMA output file
if [[ ! -f $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}_subset.out ]]; then exit 1 ; fi

#Make QQ plots
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
Rscript /data/h_vmac/eissmajm/scripts/qq_plot.R $dir/Cross_Ancestry/ADSP_X_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}_subset.out; done; done; done; done
