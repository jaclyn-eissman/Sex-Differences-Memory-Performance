#!/bin/bash

#Directory
dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/

#Remove non-rs for simplicity due to build differences
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
awk 'NR==1 || $1 ~ /rs/ { print }' $dir/GWAS/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE.out > $dir/GNOVA/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE_rs.out; done; done; done; done

#Load correct modules and source virtual environment
module restore gnova_python2
source /data/h_vmac/eissmajm/python2/bin/activate

#Munge
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
/data/h_vmac/eissmajm/GNOVA-2.0/munge_sumstats.py \
--signed-sumstats beta,0 \
--out $dir/GNOVA/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE_rs \
--a1 reference_allele \
--a2 other_allele \
--N-col n_samples \
--snp rs_number \
--sumstats $dir/GNOVA/NHW/ADSP_NHW_${j}_${k}_60plus_${i}_${l}_subset_MAF01_noAPOE_rs.out \
--p p-value; done; done; done; done
