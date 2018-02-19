#' @title Merge Final Outputs
#' @author André Vidas Olsen
#' @description This function merges final output molPct files into one data
#' file
#' @param dataList a list of paths referring to input data
#' @return a data set consisting of merged final output files
#' @export
#' @examples
#' # load final output molPct files
#' dataPathList <- c(system.file("extdata/finalOutputFiles",
#'                   "finalOutput1.csv", package = "lipidQuan"),
#'                  system.file("extdata/finalOutputFiles",
#'                   "finalOutput2.csv", package = "lipidQuan") )
#'
#' mergeFinalOutputs(dataPathList)
mergeFinalOutputs <- function(dataList){


  # Find all unique "molPct" values for all data sets
  uniqueRows <- vector("list", length(dataList))
  for(i in 1:length(dataList)){
    data<-readFile(dataList[i])
    uniqueRows[[i]] <- data$"molPct"
  }
  uniqueRows <- unique(unlist(uniqueRows))


  mergedOutput <- data.frame("molPct" = uniqueRows)


  for(i in 1:length(dataList)){
    data <- readFile(dataList[i])

    for(colIndex in 2:ncol(data)){

      mergedOutput$"newTmp" <- NA #create initial NA for new column to be merged

      #insert appropriate column name from data into new column in mergedOutput
      colnames(mergedOutput)[ncol(mergedOutput)] <- colnames(data)[colIndex]

      # match rows of incoming "final output" data sets with existing merged
      # data set to ensure correct placement of rows.
      mergedOutput[, ncol(mergedOutput)] <-
        data[match(mergedOutput$"molPct", data$"molPct"), colIndex]
    }

    # change every NA to 0
    mergedOutput[is.na(mergedOutput)] <- 0

  }

  return(mergedOutput)
}
