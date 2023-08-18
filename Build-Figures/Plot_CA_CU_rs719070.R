#By Jaclyn Eissman, March 30, 2023
#Packages
library(data.table)
library(metafor)
library(forestplot)
library(ggplot2)
library(dplyr)

#Directory
dir <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/"

##########################################NHW##########################################
#Read in covar/pheno files
NHW_ACT_Pheno <- fread(paste0(dir,"GWAS_Files/ACT_NHW_MEM_WithComorbidities_60plus.txt"))
NHW_ACT_Covar <- fread(paste0(dir,"GWAS_Files/ACT_NHW_MEM_WithComorbidities_60plus_Interaction_Normals.txt"))
NHW_ACT_Covar$MEM <- NULL
NHW_ACT <- merge(NHW_ACT_Pheno,NHW_ACT_Covar,by=c("FID","IID"))
NHW_ACT$Study <- "ACT"

NHW_ADNI_Pheno <- fread(paste0(dir,"GWAS_Files/ADNI_NHW_MEM_WithComorbidities_60plus.txt"))
NHW_ADNI_Covar <- fread(paste0(dir,"GWAS_Files/ADNI_NHW_MEM_WithComorbidities_60plus_Interaction_Normals.txt"))
NHW_ADNI_Covar$MEM <- NULL
NHW_ADNI <- merge(NHW_ADNI_Pheno,NHW_ADNI_Covar,by=c("FID","IID"))
NHW_ADNI$Study <- "ADNI"

NHW_NACC_Pheno <- fread(paste0(dir,"GWAS_Files/NACC_NHW_MEM_WithComorbidities_60plus.txt"))
NHW_NACC_Covar <- fread(paste0(dir,"GWAS_Files/NACC_NHW_MEM_WithComorbidities_60plus_Interaction_Normals.txt"))
NHW_NACC_Covar$MEM <- NULL
NHW_NACC <- merge(NHW_NACC_Pheno,NHW_NACC_Covar,by=c("FID","IID"))
NHW_NACC$Study <- "NACC"

NHW_ROSMAP_Pheno <- fread(paste0(dir,"GWAS_Files/ROSMAP_NHW_MEM_WithComorbidities_60plus.txt"))
NHW_ROSMAP_Covar <- fread(paste0(dir,"GWAS_Files/ROSMAP_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NHW_ROSMAP_Covar$MEM <- NULL
NHW_ROSMAP <- merge(NHW_ROSMAP_Pheno,NHW_ROSMAP_Covar,by=c("FID","IID"))
NHW_ROSMAP$Study <- "ROSMAP"

NHW_ALL <- rbind(NHW_ACT,NHW_ADNI,NHW_NACC,NHW_ROSMAP)
rm(NHW_ACT,NHW_ADNI,NHW_NACC,NHW_ROSMAP)

#Read in raw files -- rs719070 -- and merge in
NHW_ACT <- fread(paste0(dir,"Data/Raw/ACT_NHW_ADSP_GWAS_Final_rs719070.raw"))
NHW_ADNI <- fread(paste0(dir,"Data/Raw/ADNI_NHW_ADSP_GWAS_Final_rs719070.raw"))
NHW_NACC <- fread(paste0(dir,"Data/Raw/NACC_NHW_ADSP_GWAS_Final_rs719070.raw"))
NHW_ROSMAP <- fread(paste0(dir,"Data/Raw/ROSMAP_NHW_ADSP_GWAS_Final_rs719070.raw"))
NHW_Raw <- rbind(NHW_ACT,NHW_ADNI,NHW_NACC,NHW_ROSMAP)
NHW_Data <- merge(NHW_ALL,NHW_Raw,by=c("FID","IID"))

#Run linear models -- Men
NHW_ACT_Men <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                  data=NHW_Data[NHW_Data$Study=="ACT" & NHW_Data$sex==1,], na.action=na.omit)
NHW_ADNI_Men <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                   data=NHW_Data[NHW_Data$Study=="ADNI" & NHW_Data$sex==1,], na.action=na.omit)
NHW_NACC_Men <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                   data=NHW_Data[NHW_Data$Study=="NACC" & NHW_Data$sex==1,], na.action=na.omit)
NHW_ROSMAP_Men <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                     data=NHW_Data[NHW_Data$Study=="ROSMAP" & NHW_Data$sex==1,], na.action=na.omit)

#Run linear models -- Women
NHW_ACT_Women <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                    data=NHW_Data[NHW_Data$Study=="ACT" & NHW_Data$sex==2,], na.action=na.omit)
NHW_ADNI_Women <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                     data=NHW_Data[NHW_Data$Study=="ADNI" & NHW_Data$sex==2,], na.action=na.omit)
NHW_NACC_Women <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                     data=NHW_Data[NHW_Data$Study=="NACC" & NHW_Data$sex==2,], na.action=na.omit)
NHW_ROSMAP_Women <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A, 
                       data=NHW_Data[NHW_Data$Study=="ROSMAP" & NHW_Data$sex==2,], na.action=na.omit)

#Run linear models -- Interaction
NHW_ACT_Interaction <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A*sex, 
                          data=NHW_Data[NHW_Data$Study=="ACT",], na.action=na.omit)
NHW_ADNI_Interaction <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A*sex, 
                           data=NHW_Data[NHW_Data$Study=="ADNI",], na.action=na.omit)
NHW_NACC_Interaction <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A*sex, 
                           data=NHW_Data[NHW_Data$Study=="NACC",], na.action=na.omit)
NHW_ROSMAP_Interaction <- lm(MEM ~ Age + NHW_PC1 + NHW_PC2 + NHW_PC3 + NHW_PC4 + NHW_PC5 + rs719070_A*sex, 
                             data=NHW_Data[NHW_Data$Study=="ROSMAP",], na.action=na.omit)


#Run meta-analyses
NHW_Beta_Men <- c(summary(NHW_ACT_Men)$coefficients["rs719070_A", "Estimate"],
                  summary(NHW_ADNI_Men)$coefficients["rs719070_A", "Estimate"],
                  summary(NHW_NACC_Men)$coefficients["rs719070_A", "Estimate"],
                  summary(NHW_ROSMAP_Men)$coefficients["rs719070_A", "Estimate"])
NHW_SE_Men <- c(summary(NHW_ACT_Men)$coefficients["rs719070_A", "Std. Error"],
                summary(NHW_ADNI_Men)$coefficients["rs719070_A", "Std. Error"],
                summary(NHW_NACC_Men)$coefficients["rs719070_A", "Std. Error"],
                summary(NHW_ROSMAP_Men)$coefficients["rs719070_A", "Std. Error"])
NHW_Meta_Men <- rma(yi=NHW_Beta_Men,sei=NHW_SE_Men,method="FE")

NHW_Beta_Women <- c(summary(NHW_ACT_Women)$coefficients["rs719070_A", "Estimate"],
                    summary(NHW_ADNI_Women)$coefficients["rs719070_A", "Estimate"],
                    summary(NHW_NACC_Women)$coefficients["rs719070_A", "Estimate"],
                    summary(NHW_ROSMAP_Women)$coefficients["rs719070_A", "Estimate"])
NHW_SE_Women <- c(summary(NHW_ACT_Women)$coefficients["rs719070_A", "Std. Error"],
                  summary(NHW_ADNI_Women)$coefficients["rs719070_A", "Std. Error"],
                  summary(NHW_NACC_Women)$coefficients["rs719070_A", "Std. Error"],
                  summary(NHW_ROSMAP_Women)$coefficients["rs719070_A", "Std. Error"])
NHW_Meta_Women <- rma(yi=NHW_Beta_Women,sei=NHW_SE_Women,method="FE")

NHW_Beta_Interaction <- c(summary(NHW_ACT_Interaction)$coefficients["rs719070_A:sex", "Estimate"],
                          summary(NHW_ADNI_Interaction)$coefficients["rs719070_A:sex", "Estimate"],
                          summary(NHW_NACC_Interaction)$coefficients["rs719070_A:sex", "Estimate"],
                          summary(NHW_ROSMAP_Interaction)$coefficients["rs719070_A:sex", "Estimate"])
NHW_SE_Interaction <- c(summary(NHW_ACT_Interaction)$coefficients["rs719070_A:sex", "Std. Error"],
                        summary(NHW_ADNI_Interaction)$coefficients["rs719070_A:sex", "Std. Error"],
                        summary(NHW_NACC_Interaction)$coefficients["rs719070_A:sex", "Std. Error"],
                        summary(NHW_ROSMAP_Interaction)$coefficients["rs719070_A:sex", "Std. Error"])
NHW_Meta_Interaction <- rma(yi=NHW_Beta_Interaction,sei=NHW_SE_Interaction,method="FE")

##########################################NHB##########################################
#Read in covar/pheno files
NHB_ACT_Pheno <- fread(paste0(dir,"GWAS_Files/ACT_NHB_MEM_WithComorbidities_60plus.txt"))
NHB_ACT_Covar <- fread(paste0(dir,"GWAS_Files/ACT_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NHB_ACT_Covar$MEM <- NULL
NHB_ACT <- merge(NHB_ACT_Pheno,NHB_ACT_Covar,by=c("FID","IID"))
NHB_ACT$Study <- "ACT"

NHB_NACC_Pheno <- fread(paste0(dir,"GWAS_Files/NACC_NHB_MEM_WithComorbidities_60plus.txt"))
NHB_NACC_Covar <- fread(paste0(dir,"GWAS_Files/NACC_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NHB_NACC_Covar$MEM <- NULL
NHB_NACC <- merge(NHB_NACC_Pheno,NHB_NACC_Covar,by=c("FID","IID"))
NHB_NACC$Study <- "NACC"

NHB_ROSMAP_Pheno <- fread(paste0(dir,"GWAS_Files/ROSMAP_NHB_MEM_WithComorbidities_60plus.txt"))
NHB_ROSMAP_Covar <- fread(paste0(dir,"GWAS_Files/ROSMAP_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NHB_ROSMAP_Covar$MEM <- NULL
NHB_ROSMAP <- merge(NHB_ROSMAP_Pheno,NHB_ROSMAP_Covar,by=c("FID","IID"))
NHB_ROSMAP$Study <- "ROSMAP"

NHB_ALL <- rbind(NHB_ACT,NHB_NACC,NHB_ROSMAP)
rm(NHB_ACT,NHB_NACC,NHB_ROSMAP)

#Read in raw files -- rs719070 -- and merge in
NHB_ACT <- fread(paste0(dir,"Data/Raw/ACT_NHB_ADSP_GWAS_Final_rs719070.raw"))
NHB_NACC <- fread(paste0(dir,"Data/Raw/NACC_NHB_ADSP_GWAS_Final_rs719070.raw"))
NHB_Raw <- rbind(NHB_ACT,NHB_NACC)
NHB_Data <- merge(NHB_ALL,NHB_Raw,by=c("FID","IID"))

#Run linear models -- Men
NHB_ACT_Men <- lm(MEM ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs719070_A, 
                  data=NHB_Data[NHB_Data$Study=="ACT" & NHB_Data$sex==1,], na.action=na.omit)
NHB_NACC_Men <- lm(MEM ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs719070_A, 
                   data=NHB_Data[NHB_Data$Study=="NACC" & NHB_Data$sex==1,], na.action=na.omit)

#Run linear models -- Women
NHB_ACT_Women <- lm(MEM ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs719070_A, 
                    data=NHB_Data[NHB_Data$Study=="ACT" & NHB_Data$sex==2,], na.action=na.omit)
NHB_NACC_Women <- lm(MEM ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs719070_A, 
                     data=NHB_Data[NHB_Data$Study=="NACC" & NHB_Data$sex==2,], na.action=na.omit)

#Run linear models -- Interaction
NHB_ACT_Interaction <- lm(MEM ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs719070_A*sex, 
                          data=NHB_Data[NHB_Data$Study=="ACT",], na.action=na.omit)
NHB_NACC_Interaction <- lm(MEM ~ Age + NHB_PC1 + NHB_PC2 + NHB_PC3 + NHB_PC4 + NHB_PC5 + rs719070_A*sex, 
                           data=NHB_Data[NHB_Data$Study=="NACC",], na.action=na.omit)


#Run meta-analyses
NHB_Beta_Men <- c(summary(NHB_ACT_Men)$coefficients["rs719070_A", "Estimate"],
                  summary(NHB_NACC_Men)$coefficients["rs719070_A", "Estimate"])
NHB_SE_Men <- c(summary(NHB_ACT_Men)$coefficients["rs719070_A", "Std. Error"],
                summary(NHB_NACC_Men)$coefficients["rs719070_A", "Std. Error"])
NHB_Meta_Men <- rma(yi=NHB_Beta_Men,sei=NHB_SE_Men,method="FE")

NHB_Beta_Women <- c(summary(NHB_ACT_Women)$coefficients["rs719070_A", "Estimate"],
                    summary(NHB_NACC_Women)$coefficients["rs719070_A", "Estimate"])
NHB_SE_Women <- c(summary(NHB_ACT_Women)$coefficients["rs719070_A", "Std. Error"],
                  summary(NHB_NACC_Women)$coefficients["rs719070_A", "Std. Error"])
NHB_Meta_Women <- rma(yi=NHB_Beta_Women,sei=NHB_SE_Women,method="FE")

NHB_Beta_Interaction <- c(summary(NHB_ACT_Interaction)$coefficients["rs719070_A:sex", "Estimate"],
                          summary(NHB_NACC_Interaction)$coefficients["rs719070_A:sex", "Estimate"])
NHB_SE_Interaction <- c(summary(NHB_ACT_Interaction)$coefficients["rs719070_A:sex", "Std. Error"],
                        summary(NHB_NACC_Interaction)$coefficients["rs719070_A:sex", "Std. Error"])
NHB_Meta_Interaction <- rma(yi=NHB_Beta_Interaction,sei=NHB_SE_Interaction,method="FE")

##########################################C-A##########################################
#Pull values
NHW_To_Plot_Men <- as.data.frame(cbind(Beta = unlist(c(summary(NHW_ACT_Men)$coefficients["rs719070_A", "Estimate"], 
                                                       summary(NHW_ADNI_Men)$coefficients["rs719070_A", "Estimate"], 
                                                       summary(NHW_NACC_Men)$coefficients["rs719070_A", "Estimate"],  
                                                       summary(NHW_ROSMAP_Men)$coefficients["rs719070_A", "Estimate"] , 
                                                       unname(coef(summary(NHW_Meta_Men))["estimate"]))),
                                       lower = unlist(c(confint(NHW_ACT_Men)["rs719070_A","2.5 %"], 
                                                        confint(NHW_ADNI_Men)["rs719070_A","2.5 %"], 
                                                        confint(NHW_NACC_Men)["rs719070_A","2.5 %"], 
                                                        confint(NHW_ROSMAP_Men)["rs719070_A","2.5 %"], 
                                                        unname(coef(summary(NHW_Meta_Men))["ci.lb"]))),
                                       upper = unlist(c(confint(NHW_ACT_Men)["rs719070_A","97.5 %"], 
                                                        confint(NHW_ADNI_Men)["rs719070_A","97.5 %"], 
                                                        confint(NHW_NACC_Men)["rs719070_A","97.5 %"], 
                                                        confint(NHW_ROSMAP_Men)["rs719070_A","97.5 %"], 
                                                        unname(coef(summary(NHW_Meta_Men))["ci.ub"])))))

NHB_To_Plot_Men <- as.data.frame(cbind(Beta = unlist(c(summary(NHB_ACT_Men)$coefficients["rs719070_A", "Estimate"],
                                                       summary(NHB_NACC_Men)$coefficients["rs719070_A", "Estimate"], 
                                                       unname(coef(summary(NHB_Meta_Men))["estimate"]))),
                                       lower = unlist(c(confint(NHB_ACT_Men)["rs719070_A","2.5 %"],
                                                        confint(NHB_NACC_Men)["rs719070_A","2.5 %"], 
                                                        unname(coef(summary(NHB_Meta_Men))["ci.lb"]))),
                                       upper = unlist(c(confint(NHB_ACT_Men)["rs719070_A","97.5 %"],
                                                        confint(NHB_NACC_Men)["rs719070_A","97.5 %"], 
                                                        unname(coef(summary(NHB_Meta_Men))["ci.ub"])))))

Meta_Beta_Men <- unlist(c(unname(coef(summary(NHW_Meta_Men))["estimate"]),unname(coef(summary(NHB_Meta_Men))["estimate"])))
Meta_SE_Men <- unlist(c(unname(coef(summary(NHW_Meta_Men))["se"]),unname(coef(summary(NHB_Meta_Men))["se"])))
Meta_Men <- rma(yi=Meta_Beta_Men,sei=Meta_SE_Men,method="FE")
Temp_To_Plot_Men <- as.data.frame(cbind(Beta = unlist(c(unname(coef(summary(Meta_Men))["estimate"]))),
                                        lower = unlist(c(unname(coef(summary(Meta_Men))["ci.lb"]))),
                                        upper = unlist(c(unname(coef(summary(Meta_Men))["ci.ub"])))))
To_Plot_Men <- rbind(NHW_To_Plot_Men,NHB_To_Plot_Men,Temp_To_Plot_Men)

NHW_To_Plot_Women <- as.data.frame(cbind(Beta = unlist(c(summary(NHW_ACT_Women)$coefficients["rs719070_A", "Estimate"], 
                                                         summary(NHW_ADNI_Women)$coefficients["rs719070_A", "Estimate"], 
                                                         summary(NHW_NACC_Women)$coefficients["rs719070_A", "Estimate"],  
                                                         summary(NHW_ROSMAP_Women)$coefficients["rs719070_A", "Estimate"] , 
                                                         unname(coef(summary(NHW_Meta_Women))["estimate"]))),
                                         lower = unlist(c(confint(NHW_ACT_Women)["rs719070_A","2.5 %"], 
                                                          confint(NHW_ADNI_Women)["rs719070_A","2.5 %"], 
                                                          confint(NHW_NACC_Women)["rs719070_A","2.5 %"], 
                                                          confint(NHW_ROSMAP_Women)["rs719070_A","2.5 %"], 
                                                          unname(coef(summary(NHW_Meta_Women))["ci.lb"]))),
                                         upper = unlist(c(confint(NHW_ACT_Women)["rs719070_A","97.5 %"], 
                                                          confint(NHW_ADNI_Women)["rs719070_A","97.5 %"], 
                                                          confint(NHW_NACC_Women)["rs719070_A","97.5 %"], 
                                                          confint(NHW_ROSMAP_Women)["rs719070_A","97.5 %"], 
                                                          unname(coef(summary(NHW_Meta_Women))["ci.ub"])))))

NHB_To_Plot_Women <- as.data.frame(cbind(Beta = unlist(c(summary(NHB_ACT_Women)$coefficients["rs719070_A", "Estimate"],
                                                         summary(NHB_NACC_Women)$coefficients["rs719070_A", "Estimate"], 
                                                         unname(coef(summary(NHB_Meta_Women))["estimate"]))),
                                         lower = unlist(c(confint(NHB_ACT_Women)["rs719070_A","2.5 %"],
                                                          confint(NHB_NACC_Women)["rs719070_A","2.5 %"], 
                                                          unname(coef(summary(NHB_Meta_Women))["ci.lb"]))),
                                         upper = unlist(c(confint(NHB_ACT_Women)["rs719070_A","97.5 %"],
                                                          confint(NHB_NACC_Women)["rs719070_A","97.5 %"], 
                                                          unname(coef(summary(NHB_Meta_Women))["ci.ub"])))))

Meta_Beta_Women <- unlist(c(unname(coef(summary(NHW_Meta_Women))["estimate"]),unname(coef(summary(NHB_Meta_Women))["estimate"])))
Meta_SE_Women <- unlist(c(unname(coef(summary(NHW_Meta_Women))["se"]),unname(coef(summary(NHB_Meta_Women))["se"])))
Meta_Women <- rma(yi=Meta_Beta_Women,sei=Meta_SE_Women,method="FE")
Temp_To_Plot_Women <- as.data.frame(cbind(Beta = unlist(c(unname(coef(summary(Meta_Women))["estimate"]))),
                                          lower = unlist(c(unname(coef(summary(Meta_Women))["ci.lb"]))),
                                          upper = unlist(c(unname(coef(summary(Meta_Women))["ci.ub"])))))
To_Plot_Women <- rbind(NHW_To_Plot_Women,NHB_To_Plot_Women,Temp_To_Plot_Women)

NHW_To_Plot_Interaction <- as.data.frame(cbind(Beta = unlist(c(summary(NHW_ACT_Interaction)$coefficients["rs719070_A:sex", "Estimate"], 
                                                               summary(NHW_ADNI_Interaction)$coefficients["rs719070_A:sex", "Estimate"], 
                                                               summary(NHW_NACC_Interaction)$coefficients["rs719070_A:sex", "Estimate"],  
                                                               summary(NHW_ROSMAP_Interaction)$coefficients["rs719070_A:sex", "Estimate"] , 
                                                               unname(coef(summary(NHW_Meta_Interaction))["estimate"]))),
                                               lower = unlist(c(confint(NHW_ACT_Interaction)["rs719070_A:sex","2.5 %"], 
                                                                confint(NHW_ADNI_Interaction)["rs719070_A:sex","2.5 %"], 
                                                                confint(NHW_NACC_Interaction)["rs719070_A:sex","2.5 %"], 
                                                                confint(NHW_ROSMAP_Interaction)["rs719070_A:sex","2.5 %"], 
                                                                unname(coef(summary(NHW_Meta_Interaction))["ci.lb"]))),
                                               upper = unlist(c(confint(NHW_ACT_Interaction)["rs719070_A:sex","97.5 %"], 
                                                                confint(NHW_ADNI_Interaction)["rs719070_A:sex","97.5 %"], 
                                                                confint(NHW_NACC_Interaction)["rs719070_A:sex","97.5 %"], 
                                                                confint(NHW_ROSMAP_Interaction)["rs719070_A:sex","97.5 %"], 
                                                                unname(coef(summary(NHW_Meta_Interaction))["ci.ub"])))))

NHB_To_Plot_Interaction <- as.data.frame(cbind(Beta = unlist(c(summary(NHB_ACT_Interaction)$coefficients["rs719070_A:sex", "Estimate"],
                                                               summary(NHB_NACC_Interaction)$coefficients["rs719070_A:sex", "Estimate"], 
                                                               unname(coef(summary(NHB_Meta_Interaction))["estimate"]))),
                                               lower = unlist(c(confint(NHB_ACT_Interaction)["rs719070_A:sex","2.5 %"],
                                                                confint(NHB_NACC_Interaction)["rs719070_A:sex","2.5 %"], 
                                                                unname(coef(summary(NHB_Meta_Interaction))["ci.lb"]))),
                                               upper = unlist(c(confint(NHB_ACT_Interaction)["rs719070_A:sex","97.5 %"],
                                                                confint(NHB_NACC_Interaction)["rs719070_A:sex","97.5 %"], 
                                                                unname(coef(summary(NHB_Meta_Interaction))["ci.ub"])))))

Meta_Beta_Interaction <- unlist(c(unname(coef(summary(NHW_Meta_Interaction))["estimate"]),unname(coef(summary(NHB_Meta_Interaction))["estimate"])))
Meta_SE_Interaction <- unlist(c(unname(coef(summary(NHW_Meta_Interaction))["se"]),unname(coef(summary(NHB_Meta_Interaction))["se"])))
Meta_Interaction <- rma(yi=Meta_Beta_Interaction,sei=Meta_SE_Interaction,method="FE")
Temp_To_Plot_Interaction <- as.data.frame(cbind(Beta = unlist(c(unname(coef(summary(Meta_Interaction))["estimate"]))),
                                                lower = unlist(c(unname(coef(summary(Meta_Interaction))["ci.lb"]))),
                                                upper = unlist(c(unname(coef(summary(Meta_Interaction))["ci.ub"])))))
To_Plot_Interaction <- rbind(NHW_To_Plot_Interaction,NHB_To_Plot_Interaction,Temp_To_Plot_Interaction)

tabletext <- list(c("   ACT NHW","   ADNI NHW","   NACC NHW","   ROSMAP NHW","Meta-Analysis NHW","   ACT NHB","   NACC NHB","Meta-Analysis NHB","Cross-Ancestry Meta-Analysis"))

png(paste0(dir,"GWAS/Cross_Ancestry/Forest_Plot_rs719070.png"),width=11,height=7,units="in",res=300)
forestplot(tabletext,mean=cbind(To_Plot_Men$Beta,To_Plot_Women$Beta,To_Plot_Interaction$Beta),
           is.summary=c(rep(FALSE,4),TRUE,rep(FALSE,2),TRUE,TRUE),
           col=fpColors(box=cbind("deepskyblue2","hotpink1","purple"),line=cbind("deepskyblue2","hotpink1","purple"),
                        summary=cbind("deepskyblue2","hotpink1","purple")),
           lower=cbind(To_Plot_Men$lower,To_Plot_Women$lower,To_Plot_Interaction$lower), 
           txt_gp=fpTxtGp(ticks=gpar(cex=0.8),xlab=gpar(cex=1)),
           upper=cbind(To_Plot_Men$upper,To_Plot_Women$upper,To_Plot_Interaction$upper),xlab="Beta (95% CI)",ci.vertices=TRUE,
           ci.vertices.height=0.07,boxsize=0.1,legend=c("Men","Women","Sex-Interaction"))
dev.off()

png(paste0(dir,"GWAS/Cross_Ancestry/Box_Plot_rs719070.png"),width=11,height=7,units="in",res=300)
Data <- plyr::rbind.fill(NHW_Data,NHB_Data)
Data$sex <- ifelse(Data$sex==1,"Men","Women")
ggplot(data=Data%>%dplyr::filter(!is.na(rs719070_A)), aes(y=MEM, x=sex, fill=as.factor(rs719070_A))) + 
  geom_boxplot() + geom_point(position=position_dodge(width=0.75)) + 
  xlab("Sex") + ylab("Baseline Memory") + labs(fill="rs719070") +
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) +
  theme(legend.title=element_text(colour="black",size=14,face="bold")) +
  scale_fill_manual(values=c("hotpink1","deepskyblue2","purple"),labels=c("GG","GA","AA"))
dev.off()


