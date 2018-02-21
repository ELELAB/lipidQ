#' @title picomol Calculation
#' @author André Vidas Olsen
#' @description This function creates QC plots of MS1 intensity data
#' @param data data formatted by the use of the mergeDataSet function from
#' LipidQ.
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @param userSpecifiedColnames the column names template file containing user
#' specified column names for the input data.
#' @param numberOfReplicates the number of replicates for each sample
#' @param blnkReplicates logical parameter for specifying whether the blank
#' sample contains replicates or not. FALSE: no replicates, TRUE: replicates.
#' @param pathToOutput the directory path to save the plots
#' @import ggplot2
#' @import reshape2
#' @importFrom stats sd
#' @return barplots of every ISTD which includes all samples as well as one
#' barplot of all ISTD with median sample intensity value
#' @export
#' @examples
#' # load endo & ISTD databases as well as user specified column names file.
#' endogene_lipid_db <- read.table(system.file("extdata/dataTables/checks",
#'  "endogene_lipid_db.csv", package = "lipidQ"), stringsAsFactors = FALSE,
#'  header = TRUE, sep = ",")
#'
#' ISTD_lipid_db <- read.table(system.file("extdata/dataTables/checks",
#'  "ISTD_lipid_db.csv", package = "lipidQ"), stringsAsFactors = FALSE,
#'  header = TRUE, sep = ",")
#'
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase",
#'  "userSpecifiedColnames.csv", package = "lipidQ"),
#'  stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # load is sorted mergedDataSet made by using the mergeDataSets() function
#' mergedDataSetsIsSorted <- read.table(system.file("extdata/dataTables/checks",
#'  "mergedDataSets.csv", package = "lipidQ"),
#'  stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # create QC plot of ISTD's
#' plotQC_ISTD(data = mergedDataSetsIsSorted,
#'  endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db,
#'  userSpecifiedColnames = userSpecifiedColnames,
#'  pathToOutput = "",
#'  blnkReplicates = TRUE, numberOfReplicates = 1)
plotQC_ISTD <- function(data, endogene_lipid_db, ISTD_lipid_db,
          userSpecifiedColnames = NULL, pathToOutput = "",
          blnkReplicates = FALSE, numberOfReplicates){

  # insert a "/" in the pathToOutput if used to ensure that the folder name is
  # separated from the file name
  if(pathToOutput != ""){
    pathToOutput <- paste0(pathToOutput, "/")
  }

  # get colnames for data
  dataColnames <- checkColnames(userSpecifiedColnames = userSpecifiedColnames)

  # merge endogene_lipid_db and ISTD_lipid_db together
  database <- merge_endo_and_ISTD_db(endogene_lipid_db, ISTD_lipid_db)

  # create QUAN_SCAN column to data consisting of the QUAN_SCAN column in
  # database.
  data$QUAN_SCAN <- database$QUAN_SCAN[match(data[,
        dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION])]

  # single blnk
  if(blnkReplicates == FALSE){

    MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names
    # of all MS1x.* columns
    BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.*
    # column)
    MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from
    # MS1x_names since this is BLNK
  }

  # blnk replicates
  else{
    MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names
    # of all MS1x.* columns
    BLNK <- MS1x_names[(length(MS1x_names) -
                          numberOfReplicates+1):length(MS1x_names)] # name of
                          # BLNK column (last MS1x.* column)
    MS1x_names <- MS1x_names[-((length(MS1x_names) -
                          numberOfReplicates+1):length(MS1x_names))] # remove
                          # last column from MS1x_names since this is BLNK
  }

  # find only is classes
  isData <- data[grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  for(i in 1:nrow(isData)){

    MS1x_names <- gsub(unlist(strsplit(MS1x_names, "_"))[1],
                       isData[i,"QUAN_SCAN"], MS1x_names)

    # find median of MS1x values for each is class
    isData[i,paste0(dataColnames$MS1x,"_median")] <-
      median(as.numeric(isData[i, MS1x_names]))

    # find standard deviation of MS1x values for each is class
    isData[i,paste0(dataColnames$MS1x,"_std")] <-
      sd(as.numeric(isData[i, MS1x_names]))





    #### plot all samples for a specific ISTD. Horizontal line = median of
    #### samples
    data_pr_ISTD <- melt(isData[isData[, dataColnames$SUM_COMPOSITION] ==
                          isData[i, dataColnames$SUM_COMPOSITION], MS1x_names])
    median <- median(data_pr_ISTD$value)


    g <- ggplot()
    g <- g + geom_bar(data = data_pr_ISTD, aes_string(x = 'variable',
      y = 'value'), stat="identity") + theme(axis.text.x =
      element_text(angle = 90, hjust = 1), plot.title = element_text(
      hjust = 0.5)) + labs(x = "Classes", y = "Intensity") +
      ggtitle(paste0("Sample intensity per ISTD\n(",
      isData[i, dataColnames$SUM_COMPOSITION], ")")) +
      geom_hline(aes(yintercept = median))

    ggsave(g, filename=paste0(pathToOutput,
      isData[i, dataColnames$SUM_COMPOSITION],".png"), width = 14, height = 10,
      units = "cm")

  }




  #### plot all ISTD's for averaged (median) sample intensities
  # ggplot2
  lower <- isData[,paste0(dataColnames$MS1x,"_median")] -
    isData[,paste0(dataColnames$MS1x,"_std")]
  upper <- isData[,paste0(dataColnames$MS1x,"_median")] +
    isData[,paste0(dataColnames$MS1x,"_std")]
  p <- ggplot()
  p <- p + geom_bar(data = isData, aes_string(x = dataColnames$SUM_COMPOSITION,
    y = paste0(dataColnames$MS1x,"_median")), stat = "identity",
    position = position_dodge(width = 0.9)) + geom_errorbar(data=isData,
    position = position_dodge(width = 0.9),
    mapping=aes_string(x=dataColnames$SUM_COMPOSITION, ymin='lower',
    ymax='upper', width=0.2)) + theme(axis.text.x = element_text(angle = 90,
    hjust = 1), plot.title = element_text(hjust = 0.5)) + labs(x = "Classes",
    y = "Intensity") + scale_fill_discrete(guide = guide_legend(title =
    "Classes")) + ggtitle("Median sample intensity values for all ISTD")

  ggsave(p, filename=paste0(pathToOutput, "medianSampleIntensityAllISTDs.png"),
         width = 14, height = 10, units = "cm")

}



