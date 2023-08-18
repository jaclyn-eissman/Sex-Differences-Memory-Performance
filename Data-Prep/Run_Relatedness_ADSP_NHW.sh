#By Jaclyn Eissman and Derek Archer

##########Script for removing related individuals from 4 ADSP cohorts for the sex differences memory GWAS -- NHW

###Check for directories and for files (check for one dataset)
if [[ ! -d /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW ]]; then exit 1 ; fi
if [[ ! -f /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/ACT_NHW_imputed_final.bed ]]; then exit 1 ; fi

###Change to my directory
cd /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW

###Update IDs
for i in ACT ADNI NACC ROSMAP; do
   awk -v prefix=$i '{print $1" "$2" "prefix"_"$1" "prefix"_"$2}' ${i}_NHW_imputed_final.fam > ${i}_NHW_imputed_final_updatedIDs.txt
   plink --bfile ${i}_NHW_imputed_final --update-ids ${i}_NHW_imputed_final_updatedIDs.txt --make-bed --out ${i}_NHW_imputed_final_updatedIDs --memory 18000
  
   echo "N in original file is `cat ${i}_NHW_imputed_final.fam | wc -l`. N in new file is `cat ${i}_NHW_imputed_final_updatedIDs.fam | wc -l`."; done

###Merge all the genetic data 
for i in ACT ADNI NACC ROSMAP; do
   printf "${i}_NHW_imputed_final_updatedIDs\n" >> initial_merge_list.txt; done
plink --merge-list initial_merge_list.txt --make-bed --out Merge_First_Pass --memory 18000

if [ -f Merge_First_Pass-merge.missnp ]; then #need this to check if missnp file and remove those SNPs

   for file in `cat initial_merge_list.txt`; do 
   plink --bfile $file --exclude Merge_First_Pass-merge.missnp --make-bed --out ${file}_no_missnps --memory 18000; done

   for i in ACT ADNI NACC ROSMAP; do
   printf "${i}_NHW_imputed_final_updatedIDs_no_missnps\n" >> no_missnp_merge_list.txt; done

   plink --merge-list no_missnp_merge_list.txt --make-bed --out Merge_Second_Pass --memory 18000

else
   
   for file in `cat initial_merge_list.txt` ; do
   plink --bfile $file --make-bed --out ${file}_no_missnps --memory 18000; done #even if no missnps, renaming to make it simpler down the road
 
   for i in ACT ADNI NACC ROSMAP; do
   printf "${i}_NHW_imputed_final_updatedIDs_no_missnps\n" >> no_missnp_merge_list.txt; done
      
   plink --bfile Merge_First_Pass --make-bed --out Merge_Second_Pass --memory 18000

fi

###Genotyping filter
plink --bfile Merge_Second_Pass --geno 0.05 --make-bed --freq --out Merge_Second_Pass_geno05 --memory 18000

###LD prune 
plink --bfile Merge_Second_Pass_geno05 --indep-pairwise 200 100 0.2 --out Merge_Second_Pass_geno05 --memory 18000
plink --bfile Merge_Second_Pass_geno05 --extract Merge_Second_Pass_geno05.prune.in --make-bed --out Merge_Second_Pass_geno05_LDpruned --memory 18000

###IBD calculations
plink --bfile Merge_Second_Pass_geno05_LDpruned --genome full unbounded nudge --min 0.20 --out Merged_relateds --memory 18000

###Use Derek's Rscript to get list of relateds to drop
module load GCC/5.4.0-2.26
module load OpenMPI/1.10.3
module load R/3.3.3
Rscript /data/h_vmac/arched1/Main_Effects_Cognitive_GWAS/get_multiset_relateds.R /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/Merged_relateds.genome /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/no_missnp_merge_list.txt

###Remove relateds
for i in ACT ADNI NACC ROSMAP; do 
    sed -e "s/${i}_//g" ${i}_NHW_imputed_final_updatedIDs_no_missnps.fam_df_no_relateds.txt | tee ${i}_NHW_imputed_final_no_relateds.txt

    plink --bfile ${i}_NHW_imputed_final --keep ${i}_NHW_imputed_final_no_relateds.txt --make-bed --out ${i}_NHW_imputed_final_no_relateds
    plink --bfile ${i}_NHW_imputed_final_updatedIDs --keep ${i}_NHW_imputed_final_updatedIDs_no_missnps.fam_df_no_relateds.txt --make-bed --out ${i}_NHW_imputed_final_updatedIDs_no_relateds
    
    echo "N in original file is `cat ${i}_NHW_imputed_final.fam | wc -l`. N in the no relateds file is `cat ${i}_NHW_imputed_final_no_relateds.fam | wc -l`."

done

###Do final merge
for i in ACT ADNI NACC ROSMAP; do
printf "${i}_NHW_imputed_final_updatedIDs_no_relateds\n" >> no_relateds_merge_list.txt; done

plink --merge-list no_relateds_merge_list.txt --make-bed --out No_Relateds_Merged_First_Pass --memory 18000

if [ -f No_Relateds_Merged_First_Pass-merge.missnp ] ; then 

   for file in `cat no_relateds_merge_list.txt` ; do 
   plink --bfile $file --exclude No_Relateds_Merged_First_Pass-merge.missnp --make-bed --out ${file}_no_missnps --memory 18000; done 

   for i in ACT ADNI NACC ROSMAP; do
   printf "${i}_NHW_imputed_final_updatedIDs_no_relateds_no_missnps\n" >> no_relateds_no_missnp_merge_list.txt; done

   plink --merge-list no_relateds_no_missnp_merge_list.txt --make-bed --out No_Relateds_Merged_Second_Pass --memory 18000

else
   
   plink --bfile No_Relateds_Merged_First_Pass --make-bed --out No_Relateds_Merged_Second_Pass --memory 18000
   
fi

###Genotyping filter
plink --bfile No_Relateds_Merged_Second_Pass --geno 0.05 --make-bed --out No_Relateds_Merged_Second_Pass_geno05

###Get frequency file
plink --bfile No_Relateds_Merged_Second_Pass_geno05 --freq --out No_Relateds_Merged_Second_Pass_geno05

###Check for final file
if [[ ! -f No_Relateds_Merged_Second_Pass_geno05.bed ]]; then exit 1 ; fi

###Make final files
for j in ACT ADNI NACC ROSMAP; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${j}_NHW_imputed_final_no_relateds --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${j}_NHW_ADSP_GWAS_Final --memory 18000; done

for i in ACT ADNI NACC ROSMAP; do
for j in Men Women Interaction; do
for k in ALL Normals Impaired; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_imputed_final_no_relateds --keep /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS_Files/${i}_NHW_MEM_WithComorbidities_60plus_${j}_${k}.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_${j}_${k}_imputed_final_no_relateds --memory 18000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_${j}_${k}_imputed_final_no_relateds --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/${i}_NHW_${j}_${k}_ADSP_GWAS_Final --memory 18000; done; done; done

###Get APOE SNPs to drop
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Get_APOE_SNPs_NHW.R
if [[ ! -f NHW_No_Relateds_Merged_First_Pass_APOE_1Mb_rs.txt ]]; then exit 1 ; fi
