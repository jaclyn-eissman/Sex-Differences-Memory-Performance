#Load packages
source("/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Scripts/load_all_libraries.R")

#Directories 
Master_build_directory <- "/Users/jackieeissman/VUMC/Research - Hohman - Documents/CNT/Data/Cognitive_Build/"
Main_directory <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/"

#Read in data 
cog_data <- readRDS(paste0(Master_build_directory,"Archived_Builds/Cognitive_Master_Build_All_Participants_December_2022.RDS")) 
cog_data$FID_with_Study <- paste0(cog_data$FID,"_",cog_data$Study)

#Pull ADSP cohorts
ADSP_cog_data <- cog_data %>% filter(Study=="ACT"|Study=="ADNI"|Study=="NACC"|Study=="ROSMAP")

#NHW
ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADNI <- fread(paste0(Main_directory,"GWAS_Files/ADNI_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHW_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHW <- rbind(ACT,ADNI,NACC,ROSMAP)
ADSP_NHW_IDs <- ADSP_NHW$FID

ADSP_NHW_data <- ADSP_cog_data[ADSP_cog_data$FID %in% ADSP_NHW_IDs,]
ADSP_NHW_data_men <- ADSP_NHW_data %>% filter(sex==1)
ADSP_NHW_data_women <- ADSP_NHW_data %>% filter(sex==2)

#NHB
ACT <- fread(paste0(Main_directory,"GWAS_Files/ACT_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
NACC <- fread(paste0(Main_directory,"GWAS_Files/NACC_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ROSMAP <- fread(paste0(Main_directory,"GWAS_Files/ROSMAP_NHB_MEM_WithComorbidities_60plus_Interaction_ALL.txt"))
ADSP_NHB <- rbind(ACT,NACC,ROSMAP)
ADSP_NHB_IDs <- ADSP_NHB$FID

ADSP_NHB_data <- ADSP_cog_data[ADSP_cog_data$FID %in% ADSP_NHB_IDs,]
ADSP_NHB_data_men <- ADSP_NHB_data %>% filter(sex==1)
ADSP_NHB_data_women <- ADSP_NHB_data %>% filter(sex==2)

#Overall
ADSP_overall <- ADSP_cog_data[ADSP_cog_data$FID %in% c(ADSP_NHW_IDs,ADSP_NHB_IDs),]
ADSP_overall_men <- ADSP_overall %>% filter(sex==1)
ADSP_overall_women <- ADSP_overall %>% filter(sex==2)

#NHW
ADSP_NHW_data_long <- ADSP_NHW_data %>% filter(num_visits_MEM>=2)
ADSP_NHW_data_men_long <- ADSP_NHW_data_men %>% filter(num_visits_MEM>=2)
ADSP_NHW_data_women_long <- ADSP_NHW_data_women %>% filter(num_visits_MEM>=2)

round(mean(ADSP_NHW_data_men_long$interval_MEM,na.rm=T),2)
round(sd(ADSP_NHW_data_men$interval_MEM,na.rm=T),2)

round(mean(ADSP_NHW_data_men_long$num_visits_MEM,na.rm=T),2)
round(sd(ADSP_NHW_data_men_long$num_visits_MEM,na.rm=T),2)

round(mean(ADSP_NHW_data_women_long$interval_MEM,na.rm=T),2)
round(sd(ADSP_NHW_data_women_long$interval_MEM,na.rm=T),2)

round(mean(ADSP_NHW_data_women_long$num_visits_MEM,na.rm=T),2)
round(sd(ADSP_NHW_data_women_long$num_visits_MEM,na.rm=T),2)

#NHB
ADSP_NHB_data_long <- ADSP_NHB_data %>% filter(num_visits_MEM>=2)
ADSP_NHB_data_men_long <- ADSP_NHB_data_men %>% filter(num_visits_MEM>=2)
ADSP_NHB_data_women_long <- ADSP_NHB_data_women %>% filter(num_visits_MEM>=2)

round(mean(ADSP_NHB_data_men_long$interval_MEM,na.rm=T),2)
round(sd(ADSP_NHB_data_men$interval_MEM,na.rm=T),2)

round(mean(ADSP_NHB_data_men_long$num_visits_MEM,na.rm=T),2)
round(sd(ADSP_NHB_data_men_long$num_visits_MEM,na.rm=T),2)

round(mean(ADSP_NHB_data_women_long$interval_MEM,na.rm=T),2)
round(sd(ADSP_NHB_data_women_long$interval_MEM,na.rm=T),2)

round(mean(ADSP_NHB_data_women_long$num_visits_MEM,na.rm=T),2)
round(sd(ADSP_NHB_data_women_long$num_visits_MEM,na.rm=T),2)

#Overall
ADSP_overall_long <- ADSP_overall %>% filter(num_visits_MEM>=2)
ADSP_overall_men_long <- ADSP_overall_men %>% filter(num_visits_MEM>=2)
ADSP_overall_women_long <- ADSP_overall_women %>% filter(num_visits_MEM>=2)

round(mean(ADSP_overall_men_long$interval_MEM,na.rm=T),2)
round(sd(ADSP_overall_men_long$interval_MEM,na.rm=T),2)

round(mean(ADSP_overall_men_long$num_visits_MEM,na.rm=T),2)
round(sd(ADSP_overall_men_long$num_visits_MEM,na.rm=T),2)

round(mean(ADSP_overall_women_long$interval_MEM,na.rm=T),2)
round(sd(ADSP_overall_women_long$interval_MEM,na.rm=T),2)

round(mean(ADSP_overall_women_long$num_visits_MEM,na.rm=T),2)
round(sd(ADSP_overall_women_long$num_visits_MEM,na.rm=T),2)

#Now subset to baseline for rest
ADSP_NHW_data_men_bl <- ADSP_NHW_data_men %>% filter(Age==Age_bl_MEM)
ADSP_NHB_data_men_bl <- ADSP_NHB_data_men %>% filter(Age==Age_bl_MEM)

ADSP_NHW_data_women_bl <- ADSP_NHW_data_women %>% filter(Age==Age_bl_MEM)
ADSP_NHB_data_women_bl <- ADSP_NHB_data_women %>% filter(Age==Age_bl_MEM)

ADSP_overall_men_bl <- ADSP_overall_men %>% filter(Age==Age_bl_MEM)
ADSP_overall_women_bl <- ADSP_overall_women %>% filter(Age==Age_bl_MEM)

#NHW
round(mean(ADSP_NHW_data_men_bl$Age,na.rm=T),2)
round(sd(ADSP_NHW_data_men_bl$Age,na.rm=T),2)

round(mean(ADSP_NHW_data_men_bl$education,na.rm=T),2)
round(sd(ADSP_NHW_data_men_bl$education,na.rm=T),2)

round(mean(ADSP_NHW_data_men_bl$MEM,na.rm=T),2)
round(sd(ADSP_NHW_data_men_bl$MEM,na.rm=T),2)

round(mean(ADSP_NHW_data_men_bl$memslopes,na.rm=T),2)
round(sd(ADSP_NHW_data_men_bl$memslopes,na.rm=T),2)

round(mean(ADSP_NHW_data_women_bl$Age,na.rm=T),2)
round(sd(ADSP_NHW_data_women_bl$Age,na.rm=T),2)

round(mean(ADSP_NHW_data_women_bl$education,na.rm=T),2)
round(sd(ADSP_NHW_data_women_bl$education,na.rm=T),2)

round(mean(ADSP_NHW_data_women_bl$MEM,na.rm=T),2)
round(sd(ADSP_NHW_data_women_bl$MEM,na.rm=T),2)

round(mean(ADSP_NHW_data_women_bl$memslopes,na.rm=T),2)
round(sd(ADSP_NHW_data_women_bl$memslopes,na.rm=T),2)

#NHB
round(mean(ADSP_NHB_data_men_bl$Age,na.rm=T),2)
round(sd(ADSP_NHB_data_men_bl$Age,na.rm=T),2)

round(mean(ADSP_NHB_data_men_bl$education,na.rm=T),2)
round(sd(ADSP_NHB_data_men_bl$education,na.rm=T),2)

round(mean(ADSP_NHB_data_men_bl$MEM,na.rm=T),2)
round(sd(ADSP_NHB_data_men_bl$MEM,na.rm=T),2)

round(mean(ADSP_NHB_data_men_bl$memslopes,na.rm=T),2)
round(sd(ADSP_NHB_data_men_bl$memslopes,na.rm=T),2)

round(mean(ADSP_NHB_data_women_bl$Age,na.rm=T),2)
round(sd(ADSP_NHB_data_women_bl$Age,na.rm=T),2)

round(mean(ADSP_NHB_data_women_bl$education,na.rm=T),2)
round(sd(ADSP_NHB_data_women_bl$education,na.rm=T),2)

round(mean(ADSP_NHB_data_women_bl$MEM,na.rm=T),2)
round(sd(ADSP_NHB_data_women_bl$MEM,na.rm=T),2)

round(mean(ADSP_NHB_data_women_bl$memslopes,na.rm=T),2)
round(sd(ADSP_NHB_data_women_bl$memslopes,na.rm=T),2)

#Overall
round(mean(ADSP_overall_men_bl$Age,na.rm=T),2)
round(sd(ADSP_overall_men_bl$Age,na.rm=T),2)

round(mean(ADSP_overall_men_bl$education,na.rm=T),2)
round(sd(ADSP_overall_men_bl$education,na.rm=T),2)

round(mean(ADSP_overall_men_bl$MEM,na.rm=T),2)
round(sd(ADSP_overall_men_bl$MEM,na.rm=T),2)

round(mean(ADSP_overall_men_bl$memslopes,na.rm=T),2)
round(sd(ADSP_overall_men_bl$memslopes,na.rm=T),2)

round(mean(ADSP_overall_women_bl$Age,na.rm=T),2)
round(sd(ADSP_overall_women_bl$Age,na.rm=T),2)

round(mean(ADSP_overall_women_bl$education,na.rm=T),2)
round(sd(ADSP_overall_women_bl$education,na.rm=T),2)

round(mean(ADSP_overall_women_bl$MEM,na.rm=T),2)
round(sd(ADSP_overall_women_bl$MEM,na.rm=T),2)

round(mean(ADSP_overall_women_bl$memslopes,na.rm=T),2)
round(sd(ADSP_overall_women_bl$memslopes,na.rm=T),2)

#NHW
nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$dx) & ADSP_NHW_data_men_bl$dx==1,])
round(nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$dx) & ADSP_NHW_data_men_bl$dx==1,])/nrow(ADSP_NHW_data_men_bl)*100,2)

nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$dx) & ADSP_NHW_data_men_bl$dx>1,])
round(nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$dx) & ADSP_NHW_data_men_bl$dx>1,])/nrow(ADSP_NHW_data_men_bl)*100,2)

nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$apoe2pos) & ADSP_NHW_data_men_bl$apoe2pos==1,])
round(nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$apoe2pos) & ADSP_NHW_data_men_bl$apoe2pos==1,])/nrow(ADSP_NHW_data_men_bl)*100,2)

nrow(ADSP_NHW_data_men_bl[!is.na(ADSP_NHW_data_men_bl$apoe4pos) & ADSP_NHW_data_men_bl$apoe4pos==1,])
round(nrow(ADSP_NHW_data_men_bl[ADSP_NHW_data_men_bl$apoe4pos==1,])/nrow(ADSP_NHW_data_men_bl)*100,2)

nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$dx) & ADSP_NHW_data_women_bl$dx==1,])
round(nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$dx) & ADSP_NHW_data_women_bl$dx==1,])/nrow(ADSP_NHW_data_women_bl)*100,2)

nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$dx) & ADSP_NHW_data_women_bl$dx>1,])
round(nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$dx) & ADSP_NHW_data_women_bl$dx>1,])/nrow(ADSP_NHW_data_women_bl)*100,2)

nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$apoe2pos) & ADSP_NHW_data_women_bl$apoe2pos==1,])
round(nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$apoe2pos) & ADSP_NHW_data_women_bl$apoe2pos==1,])/nrow(ADSP_NHW_data_women_bl)*100,2)

nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$apoe4pos) & ADSP_NHW_data_women_bl$apoe4pos==1,])
round(nrow(ADSP_NHW_data_women_bl[!is.na(ADSP_NHW_data_women_bl$apoe4pos) & ADSP_NHW_data_women_bl$apoe4pos==1,])/nrow(ADSP_NHW_data_women_bl)*100,2)

#NHB
nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$dx) & ADSP_NHB_data_men_bl$dx==1,])
round(nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$dx) & ADSP_NHB_data_men_bl$dx==1,])/nrow(ADSP_NHB_data_men_bl)*100,2)

nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$dx) & ADSP_NHB_data_men_bl$dx>1,])
round(nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$dx) & ADSP_NHB_data_men_bl$dx>1,])/nrow(ADSP_NHB_data_men_bl)*100,2)

nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$apoe2pos) & ADSP_NHB_data_men_bl$apoe2pos==1,])
round(nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$apoe2pos) & ADSP_NHB_data_men_bl$apoe2pos==1,])/nrow(ADSP_NHB_data_men_bl)*100,2)

nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$apoe4pos) & ADSP_NHB_data_men_bl$apoe4pos==1,])
round(nrow(ADSP_NHB_data_men_bl[!is.na(ADSP_NHB_data_men_bl$apoe4pos) & ADSP_NHB_data_men_bl$apoe4pos==1,])/nrow(ADSP_NHB_data_men_bl)*100,2)

nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$dx) & ADSP_NHB_data_women_bl$dx==1,])
round(nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$dx) & ADSP_NHB_data_women_bl$dx==1,])/nrow(ADSP_NHB_data_women_bl)*100,2)

nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$dx) & ADSP_NHB_data_women_bl$dx>1,])
round(nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$dx) & ADSP_NHB_data_women_bl$dx>1,])/nrow(ADSP_NHB_data_women_bl)*100,2)

nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$apoe2pos) & ADSP_NHB_data_women_bl$apoe2pos==1,])
round(nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$apoe2pos) & ADSP_NHB_data_women_bl$apoe2pos==1,])/nrow(ADSP_NHB_data_women_bl)*100,2)

nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$apoe4pos) & ADSP_NHB_data_women_bl$apoe4pos==1,])
round(nrow(ADSP_NHB_data_women_bl[!is.na(ADSP_NHB_data_women_bl$apoe4pos) & ADSP_NHB_data_women_bl$apoe4pos==1,])/nrow(ADSP_NHB_data_women_bl)*100,2)

#Overall
nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$dx) & ADSP_overall_men_bl$dx==1,])
round(nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$dx) & ADSP_overall_men_bl$dx==1,])/nrow(ADSP_overall_men_bl)*100,2)

nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$dx) & ADSP_overall_men_bl$dx>1,])
round(nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$dx) & ADSP_overall_men_bl$dx>1,])/nrow(ADSP_overall_men_bl)*100,2)

nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$apoe2pos) & ADSP_overall_men_bl$apoe2pos==1,])
round(nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$apoe2pos) & ADSP_overall_men_bl$apoe2pos==1,])/nrow(ADSP_overall_men_bl)*100,2)

nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$apoe4pos) & ADSP_overall_men_bl$apoe4pos==1,])
round(nrow(ADSP_overall_men_bl[!is.na(ADSP_overall_men_bl$apoe4pos) & ADSP_overall_men_bl$apoe4pos==1,])/nrow(ADSP_overall_men_bl)*100,2)

nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$dx) & ADSP_overall_women_bl$dx==1,])
round(nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$dx) & ADSP_overall_women_bl$dx==1,])/nrow(ADSP_overall_women_bl)*100,2)

nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$dx) & ADSP_overall_women_bl$dx>1,])
round(nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$dx) & ADSP_overall_women_bl$dx>1,])/nrow(ADSP_overall_women_bl)*100,2)

nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$apoe2pos) & ADSP_overall_women_bl$apoe2pos==1,])
round(nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$apoe2pos) & ADSP_overall_women_bl$apoe2pos==1,])/nrow(ADSP_overall_women_bl)*100,2)

nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$apoe4pos) & ADSP_overall_women_bl$apoe4pos==1,])
round(nrow(ADSP_overall_women_bl[!is.na(ADSP_overall_women_bl$apoe4pos) & ADSP_overall_women_bl$apoe4pos==1,])/nrow(ADSP_overall_women_bl)*100,2)

ADSP_overall$Study <- ifelse(ADSP_overall$Study=="ROSMAP","ROS/MAP/MARS",ADSP_overall$Study)
png(paste0(Main_directory,"Data/Plots/ADSP_Histo_01.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_overall, aes(MEM)) + 
  theme_minimal() +
  theme(panel.grid.minor = element_blank()) +
  geom_histogram(aes(color=Study, fill=Study), alpha = 0.2) +
  xlab("Baseline Memory Scores") + ylab("Count") +
  theme(legend.position=c(.90,.30),legend.title=element_text(size=14,face="bold"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12), axis.title=element_text(size=12)) +
  theme(axis.text.y=element_text(colour="black",size=14)) +
  theme(axis.title.y=element_text(colour="black",size=18,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=18,face="bold")) 
dev.off()

ADSP_overall$Sex[ADSP_overall$sex==1] <- "Men"
ADSP_overall$Sex[ADSP_overall$sex==2] <- "Women"
png(paste0(Main_directory,"Data/Plots/ADSP_Histo_02.png"),width=11,height=7,units="in",res=300)
ggplot(data=ADSP_overall, aes(MEM)) + 
  theme_minimal() +
  theme(panel.grid.minor = element_blank()) +
  geom_histogram(aes(color=Sex, fill=Sex), alpha = 0.2) +
  xlab("Baseline Memory Scores") + ylab("Count") +
  theme(legend.position=c(.90,.30),legend.title=element_text(size=14,face="bold"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12), axis.title=element_text(size=12)) +
  theme(axis.text.y=element_text(colour="black",size=14)) +
  theme(axis.title.y=element_text(colour="black",size=18,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=18,face="bold")) +
  scale_color_manual(values=c("deepskyblue2","hotpink1")) +
  scale_fill_manual(values=c("deepskyblue2","hotpink1")) 
dev.off()

