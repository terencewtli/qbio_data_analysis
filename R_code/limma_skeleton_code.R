if (!require(TCGAbiolinks)) BiocManager::install("TCGAbiolinks")
if (!require(limma)) BiocManager::install("limma")

library(TCGAbiolinks)
library(limma)

# REFERENCE: https://www.bioconductor.org/packages/release/bioc/vignettes/DEqMS/inst/doc/DEqMS-package-vignette.html

# Read in clinical CSV file to get patient ages. 
# clinical <- read.csv("PATH/FILENAME.csv", header = TRUE)
rownames(clinical) <- clinical$Patient_ID

# As usual, we need to create age categories for each patient.
# Create a column titled "Age.in.Years" using the $Age.in.month column.
# Then create age_category column using ifelse code and boolean indexing
clinical$Age.in.Years <- #fill in
# Use desired cutoff between young and old patients
clinical$age_category <- #fill in
  
# We also want to drop missing data using boolean indexing.
na_mask <- !is.na(clinical$age_category)
# Use the age_mask and boolean indexing to filter clinical dataset.
clinical <- # fill in
  
# Read in proteomics CSV file to get protein abundances.
# proteomics <- read.csv("PATH/FILENAME.csv", header = TRUE)
rownames(proteomics) <- proteomics$Patient_ID
# Drop patient column because we don't want it in transposed data frame
proteomics$Patient_ID <- NULL
# Same as clinical, filter proteomics dataset to remove NA patients
proteomics <- #fill in
  
# Use the function t(your_dataframe) to ranspose matrix to desired format.
# rows = proteins, columns = patients
proteomics_t <- #fill in
  
# Setting up design matrix, which contains categorical variables
# associated with each patient (young/old in this case)
f <- factor( clinical$age_category, levels=c("Young", "Old"))
design <- model.matrix(~0+f, clinical)

# Use the limma lmFit(data, design_matrix) function
# and assign the result to a variable called fit
fit <- #fill in here
# Contrast matrix to express the different conditions
# for the linear model. Here we only have young/old
cont.matrix <- makeContrasts(Y_O="fYoung-fOld", levels=design)

# Use contrasts to fit data.
# Save the result of the contrasts.fit(fit, contrasts) 
# function into fit2
fit2 <- #fill in here
  
# eBayes smooths the error.
fit3 <- eBayes( fit2 )

# topTable gives statistics for top differentially expressed
# genes, including adjusted log fold change and p-values
results <- topTable( fit3, adjust="BH", n=Inf)

# Plot points on a volcano plot, same as DESeq2
padj_threshold <- 0.05
log2FC_threshold <- 1.0
plot(x= results$logFC, y= -log10(results$adj.P.Val) )
plot(x= filter$logFC, y= -log10(filter$finalFDR) )
abline(v=c(log2FC_threshold, -log2FC_threshold), 
       h= c(-log10(padj_threshold)), col="green")

# Write results to table for future use
write.table(results, "FILENAME.txt", sep = "\t",
            row.names = F, quote = F)
