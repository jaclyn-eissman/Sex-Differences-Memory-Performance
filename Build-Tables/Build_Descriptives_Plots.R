#Load packages
source("/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Scripts/load_all_libraries.R")

#Directories -- fix paths to re-run
Master_build_directory <- "/Users/jackieeissman/VUMC/Research - Hohman - Documents/CNT/Data/Cognitive_Build/Archived_Builds/"
Main_directory <- "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Data/Plots/"

#Read in data 
cog_data=readRDS(paste0(Master_build_directory,"Cognitive_Master_Build_All_Participants_December_2022.RDS")) 
cog_data$Study <- ifelse(cog_data$Study=="ROSMAP","ROS/MAP/MARS",cog_data$Study)
cog_data$Phenotype_ID <- paste0(cog_data$FID,"_",cog_data$Study)

#Pull ADSP cohorts
cog_data <- cog_data %>% filter(Study=="ACT"|Study=="ADNI"|Study=="NACC"|Study=="ROS/MAP/MARS")

#Pull baseline visit
cog_data_bl <- cog_data %>% filter(Age==Age_bl_MEM) %>% filter(Age_bl_MEM>=60)

#Overlaid Histograms
png(paste0(Main_directory,"Memory_Histogram_by_Study_in_CU.png"),width=11,height=7,units="in",res=330)
ggplot(data=cog_data_bl%>%filter(dx_bl_MEM==1), aes(MEM)) + 
  theme_minimal() + theme(panel.grid.minor = element_blank()) +
  geom_histogram(aes(color=Study, fill=Study), alpha = 0.2) +
  xlab("Baseline Memory Scores among Unimpaired") + ylab("Count") +
  theme(legend.position=c(.90,.40),legend.title=element_text(size=14,face="bold"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12), axis.title=element_text(size=12)) +
  scale_color_manual(values = c("red","orange","yellow","green"),
                     labels=c("ACT","ADNI","NACC","ROS/MAP/MARS")) + 
  scale_fill_manual(values = c("red","orange","yellow","green"),
                     labels=c("ACT","ADNI","NACC","ROS/MAP/MARS")) + 
  theme(axis.text.y=element_text(colour="black",size=14)) +
  theme(axis.title.y=element_text(colour="black",size=18,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=18,face="bold")) 
dev.off()

png(paste0(Main_directory,"Memory_Histogram_by_Study_in_CI.png"),width=11,height=7,units="in",res=330)
ggplot(data=cog_data_bl%>%filter(dx_bl_MEM>1), aes(MEM)) + 
  theme_minimal() + theme(panel.grid.minor = element_blank()) +
  geom_histogram(aes(color=Study, fill=Study), alpha = 0.2) +
  xlab("Baseline Memory Scores among Impaired") + ylab("Count") +
  theme(legend.position=c(.90,.40),legend.title=element_text(size=14,face="bold"),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12), axis.title=element_text(size=12)) +
  scale_color_manual(values = c("red","orange","yellow","green"),
                     labels=c("ADNI","NACC","ROS/MAP/MARS")) + 
  scale_fill_manual(values = c("orange","yellow","green"),
                    labels=c("ADNI","NACC","ROS/MAP/MARS")) + 
  theme(axis.text.y=element_text(colour="black",size=14)) +
  theme(axis.title.y=element_text(colour="black",size=18,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=18,face="bold")) 
dev.off()


