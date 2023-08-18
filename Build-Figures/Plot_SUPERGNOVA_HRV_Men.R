#By Jaclyn Eissman, March 30, 2023
#Packages
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyverse)

#Directory
dir <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/"

###################Plot of rho vs bp -- resilience & memory###################
GLOBALRES = fread(paste0(dir,"Men_SDNN_GLOBALRES.txt"))
GLOBALRES$Phenotype = "Resilience"
memslopes = fread(paste0(dir,"Men_SDNN_memslopes.txt"))
memslopes$Phenotype = "Memory_Decline"
Data = rbind(GLOBALRES,memslopes)

pdf(paste0(dir,"Men_HRV_BP_vs_Rho_by_CHR_ALL.pdf"),width=13,height=7)
for (i in 1:length(unique(Data$chr))){
  DataTemp=Data%>%filter(chr==i)
  print(ggplot(DataTemp, aes(x=start, y=rho, color=Phenotype)) + geom_line() + theme_bw()+ 
    theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="top") +
    ylab("Covariance") + xlab("Start of Region") + labs(title=paste0("Chromosome ",i)))
}
dev.off()

GLOBALRES = fread(paste0(dir,"Men_SDNN_GLOBALRES.txt"))
GLOBALRES$Phenotype = "Resilience"
memslopes = fread(paste0(dir,"Men_SDNN_memslopes.txt"))
memslopes$Phenotype = "Memory_Decline"

Data = rbind(GLOBALRES,memslopes)
SigReg = Data[Data$p<0.05,]$start
Data_Sig = Data[Data$start %in% SigReg,]
Data_Sig = Data_Sig[order(Data_Sig$chr,Data_Sig$start),]

pdf(paste0(dir,"Men_HRV_BP_vs_Rho_SigReg.pdf"),width=13,height=7)
print(ggplot(Data_Sig, aes(x=start, y=rho, color=Phenotype)) + geom_line() + theme_bw()+ 
        theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="top") +
        ylab("Covariance") + xlab("Start of Region"))
dev.off()

GLOBALRES = fread(paste0(dir,"Men_SDNN_GLOBALRES.txt"))
GLOBALRES$Phenotype = "Resilience"
memslopes = fread(paste0(dir,"Men_SDNN_memslopes.txt"))
memslopes$Phenotype = "Memory_Decline"

Data = rbind(GLOBALRES,memslopes)
memslopes_sig = memslopes[memslopes$p<0.05,]$start
Data_Sig = Data[Data$start %in% memslopes_sig,]
Data_Sig = Data_Sig[order(Data_Sig$chr,Data_Sig$start),]

pdf(paste0(dir,"Men_HRV_BP_vs_Rho_Sig_memslopes.pdf"),width=13,height=7)
print(ggplot(Data_Sig, aes(x=start, y=rho, color=Phenotype)) + geom_line() + theme_bw()+ 
        theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="top") +
        ylab("Covariance") + xlab("Start of Region"))
dev.off()


