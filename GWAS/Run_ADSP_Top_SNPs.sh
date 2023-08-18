#By Jaclyn Eissman, March 30, 2023
###Set to fail if error
set -e 

###NHW and NHB
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
for m in NHW NHB; do
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Get_Top_SNPs.R /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/${m} ADSP_${m}_${j}_${k}_60plus_${i}_${l}_subset_MAF01_edited_withX.out; done; done; done; done; done


###Cross-Ancestry
for i in Men Women Interaction; do
for j in MEM memslopes; do
for k in WithComorbidities WithoutComorbidities; do
for l in ALL Normals Impaired; do
Rscript /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Slurm/Get_Top_SNPs.R /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/Cross_Ancestry ADSP_Cross_Ancestry_${j}_${k}_60plus_${i}_${l}_subset_edited_withX.out; done; done; done; done
