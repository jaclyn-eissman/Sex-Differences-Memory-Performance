##########Script for prepping X-chromosome data for ADSP 4 cohort GWAS

###Drop relateds
for i in ACT ADNI NACC ROSMAP; do
awk '{ print $1, $2 }' /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_imputed_final_no_relateds.fam > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_imputed_final_no_relateds.txt; done

for i in ACT ADNI NACC ROSMAP; do
awk '{ print $1, $2 }' /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_AllRaces_imputed_final_no_relateds.fam > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_AllRaces_imputed_final_no_relateds.txt; done

for i in ACT ADNI NACC ROSMAP; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_X_NHW_imputed_final --keep /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_imputed_final_no_relateds.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_X_NHW_imputed_final_no_relateds --memory 18000; done

for i in ACT ADNI NACC ROSMAP; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_X_AllRaces_imputed_final --keep /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_AllRaces_imputed_final_no_relateds.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_X_AllRaces_imputed_final_no_relateds --memory 18000; done

###Take all races files and subset to NHB IDs only -- use phenotype or covar file
for j in ACT ADNI NACC ROSMAP; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${j}_X_AllRaces_imputed_final_no_relateds --keep /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/${j}_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${j}_X_AllRaces_imputed_final_no_relateds_NHBonly --memory 18000; done

###Check #1
if [[ ! -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ACT_X_AllRaces_imputed_final_no_relateds_NHBonly.bed ]]; then exit 1 ; fi

###Making combined X files
#NHW
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ACT_X_NHW_imputed_final_no_relateds
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADNI_X_NHW_imputed_final_no_relateds
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/NACC_X_NHW_imputed_final_no_relateds
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ROSMAP_X_NHW_imputed_final_no_relateds" > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW_Merge_List.txt

plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW_Merge_List.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW --geno 0.05 --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW_geno05 --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW_geno05 --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW_geno05 --memory 18000

###Check #2
if [[ ! -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW_geno05.bed ]]; then exit 1 ; fi

#NHB
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ACT_X_AllRaces_imputed_final_no_relateds_NHBonly
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADNI_X_AllRaces_imputed_final_no_relateds_NHBonly
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/NACC_X_AllRaces_imputed_final_no_relateds_NHBonly
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ROSMAP_X_AllRaces_imputed_final_no_relateds_NHBonly" > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB_Merge_List.txt

plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB_Merge_List.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB --geno 0.05 --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB_geno05 --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB_geno05 --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB_geno05 --memory 18000

###Check #3
if [[ ! -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB_geno05.bed ]]; then exit 1 ; fi

#Cross_Ancestry
printf "/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ACT_X_AllRaces_imputed_final_no_relateds
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADNI_X_AllRaces_imputed_final_no_relateds
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/NACC_X_AllRaces_imputed_final_no_relateds
/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ROSMAP_X_AllRaces_imputed_final_no_relateds" > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces_Merge_List.txt

plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces_Merge_List.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces --geno 0.05 --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces_geno05 --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces_geno05 --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces_geno05 --memory 18000

###Check #4
if [[ ! -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces_geno05.bed ]]; then exit 1 ; fi

##Making final files
#NHW
for i in ACT ADNI NACC ROSMAP; do
for j in Men Women Interaction; do
for k in ALL Normals Impaired; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_X_NHW_imputed_final_no_relateds --keep /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/${i}_NHW_MEM_WithComorbidities_60plus_${j}_${k}.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_X_NHW_${j}_${k}_imputed_final_no_relateds --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_X_NHW_${j}_${k}_imputed_final_no_relateds --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_X_NHW_${j}_${k}_ADSP_GWAS_Final --memory 18000; done; done; done

#NHB
for i in ACT ADNI NACC ROSMAP; do
for j in Men Women Interaction; do
for k in ALL Normals Impaired; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_X_AllRaces_imputed_final_no_relateds_NHBonly --keep /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/${i}_NHB_MEM_WithComorbidities_60plus_${j}_${k}.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_X_NHB_${j}_${k}_imputed_final_no_relateds --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_X_NHB_${j}_${k}_imputed_final_no_relateds --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/${i}_X_NHB_${j}_${k}_ADSP_GWAS_Final --memory 18000; done; done; done

###Rename final file set for post-GWAS
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ADSP_X_NHW --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/All_Cohorts_NHW_X_Merged_No_Filter --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_NHB --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/All_Cohorts_NHB_X_Merged_No_Filter --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_X_AllRaces --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/All_Cohorts_AllRaces_X_Merged_No_Filter --memory 18000
