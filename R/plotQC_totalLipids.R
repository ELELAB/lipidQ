#' @title picomol Calculation
#' @author André Vidas Olsen
#' @description This function creates QC plots of MS1 intensity data
#' @param data data formatted by the use of the compactOutput_pmolCalc function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @param pathToOutput the directory path to save the plots
#' @import ggplot2
#' @import reshape2
#' @importFrom stats sd
#' @export
#' @examples
#' # load user specified column names
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase", "userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # load pmolCalculatedDataSet.csv made by using the pmolCalc() function
#' pmolCalculatedDataSet <- read.table(system.file("extdata/dataTables", "pmolCalculatedDataSet.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # make compact output from pmolCalculatedDataSet
#' classPmol_molPctClass_compact <- compactOutput_pmolCalc(pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
#'
#' # create QC plot of of total lipids
#' plotQC_totalLipids(data = classPmol_molPctClass_compact, userSpecifiedColnames = userSpecifiedColnames, pathToOutput = "results/QC/post")
plotQC_totalLipids <- function(data, userSpecifiedColnames = NULL, pathToOutput){
  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames = userSpecifiedColnames)

  # find MS1x columns and BLNK column (last MS1x column)
  #class_pmol_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
  #BLNK <- class_pmol_names[length(class_pmol_names)] # name of BLNK column (last MS1x.* column)
  #class_pmol_names <- class_pmol_names[-length(class_pmol_names)] # remove last column from class_pmol_names since this is BLNK

  # single blnk
  if(TRUE){
    #grep("^CLASS_PMOL_SUBT_PMOL_",colnames(data))
    class_pmol_names <- colnames(data)[grep("^CLASS_PMOL_SUBT_PMOL_",colnames(data))] # names of all CLASS_PMOL_SUBT_PMOL.* columns
    #class_pmol_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
    BLNK <- class_pmol_names[length(class_pmol_names)] # name of BLNK column (last MS1x.* column)
    #class_pmol_names <- class_pmol_names[-length(class_pmol_names)] # remove last column from class_pmol_names since this is BLNK

  }
  # blnk replicates
  #else{
  #  class_pmol_names <- colnames(data)[grep("^CLASS_PMOL_SUBT_PMOL_",colnames(data))] # names of all CLASS_PMOL_SUBT_PMOL.* columns
  #  #class_pmol_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
  #  BLNK <- class_pmol_names[(length(class_pmol_names)-numberOfReplicates+1):length(class_pmol_names)] # name of BLNK column (last MS1x.* column)
  #  class_pmol_names <- class_pmol_names[-((length(class_pmol_names)-numberOfReplicates+1):length(class_pmol_names))] # remove last column from class_pmol_names since this is BLNK
  #}


  # find only species
  exData <- data[-grep("^is",data[,dataColnames$SUM_COMPOSITION]),]



  exData_colSums <- colSums(exData[grep("^CLASS_PMOL_SUBT_PMOL_",colnames(exData))], na.rm = TRUE)

  data_pr_sample <- melt(exData_colSums)
  #print(data_pr_sample)
  #print(colnames(data_pr_sample))

  #### plot total amount of lipids for each sample
  p <- ggplot()
  p <- p + geom_bar(data = data_pr_sample, aes_string(x = factor(1:nrow(data_pr_sample)), y = 'value'), stat = "identity", position = position_dodge(width = 0.9)) +
    theme(plot.title = element_text(hjust = 0.5)) + labs(x = "Samples", y = "pmol") + scale_fill_discrete(guide = guide_legend(title = "Classes")) +
    ggtitle("Total amount of lipids per sample")

  ggsave(p, filename=paste0(pathToOutput, "/totalAmountOfLipids.png"), width = 14, height = 10, units = "cm")


  #### plot all samples for a specific ISTD. Horizontal line = median of samples
  #count <- 0

  exData_SUM_C_and_CLASS <- cbind(exData[dataColnames$SUM_COMPOSITION], exData[grep("^CLASS_PMOL_SUBT_PMOL_",colnames(exData))])
  #print(head(exData_SUM_C_and_CLASS))

  count <- 0 # NECESSAY???
  for(name in exData_SUM_C_and_CLASS[,dataColnames$SUM_COMPOSITION]){
    #print(name)
    data_pr_lipid <- melt(exData_SUM_C_and_CLASS[exData_SUM_C_and_CLASS[, dataColnames$SUM_COMPOSITION] == name, class_pmol_names])
    median <- median(data_pr_lipid$value)



    g <- ggplot()
    g <- g + geom_bar(data = data_pr_lipid, aes_string(x = factor(1:nrow(data_pr_sample)), y = 'value'), stat="identity") +
      theme(plot.title = element_text(hjust = 0.5)) + labs(x = "Sample", y = "pmol") + ggtitle(paste0("Total amount of lipid per sample\n(", name, ")")) +
      geom_hline(aes(yintercept = median))

    ggsave(g, filename=paste0(pathToOutput,"/", name,".png"), width = 14, height = 10, units = "cm")
    count <- count + 1
  }

}





# test
#setwd("/data/user/andre/lipidomics/lipidQuan")
#library(ggplot2)
#library(reshape2)
#source("R/mergeDataSets.R")
#source("R/sort_is.R")
#source("R/filterDataSet.R")
#source("R/pmolCalc.R")
#source("R/mergeFinalOutputs.R")
#source("R/readFile.R")
#source("R/rmSpaceInBeginning.R")
#source("R/getColnames.R")
#source("R/merge_endo_and_ISTD_db.R")
#source("R/filterReplicates.R")
#source("R/compactOutput_pmolCalc.R")
#source("R/makeFinalOutput.R")

#dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

#t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#t <- sort_is(t)
#t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
#classPmol_molPctClass <- compactOutput_pmolCalc(data = t, list)



# run function
#plotQC_totalLipids(data = classPmol_molPctClass, userSpecifiedColnames = list, pathToOutput = "results/QC/post")


