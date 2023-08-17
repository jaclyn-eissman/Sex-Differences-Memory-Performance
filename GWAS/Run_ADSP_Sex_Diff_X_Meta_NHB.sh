#!/bin/bash

#Set up job array
analysis=$1
pheno=$2
comorbid=$3
dx=$4

#Set main directory
dir=/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS

#If statement to determine the correct meta-analysis to run. 
if [[ $dx == "Impaired" ]]  ; then  

	#Create input text file
	printf "$dir/XWAS/NHB/NACC_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA
	$dir/XWAS/NHB/ROSMAP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA" > $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.in

	#Run meta-analysis
	GWAMA --filelist $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.in --output $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx} --quantitative --name_marker MARKERNAME

	#Check for output file
	if [[ ! -f $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.out ]]; then exit 1 ; fi

	#Restrict to SNPs in 2 studies
	awk '{if (($15 > 1) || (NR==1)) print}' $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.out > $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset.out
	
	#Do MAF filtering
	awk '{ if(NR==1 || $4>0.01) print }' $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset.out > $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01.out

	#Create QQ plot
	Rscript /data/h_vmac/eissmajm/scripts/qq_plot.R $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01.out

	#Echo statement
	echo "Done running $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01.out"
	
else 

	#Create input text file
	printf "$dir/XWAS/NHB/ACT_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA
	$dir/XWAS/NHB/NACC_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA
	$dir/XWAS/NHB/ROSMAP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.GWAMA" > $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.in

	#Run meta-analysis
	GWAMA --filelist $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.in --output $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx} --quantitative --name_marker MARKERNAME

	#Check for output file
	if [[ ! -f $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.out ]]; then exit 1 ; fi

	#Restrict to SNPs in 2-3 studies
	awk '{if (($15 > 1) || (NR==1)) print}' $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}.out > $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset.out

	#Do MAF filtering
	awk '{ if(NR==1 || $4>0.01) print }' $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset.out > $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01.out

	#Create QQ plot
	Rscript /data/h_vmac/eissmajm/scripts/qq_plot.R $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01.out

	#Echo statement
	echo "Done running $dir/XWAS/NHB/ADSP_X_NHB_${pheno}_${comorbid}_60plus_${analysis}_${dx}_subset_MAF01.out"
	
fi
