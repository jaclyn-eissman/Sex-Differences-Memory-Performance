##########################Top SNP Tables -- SNPs with P<0.00001##########################

#Packages
library(data.table)
library(dplyr)
library(openxlsx)

#Directory
directory = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Tables/"

#Vars
cog_variables = c("MEM","memslopes")
cog_dictionary = c("MEM"="Baseline Memory","memslopes"="Memory Decline")
sex_variables = c("Men","Women","Interaction")
dx_variables = c("ALL","Normals","Impaired")
ancestry_variables = c("Cross_Ancestry","NHW","NHB")
List_SNPs = c()

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
            file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_edited_withX_TopSNPs.txt")
            Ancestry = paste(sapply(strsplit(file,"_"),"[",2),sapply(strsplit(file,"_"),"[",3))
            Sex = paste(sapply(strsplit(file,"_"),"[",7))
            Dx = paste(sapply(strsplit(file,"_"),"[",8))
            data = fread(paste0(directory,file))
          } else{
            file = paste0("ADSP_",ancestry,"_",cog,"_WithComorbidities_60plus_",sex,"_",dx,"_subset_MAF01_edited_withX_TopSNPs.txt")
            Ancestry = paste(sapply(strsplit(file,"_"),"[",2))
            Sex = paste(sapply(strsplit(file,"_"),"[",6))
            Dx = paste(sapply(strsplit(file,"_"),"[",7))
            data = fread(paste0(directory,file))
          }
          
          if (cog=="MEM") {
            Phenotype = cog_dictionary[1]
          } else{
            Phenotype = cog_dictionary[2]
          }
        
          data = data %>% dplyr::select(c("rs_number","eaf","beta","p-value")) %>% 
            dplyr::rename(SNP=rs_number,MAF=eaf,β=beta,P=`p-value`)
          data = cbind(data,Sex,Ancestry,Dx,Phenotype)
          
          List_SNPs = rbind(List_SNPs,data)
      }
    }
  }
}

#Split up into Men/Women/Int and then also by phenotype
List_SNPs_Men_Bl = List_SNPs %>% filter(Sex=="Men") %>% filter(Phenotype=="Baseline Memory")
List_SNPs_Women_Bl = List_SNPs %>% filter(Sex=="Women") %>% filter(Phenotype=="Baseline Memory")
List_SNPs_Interaction_Bl = List_SNPs %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Baseline Memory")

List_SNPs_Men_Dec = List_SNPs %>% filter(Sex=="Men") %>% filter(Phenotype=="Memory Decline")
List_SNPs_Women_Dec = List_SNPs %>% filter(Sex=="Women") %>% filter(Phenotype=="Memory Decline")
List_SNPs_Interaction_Dec = List_SNPs %>% filter(Sex=="Interaction") %>% filter(Phenotype=="Memory Decline")

#Order by ancestry, then dx, then p-value
List_SNPs_Men_Bl = List_SNPs_Men_Bl[order(List_SNPs_Men_Bl$Ancestry,List_SNPs_Men_Bl$Dx,
                                          List_SNPs_Men_Bl$P),]
List_SNPs_Women_Bl = List_SNPs_Women_Bl[order(List_SNPs_Women_Bl$Ancestry,List_SNPs_Women_Bl$Dx,
                                              List_SNPs_Women_Bl$P),]
List_SNPs_Interaction_Bl = List_SNPs_Interaction_Bl[order(List_SNPs_Interaction_Bl$Ancestry,
                                                          List_SNPs_Interaction_Bl$Dx,
                                                          List_SNPs_Interaction_Bl$P),]

List_SNPs_Men_Dec = List_SNPs_Men_Dec[order(List_SNPs_Men_Dec$Ancestry,List_SNPs_Men_Dec$Dx,
                                            List_SNPs_Men_Dec$P),]
List_SNPs_Women_Dec = List_SNPs_Women_Dec[order(List_SNPs_Women_Dec$Ancestry,List_SNPs_Women_Dec$Dx,
                                                List_SNPs_Women_Dec$P),]
List_SNPs_Interaction_Dec = List_SNPs_Interaction_Dec[order(List_SNPs_Interaction_Dec$Ancestry,
                                                            List_SNPs_Interaction_Dec$Dx,
                                                            List_SNPs_Interaction_Dec$P),]

#Write out excel tables
list_dfs <- list("Top SNPs - Men, Bl"=List_SNPs_Men_Bl,"Top SNPs - Women, Bl"=List_SNPs_Women_Bl,
                "Top SNPs - Interaction, Bl"=List_SNPs_Interaction_Bl,
                "Top SNPs - Men, Dec"=List_SNPs_Men_Dec,"Top SNPs - Women, Dec"=List_SNPs_Women_Dec,
                "Top SNPs - Interaction, Dec"=List_SNPs_Interaction_Dec)
write.xlsx(list_dfs,paste0(directory,"Supplementary_Tables_One_thru_Six.xlsx"))



