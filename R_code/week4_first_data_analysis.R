#Installs TCGAbiolinks if not already present
if (!require(TCGAbiolinks)) BiocManager::install("TCGAbiolinks")

#What line of code needs to be added before using TCGAbiolinks?

#add barcodes argument to query if you want to run on your local machine for smaller files downloaded
#barcodes_rnaseq <- c("TCGA-BH-A0DG-01A-21R-A12P-07","TCGA-A2-A0YF-01A-21R-A109-07",
#          "TCGA-AN-A04A-01A-21R-A034-07","TCGA-AR-A1AP-01A-11R-A12P-07",
#              "TCGA-A2-A0T3-01A-21R-A115-07", "TCGA-E2-A154-01A-11R-A115-07" )
#barcodes_clinic <- c("TCGA-BH-A0DG","TCGA-A2-A0YF","TCGA-AN-A04A","TCGA-AR-A1AP", "TCGA-A2-A0T3",
#                      "TCGA-E2-A154", "TCGA-AO-A12F", "TCGA-A2-A0YM", "TCGA-BH-A0E0", "TCGA-AN-A0FL")


#######    Group 1: RNASeq     ############
# library(SummarizedExperiment)
# query <- GDCquery(project = "TCGA-BRCA",
#                   data.category = "Transcriptome Profiling",
#                   data.type = "Gene Expression Quantification",
#                   workflow.type = "HTSeq - Counts")
# GDCdownload(query) #only need this line of code once to download the data
# sum_exp <- GDCprepare(query)
# Create a tutorial on SummarizedExperiment

# run the following lines to convert rnaseq barcodes to clinic barcodes
# pattern <- "^.*?-.*?-...."
# m <- regexpr(pattern, sum_exp$barcode)
# regmatches(sum_exp$barcode, m)
# sum_exp$barcode <- regmatches(sum_exp$barcode, m)

# Boxplots by age
# Add a new column to colData called "age_category"
# If age_at_initial_pathologic_diagnosis is < 40, define patient as "Young" in new column
# If age_at_initial_pathologic_diagnosis is >= 60, define patient as "Old" in new column
# Other patients (between 40 and 60), define as "Mid"
# Choose 3 genes of interest from the paper presentations
# Create 3 different boxplots with age_category on x-axis, counts on the y-axis by repeating the below code for each gene
# remember to give your plot a title and informative axis labels
# png("boxplot_genename.png")
# boxplot(FILL IN HERE)
# *Feel free to add lines here that format your boxplot*
# dev.off()
# Use rsync to copy your create pngfile to local machine for viewing

#######    Group 2: clinical   ###########
# library(survival) #What do you need to do before running this line?
# library(survminer) #What do you need to do before running this line?
# library(arsenal) #What do you need to do before running this line?
# clin_query <- GDCquery(project = "TCGA-BRCA", data.category="Clinical", file.type="xml")
# GDCdownload( clin_query ) #should only need this command once. This downloads the files onto your system.
# clinic <- GDCprepare_clinic(clin_query, clinical.info="patient")
# names(clinic)[names(clinic) == "days_to_last_followup"] = "days_to_last_follow_up"

#Add a new column to clinic called "age_category"
#If age_at_initial_pathologic_diagnosis is < 40, define patient as "Young" in new column
#If age_at_initial_pathologic_diagnosis is >= 60, define patient as "Old" in new column
#Other patients (between 40 and 60), define as "Mid"

#use tableone to create summary of clinic data
# subtypes <- TCGAquery_subtype(tumor = "BRCA")
# Add the age_category column in the same way as above
# How many patients are in subtypes vs clinic? Why?

# BELOW CODE WILL NOT RUN. This is an example from another dataset
# Consider what you need to change for it to run on clinic
# Hint: age_category stays the same. "Oncotree.Code" was the name of a column
# Option to use either subtypes or clinic dataframe
# table_arse <- tableby(age_category ~ (Age.at.Diagnosis) +(Oncotree.Code) +
#          (ER.Status) + (Pam50) + (Tumor.Stage) + (Ethnicity.Call), data=clinic_oneone,
#          numeric.test="kwt", cat.test="fe", numeric.stats = c("Nmiss", "meansd"), total=FALSE)
# df <- as.data.frame( summary(table_arse, text=TRUE, pfootnote=TRUE) )                                                                                                                                                                                             df <- as.data.frame( summary(table_arse, text=TRUE, pfootnote=TRUE) )
# write.csv(df, “filepath/filename.csv”, row.names=FALSE)

# Modify below code for different variables of interest
# The "gender" can be changed to any of the column names of the clinic dataframe
# Look at the dataframe via the str(clinic) command
# TCGAanalyze_survival( clinic, "gender", filename="survival_gender.pdf")
#TCGAanalyze_survival( clinic, "age_category", filename="survival_age_category.pdf")
# use ls to confirm the file was created
# rsync to copy and view on local computer

# overall_survival <- as.integer( ifelse( is.na(clinic$days_to_death), clinic$days_to_last_follow_up, clinic$days_to_death) )
# clinic$overall_survival <- overall_survival
# clinic$death_event <- ifelse(clinic$patient.vital_status == 'alive', 0,1)
# colnames(clinic) #use if want to visually see affect of ^^
# cox_fit <- coxph(Surv(overall_survival, death_event)~age_at_initial_pathologic_diagnosis, data=clinic)
# jpeg("cox_plot_age_continuous.jpg")
# ggcoxadjustedcurves(fit, data=lung)
# dev.off()
# Use rsync to copy figure onto local system and view

#######    Group 3: MAF   ###########
# BiocManager::install("maftools")
# library(maftools)
# mutation <- GDCquery_Maf(tumor = "BRCA",save.csv=TRUE, pipeline="") #choose a pipeline
# after running ^^, navigate to the saved csv file. Open the csv file with below Code
# only need to query once. For repeating code, you can just read in the saved dataframe you created
# maf_dataframe <- read.csv("PATH/FILENAME.csv")
# plotmafSummary(maf = maf_dataframe, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
# pdf("maf_summary.pdf")
# dev.off()
# Use rsync to copy onto local machine and view
# Create figures from Part 7: https://bioconductor.riken.jp/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html#7_Visualization
