#' @title Sort Internal Standards
#' @author André Vidas Olsen
#' @description This function orders all internal standards (is) in a given data set so that they appear as the last rows
#' (after the normal species). The purpose for this is mainly to get a better overview of the data types when manually inspecting the data.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @export
sort_is<-function(data, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  # save all is-rows
  isTmp <- data[grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  # remove all is-rows from data
  data <- data[-grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  # rbind all saved is-rows at the buttom of data
  data <- rbind(data,isTmp)

  return(data)
}
