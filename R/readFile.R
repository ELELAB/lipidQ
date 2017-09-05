readFile <- function(dataPath){
  #
  # Auxiliary function that reads a data set by using the destination stored in the dataPath parameter.
  #
  data <- read.table(file=paste0(dataPath), sep=",",header = TRUE, as.is = TRUE, fill = TRUE, row.names = NULL)
  return(data)
}
