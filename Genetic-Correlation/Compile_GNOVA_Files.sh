#!/bin/bash
#Compile GNOVA Files 

#Add trait label and compile
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
for m in `ls /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/${i}/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE_*.txt` ; do
str=$(echo "$m" | cut -f 15 -d '_' | cut -f 1 -d '.')
sed -i "s/$/ $str/" "$m" >> $m
awk 'FNR>1' "$m" >> /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE_All_Traits.txt; done; done; done; done; done
