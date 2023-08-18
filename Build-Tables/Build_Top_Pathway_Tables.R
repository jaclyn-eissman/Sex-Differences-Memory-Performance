#By Jaclyn Eissman, March 30, 2023
##########################Top Pathway Tables -- Pathways with P<0.001##########################

#Packages
library(data.table)
library(dplyr)
library(openxlsx)

#Directory
directory = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/MAGMA"
table_dir = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Tables/"

#Vars
cog_variables = c("MEM","memslopes")
cog_dictionary = c("MEM"="Baseline Memory","memslopes"="Memory Decline")
sex_variables = c("Men","Women","Interaction")
dx_variables = c("ALL","Normals","Impaired")
ancestry_variables = c("Cross_Ancestry","NHW","NHB")
List_Paths = c()

#Loop
for (i in 1:length(cog_variables)){
  for (j in 1:length(sex_variables)){
    for (k in 1:length(dx_variables)){
      for (l in 1:length(ancestry_variables)){
        
        cog = cog_variables[i]
        sex = sex_variables[j]
        dx = dx_variables[k]
        ancestry = ancestry_variables[l]
        
        if (ancestry=="Cross_Ancestry") {
          file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_MAF01_noAPOE.gsa.out_with_FDR")
          Ancestry = paste(sapply(strsplit(file,"_"),"[",2),sapply(strsplit(file,"_"),"[",3))
          Sex = paste(sapply(strsplit(file,"_"),"[",7))
          Dx = paste(sapply(strsplit(file,"_"),"[",8))
          data = fread(paste0(directory,"/",ancestry,"/",file))
        } else{
          file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_MAF01_noAPOE.gsa.out_with_FDR")
          Ancestry = paste(sapply(strsplit(file,"_"),"[",2))
          Sex = paste(sapply(strsplit(file,"_"),"[",6))
          Dx = paste(sapply(strsplit(file,"_"),"[",7))
          data = fread(paste0(directory,"/",ancestry,"/",file))
        }
        
        if (cog=="MEM") {
          Phenotype = cog_dictionary[1]
        } else{
          Phenotype = cog_dictionary[2]
        }
        
        data = data %>% dplyr::select(c("FULL_NAME","NGENES","BETA","P","P.fdr")) %>% 
          dplyr::rename(Pathway=FULL_NAME,`N_Genes`=NGENES,β=BETA) %>%
          dplyr::filter(P<=0.001) 
        data = cbind(data,Sex,Ancestry,Dx,Phenotype)
        
        List_Paths = rbind(List_Paths,data)
      }
    }
  }
}

#Split up into Men/Women/Int and then also by phenotype
List_Paths_Men_Bl = List_Paths %>% filter(Sex=="Men") %>% filter(Phenotype=="Baseline Memory")
List_Paths_Women_Bl = List_Paths %>% filter(Sex=="Women") %>% filter(Phenotype=="Baseline Memory")
List_Paths_Interaction_Bl = List_Paths %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Baseline Memory")

List_Paths_Men_Dec = List_Paths %>% filter(Sex=="Men") %>% filter(Phenotype=="Memory Decline")
List_Paths_Women_Dec = List_Paths %>% filter(Sex=="Women") %>% filter(Phenotype=="Memory Decline")
List_Paths_Interaction_Dec = List_Paths %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Memory Decline")

#Order by ancestry, then dx, then p-value
List_Paths_Men_Bl = List_Paths_Men_Bl[order(List_Paths_Men_Bl$Ancestry,List_Paths_Men_Bl$Dx,
                                            List_Paths_Men_Bl$P),]
List_Paths_Women_Bl = List_Paths_Women_Bl[order(List_Paths_Women_Bl$Ancestry,List_Paths_Women_Bl$Dx,
                                                List_Paths_Women_Bl$P),]
List_Paths_Interaction_Bl = List_Paths_Interaction_Bl[order(List_Paths_Interaction_Bl$Ancestry,
                                                            List_Paths_Interaction_Bl$Dx,
                                                            List_Paths_Interaction_Bl$P),]

List_Paths_Men_Dec = List_Paths_Men_Dec[order(List_Paths_Men_Dec$Ancestry,List_Paths_Men_Dec$Dx,
                                              List_Paths_Men_Dec$P),]
List_Paths_Women_Dec = List_Paths_Women_Dec[order(List_Paths_Women_Dec$Ancestry,List_Paths_Women_Dec$Dx,
                                                  List_Paths_Women_Dec$P),]
List_Paths_Interaction_Dec = List_Paths_Interaction_Dec[order(List_Paths_Interaction_Dec$Ancestry,
                                                              List_Paths_Interaction_Dec$Dx,
                                                              List_Paths_Interaction_Dec$P),]

#Write out excel tables
list_dfs <- list("Top Paths - Men, Bl"=List_Paths_Men_Bl,"Top Paths - Women, Bl"=List_Paths_Women_Bl,
                 "Top Paths - Interaction, Bl"=List_Paths_Interaction_Bl,
                 "Top Paths - Men, Dec"=List_Paths_Men_Dec,"Top Paths - Women, Dec"=List_Paths_Women_Dec,
                 "Top Paths - Interaction, Dec"=List_Paths_Interaction_Dec)
write.xlsx(list_dfs,paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"))


