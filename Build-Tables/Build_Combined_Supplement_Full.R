##########################Read In & Combine All Supplementary Tables##########################

#Packages
library(data.table)
library(dplyr)
library(openxlsx)

#Directory
table_dir = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Sex_Diff_ADSP_GWAS/Tables/"
manuscript_dir = "/Users/jackieeissman/VUMC/Research - Hohman - Jaclyn Eissman/Manuscripts/ADSP_Memory/A&D/"

#Read in top SNP tables
TopSNP1 = read.xlsx(paste0(table_dir,"Supplementary_Tables_One_thru_Six.xlsx"),sheet=1)
TopSNP2 = read.xlsx(paste0(table_dir,"Supplementary_Tables_One_thru_Six.xlsx"),sheet=2)
TopSNP3 = read.xlsx(paste0(table_dir,"Supplementary_Tables_One_thru_Six.xlsx"),sheet=3)
TopSNP4 = read.xlsx(paste0(table_dir,"Supplementary_Tables_One_thru_Six.xlsx"),sheet=4)
TopSNP5 = read.xlsx(paste0(table_dir,"Supplementary_Tables_One_thru_Six.xlsx"),sheet=5)
TopSNP6 = read.xlsx(paste0(table_dir,"Supplementary_Tables_One_thru_Six.xlsx"),sheet=6)

#Read in top gene tables
TopGene1 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"),sheet=1)
TopGene2 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"),sheet=2)
TopGene3 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"),sheet=3)
TopGene4 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"),sheet=4)
TopGene5 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"),sheet=5)
TopGene6 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Seven_thru_Twelve.xlsx"),sheet=6)

#Read in top pathway tables
TopPath1 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"),sheet=1)
TopPath2 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"),sheet=2)
TopPath3 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"),sheet=3)
TopPath4 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"),sheet=4)
TopPath5 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"),sheet=5)
TopPath6 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Thirteen_thru_Eighteen.xlsx"),sheet=6)

#Read in genetic correlation tables
TopCorr1 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"),sheet=1)
TopCorr2 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"),sheet=2)
TopCorr3 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"),sheet=3)
TopCorr4 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"),sheet=4)
TopCorr5 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"),sheet=5)
TopCorr6 = read.xlsx(paste0(table_dir,"Supplementary_Tables_Nineteen_thru_TwentyFour.xlsx"),sheet=6)

#Write out combined supplement 
list_dfs <- list("Top SNPs - Men, Bl"=TopSNP1,"Top SNPs - Women, Bl"=TopSNP2,
                 "Top SNPs - Interaction, Bl"=TopSNP3,"Top SNPs - Men, Dec"=TopSNP4,
                 "Top SNPs - Women, Dec"=TopSNP5,"Top SNPs - Interaction, Dec"=TopSNP6,
                 "Top Genes - Men, Bl"=TopGene1,"Top Genes - Women, Bl"=TopGene2,
                 "Top Genes - Interaction, Bl"=TopGene3,"Top Genes - Men, Dec"=TopGene4,
                 "Top Genes - Women, Dec"=TopGene5,"Top Genes - Interaction, Dec"=TopGene6,
                 "Top Paths - Men, Bl"=TopPath1,"Top Paths - Women, Bl"=TopPath2,
                 "Top Paths - Interaction, Bl"=TopPath3,"Top Paths - Men, Dec"=TopPath4,
                 "Top Paths - Women, Dec"=TopPath5,"Top Paths - Interaction, Dec"=TopPath6,
                 "Top Corrs - Men, Bl"=TopCorr1,"Top Corrs - Women, Bl"=TopCorr2,
                 "Top Corrs - Interaction, Bl"=TopCorr3,"Top Corrs - Men, Dec"=TopCorr4,
                 "Top Corrs - Women, Dec"=TopCorr5,"Top Corrs - Interaction, Dec"=TopCorr6)
write.xlsx(list_dfs,paste0(manuscript_dir,"Submission_Docs/Supplementary_Tables_Full_033023.xlsx"))


