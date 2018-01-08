#' @title picomol Calculation
#' @author André Vidas Olsen
#' @description This function creates QC plots of MS1 intensity data
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @param numberOfReplicates the number of replicates for each sample
#' @param blnkReplicates logical parameter for specifying whether the blank sample contains replicates or not. FALSE: no replicates, TRUE: replicates.
#' @param pathToOutput the directory path to save the plots
#' @import ggplot2
#' @import reshape2
#' @importFrom stats sd
#' @export
plotQC_ISTD <- function(data, userSpecifiedColnames = NULL, pathToOutput, blnkReplicates = FALSE, numberOfReplicates){
  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames = userSpecifiedColnames)

  # find MS1x columns and BLNK column (last MS1x column)
  #MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
  #BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.* column)
  #MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from MS1x_names since this is BLNK

  # single blnk
  if(blnkReplicates == FALSE){

    MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
    BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.* column)
    MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from MS1x_names since this is BLNK
  }
  #IMPLEMENT_REP
  # blnk replicates
  else{
    MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
    BLNK <- MS1x_names[(length(MS1x_names)-numberOfReplicates+1):length(MS1x_names)] # name of BLNK column (last MS1x.* column)
    MS1x_names <- MS1x_names[-((length(MS1x_names)-numberOfReplicates+1):length(MS1x_names))] # remove last column from MS1x_names since this is BLNK
  }

  # find only is classes
  isData <- data[grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  # find median of MS1x values for each is class
  isData[,paste0(dataColnames$MS1x,"_median")] <- apply(isData[, MS1x_names], 1, FUN = median)

  isData[,paste0(dataColnames$MS1x,"_std")] <- apply(isData[, MS1x_names], 1, FUN = sd)
  head(isData)

  #### plot all ISTD's for averaged (median) sample intensities
  # ggplot2
  lower <- isData$PREC_median - isData$PREC_std
  upper <- isData$PREC_median + isData$PREC_std
  p <- ggplot()
  p <- p + geom_bar(data = isData, aes_string(x = 'NAME', y = 'PREC_median'), stat = "identity", position = position_dodge(width = 0.9)) +
    geom_errorbar(data=isData, position = position_dodge(width = 0.9), mapping=aes_string(x='NAME', ymin='lower', ymax='upper', width=0.2)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), plot.title = element_text(hjust = 0.5)) + labs(x = "Classes", y = "Intensity") + scale_fill_discrete(guide = guide_legend(title = "Classes")) +
    ggtitle("Median sample intensity values for all ISTD")

  ggsave(p, filename=paste0(pathToOutput, "/medianSampleIntensityAllISTDs.png"), width = 14, height = 10, units = "cm")


  #### plot all samples for a specific ISTD. Horizontal line = median of samples
  # ggplot2
  count <- 0
  for(name in isData$NAME){
    data_pr_ISTD <- melt(isData[isData$NAME == name, MS1x_names])
    median <- median(data_pr_ISTD$value)


    g <- ggplot()
    g <- g + geom_bar(data = data_pr_ISTD, aes_string(x = 'variable', y = 'value'), stat="identity") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1), plot.title = element_text(hjust = 0.5)) + labs(x = "Classes", y = "Intensity") + ggtitle(paste0("Sample intensity per ISTD\n(", name, ")")) +
      geom_hline(aes(yintercept = median))

    ggsave(g, filename=paste0(pathToOutput,"/", name,".png"), width = 14, height = 10, units = "cm")

    count <- count + 1
  }

}









#plotQC_ISTD(data, userSpecifiedColnames = NULL, pathToOutput = "results/QC/", blnkReplicates = TRUE, numberOfReplicates = 3)










