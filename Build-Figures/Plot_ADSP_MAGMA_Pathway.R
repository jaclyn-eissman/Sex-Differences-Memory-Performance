#By Jaclyn Eissman, March 30, 2023
#Packages
library(data.table)
library(ggplot2)
library(dplyr)

#Directory
dir <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/"

###############--------------------Cross-Ancestry MEM ALL--------------------###############
#Read in files
Males <- fread(paste0(dir,"MAGMA/Cross_Ancestry/ADSP_Cross_Ancestry_MEM_WithComorbidities_60plus_Men_ALL_subset_MAF01_noAPOE.gsa.out_with_FDR"))
Females <- fread(paste0(dir,"MAGMA/Cross_Ancestry/ADSP_Cross_Ancestry_MEM_WithComorbidities_60plus_Women_ALL_subset_MAF01_noAPOE.gsa.out_with_FDR"))

#Pull significant pathways
Males_Pathways <- Males[order(Males$P.fdr),][1:10,]$FULL_NAME
Females_Pathways <- Females[order(Females$P.fdr),][1:10,]$FULL_NAME
Pathways <- rbind(Males_Pathways,Females_Pathways)

Males <- Males[Males$FULL_NAME %in% Pathways,] %>% dplyr::select(c("FULL_NAME","BETA","SE","P","P.fdr"))
Females <- Females[Females$FULL_NAME %in% Pathways,] %>% dplyr::select(c("FULL_NAME","BETA","SE","P","P.fdr"))

#Combine
Males$Sex <- "Males"
Females$Sex <- "Females"

#Make CI
Males$CI_Upper <- Males$BETA + (Males$SE*1.96)
Males$CI_Lower <- Males$BETA - (Males$SE*1.96)

Females$CI_Upper <- Females$BETA + (Females$SE*1.96)
Females$CI_Lower <- Females$BETA - (Females$SE*1.96)

#Combine
Data <- rbind(Males,Females)
Data$sex <- ifelse(Data$sex==1,"Males","Females")
Data$P_Group <- "P>0.05"
Data$P_Group[Data$P<0.05] <- "P<0.05"
Data$P_Group[Data$P.fdr<0.05] <- "P.FDR<0.05"
Data$Sex_P_Group <- factor(paste(Data$Sex,Data$P_Group,sep="_"))

#Plot pathway
png(paste0(dir,"MAGMA/Cross_Ancestry/ADSP_Cross_Ancestry_MEM_ALL_CI.png"),width=17,height=6.5,units="in",res=1000)
ggplot(Data, aes(x=BETA, y=FULL_NAME, color=Sex_P_Group, shape=Sex_P_Group)) + 
  geom_linerange(aes(xmin=CI_Lower, xmax=CI_Upper), position=position_dodge(1)) +
  geom_pointrange(aes(xmin=CI_Lower, xmax=CI_Upper), size=0.5, position=position_dodge(1)) +
  geom_errorbar(aes(xmin=CI_Lower, xmax=CI_Upper), width=0.7, size=0.7, position=position_dodge(1)) +
  geom_vline(xintercept=0) + theme_bw() + 
  theme(axis.text.y=element_text(angle=10,vjust=0.5,hjust=1,colour="black",size=8)) +
  theme(axis.title.y=element_text(colour="black",size=16,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=16,face="bold")) +
  theme(legend.title=element_blank(),legend.position="top") +
  xlab("Baseline Memory Associations") + ylab("Biological Pathway") +
  scale_colour_manual(labels=c("Females, P.FDR<0.05","Females, P<0.05","Females, P>0.05",
                               "Males, P<0.05", "Males, P>0.05"),
                      values=c("hotpink1","hotpink1", "hotpink1",
                               "deepskyblue2", "deepskyblue2")) +   
  scale_shape_manual(labels=c("Females, P.FDR<0.05","Females, P<0.05","Females, P>0.05",
                              "Males, P<0.05", "Males, P>0.05"),
                     values=c(15,2,1,2,1))
dev.off()

Females$Level <- factor(Females$FULL_NAME,levels=Females[order(Females$P.fdr),]$FULL_NAME)
png(paste0(dir,"MAGMA/Cross_Ancestry/ADSP_Cross_Ancestry_MEM_ALL_Bar.png"),width=17,height=6.5,units="in",res=1000)
ggplot(data=Females, aes(x=Level, y=-log10(P))) + 
  geom_bar(stat="identity", fill="hotpink1") + coord_flip() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(colour = "hotpink1")) + theme_bw() + 
  theme(axis.text.y=element_text(angle=5,vjust=0.5,hjust=1,colour="black",size=8)) +
  geom_hline(yintercept=-log10(5e-05)) +
  labs(x="Biological Pathways", y="-log10P") + theme(axis.text=element_text(size=10)) +
  theme(axis.title.y=element_text(colour="black",size=16,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=16,face="bold")) 
dev.off()





