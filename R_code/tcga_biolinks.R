#not every machine is the same, so please Slack if the following code is getting errors

#use following line on the cluster
# if you are getting an install error
# Open an R console on the cluster and run: BiocManager::install("TCGAbiolinks")
# If it asks to write to personal library, say yes
if (!require(TCGAbiolinks)) BiocManager::install("TCGAbiolinks")

#comment above line and uncomment the following lines if using a local machine
# if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
# BiocManager::install(c("devtools"))
# BiocManager::install(c("robustbase"))
# library(devtools)
# library(robustbase)
#
# devtools::install_github("BioinformaticsFMRP/TCGAbiolinks")



library(TCGAbiolinks)

#Group 1
# library(SummarizedExperiment) #look up how a SummarizedExperiment is built
# clinical_file <- read.csv("data/tcga_brca_six_example_clinical.csv")
# barcodes <- as.character( clinical_file$barcode )
# query <- GDCquery(project = "TCGA-BRCA",
#                   data.category = "Transcriptome Profiling",
#                   data.type = "Gene Expression Quantification",
#                   workflow.type = "HTSeq - Counts",
#                   barcode = c(barcodes))
#
# GDCdownload(query)
# data <- GDCprepare(query)
#str(data) #use this line if you are typing in the command line

#Group 2
# clinical_file <- read.csv("data/tcga_brca_six_example_clinical.csv")
# barcodes <- as.character( clinical_file$bcr_patient_barcode )
# clin_query <- GDCquery(project = "TCGA-BRCA", data.category="Clinical", barcode= barcodes)
# GDCdownload(clin_query)
# clinic <- GDCprepare_clinic(clin_query, clinical.info="patient")
# str(clinic) #use this line if you are typing in the command line

#Group 3
# mutation <- GDCquery_Maf(tumor = "BRCA",save.csv=TRUE)
# after running ^^, navigate to the saved csv file. Open the csv file with below Code
# maf_dataframe <- read.csv("PATH/FILENAME.csv")
# str(maf_dataframe)
