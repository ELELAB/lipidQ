#' @title Merge Tableau Data Sets
#' @author André Vidas Olsen
#' @description This function merges tableau output files into one data file
#' @param dataList a list of paths referring to input data
#' @export
mergeTableauDataSets <- function(dataList){


  # Find all unique "mol." values for all data sets
  uniqueRows <- vector("list", length(dataList))
  for(i in 1:length(dataList)){
    data<-readFile(dataList[i])
    uniqueRows[[i]] <- data$"mol."
  }
  uniqueRows <- unique(unlist(uniqueRows))



  #mergedTableau <- data.frame()
  mergedTableau <- data.frame("mol." = uniqueRows)


  #firstRun <- TRUE
  for(i in 1:length(dataList)){
    data <- readFile(dataList[i])

    for(colIndex in 2:ncol(data)){

      mergedTableau$"newTmp" <- NA # create initial NA for new column to be merged

      colnames(mergedTableau)[ncol(mergedTableau)] <- colnames(data)[colIndex] # insert appropriate column name from data into new column in mergedTableau

      # match rows of incoming tableau data sets with existing merged data set to ensure correct placement of rows.
      mergedTableau[, ncol(mergedTableau)] <- data[match(mergedTableau$"mol.", data$"mol."), colIndex]
    }

  }


  # change 1st column name from "mol." to "mol%" due to conversion of "%" -> "." when reading data into R
  colnames(mergedTableau)[1] <- "mol%"

  return(mergedTableau)
}
