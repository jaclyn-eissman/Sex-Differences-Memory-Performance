############################
##########Libraries#########
############################
source("/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Scripts/load_all_libraries.R")

######################################
##########Setting directories#########
######################################
Master_build_directory<-"/Users/jackieeissman/Box Sync/Hohman_Lab/Cognitive_Builds/"
Main_directory<-"/Users/jackieeissman/Box Sync/Hohman_Lab/Archer_VMAC/Main_Effect_Cognitive_GWAS/"
File_directory<-"/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_ADSP_GWAS/GWAS_Files/"

######################################
############Reading in data###########
######################################
#####First, reading in Cognitive_Master_Build_All_Participants_December_2022.RDS
#####This has a Comoborbidities column which will be used to subset the cohort when necessary. 
cog_data<-readRDS(paste0(Master_build_directory,"Cognitive_Master_Build_All_Participants_December_2022.RDS")) 
cog_data$FID_with_Study<-paste0(cog_data$FID,"_",cog_data$Study)

sink(paste0(File_directory,"Sample_Sizes_Output_03.23.23.csv"))

##########################################################################################################
#########################Create phenotype and covariate files for MEM/memslopes###########################
##########################################################################################################
cog_variables<-c("memslopes","MEM")
cog_dictionary<-c("memslopes"="MEM","MEM"="MEM")
cohorts<-c("ACT","ADNI","ROSMAP","NACC") 
pc_dictionary<-c("NHW"="NHW","NHB"="AllRaces")

for (i in 1:length(cog_variables)){
  
  for (j in 1:length(cohorts)){
    
    ###Setup variables.
    cohort<-cohorts[j]
    var<-cog_variables[i]
    interval_var<-paste0("interval_",cog_dictionary[var])
    Age_var<-paste0("Age_bl_",cog_dictionary[var])
    dx_var<-paste0("dx_bl_",cog_dictionary[var])
    num_visits_var<-paste0("num_visits_",cog_dictionary[var])
    
    #################################################
    #############Save all necessary files############
    #################################################
    race_categories<-c("NHW","NHB")
    
    for (k in 1:length(race_categories)){
      
      #print(k)
      ###Get baseline datapoint for cognitive measure. 
      data_race<-cog_data[(cog_data$Age == cog_data[Age_var]),] %>% 
        filter(Study == cohort) %>% 
        filter(race == race_categories[k])
      
      ###Remove all relateds. This is reading the .fam files originally from:
      ###AllRaces: /data/h_vmac/arched1/Main_Effects_Cognitive_GWAS/Genetic_Datasets/AllRaces_Datasets/
      ###NHW: /data/h_vmac/arched1/Main_Effects_Cognitive_GWAS/Genetic_Datasets/NHW_Datasets/
      if(cohort!="BLSA"){
        participants_to_include<-read.table(paste0(Main_directory,"ADSP_NonRelated_Participants/",pc_dictionary[k],"/",cohort,"_",pc_dictionary[k],"_no_relateds.txt"),header=TRUE) 
        
        ###Create unique FID variable.
        data_race$FID_races<-paste0(cohort,"_",pc_dictionary[k],"_",data_race$FID)
        
        ###Remove participants not in participants_to_include df.
        print(paste0(nrow(data_race)," participants for ",cohort," before ",race_categories[k]," relatedness removal!"))
        data_race<-data_race[(data_race$FID %in% participants_to_include$FID),]
        print(paste0(nrow(data_race)," participants for ",cohort," after ",race_categories[k]," relatedness removal!"))
      }
      
      #############################
      ###Remove NHB PC outliers!###
      #############################
      if(race_categories[k]=="NHB"){
        #print(paste0(nrow(data_race %>% filter(AllRaces_PC1!="NA"))," NHB participants for ",cohort,"prior to PC removal!"))
        no_PC_outliers<-read.table(paste0("/Users/jackieeissman/Box Sync/Hohman_Lab/Cognitive_Builds/NHB_PCs/",cohort,"_NHB_PCs_Final.txt"),header=TRUE)
        data_race<-data_race[(data_race$FID %in% no_PC_outliers$FID),]
        #print(paste0(nrow(data_race)," NHB participants for ",cohort," after PC removal!"))
        data_race<-merge(data_race,no_PC_outliers,by=c("FID","IID"),all.x=TRUE)
      }
      
      ######################################################################
      ###################Create/save phenotype files########################
      ######################################################################
      
      ###Setup phenotype files. 
      data_phenotype_with_comorbid_participants<-data_race %>% 
        filter(!is.na(!!(sym(var)))) %>% 
        filter(!is.na(IID)) %>% 
        filter(!is.na(!!as.name(paste0(pc_dictionary[k],"_PC1")))) 
      
      data_phenotype_no_comorbid_participants<-data_race %>% 
        filter(!is.na(!!(sym(var)))) %>% 
        filter(!is.na(IID)) %>% 
        filter(!is.na(!!as.name(paste0(pc_dictionary[k],"_PC1")))) %>% 
        filter(Comorbidities==0) 
      
      ###Save 60+ phenotype files
      if(nrow(data_phenotype_with_comorbid_participants %>% filter(Age>=60))>1){write.table(data_phenotype_with_comorbid_participants %>% filter(Age>=60) %>% dplyr::select(c("FID","IID",!!(sym(var)))),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_phenotype_no_comorbid_participants %>% filter(Age>=60))>1){write.table(data_phenotype_no_comorbid_participants %>% filter(Age>=60) %>% dplyr::select(c("FID","IID",!!(sym(var)))),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus",".txt"),row.names=FALSE,quote=FALSE)}
      
      ######################################################################
      ###################Create/save covariate files########################
      ######################################################################
      
      ###PC variable names
      PC1<-paste0(race_categories[k],"_PC1")
      PC2<-paste0(race_categories[k],"_PC2")
      PC3<-paste0(race_categories[k],"_PC3")
      PC4<-paste0(race_categories[k],"_PC4")
      PC5<-paste0(race_categories[k],"_PC5")
      
      ###Setup cross-sectional covariate files. 
      covariate_variable_names<-c("FID","IID","Age","sex","education","race","dx",
                                  "apoe4count","apoe2count","apoe4pos","apoe2pos",
                                  PC1,PC2,PC3,PC4,PC5,var,"Comorbidities")
      
      ###Make covariate dataframes
      data_cov_ALL_with_comorbid_participants_60plus<-data_race[covariate_variable_names] %>% filter(!is.na(PC1)) %>% filter(!is.na(!!(sym(var)))) %>% filter(Age>=60) %>% filter(!is.na(IID))
      data_cov_ALL_without_comorbid_participants_60plus<-data_race[covariate_variable_names] %>% filter(!is.na(PC1)) %>% filter(!is.na(!!(sym(var)))) %>% filter(Comorbidities==0) %>% filter(Age>=60) %>% filter(!is.na(IID))
 
      ##############################
      ###Save 60+ covariate files###
      ##############################
      ###ALL
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus)>1){write.table(data_cov_ALL_with_comorbid_participants_60plus,file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Interaction_ALL",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus)>1){write.table(data_cov_ALL_without_comorbid_participants_60plus,file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Interaction_ALL",".txt"),row.names=FALSE,quote=FALSE)}
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","ALL:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus)))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","ALL:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus)))
      
      ####Men
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Men_ALL",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Men_ALL",".txt"),row.names=FALSE,quote=FALSE)}       
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Men:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Men:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1)))) 
      
      ###Women
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Women_ALL",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Women_ALL",".txt"),row.names=FALSE,quote=FALSE)}            
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Women:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Women:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2)))) 
      
      ###Normals -- ALL
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(dx==1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(dx==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Interaction_Normals",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(dx==1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(dx==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Interaction_Normals",".txt"),row.names=FALSE,quote=FALSE)}            
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Normals:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(dx==1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Normals:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(dx==1)))) 
      
      ###Normals -- Men
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx==1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Men_Normals",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx==1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Men_Normals",".txt"),row.names=FALSE,quote=FALSE)}            
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Men Normals:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx==1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Men Normals:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx==1)))) 
      
      ###Normals -- Women
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx==1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Women_Normals",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx==1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx==1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Women_Normals",".txt"),row.names=FALSE,quote=FALSE)}            
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Women Normals:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx==1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Women Normals:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx==1)))) 
      
      ###Impaired -- ALL
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(dx>1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(dx>1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Interaction_Impaired",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(dx>1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(dx>1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Interaction_Impaired",".txt"),row.names=FALSE,quote=FALSE)}       
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Impaired:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(dx>1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Impaired:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(dx>1))))
      
      ###Impaired -- Men
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx>1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx>1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Men_Impaired",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx>1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx>1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Men_Impaired",".txt"),row.names=FALSE,quote=FALSE)}            
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Men Impaired:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx>1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Men Impaired:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==1) %>% filter(dx>1)))) 
      
      ###Impaired -- Women
      if(nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx>1))>1){write.table(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx>1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithComorbidities_60plus","_","Women_Impaired",".txt"),row.names=FALSE,quote=FALSE)}
      if(nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx>1))>1){write.table(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx>1),file=paste0(File_directory,cohort,"_",race_categories[k],"_",var,"_","WithoutComorbidities_60plus","_","Women_Impaired",".txt"),row.names=FALSE,quote=FALSE)}            
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Women Impaired:","WithComorbidities",":60plus",": ",nrow(data_cov_ALL_with_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx>1))))
      print(paste0(cohorts[j],":",race_categories[k],":",var,":","Women Impaired:","WithoutComorbidities",":60plus",": ",nrow(data_cov_ALL_without_comorbid_participants_60plus %>% filter(sex==2) %>% filter(dx>1)))) 
    }
  } 
}
sink()

