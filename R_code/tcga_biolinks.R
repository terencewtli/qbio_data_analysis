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

#need to edit this line of code to the path of your example_ids.txt
clinical_file <- read.csv("data/tcga_brca_six_example_clinical.csv")
barcodes <- as.character( clinical_file$bcr_patient_barcode )

query <- GDCquery(project = "TCGA-BRCA",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "HTSeq - Counts",
                  barcode = c(barcodes))

GDCdownload(query)
data <- GDCprepare(query)
