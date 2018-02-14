#' @title Merge Final Outputs
#' @author André Vidas Olsen
#' @description This function merges final output files into one data file
#' @param dataList a list of paths referring to input data
#' @return a data set consisting of merged final output files
#' @export
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

      mergedOutput$"newTmp" <- NA # create initial NA for new column to be merged

      colnames(mergedOutput)[ncol(mergedOutput)] <- colnames(data)[colIndex] # insert appropriate column name from data into new column in mergedOutput

      # match rows of incoming "final output" data sets with existing merged data set to ensure correct placement of rows.
      mergedOutput[, ncol(mergedOutput)] <- data[match(mergedOutput$"molPct", data$"molPct"), colIndex]
    }

  }


  ## change 1st column name from "mol." to "mol%" due to conversion of "%" -> "." when reading data into R
  #colnames(mergedOutput)[1] <- "mol%"

  return(mergedOutput)
}
