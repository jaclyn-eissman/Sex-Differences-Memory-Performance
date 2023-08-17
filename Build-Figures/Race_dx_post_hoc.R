####Race and dx post-hoc analyses for SNPs

#Packages
library(data.table)
library(dplyr)
library(metafor)
library(ggplot2)

#Directories 
Main_directory <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/"

######################################################rs5935633######################################################
###NHW pheno & covar info
ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ADNI <- fread(paste0(Main_directory,"GWAS_Files/ADNI_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHW <- rbind(ACT,ADNI,NACC,ROSMAP)

###NHB pheno & covar info
#ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHB_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHB_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHB_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHB <- rbind(NACC,ROSMAP)

###Combine and add in SNP info
ADSP <- plyr::rbind.fill(ADSP_NHW,ADSP_NHB)
rm(ACT,ADNI,NACC,ROSMAP,ADSP_NHW,ADSP_NHB)

ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHW_ADSP_GWAS_Final_rs5935633.raw"))
ADNI <- fread(paste0(Main_directory,"Data/Raw/ADNI_NHW_ADSP_GWAS_Final_rs5935633.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHW_ADSP_GWAS_Final_rs5935633.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHW_ADSP_GWAS_Final_rs5935633.raw"))
NHW <- rbind(ACT,ADNI,NACC,ROSMAP)
rm(ACT,ADNI,NACC,ROSMAP)

#ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHB_ADSP_GWAS_Final_rs5935633.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHB_ADSP_GWAS_Final_rs5935633.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHB_ADSP_GWAS_Final_rs5935633.raw"))
NHB <- rbind(NACC,ROSMAP)
ADSP_raw <- rbind(NHW,NHB)
rm(NACC,ROSMAP,NHW,NHB)

ADSP_Master <- merge(ADSP,ADSP_raw,by=c("FID","IID"))
ADSP_Master$dx_new[ADSP_Master$dx==2|3] <- "CI"
ADSP_Master$dx_new[ADSP_Master$dx==1] <- "CU"

###Run Models
#race*sex*SNP
summary(lm(memslopes ~ as.factor(race)*as.factor(sex)*rs5935633_A, data=ADSP_Master, na.action=na.omit))

#dx*sex*SNP
summary(lm(memslopes ~ as.factor(dx_new)*as.factor(sex)*rs5935633_A, data=ADSP_Master, na.action=na.omit))

#race*dx*sex*SNP
summary(lm(memslopes ~ as.factor(race)*as.factor(dx_new)*as.factor(sex)*rs5935633_A, data=ADSP_Master, na.action=na.omit))

###Plot
ADSP_Master$sex <- ifelse(ADSP_Master$sex==1,"Males","Females")
ADSP_Master_Temp <- ADSP_Master %>% filter(!is.na(rs5935633_A)) %>% filter(dx_new=="CU")
ADSP_Master <- ADSP_Master %>% filter(!is.na(rs5935633_A)) %>% filter(dx_new=="CI")
ADSP_Master_NHB <- ADSP_Master %>% filter(race=="NHB")
ADSP_Master_NHW <- ADSP_Master %>% filter(race=="NHW")
ADSP_Master_Temp_NHB <- ADSP_Master_Temp %>% filter(race=="NHB")
ADSP_Master_Temp_NHW <- ADSP_Master_Temp %>% filter(race=="NHW")

png(paste0(Main_directory,"Data/Plots/NHB_CI_rs5935633_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_NHB, aes(y=memslopes, x=sex, fill=as.factor(rs5935633_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Memory Decline") + labs(fill="rs5935633") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHW_CI_rs5935633_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_NHW, aes(y=memslopes, x=sex, fill=as.factor(rs5935633_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Memory Decline") + labs(fill="rs5935633") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHB_CU_rs5935633_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_Temp_NHB, aes(y=memslopes, x=sex, fill=as.factor(rs5935633_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Memory Decline") + labs(fill="rs5935633") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHW_CU_rs5935633_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_Temp_NHW, aes(y=memslopes, x=sex, fill=as.factor(rs5935633_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Memory Decline") + labs(fill="rs5935633") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

######################################################rs67099044######################################################
###NHW pheno & covar info
ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADNI <- fread(paste0(Main_directory,"GWAS_Files/ADNI_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHW <- rbind(ACT,ADNI,NACC,ROSMAP)

###NHB pheno & covar info
#ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHB <- rbind(NACC,ROSMAP)

###Combine and add in SNP info
ADSP <- plyr::rbind.fill(ADSP_NHW,ADSP_NHB)
rm(ACT,ADNI,NACC,ROSMAP,ADSP_NHW,ADSP_NHB)

ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHW_ADSP_GWAS_Final_rs67099044.raw"))
ADNI <- fread(paste0(Main_directory,"Data/Raw/ADNI_NHW_ADSP_GWAS_Final_rs67099044.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHW_ADSP_GWAS_Final_rs67099044.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHW_ADSP_GWAS_Final_rs67099044.raw"))
NHW <- rbind(ACT,ADNI,NACC,ROSMAP)
rm(ACT,ADNI,NACC,ROSMAP)

#ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHB_ADSP_GWAS_Final_rs67099044.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHB_ADSP_GWAS_Final_rs67099044.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHB_ADSP_GWAS_Final_rs67099044.raw"))
NHB <- rbind(NACC,ROSMAP)
ADSP_raw <- rbind(NHW,NHB)
rm(NACC,ROSMAP,NHW,NHB)

ADSP_Master <- merge(ADSP,ADSP_raw,by=c("FID","IID"))
ADSP_Master$dx_new[ADSP_Master$dx==2|3] <- "CI"
ADSP_Master$dx_new[ADSP_Master$dx==1] <- "CU"

###Run Models
#race*sex*SNP
summary(lm(MEM ~ as.factor(race)*as.factor(sex)*rs67099044_A, data=ADSP_Master, na.action=na.omit))

#dx*sex*SNP
summary(lm(MEM ~ as.factor(dx_new)*as.factor(sex)*rs67099044_A, data=ADSP_Master, na.action=na.omit))

#race*dx*sex*SNP
summary(lm(MEM ~ as.factor(race)*as.factor(dx_new)*as.factor(sex)*rs67099044_A, data=ADSP_Master, na.action=na.omit))

###Plot
ADSP_Master$sex <- ifelse(ADSP_Master$sex==1,"Men","Women")
ADSP_Master <- ADSP_Master %>% filter(!is.na(rs67099044_A))
ADSP_Master_NHB <- ADSP_Master %>% filter(race=="NHB")
ADSP_Master_NHW <- ADSP_Master %>% filter(race=="NHW")

png(paste0(Main_directory,"Data/Plots/CrossAncestry_ALL_rs67099044_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master, aes(y=MEM, x=sex, fill=as.factor(rs67099044_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs67099044") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("CC","AC","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHB_ALL_rs67099044_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_NHB, aes(y=MEM, x=sex, fill=as.factor(rs67099044_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs67099044") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("CC","AC","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHW_ALL_rs67099044_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_NHW, aes(y=MEM, x=sex, fill=as.factor(rs67099044_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs67099044") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("CC","AC","AA"))
dev.off()

######################################################rs6733839######################################################
###NHW pheno & covar info
ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ADNI <- fread(paste0(Main_directory,"GWAS_Files/ADNI_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHW_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHW <- rbind(ACT,ADNI,NACC,ROSMAP)

###NHB pheno & covar info
#ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHB_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHB_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHB_memslopes_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHB <- rbind(NACC,ROSMAP)

###Combine and add in SNP info
ADSP <- plyr::rbind.fill(ADSP_NHW,ADSP_NHB)
rm(ACT,ADNI,NACC,ROSMAP,ADSP_NHW,ADSP_NHB)

ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHW_ADSP_GWAS_Final_rs6733839.raw"))
ADNI <- fread(paste0(Main_directory,"Data/Raw/ADNI_NHW_ADSP_GWAS_Final_rs6733839.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHW_ADSP_GWAS_Final_rs6733839.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHW_ADSP_GWAS_Final_rs6733839.raw"))
NHW <- rbind(ACT,ADNI,NACC,ROSMAP)
rm(ACT,ADNI,NACC,ROSMAP)

#ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHB_ADSP_GWAS_Final_rs6733839.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHB_ADSP_GWAS_Final_rs6733839.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHB_ADSP_GWAS_Final_rs6733839.raw"))
NHB <- rbind(NACC,ROSMAP)
ADSP_raw <- rbind(NHW,NHB)
rm(NACC,ROSMAP,NHW,NHB)

ADSP_Master <- merge(ADSP,ADSP_raw,by=c("FID","IID"))
ADSP_Master$dx_new[ADSP_Master$dx==2|3] <- "CI"
ADSP_Master$dx_new[ADSP_Master$dx==1] <- "CU"

###Run Models
#race*sex*SNP
summary(lm(memslopes ~ as.factor(race)*as.factor(sex)*rs6733839_T, data=ADSP_Master, na.action=na.omit))

#dx*sex*SNP
summary(lm(memslopes ~ as.factor(dx_new)*as.factor(sex)*rs6733839_T, data=ADSP_Master, na.action=na.omit))

#race*dx*sex*SNP
summary(lm(memslopes ~ as.factor(race)*as.factor(dx_new)*as.factor(sex)*rs6733839_T, data=ADSP_Master, na.action=na.omit))

######################################################rs719070######################################################
###NHW pheno & covar info
ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADNI <- fread(paste0(Main_directory,"GWAS_Files/ADNI_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHW <- rbind(ACT,ADNI,NACC,ROSMAP)

###NHB pheno & covar info
#ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHB <- rbind(NACC,ROSMAP)

###Combine and add in SNP info
ADSP <- plyr::rbind.fill(ADSP_NHW,ADSP_NHB)
rm(ACT,ADNI,NACC,ROSMAP,ADSP_NHW,ADSP_NHB)

ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHW_ADSP_GWAS_Final_rs719070.raw"))
ADNI <- fread(paste0(Main_directory,"Data/Raw/ADNI_NHW_ADSP_GWAS_Final_rs719070.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHW_ADSP_GWAS_Final_rs719070.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHW_ADSP_GWAS_Final_rs719070.raw"))
NHW <- rbind(ACT,ADNI,NACC,ROSMAP)
rm(ACT,ADNI,NACC,ROSMAP)

#ACT <- fread(paste0(Main_directory,"Data/Raw/ACT_NHB_ADSP_GWAS_Final_rs719070.raw"))
NACC <- fread(paste0(Main_directory,"Data/Raw/NACC_NHB_ADSP_GWAS_Final_rs719070.raw"))
ROSMAP <- fread(paste0(Main_directory,"Data/Raw/ROSMAP_NHB_ADSP_GWAS_Final_rs719070.raw"))
NHB <- rbind(NACC,ROSMAP)
ADSP_raw <- rbind(NHW,NHB)
rm(NACC,ROSMAP,NHW,NHB)

ADSP_Master <- merge(ADSP,ADSP_raw,by=c("FID","IID"))
ADSP_Master$dx_new[ADSP_Master$dx==2|3] <- "CI"
ADSP_Master$dx_new[ADSP_Master$dx==1] <- "CU"

###Run Models
#race*sex*SNP
summary(lm(MEM ~ as.factor(race)*as.factor(sex)*rs719070_A, data=ADSP_Master, na.action=na.omit))

#dx*sex*SNP
summary(lm(MEM ~ as.factor(dx_new)*as.factor(sex)*rs719070_A, data=ADSP_Master, na.action=na.omit))

#race*dx*sex*SNP
summary(lm(MEM ~ as.factor(race)*as.factor(dx_new)*as.factor(sex)*rs719070_A, data=ADSP_Master, na.action=na.omit))

###Plot
ADSP_Master$sex <- ifelse(ADSP_Master$sex==1,"Men","Women")
ADSP_Master_Temp <- ADSP_Master %>% filter(!is.na(rs719070_A)) %>% filter(dx_new=="CI")
ADSP_Master <- ADSP_Master %>% filter(!is.na(rs719070_A)) %>% filter(dx_new=="CU")
ADSP_Master_NHB <- ADSP_Master %>% filter(race=="NHB")
ADSP_Master_NHW <- ADSP_Master %>% filter(race=="NHW")

png(paste0(Main_directory,"Data/Plots/CrossAncestry_CI_rs719070_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_Temp, aes(y=MEM, x=sex, fill=as.factor(rs719070_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs719070") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/CrossAncestry_CU_rs719070_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master, aes(y=MEM, x=sex, fill=as.factor(rs719070_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs719070") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHB_CU_rs719070_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_NHB, aes(y=MEM, x=sex, fill=as.factor(rs719070_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs719070") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

png(paste0(Main_directory,"Data/Plots/NHW_CU_rs719070_by_Sex.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_Master_NHW, aes(y=MEM, x=sex, fill=as.factor(rs719070_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs719070") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","AG","AA"))
dev.off()

