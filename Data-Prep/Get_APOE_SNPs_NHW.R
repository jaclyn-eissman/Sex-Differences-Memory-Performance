#By Jaclyn Eissman, March 30, 2023

#Get APOE SNPs to drop -- NHW

#libraries
library(data.table)

#NHW
bim <- fread("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/No_Relateds_Merged_First_Pass.bim") 
bim_chr19 <- bim[bim$V1==19 & bim$V4>=43905796 & bim$V4<=45909395,]
bim_chr19_rs <- bim_chr19$V2
write.table(bim_chr19_rs,"/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHW/NHW_No_Relateds_Merged_First_Pass_APOE_1Mb_rs.txt",quote=F,col.names=F,row.names=F)
rm(bim,bim_chr19,bim_chr19_rs)
