#By Jaclyn Eissman, March 30, 2023
#Packages
library(data.table)
library(metafor)
library(forestplot)
library(ggplot2)
library(dplyr)

#Directory
dir <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/"

#Read in covar/pheno files
NACC_Pheno <- fread(paste0(dir,"GWAS_Files/NACC_NHB_memslopes_WithComorbidities_60plus.txt"))
NACC_Covar <- fread(paste0(dir,"GWAS_Files/NACC_NHB_memslopes_WithComorbidities_60plus_Interaction_Impaired.txt"))
NACC_Covar$memslopes <- NULL
NACC <- merge(NACC_Pheno,NACC_Covar,by=c("FID","IID"))
NACC$Study <- "NACC"

ROSMAP_Pheno <- fread(paste0(dir,"GWAS_Files/ROSMAP_NHB_memslopes_WithComorbidities_60plus.txt"))
ROSMAP_Covar <- fread(paste0(dir,"GWAS_Files/ROSMAP_NHB_memslopes_WithComorbidities_60plus_Interaction_Impaired.txt"))
ROSMAP_Covar$memslopes <- NULL
ROSMAP <- merge(ROSMAP_Pheno,ROSMAP_Covar,by=c("FID","IID"))
ROSMAP$Study <- "ROSMAP"

ALL <- rbind(NACC,ROSMAP)
rm(NACC,ROSMAP)

#Read in raw files -- rs5935633 -- and merge in
#ACT <- fread(paste0(dir,"Data/Raw/ACT_NHB_ADSP_GWAS_Final_rs5935633.raw"))
NACC <- fread(paste0(dir,"Data/Raw/NACC_NHB_ADSP_GWAS_Final_rs5935633.raw"))
ROSMAP <- fread(paste0(dir,"Data/Raw/ROSMAP_NHB_ADSP_GWAS_Final_rs5935633.raw"))
Raw <- rbind(NACC,ROSMAP)
Data <- merge(ALL,Raw,by=c("FID","IID"))

#Run linear models -- Men
NACC_Men <- lm(memslopes ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs5935633_A, 
               data=Data[Data$Study=="NACC" & Data$sex==1,], na.action=na.omit)
ROSMAP_Men <- lm(memslopes ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs5935633_A, 
                 data=Data[Data$Study=="ROSMAP" & Data$sex==1,], na.action=na.omit)

#Run linear models -- Women
NACC_Women <- lm(memslopes ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs5935633_A, 
                 data=Data[Data$Study=="NACC" & Data$sex==2,], na.action=na.omit)
ROSMAP_Women <- lm(memslopes ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs5935633_A, 
                   data=Data[Data$Study=="ROSMAP" & Data$sex==2,], na.action=na.omit)

#Run linear models -- Interaction
NACC_Interaction <- lm(memslopes ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs5935633_A*sex, 
                       data=Data[Data$Study=="NACC",], na.action=na.omit)
ROSMAP_Interaction <- lm(memslopes ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs5935633_A*sex, 
                         data=Data[Data$Study=="ROSMAP",], na.action=na.omit)

#Run meta-analyses
Beta_Men <- c(summary(NACC_Men)$coefficients["rs5935633_A", "Estimate"],
              summary(ROSMAP_Men)$coefficients["rs5935633_A", "Estimate"])
SE_Men <- c(summary(NACC_Men)$coefficients["rs5935633_A", "Std. Error"],
            summary(ROSMAP_Men)$coefficients["rs5935633_A", "Std. Error"])
Meta_Men <- rma(yi=Beta_Men,sei=SE_Men,method="FE")

Beta_Women <- c(summary(NACC_Women)$coefficients["rs5935633_A", "Estimate"],
                summary(ROSMAP_Women)$coefficients["rs5935633_A", "Estimate"])
SE_Women <- c(summary(NACC_Women)$coefficients["rs5935633_A", "Std. Error"],
              summary(ROSMAP_Women)$coefficients["rs5935633_A", "Std. Error"])
Meta_Women <- rma(yi=Beta_Women,sei=SE_Women,method="FE")

Beta_Interaction <- c(summary(NACC_Interaction)$coefficients["rs5935633_A:sex", "Estimate"],
                      summary(ROSMAP_Interaction)$coefficients["rs5935633_A:sex", "Estimate"])
SE_Interaction <- c(summary(NACC_Interaction)$coefficients["rs5935633_A:sex", "Std. Error"],
                    summary(ROSMAP_Interaction)$coefficients["rs5935633_A:sex", "Std. Error"])
Meta_Interaction <- rma(yi=Beta_Interaction,sei=SE_Interaction,method="FE")

#Pull values
To_Plot_Men <- as.data.frame(cbind(Beta = unlist(c( summary(NACC_Men)$coefficients["rs5935633_A", "Estimate"],  
                                                   summary(ROSMAP_Men)$coefficients["rs5935633_A", "Estimate"] , 
                                                   unname(coef(summary(Meta_Men))["estimate"]))),
                                   lower = unlist(c(confint(NACC_Men)["rs5935633_A","2.5 %"], 
                                                    confint(ROSMAP_Men)["rs5935633_A","2.5 %"], 
                                                    unname(coef(summary(Meta_Men))["ci.lb"]))),
                                   upper = unlist(c(confint(NACC_Men)["rs5935633_A","97.5 %"], 
                                                    confint(ROSMAP_Men)["rs5935633_A","97.5 %"], 
                                                    unname(coef(summary(Meta_Men))["ci.ub"])))))

To_Plot_Women <- as.data.frame(cbind(Beta = unlist(c(summary(NACC_Women)$coefficients["rs5935633_A", "Estimate"],  
                                                     summary(ROSMAP_Women)$coefficients["rs5935633_A", "Estimate"] , 
                                                     unname(coef(summary(Meta_Women))["estimate"]))),
                                     lower = unlist(c(confint(NACC_Women)["rs5935633_A","2.5 %"], 
                                                      confint(ROSMAP_Women)["rs5935633_A","2.5 %"], 
                                                      unname(coef(summary(Meta_Women))["ci.lb"]))),
                                     upper = unlist(c(confint(NACC_Women)["rs5935633_A","97.5 %"], 
                                                      confint(ROSMAP_Women)["rs5935633_A","97.5 %"], 
                                                      unname(coef(summary(Meta_Women))["ci.ub"])))))

To_Plot_Interaction <- as.data.frame(cbind(Beta = unlist(c(summary(NACC_Interaction)$coefficients["rs5935633_A:sex", "Estimate"],  
                                                           summary(ROSMAP_Interaction)$coefficients["rs5935633_A:sex", "Estimate"] , 
                                                           unname(coef(summary(Meta_Interaction))["estimate"]))),
                                           lower = unlist(c(confint(NACC_Interaction)["rs5935633_A:sex","2.5 %"], 
                                                            confint(ROSMAP_Interaction)["rs5935633_A:sex","2.5 %"], 
                                                            unname(coef(summary(Meta_Interaction))["ci.lb"]))),
                                           upper = unlist(c(confint(NACC_Interaction)["rs5935633_A:sex","97.5 %"], 
                                                            confint(ROSMAP_Interaction)["rs5935633_A:sex","97.5 %"], 
                                                            unname(coef(summary(Meta_Interaction))["ci.ub"])))))
tabletext <- list(c("NACC","ROS/MAP/MARS","Meta-Analysis"))

png(paste0(dir,"XWAS/NHB/Forest_Plot_rs5935633.png"),width=11,height=7,units="in",res=300)
forestplot(tabletext,mean=cbind(To_Plot_Men$Beta,To_Plot_Women$Beta,To_Plot_Interaction$Beta),is.summary=c(rep(FALSE,2),TRUE),
           col=fpColors(box=cbind("deepskyblue2","hotpink1","purple"),line=cbind("deepskyblue2","hotpink1","purple"),
                        summary=cbind("deepskyblue2","hotpink1","purple")),  
           lower=cbind(To_Plot_Men$lower,To_Plot_Women$lower,To_Plot_Interaction$lower), 
           txt_gp=fpTxtGp(ticks=gpar(cex=0.8),xlab=gpar(cex=1)),
           upper=cbind(To_Plot_Men$upper,To_Plot_Women$upper,To_Plot_Interaction$upper),xlab="Beta (95% CI)",
           ci.vertices=TRUE,ci.vertices.height=0.07,boxsize=0.1,legend=c("Men","Women","Sex-Interaction"))
dev.off()

png(paste0(dir,"XWAS/NHB/Box_Plot_rs5935633.png"),width=11,height=7,units="in",res=300)
Data$sex <- ifelse(Data$sex==1,"Men","Women")
ggplot(data=Data, aes(y=memslopes, x=sex, fill=as.factor(rs5935633_A))) + geom_boxplot() + 
  geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs5935633") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_text(colour="black",size=14,face="bold")) +
  scale_fill_manual(values=c("hotpink","deepskyblue","purple"),labels=c("GG","GA","AA"))
dev.off()



