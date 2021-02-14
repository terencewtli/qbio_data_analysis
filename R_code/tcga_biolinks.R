# if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
#
if (!require(TCGAbiolinks)) BiocManager::install("TCGAbiolinks")

# if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
# BiocManager::install(c("devtools"))
# BiocManager::install(c("robustbase"))
# library(devtools)
# library(robustbase)
#
# devtools::install_github("BioinformaticsFMRP/TCGAbiolinks")



library(TCGAbiolinks)

#Group 1
library(SummarizedExperiment)
clinical_file <- read.csv("data/tcga_brca_six_example_clinical.csv") #option to remove this line
barcodes <- as.character( clinical_file$barcode ) #option to remove this line
query <- GDCquery(project = "TCGA-BRCA",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "HTSeq - Counts",
                  barcode = c(barcodes))

GDCdownload(query)
data <- GDCprepare(query)
str(data)

#Group 2
# clinical_file <- read.csv("data/tcga_brca_six_example_clinical.csv") #option to remove this line
# barcodes <- as.character( clinical_file$bcr_patient_barcode ) #option to remove this line
# clin_query <- GDCquery(project = "TCGA-BRCA", data.category="Clinical", barcode= barcodes) #option to remove "barcode"
# GDCdownload(clin_query)
# clinic <- GDCprepare_clinic(clin_query, clinical.info="patient")
# str(clinic)
