#' @title Merge Final Outputs
#' @author André Vidas Olsen
#' @description This function merges final output files into one data file
#' @param dataList a list of paths referring to input data
#' @export
mergeFinalOutputs <- function(dataList){


  # Find all unique "mol." values for all data sets
  uniqueRows <- vector("list", length(dataList))
  for(i in 1:length(dataList)){
    data<-readFile(dataList[i])
    uniqueRows[[i]] <- data$"mol."
  }
  uniqueRows <- unique(unlist(uniqueRows))


  mergedOutput <- data.frame("mol." = uniqueRows)


  for(i in 1:length(dataList)){
    data <- readFile(dataList[i])

    for(colIndex in 2:ncol(data)){

      mergedOutput$"newTmp" <- NA # create initial NA for new column to be merged

      colnames(mergedOutput)[ncol(mergedOutput)] <- colnames(data)[colIndex] # insert appropriate column name from data into new column in mergedOutput

      # match rows of incoming "final output" data sets with existing merged data set to ensure correct placement of rows.
      mergedOutput[, ncol(mergedOutput)] <- data[match(mergedOutput$"mol.", data$"mol."), colIndex]
    }

  }


  # change 1st column name from "mol." to "mol%" due to conversion of "%" -> "." when reading data into R
  colnames(mergedOutput)[1] <- "mol%"

  return(mergedOutput)
}
