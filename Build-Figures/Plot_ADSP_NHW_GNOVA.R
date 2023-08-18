#By Jaclyn Eissman, March 30, 2023
#Packages
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyverse)

#Directory
dir <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/"

##############################################NHW ALL MEM##############################################
key <- fread(paste0(dir,"Data/GNOVA_Trait_Key.txt"))
categories <- fread(paste0(dir,"Data/GNOVA_Pheno_Groups.txt"))
key <- merge(key,categories,by.x="New_Trait",by.y="Trait")
sex <- c('1'="Males",'2'="Females")
files <- c("GNOVA/NHW/ADSP_NHW_MEM_WithComorbidities_60plus_Men_ALL_subset_MAF01_noAPOE_All_Traits.txt",
           "GNOVA/NHW/ADSP_NHW_MEM_WithComorbidities_60plus_Women_ALL_subset_MAF01_noAPOE_All_Traits.txt")
list_df <- c()

for (i in 1:length(files)){
  temp <- read.table(paste0(dir,files[i]))
  temp <- temp[,c("V17","V9","V10","V12")]
  #"corr_corrected","se_corr_corrected","pvalue_corrected_corr"
  names(temp) <- c("Trait","Genetic_Corr","SE_Corr","P_Corr")
  temp$Sex <- sex[i]
  temp$CI_upper <- temp$Genetic_Corr + (temp$SE_Corr*1.96)
  temp$CI_lower <- temp$Genetic_Corr - (temp$SE_Corr*1.96)
  temp <- temp[order(temp$P_Corr,decreasing=F),]
  temp$P.FDR <- p.adjust(temp$P_Corr, method="fdr")
  temp$P_Group <- "P>0.05"
  temp$P_Group[temp$P_Corr<0.05] <- "P<0.05"
  temp$P_Group[temp$P.FDR<0.05] <- "P.FDR<0.05"
  temp <- merge(key,temp,by.x="Old_Trait",by.y="Trait")
  list_df[[i]] <- temp
  rm(temp)
}

#Combine and get P-value group by sex
Data <- do.call(rbind,list_df)
Data$Sex_P_Group <- factor(paste(Data$Sex,Data$P_Group,sep="_"))
Data <- Data[order(Data$Sex_P_Group),]
print(unique(Data$Sex_P_Group))

#Plot traits
png(paste0(dir,"GNOVA/NHW/ADSP_NHW_MEM_WithComorbidities_60plus_ALL.png"),width=8.5,height=10,units="in",res=1000)
ggplot(Data, aes(x=Genetic_Corr, y=New_Trait, color=Sex_P_Group, shape=Sex_P_Group)) + 
  geom_linerange(aes(xmin=CI_lower, xmax=CI_upper), position=position_dodge(1)) +
  geom_pointrange(aes(xmin=CI_lower, xmax=CI_upper), 
                  size=0.5, position=position_dodge(1)) +
  geom_errorbar(aes(xmin=CI_lower, xmax=CI_upper), width=0.7, size=0.7, position=position_dodge(1)) + 
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Correlations with Baseline Memory") +
  theme(axis.text.y=element_text(vjust=0.5,hjust=1,colour="black",size=10)) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  facet_grid(Group ~ ., scales = "free_y", space = "free_y") + 
  ylab("") + theme(strip.text.y = element_text(angle=0)) + scale_y_discrete(limits=rev) +
  theme(legend.position="top", legend.title=element_blank()) +
  scale_colour_manual(labels=c("Females, P.FDR<0.05","Females, P<0.05","Females, P>0.05",
                               "Males, P.FDR<0.05","Males, P<0.05", "Males, P>0.05"),
                      values=c("hotpink1","hotpink1","hotpink1",
                               "deepskyblue2","deepskyblue2","deepskyblue2")) +   
  scale_shape_manual(labels=c("Females, P.FDR<0.05","Females, P<0.05","Females, P>0.05",
                              "Males, P.FDR<0.05","Males, P<0.05", "Males, P>0.05"),
                     values=c(15,2,1,15,2,1))
dev.off()

##############################################NHW ALL memslopes##############################################
key <- fread(paste0(dir,"Data/GNOVA_Trait_Key.txt"))
categories <- fread(paste0(dir,"Data/GNOVA_Pheno_Groups.txt"))
key <- merge(key,categories,by.x="New_Trait",by.y="Trait")
sex <- c('1'="Males",'2'="Females")
files <- c("GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_Men_ALL_subset_MAF01_noAPOE_All_Traits.txt",
           "GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_Women_ALL_subset_MAF01_noAPOE_All_Traits.txt")
list_df <- c()

for (i in 1:length(files)){
  temp <- read.table(paste0(dir,files[i]))
  temp <- temp[,c("V17","V9","V10","V12")]
  #"corr_corrected","se_corr_corrected","pvalue_corrected_corr"
  names(temp) <- c("Trait","Genetic_Corr","SE_Corr","P_Corr")
  temp$Sex <- sex[i]
  temp$CI_upper <- temp$Genetic_Corr + (temp$SE_Corr*1.96)
  temp$CI_lower <- temp$Genetic_Corr - (temp$SE_Corr*1.96)
  temp <- temp[order(temp$P_Corr,decreasing=F),]
  temp$P.FDR <- p.adjust(temp$P_Corr, method="fdr")
  temp$P_Group <- "P>0.05"
  temp$P_Group[temp$P_Corr<0.05] <- "P<0.05"
  temp$P_Group[temp$P.FDR<0.05] <- "P.FDR<0.05"
  temp <- merge(key,temp,by.x="Old_Trait",by.y="Trait")
  list_df[[i]] <- temp
  rm(temp)
}

#Combine and get P-value group by sex
Data <- do.call(rbind,list_df)
Data$Sex_P_Group <- factor(paste(Data$Sex,Data$P_Group,sep="_"))
Data <- Data[order(Data$Sex_P_Group),]
print(unique(Data$Sex_P_Group))

#Plot traits
png(paste0(dir,"GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_ALL.png"),width=8.5,height=10,units="in",res=1000)
ggplot(Data, aes(x=Genetic_Corr, y=New_Trait, color=Sex_P_Group, shape=Sex_P_Group)) + 
  geom_linerange(aes(xmin=CI_lower, xmax=CI_upper), position=position_dodge(1)) +
  geom_pointrange(aes(xmin=CI_lower, xmax=CI_upper), 
                  size=0.5, position=position_dodge(1)) +
  geom_errorbar(aes(xmin=CI_lower, xmax=CI_upper), width=0.7, size=0.7, position=position_dodge(1)) + 
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Correlations with Memory Decline") +
  theme(axis.text.y=element_text(vjust=0.5,hjust=1,colour="black",size=10)) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  facet_grid(Group ~ ., scales = "free_y", space = "free_y") + 
  ylab("") + theme(strip.text.y = element_text(angle=0)) + scale_y_discrete(limits=rev) +
  theme(legend.position="top", legend.title=element_blank()) +
  scale_colour_manual(labels=c("Females, P.FDR<0.05","Females, P<0.05","Females, P>0.05",
                               "Males, P.FDR<0.05","Males, P<0.05", "Males, P>0.05"),
                      values=c("hotpink1","hotpink1","hotpink1",
                               "deepskyblue2","deepskyblue2","deepskyblue2")) +   
  scale_shape_manual(labels=c("Females, P.FDR<0.05","Females, P<0.05","Females, P>0.05",
                              "Males, P.FDR<0.05","Males, P<0.05", "Males, P>0.05"),
                     values=c(15,2,1,15,2,1))
dev.off()

##############################################NHW ALL Sig MEM##############################################
key <- fread(paste0(dir,"Data/GNOVA_Trait_Key.txt"))
categories <- fread(paste0(dir,"Data/GNOVA_Pheno_Groups.txt"))
key <- merge(key,categories,by.x="New_Trait",by.y="Trait")
sex <- c('1'="Males",'2'="Females")
files <- c("GNOVA/NHW/ADSP_NHW_MEM_WithComorbidities_60plus_Men_ALL_subset_MAF01_noAPOE_All_Traits.txt",
           "GNOVA/NHW/ADSP_NHW_MEM_WithComorbidities_60plus_Women_ALL_subset_MAF01_noAPOE_All_Traits.txt")
list_df <- c()

for (i in 1:length(files)){
  temp <- read.table(paste0(dir,files[i]))
  temp <- temp[,c("V17","V9","V10","V12")]
  #"corr_corrected","se_corr_corrected","pvalue_corrected_corr"
  names(temp) <- c("Trait","Genetic_Corr","SE_Corr","P_Corr")
  temp$Sex <- sex[i]
  temp$CI_upper <- temp$Genetic_Corr + (temp$SE_Corr*1.96)
  temp$CI_lower <- temp$Genetic_Corr - (temp$SE_Corr*1.96)
  temp <- temp[order(temp$P_Corr,decreasing=F),]
  temp$P.FDR <- p.adjust(temp$P_Corr, method="fdr")
  temp$P_Group <- "P>0.05"
  temp$P_Group[temp$P_Corr<0.05] <- "P<0.05"
  temp$P_Group[temp$P.FDR<0.05] <- "P.FDR<0.05"
  temp <- merge(key,temp,by.x="Old_Trait",by.y="Trait")
  list_df[[i]] <- temp
  rm(temp)
}

#Combine and get P-value group by sex
Data <- do.call(rbind,list_df)
Data$Sex_P_Group <- factor(paste(Data$Sex,Data$P_Group,sep="_"))
Data <- Data[order(Data$Sex_P_Group),]
Traits = unique(Data[Data$P_Group=="P.FDR<0.05",]$New_Trait)
Data = Data %>% filter(New_Trait %in% Traits)
print(unique(Data$Sex_P_Group))

#Plot traits
png(paste0(dir,"GNOVA/NHW/ADSP_NHW_MEM_WithComorbidities_60plus_ALL_SigTraits.png"),width=8.5,height=10,units="in",res=1000)
ggplot(Data, aes(x=Genetic_Corr, y=New_Trait, color=Sex_P_Group, shape=Sex_P_Group)) + 
  geom_linerange(aes(xmin=CI_lower, xmax=CI_upper), position=position_dodge(1)) +
  geom_pointrange(aes(xmin=CI_lower, xmax=CI_upper), 
                  size=0.5, position=position_dodge(1)) +
  geom_errorbar(aes(xmin=CI_lower, xmax=CI_upper), width=0.7, size=0.7, position=position_dodge(1)) + 
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Correlations with Baseline Memory") +
  theme(axis.text.y=element_text(vjust=0.5,hjust=1,colour="black",size=10)) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  facet_grid(Group ~ ., scales = "free_y", space = "free_y") + 
  ylab("") + theme(strip.text.y = element_text(angle=0)) + scale_y_discrete(limits=rev) +
  theme(legend.position="top", legend.title=element_blank()) +
  scale_colour_manual(labels=c("Females, P.FDR<0.05","Females, P>0.05",
                                "Males, P.FDR<0.05","Males, P<0.05","Males, P>0.05"),
                      values=c("hotpink1","hotpink1",
                               "deepskyblue2", "deepskyblue2", "deepskyblue2")) +   
  scale_shape_manual(labels=c("Females, P.FDR<0.05","Females, P>0.05",
                              "Males, P.FDR<0.05","Males, P<0.05","Males, P>0.05"),
                     values=c(15,1,15,2,1))
dev.off()

##############################################NHW ALL Sig memslopes##############################################
key <- fread(paste0(dir,"Data/GNOVA_Trait_Key.txt"))
categories <- fread(paste0(dir,"Data/GNOVA_Pheno_Groups.txt"))
key <- merge(key,categories,by.x="New_Trait",by.y="Trait")
sex <- c('1'="Males",'2'="Females")
files <- c("GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_Men_ALL_subset_MAF01_noAPOE_All_Traits.txt",
           "GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_Women_ALL_subset_MAF01_noAPOE_All_Traits.txt")
list_df <- c()

for (i in 1:length(files)){
  temp <- read.table(paste0(dir,files[i]))
  temp <- temp[,c("V17","V9","V10","V12")]
  #"corr_corrected","se_corr_corrected","pvalue_corrected_corr"
  names(temp) <- c("Trait","Genetic_Corr","SE_Corr","P_Corr")
  temp$Sex <- sex[i]
  temp$CI_upper <- temp$Genetic_Corr + (temp$SE_Corr*1.96)
  temp$CI_lower <- temp$Genetic_Corr - (temp$SE_Corr*1.96)
  temp <- temp[order(temp$P_Corr,decreasing=F),]
  temp$P.FDR <- p.adjust(temp$P_Corr, method="fdr")
  temp$P_Group <- "P>0.05"
  temp$P_Group[temp$P_Corr<0.05] <- "P<0.05"
  temp$P_Group[temp$P.FDR<0.05] <- "P.FDR<0.05"
  temp <- merge(key,temp,by.x="Old_Trait",by.y="Trait")
  list_df[[i]] <- temp
  rm(temp)
}

#Combine and get P-value group by sex
Data <- do.call(rbind,list_df)
Data$Sex_P_Group <- factor(paste(Data$Sex,Data$P_Group,sep="_"))
Data <- Data[order(Data$Sex_P_Group),]
Traits = unique(Data[Data$P_Group=="P.FDR<0.05",]$New_Trait)
Data = Data %>% filter(New_Trait %in% Traits)
print(unique(Data$Sex_P_Group))

#Plot traits
png(paste0(dir,"GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_ALL_SigTraits.png"),width=8.5,height=10,units="in",res=1000)
ggplot(Data, aes(x=Genetic_Corr, y=New_Trait, color=Sex_P_Group, shape=Sex_P_Group)) + 
  geom_linerange(aes(xmin=CI_lower, xmax=CI_upper), position=position_dodge(1)) +
  geom_pointrange(aes(xmin=CI_lower, xmax=CI_upper), 
                  size=0.5, position=position_dodge(1)) +
  geom_errorbar(aes(xmin=CI_lower, xmax=CI_upper), width=0.7, size=0.7, position=position_dodge(1)) + 
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Correlations with Memory Decline") +
  theme(axis.text.y=element_text(vjust=0.5,hjust=1,colour="black",size=10)) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  facet_grid(Group ~ ., scales = "free_y", space = "free_y") + 
  ylab("") + theme(strip.text.y = element_text(angle=0)) + scale_y_discrete(limits=rev) +
  theme(legend.position="top", legend.title=element_blank()) +
  scale_colour_manual(labels=c("Females, P.FDR<0.05","Females, P>0.05",
                               "Males, P.FDR<0.05","Males, P<0.05","Males, P>0.05"),
                      values=c("hotpink1","hotpink1",
                               "deepskyblue2", "deepskyblue2", "deepskyblue2")) +   
  scale_shape_manual(labels=c("Females, P.FDR<0.05","Females, P>0.05",
                              "Males, P.FDR<0.05","Males, P<0.05","Males, P>0.05"),
                     values=c(15,1,15,2,1))
dev.off()



