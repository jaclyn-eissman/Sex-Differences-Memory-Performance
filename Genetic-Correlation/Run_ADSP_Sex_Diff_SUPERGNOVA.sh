#!/bin/bash
set -e

#Activate virtual env
module restore gnova_python2
source /data/h_vmac/eissmajm/SG_python2/bin/activate

#Run SUPERGNOVA
python /data/h_vmac/eissmajm/SUPERGNOVA/supergnova.py /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_Men_ALL_subset_MAF01_noAPOE_rs.sumstats.gz /data/h_vmac/eissmajm/SUMSTATS/Munged_Traits/RestingHrSDNN.sumstats.gz --bfile /data/h_vmac/eissmajm/SUPERGNOVA/data/bfiles/eur_chr@_SNPmaf5 --partition /data/h_vmac/eissmajm/SUPERGNOVA/data/partition/eur_chr@.bed --thread 10 --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/Men_SDNN_memslopes.txt
python /data/h_vmac/eissmajm/SUPERGNOVA/supergnova.py /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/ADSP_NHW_memslopes_WithComorbidities_60plus_Women_ALL_subset_MAF01_noAPOE_rs.sumstats.gz /data/h_vmac/eissmajm/SUMSTATS/Munged_Traits/RestingHrSDNN.sumstats.gz --bfile /data/h_vmac/eissmajm/SUPERGNOVA/data/bfiles/eur_chr@_SNPmaf5 --partition /data/h_vmac/eissmajm/SUPERGNOVA/data/partition/eur_chr@.bed --thread 10 --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/Women_SDNN_memslopes.txt
python /data/h_vmac/eissmajm/SUPERGNOVA/supergnova.py /nfs/eissmajm/Sex_Diff_Final/GNOVA/SexStrat/males/GLOBALRES.males_2sets.sumstats.gz /data/h_vmac/eissmajm/SUMSTATS/Munged_Traits/RestingHrSDNN.sumstats.gz --bfile /data/h_vmac/eissmajm/SUPERGNOVA/data/bfiles/eur_chr@_SNPmaf5 --partition /data/h_vmac/eissmajm/SUPERGNOVA/data/partition/eur_chr@.bed --thread 10 --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/Men_SDNN_GLOBALRES.txt
python /data/h_vmac/eissmajm/SUPERGNOVA/supergnova.py /nfs/eissmajm/Sex_Diff_Final/GNOVA/SexStrat/females/GLOBALRES.females_2sets.sumstats.gz /data/h_vmac/eissmajm/SUMSTATS/Munged_Traits/RestingHrSDNN.sumstats.gz --bfile /data/h_vmac/eissmajm/SUPERGNOVA/data/bfiles/eur_chr@_SNPmaf5 --partition /data/h_vmac/eissmajm/SUPERGNOVA/data/partition/eur_chr@.bed --thread 10 --out /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/Women_SDNN_GLOBALRES.txt

#Zip some files
gzip -c /data/h_vmac/eissmajm/SUMSTATS/Formatted/RestingHrSDNN.txt > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/HRV_GWAS_SDNN.gz
gzip -c /nfs/eissmajm/Sex_Diff_Final/META/SexStrat/GLOBALRES.males_2sets.out > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/GLOBALRES.males_2sets.gz
gzip -c /nfs/eissmajm/Sex_Diff_Final/META/SexStrat/GLOBALRES.females_2sets.out > /data/h_vmac/eissmajm/Sex_Diff_ADSP_GWAS/GNOVA/NHW/SUPERGNOVA/GLOBALRES.females_2sets.gz
