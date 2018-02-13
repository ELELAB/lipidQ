#' @title Sort Internal Standards
#' @author André Vidas Olsen
#' @description This function orders all internal standards (is) in a given data set so that they appear as the last rows
#' (after the normal species). The purpose for this is mainly to get a better overview of the data types when manually inspecting the data.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
#' @export
#' @return a sorted data set
#' @examples
#' mergedDataSets <- read.table(system.file("extdata/dataTables", "mergedDataSets.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#' list <- read.table(system.file("extdata/LipidQ_DataBase", "userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#' sortedData <- sort_is(mergedDataSets, userSpecifiedColnames = list)
sort_is<-function(data, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- checkColnames(userSpecifiedColnames)

  # save all is-rows
  isTmp <- data[grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  # remove all is-rows from data
  data <- data[-grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  # rbind all saved is-rows at the buttom of data
  data <- rbind(data,isTmp)

  return(data)
}
