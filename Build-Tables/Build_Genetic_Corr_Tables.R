##########################All Genetic Correlation Results -- NHW##########################

#Packages
library(data.table)
library(dplyr)
library(openxlsx)

#Directory
directory = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/GNOVA"
table_dir = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Tables/"

#Vars
cog_variables = c("MEM","memslopes")
cog_dictionary = c("MEM"="Baseline Memory","memslopes"="Memory Decline")
sex_variables = c("Men","Women","Interaction")
dx_variables = c("ALL","Normals","Impaired")
sex_variables = c("Men","Women","Interaction")
List_Corrs = c()

#Loop
for (i in 1:length(cog_variables)){
  for (j in 1:length(sex_variables)){
    for (k in 1:length(dx_variables)){
      for (l in 1:length(sex_variables)){
        
        cog = cog_variables[i]
        sex = sex_variables[j]
        dx = dx_variables[k]
        sex = sex_variables[l]
        ancestry = "NHW"
        
        file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_MAF01_noAPOE_All_Traits.txt")
        Ancestry = paste(sapply(strsplit(file,"_"),"[",2))
        Sex = paste(sapply(strsplit(file,"_"),"[",6))
        Dx = paste(sapply(strsplit(file,"_"),"[",7))
        data = fread(paste0(directory,"/",ancestry,"/",file))
        
        if (cog=="MEM") {
          Phenotype = cog_dictionary[1]
        } else{
          Phenotype = cog_dictionary[2]
        }
        
        data = data %>% dplyr::select(c("V17","V3","V6","V9","V12")) %>% 
          dplyr::rename(Trait=V17,Rho=V3,P.Rho=V6,Corr=V9,P.Corr=V12)
        data$P.Rho.fdr = p.adjust(data$P.Rho, method="fdr")
        data$P.Corr.fdr = p.adjust(data$P.Corr, method="fdr")
        data = cbind(data,Sex,Ancestry,Dx,Phenotype)
        
        List_Corrs = rbind(List_Corrs,data)
      }
    }
  }
}

#Split up into Men/Women/Int and then also by phenotype
List_Corrs_Men_Bl = List_Corrs %>% filter(Sex=="Men") %>% filter(Phenotype=="Baseline Memory")
List_Corrs_Women_Bl = List_Corrs %>% filter(Sex=="Women") %>% filter(Phenotype=="Baseline Memory")
List_Corrs_Interaction_Bl = List_Corrs %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Baseline Memory")

List_Corrs_Men_Dec = List_Corrs %>% filter(Sex=="Men") %>% filter(Phenotype=="Memory Decline")
List_Corrs_Women_Dec = List_Corrs %>% filter(Sex=="Women") %>% filter(Phenotype=="Memory Decline")
List_Corrs_Interaction_Dec = List_Corrs %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Memory Decline")

#Order by dx and then p-value
List_Corrs_Men_Bl = List_Corrs_Men_Bl[order(List_Corrs_Men_Bl$Trait,List_Corrs_Men_Bl$Dx,
                                            List_Corrs_Men_Bl$P.Corr.fdr),]
List_Corrs_Women_Bl = List_Corrs_Women_Bl[order(List_Corrs_Women_Bl$Trait,List_Corrs_Women_Bl$Dx,
                                                List_Corrs_Women_Bl$P.Corr.fdr),]
List_Corrs_Interaction_Bl = List_Corrs_Interaction_Bl[order(List_Corrs_Interaction_Bl$Trait,
                                                            List_Corrs_Interaction_Bl$Dx,
                                                            List_Corrs_Interaction_Bl$P.Corr.fdr),]

List_Corrs_Men_Dec = List_Corrs_Men_Dec[order(List_Corrs_Men_Dec$Trait,List_Corrs_Men_Dec$Dx,
                                              List_Corrs_Men_Dec$P.Corr.fdr),]
List_Corrs_Women_Dec = List_Corrs_Women_Dec[order(List_Corrs_Women_Dec$Trait,List_Corrs_Women_Dec$Dx,
                                                  List_Corrs_Women_Dec$P.Corr.fdr),]
List_Corrs_Interaction_Dec = List_Corrs_Interaction_Dec[order(List_Corrs_Interaction_Dec$Trait,
                                                              List_Corrs_Interaction_Dec$Dx,
                                                              List_Corrs_Interaction_Dec$P.Corr.fdr),]

#Write out excel tables
list_dfs <- list("Top Corrs - Men, Bl"=List_Corrs_Men_Bl,"Top Corrs - Women, Bl"=List_Corrs_Women_Bl,
                 "Top Corrs - Interaction, Bl"=List_Corrs_Interaction_Bl,
                 "Top Corrs - Men, Dec"=List_Corrs_Men_Dec,"Top Corrs - Women, Dec"=List_Corrs_Women_Dec,
                 "Top Corrs - Interaction, Dec"=List_Corrs_Interaction_Dec)
write.xlsx(list_dfs,paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"))


