#' @title Read File
#' @author André Vidas Olsen
#' @description Auxiliary function that reads a data set by using the destination stored in the dataPath parameter.
readFile <- function(dataPath){

  data <- read.table(file=paste0(dataPath), sep=",",header = TRUE, as.is = TRUE, fill = TRUE, row.names = NULL)
  return(data)
}
