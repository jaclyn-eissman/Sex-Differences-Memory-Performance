#Get APOE SNPs to drop -- NHB & All Races

#libraries
library(data.table)

#NHB
bim <- fread("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/ADSP_NHB.bim") 
bim_chr19 <- bim[bim$V1==19 & bim$V4>=43905796 & bim$V4<=45909395,]
bim_chr19_rs <- bim_chr19$V2
write.table(bim_chr19_rs,"/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/NHB_No_Relateds_Merged_First_Pass_APOE_1Mb_rs.txt",quote=F,col.names=F,row.names=F)
rm(bim,bim_chr19,bim_chr19_rs)

#All Races
bim <- fread("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/No_Relateds_Merged_First_Pass.bim") 
bim_chr19 <- bim[bim$V1==19 & bim$V4>=43905796 & bim$V4<=45909395,]
bim_chr19_rs <- bim_chr19$V2
write.table(bim_chr19_rs,"/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Data/NHB/AllRaces_No_Relateds_Merged_First_Pass_APOE_1Mb_rs.txt",quote=F,col.names=F,row.names=F)
rm(bim,bim_chr19,bim_chr19_rs)