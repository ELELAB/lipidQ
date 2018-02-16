#' @title picomol Calculation
#' @author André Vidas Olsen
#' @description This function creates QC plots of MS1 intensity data
#' @param data data formatted by the use of the compactOutput_pmolCalc function
#' from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user
#' specified column names for the input data.
#' @param pathToOutput the directory path to save the plots
#' @import ggplot2
#' @import reshape2
#' @importFrom stats sd
#' @return barplots of pmol for every lipid class as well as one barplot of the
#' total amount of lipids for each sample
#' @export
#' @examples
#' # load user specified column names
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase",
#'  "userSpecifiedColnames.csv", package = "lipidQuan"),
#'  stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # load pmolCalculatedDataSet.csv made by using the pmolCalc() function
#' pmolCalculatedDataSet <- read.table(system.file("extdata/dataTables/checks",
#'  "pmolCalculatedDataSet.csv", package = "lipidQuan"),
#'  stringsAsFactors = FALSE, header = TRUE, sep = ",")
#' # make compact output from pmolCalculatedDataSet
#' classPmol_molPctClass_compact <- compactOutput_pmolCalc(
#'  pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
#'
#' # create QC plot of of total lipids
#' plotQC_totalLipids(data = classPmol_molPctClass_compact,
#'  userSpecifiedColnames = userSpecifiedColnames,
#'  pathToOutput = "")
plotQC_totalLipids <- function(data, userSpecifiedColnames = NULL,
                               pathToOutput = ""){

  # insert a "/" in the pathToOutput if used to ensure that the folder name is
  # separated from the file name
  if(pathToOutput != ""){
    pathToOutput <- paste0(pathToOutput, "/")
  }

  # get colnames for data
  dataColnames <- checkColnames(userSpecifiedColnames = userSpecifiedColnames)

  # single blnk
  if(TRUE){
    class_pmol_names <- colnames(data)[grep("^CLASS_PMOL_SUBT_PMOL_",
                  colnames(data))] # names of all CLASS_PMOL_SUBT_PMOL.* columns
    BLNK <- class_pmol_names[length(class_pmol_names)] # name of
    # BLNK column (last MS1x.* column)


  }


  # find only species
  exData <- data[-grep("^is",data[,dataColnames$SUM_COMPOSITION]),]



  exData_colSums <- colSums(exData[grep("^CLASS_PMOL_SUBT_PMOL_",
                                        colnames(exData))], na.rm = TRUE)

  data_pr_sample <- melt(exData_colSums)

  #### plot total amount of lipids for each sample
  p <- ggplot()
  p <- p + geom_bar(data = data_pr_sample,
                    aes_string(x = factor(1:nrow(data_pr_sample)), y = 'value'),
                    stat = "identity", position = position_dodge(width = 0.9)) +
                    theme(plot.title = element_text(hjust = 0.5)) +
                    labs(x = "Samples", y = "pmol") + scale_fill_discrete(
                    guide= guide_legend(title = "Classes")) +
                    ggtitle("Total amount of lipids per sample")

  ggsave(p, filename=paste0(pathToOutput, "totalAmountOfLipids.png"),
         width = 14, height = 10, units = "cm")


  #### plot all samples for a specific ISTD. Horizontal line = median of samples

  exData_SUM_C_and_CLASS <- cbind(exData[dataColnames$SUM_COMPOSITION],
                        exData[grep("^CLASS_PMOL_SUBT_PMOL_",colnames(exData))])


  count <- 0 # NECESSAY???
  for(name in exData_SUM_C_and_CLASS[,dataColnames$SUM_COMPOSITION]){
    #print(name)
    data_pr_lipid <- melt(exData_SUM_C_and_CLASS[exData_SUM_C_and_CLASS[,
                      dataColnames$SUM_COMPOSITION] == name, class_pmol_names])
    median <- median(data_pr_lipid$value)



    g <- ggplot()
    g <- g + geom_bar(data = data_pr_lipid, aes_string(
      x = factor(1:nrow(data_pr_sample)), y = 'value'), stat="identity") +
      theme(plot.title = element_text(hjust = 0.5)) + labs(x = "Sample",
      y = "pmol") +
      ggtitle(paste0("Total amount of lipid per sample\n(", name, ")")) +
      geom_hline(aes(yintercept = median))

    ggsave(g, filename=paste0(pathToOutput, name,".png"), width = 14,
           height = 10, units = "cm")
    count <- count + 1
  }

}

