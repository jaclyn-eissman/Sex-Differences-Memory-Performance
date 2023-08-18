#By Jaclyn Eissman, March 30, 2023
#Remove 1Mb region around APOE -- NHB

#libraries
library(data.table)

#Remove APOE
analysis <- c("Men","Women","Interaction")
phenotypes <- c("MEM","memslopes")
comorbid <- c("WithComorbidities","WithoutComorbidities")
dx <- c("ALL","Normals","Impaired")
rs <- fread("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/NHB_No_Relateds_Merged_First_Pass_APOE_1Mb_rs.txt",header=F)
for (i in 1:length(analysis)) {
for (j in 1:length(phenotypes)) {
for (k in 1:length(comorbid)) {
for (l in 1:length(dx)) {
temp <-fread(paste0("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/NHB/ADSP_NHB_",phenotypes[j],"_",comorbid[k],"_60plus_",analysis[i],"_",dx[l],"_subset_MAF01.out"),header=T)
temp <- temp[!(temp$rs_number %in% rs$V1),]
write.table(temp,paste0("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GWAS/NHB/ADSP_NHB_",phenotypes[j],"_",comorbid[k],"_60plus_",analysis[i],"_",dx[l],"_subset_MAF01_noAPOE.out"),quote=F,col.names=T,row.names=F)
rm(temp)
}
}
}
}
