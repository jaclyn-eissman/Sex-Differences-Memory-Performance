#By Jaclyn Eissman, March 30, 2023

#Add back in headers to meta file
library(data.table)
args <- commandArgs(TRUE)
meta_file <- args[1] 

#Read in file
file <- fread(meta_file,header=F)

#Add in headers
names(file) <- c("rs_number", "reference_allele", "other_allele", "eaf", "beta", "se", "beta_95L", "beta_95U", "z", "p-value", "-log10_p-value", "q_statistic", "q_p-value", "i2", "n_studies", "n_samples", "effects")

#Write back out
write.table(file,paste0(meta_file),quote=F,row.names=F,col.names=T,sep="\t")
