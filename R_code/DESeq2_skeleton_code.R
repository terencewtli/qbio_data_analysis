if (!require(DESeq2)) BiocManager::install("DESeq2")

library(TCGAbiolinks)
library(DESeq2)

# REFERENCE: https://www.bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html

# If testing on the 6 patients, get the patient barcodes
# clinical_file <- read.csv("../data/tcga_brca_six_example_clinical.csv")
# barcodes <- as.character( clinical_file$barcode )

###### Load in your HTSeq Counts #######
#Option A: Use GDCquery
#Option B: In the R Review Notebook, there was an example to save your SummarizedExperiment to an h5fd file.
#For this option, use getwd() to understand exactly where you are located in your system.
#Fill in the dir argument with appropriate file path and directory name that you PREVIOUSLY saved.
#sum_exp <- loadHDF5SummarizedExperiment(dir="htseq_h5_sumexp", prefix="")

#If you have not previously saved your HTSeq SummarizedExperiment, use query as normal and then use:
#saveHDF5SummarizedExperiment(sum_exp, dir="htseq_h5_sumexp", prefix="", replace=FALSE,chunkdim=NULL, level=NULL, as.sparse=NA,verbose=NA)
#After you have saved the HTSeq file, you don't have to query again and can just use the loadHDF5SummarizedExperiment()


#access the actual counts. counts is genes in rows X patients in columns.
counts <- assays(sum_exp)$"HTSeq - Counts"

#We are interested in the age of the patients, but some patients don't have this information, instead they have NA.
#We need to remove patients with unknown ages.
#The is.na() creates a mask of TRUE when the column is NA and FALSE when the column has actual information
#The ! means "not". It returns TRUE when the list is FALSE, and FALSE when the list is TRUE
#What does patients_no_NA_mask contain?
patients_no_NA_mask <- !is.na(colData(sum_exp)$paper_age_at_initial_pathologic_diagnosis)

#access the patient_data from coldata
patient_data <- colData(sum_exp)[ patients_no_NA_mask, ]

##### Preprocess your data #####
#How many genes are in counts? Hint: Look at the dimensions of counts.

#Because there are so many genes, it is common to only use genes with a mean of greater than or equal to 10
#Use counts <- counts[row,col] format and rowMeans(counts) function to filter counts to only those with a row mean of >= 10

#We are interested in the age category of the patients.
#Some patients might not have age information and this could crash our analysis if their age is "NA"
counts <- counts[ , patients_no_NA_mask]

#We need to add an age_category column to our patient data. Use your ifelse() structure to do this
#Remember "Young" is < 40, "Mid" is 40-59, "Old" is 60+

#Next, we need to make age_category a "factor". This means we are explicitly creating a CATEGORICAL variable.
patient_data$age_category <- factor(patient_data$age_category, levels=c("Young", "Mid", "Old"))

####### Now for actual analysis!! #######
dds <- DESeqDataSetFromMatrix(countData = counts, colData = patient_data, design = ~age_category)
dds_obj <- DESeq(dds)
resultsNames(dds_obj) #lists the coefficients

results <- results(dds_obj, contrast=c("age_category", "Young",'Old'))

head(results) #look at the results

#Notice, each gene has a log2FoldChange and a padj value. This is what we are interested in!
#For clarification, please add a FoldChange column by computing 2^log2FoldChange column
results$FoldChange <- 2^ #fill in here

#Save ALL your results to a csv file
write.csv(results, "PATH/FILE.csv")

####### Interpreting results ########

#We often visualize results via a "volcano plot"
padj_threshold <- 0.05
log2FC_threshold <- 1.0
jpeg("PATH/FILE.jpg")
plot(x= results$log2FoldChange, y= -log10(results$padj) )
#abline() plots straight lines on an R plot.
#v argument is for a vertical line, h argument is for a horizontal line. col argument is color
abline(v=c(log2FC_threshold, -log2FC_threshold), h= c(-log10(padj_threshold)), col="green")
dev.off()

#Look at your volcano plot and answer the following questions
#What does each dot on the plot represent?
#Why might we have two vertical line and only one horizontal line?
#Why are we plotting the -log10 of the adjusted p values rather than the actual adjusted p values?
#                  Feel free to create a plot with the actual values to answer this question.

#We want to separate between genes that are UP regulated in young (higher expression in young patients),
#                                         and genes that are DOWN regulated in young (lower expression in young patients)
#If the log2FoldChange is POSITIVE, the expression is higher in young
#If the log2FoldChange is NEGATIVE, the expression is lower in young and higher in old
#What does the log2FoldChange equal, if the expression is the same in young and old patients?

#On the volcano plot we can see the distribution of adjusted p values and log2FoldChanges
#We are interested in the actual genes that are significant
#Create results_significant_adjp with all columns of genes have padj > padj_threshold(from above)
results_significant_adjp <- #fill in here

#For UP regulation, we want genes that have a log2FoldChange of > log2FC_threshold
#For DOWN regulation, we want genes that have a log2FoldChange of < -log2FC_threshold. NOTICE THE NEGATIVE SIGN
results_sig_up_regulated <- results_significant_adjp#finish this line
results_sig_down_regulated <- results_significant_adjp#finish this line

#How could you get the same results using the absolute value of the log2FoldChange?

#Notice that the gene names are in the ENSG00000#### format. This is the ensembl_gene_id format.
#we probably want the "common" name of the gene.
gene_information <- rowData(sum_exp)
#Use gene_information$external_gene_name to create a new column in your results_sig_up_regulated and results_sig_down_regulated
#HINT: rownames(results_sig_up_regulated) gives a list of the ENSG0000### format

#Use write.csv() to save your results!

##################################################################
#As we have touched on, there are many other variables that may influence the results between young and old
#You may want to ADJUST for this confounding variables like PAM50 subtype, and what is called "Histology"
#Breast cancer subtypes and histology (ductal vs. lobular, feel free to Google!), affect the patient's "omics" data.
#Repeat the above analysis, but add the below modifications.
#Compare your results with adjustment and without adjustment.
#Are there greater or fewer genes significant with the adjustment?
#Are the genes that are signficant the same?

#check that all variables are not "NA"
patients_no_NA_mask <- ( !is.na(colData(sum_exp)$paper_age_at_initial_pathologic_diagnosis)
                        & !is.na(colData(sum_exp)$paper_BRCA_Subtype_PAM50)
                        & !is.na(colData(sum_exp)$paper_BRCA_Pathology)
                        & !colData(sum_exp)$paper_BRCA_Pathology == "NA" )

counts <- counts[ , patients_no_NA_mask ]

#all columns must be FACTORS
patient_data$age_category <- factor( patient_data$age_category, levels=c("Young", "Mid", "Old") )
patient_data$paper_BRCA_Subtype_PAM50 <- factor( patient_data$paper_BRCA_Subtype_PAM50 levels=c("Her2","LumA","LumB","Basal","Normal") )
patient_data$paper_BRCA_Pathology <- factor( patient_data$paper_BRCA_Pathology, levels=c("IDC","Other","Mixed","ILC") )

dds_with_adjustment <- DESeqDataSetFromMatrix(countData = counts, colData = patient_data, design = ~paper_BRCA_Pathology+ paper_BRCA_Subtype_PAM50 +age_category)
