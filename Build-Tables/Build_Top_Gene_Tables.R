##########################Top Gene Tables -- Genes with P<0.001###########################

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
List_Genes = c()

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
          file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_MAF01_noAPOE.genes.out_with_FDR")
          Ancestry = paste(sapply(strsplit(file,"_"),"[",2),sapply(strsplit(file,"_"),"[",3))
          Sex = paste(sapply(strsplit(file,"_"),"[",7))
          Dx = paste(sapply(strsplit(file,"_"),"[",8))
          data = fread(paste0(directory,"/",ancestry,"/",file))
        } else{
          file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_MAF01_noAPOE.genes.out_with_FDR")
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
        
        data = data %>% dplyr::select(c("GENE","NSNPS","ZSTAT","P","P.fdr")) %>% 
          dplyr::rename(N_SNPs=NSNPS,`Z-Stat`=ZSTAT) %>%
          dplyr::filter(P<=0.001) 
        data = cbind(data,Sex,Ancestry,Dx,Phenotype)
        
        List_Genes = rbind(List_Genes,data)
      }
    }
  }
}
        
#Split up into Men/Women/Int and then also by phenotype
List_Genes_Men_Bl = List_Genes %>% filter(Sex=="Men") %>% filter(Phenotype=="Baseline Memory")
List_Genes_Women_Bl = List_Genes %>% filter(Sex=="Women") %>% filter(Phenotype=="Baseline Memory")
List_Genes_Interaction_Bl = List_Genes %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Baseline Memory")

List_Genes_Men_Dec = List_Genes %>% filter(Sex=="Men") %>% filter(Phenotype=="Memory Decline")
List_Genes_Women_Dec = List_Genes %>% filter(Sex=="Women") %>% filter(Phenotype=="Memory Decline")
List_Genes_Interaction_Dec = List_Genes %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Memory Decline")

#Order by ancestry, then dx, then p-value
List_Genes_Men_Bl = List_Genes_Men_Bl[order(List_Genes_Men_Bl$Ancestry,List_Genes_Men_Bl$Dx,
                                          List_Genes_Men_Bl$P),]
List_Genes_Women_Bl = List_Genes_Women_Bl[order(List_Genes_Women_Bl$Ancestry,List_Genes_Women_Bl$Dx,
                                              List_Genes_Women_Bl$P),]
List_Genes_Interaction_Bl = List_Genes_Interaction_Bl[order(List_Genes_Interaction_Bl$Ancestry,
                                                          List_Genes_Interaction_Bl$Dx,
                                                          List_Genes_Interaction_Bl$P),]

List_Genes_Men_Dec = List_Genes_Men_Dec[order(List_Genes_Men_Dec$Ancestry,List_Genes_Men_Dec$Dx,
                                            List_Genes_Men_Dec$P),]
List_Genes_Women_Dec = List_Genes_Women_Dec[order(List_Genes_Women_Dec$Ancestry,List_Genes_Women_Dec$Dx,
                                                List_Genes_Women_Dec$P),]
List_Genes_Interaction_Dec = List_Genes_Interaction_Dec[order(List_Genes_Interaction_Dec$Ancestry,
                                                            List_Genes_Interaction_Dec$Dx,
                                                            List_Genes_Interaction_Dec$P),]

#Write out excel tables
list_dfs <- list("Top Genes - Men, Bl"=List_Genes_Men_Bl,"Top Genes - Women, Bl"=List_Genes_Women_Bl,
                 "Top Genes - Interaction, Bl"=List_Genes_Interaction_Bl,
                 "Top Genes - Men, Dec"=List_Genes_Men_Dec,"Top Genes - Women, Dec"=List_Genes_Women_Dec,
                 "Top Genes - Interaction, Dec"=List_Genes_Interaction_Dec)
write.xlsx(list_dfs,paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"))

        