#!/bin/bash

#Set up job array
cohort=$1
race=$2
analysis=$3
pheno=$4
comorbid=$5
dx=$6

#Set main directory
dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS

#If/else to determine correct XWAS model and covariates
if [[ $analysis == "Women" && $race == "NHW" ]] ; then
  model="--linear hide-covar"  
  covars="Age, NHW_PC1, NHW_PC2, NHW_PC3, NHW_PC4, NHW_PC5"
elif [[ $analysis == "Men" && $race == "NHW" ]] ; then
  model="--linear hide-covar --xchr-model 2" 
  covars="Age, NHW_PC1, NHW_PC2, NHW_PC3, NHW_PC4, NHW_PC5"
elif [[ $analysis == "Women" && $race == "NHB" ]] ; then
  covars="Age, NHB_PC1, NHB_PC2, NHB_PC3, NHB_PC4, NHB_PC5"
  model="--linear hide-covar"
elif [[ $analysis == "Men" && $race == "NHB" ]] ; then
  covars="Age, NHB_PC1, NHB_PC2, NHB_PC3, NHB_PC4, NHB_PC5"
  model="--linear hide-covar --xchr-model 2"
elif [[ $analysis == "Interaction" && $race == "NHW" ]] ; then
  covars="Age, NHW_PC1, NHW_PC2, NHW_PC3, NHW_PC4, NHW_PC5"
  model="--linear --xchr-model 3"
else
  covars="Age, NHB_PC1, NHB_PC2, NHB_PC3, NHB_PC4, NHB_PC5"
  model="--linear --xchr-model 3"
fi

#Run the XWAS 
plink --bfile $dir/Data/${race}/${cohort}_X_${race}_${analysis}_${dx}_ADSP_GWAS_Final --keep $dir/GWAS_Files/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.txt --pheno $dir/GWAS_Files/${cohort}_${race}_${pheno}_${comorbid}_60plus.txt --pheno-name ${pheno} --covar $dir/GWAS_Files/${cohort}_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.txt --covar-name $covars $model --ci 0.95 --out $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}

#Check for .assoc.linear file
if [[ ! -f $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.assoc.linear ]]; then exit 1 ; fi

#If/else to make the correct GWAMA file
if [[ $analysis == "Interaction" ]] ; then  
  for i in $( ls $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_Interaction_${dx}.assoc.linear ); do
    new_file_name=$( echo $i | sed 's/Interaction/Interaction.Only/' )
    awk 'NR==1 || $5 ~ /XxSEX/ { print }' $i > $new_file_name
  done 
  perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_Interaction.Only_${dx}.assoc.linear $dir/Data/${race}/${cohort}_X_${race}_${analysis}_${dx}_ADSP_GWAS_Final.frq $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_Interaction_${dx}.GWAMA
  echo "Done making $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_Interaction_${dx}.GWAMA"
else 
  perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.assoc.linear $dir/Data/${race}/${cohort}_X_${race}_${analysis}_${dx}_ADSP_GWAS_Final.frq $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA
  echo "Done making $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA"
fi

#Check for .GWAMA file
if [[ ! -f $dir/XWAS/${race}/${cohort}_X_${race}_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA ]]; then exit 1 ; fi
