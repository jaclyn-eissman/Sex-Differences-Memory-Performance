#!/bin/bash
#By Jaclyn Eissman, March 30, 2023

#Set up job array
cohort=$1
race=$2
analysis=$3
pheno=$4
comorbid=$5
dx=$6

#Set main directory
dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS

#If/else to determine correct GWAS model and covariates
if [[ $analysis == "Women" && $race == "NHW" ]] || [[ $analysis == "Men" &&  $race == "NHW" ]] ; then
  model="--linear hide-covar"  
  covars="Age, NHW_PC1, NHW_PC2, NHW_PC3, NHW_PC4, NHW_PC5"
elif [[ $analysis == "Interaction" && $race == "NHW" ]] ; then
  model="--linear interaction --parameters 1-8, 10"  
  covars="Age, sex, NHW_PC1, NHW_PC2, NHW_PC3, NHW_PC4, NHW_PC5"
elif [[ $analysis == "Women" && $race == "NHB" ]] || [[ $analysis == "Men" && $race == "NHB" ]] ; then
  covars="Age, NHB_PC1, NHB_PC2, NHB_PC3, NHB_PC4, NHB_PC5"
  model="--linear hide-covar"
else
  covars="Age, sex, NHB_PC1, NHB_PC2, NHB_PC3, NHB_PC4, NHB_PC5"
  model="--linear interaction --parameters 1-8, 10"
fi

#Run the GWAS 
plink --bfile $dir/Data/${race}/${cohort}_${race}_${analysis}_${dx}_ADSP_GWAS_Final --keep $dir/GWAS_Files/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.txt --pheno $dir/GWAS_Files/${cohort}_${race}_${pheno}_${comorbid}_60plus.txt --pheno-name ${pheno} --covar $dir/GWAS_Files/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.txt --covar-name $covars $model --ci 0.95 --out $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}

#Check for .assoc.linear file
if [[ ! -f $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.assoc.linear ]]; then exit 1 ; fi

#If/else to make the correct GWAMA file
if [[ $analysis == "Interaction" ]] ; then  
  for i in $( ls $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_Interaction_${dx}.assoc.linear ); do
    new_file_name=$( echo $i | sed 's/Interaction/Interaction.Only/' )
    awk 'NR==1 || $5 ~ /ADDx/ { print }' $i > $new_file_name
  done 
  perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_Interaction.Only_${dx}.assoc.linear $dir/Data/${race}/${cohort}_${race}_${analysis}_${dx}_ADSP_GWAS_Final.frq $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_Interaction_${dx}.GWAMA
  echo "Done making $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_Interaction_${dx}.GWAMA"
else 
  perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.assoc.linear $dir/Data/${race}/${cohort}_${race}_${analysis}_${dx}_ADSP_GWAS_Final.frq $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA
  echo "Done making $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA"
fi

#Check for .GWAMA file
if [[ ! -f $dir/GWAS/${race}/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA ]]; then exit 1 ; fi
