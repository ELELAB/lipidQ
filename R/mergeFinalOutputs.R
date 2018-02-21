#' @title Merge Final Outputs
#' @author André Vidas Olsen
#' @description This function merges final output molPct files into one data
#' file
#' @param dataList a list of paths referring to input data
#' @return a data set consisting of merged final output files
#' @export
#' @examples
#' # make output molPct files data path list
#' dataPathList <- c(system.file("extdata/",
#'                   "finalOutput1.csv", package = "lipidQ"),
#'                  system.file("extdata/",
#'                   "finalOutput2.csv", package = "lipidQ"))
#'
#' # merge final output files to one file
#' mergeFinalOutputs(dataPathList)
mergeFinalOutputs <- function(dataList){


  # Find all unique "molPct" values for all data sets
  uniqueRows <- vector("list", length(dataList))
  for(i in 1:length(dataList)){
    data<-readFile(dataList[i])
    uniqueRows[[i]] <- data$"molPct"
  }
  uniqueRows <- unique(unlist(uniqueRows))

  # sort species
  species <- sort(uniqueRows[grep(":",uniqueRows)])


  # sort classes
  classes <- sort(uniqueRows[-grep(":",uniqueRows)])
  print(classes)

  # return sorted uniqueRows (first all sorted species, then all sorted classes)
  uniqueRows <- c(species, classes)

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
