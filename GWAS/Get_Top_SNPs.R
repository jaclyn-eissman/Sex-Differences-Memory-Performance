#Args
args <- commandArgs(TRUE)
dir <- args[1]
sumstats <- args[2]

#Packages
library(data.table)
library(dplyr)

#Read in file
file = fread(paste0(dir,"/",sumstats),header=T)
print(nrow(file))

#Grab anything less than 0.00001
file_subset = file[file$`p-value`<0.00001,]

#Order 
file_subset_ordered = file_subset[order(file_subset$`p-value`),]

#Print head of file and nrow of file
print(nrow(file_subset_ordered))
print(head(file_subset_ordered))

#Get file name
file_name = gsub(".out","",paste0(sumstats))
print(file_name)

#Write out
write.table(file_subset_ordered,paste0("/data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/Tables/",file_name,"_TopSNPs.txt"),quote=F,row.names=F,col.names=T)
