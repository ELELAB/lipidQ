#' @title Remove Space In Beginning of NAME and SPECIE Rows
#' @author André Vidas Olsen
#' @description Auxiliary function that removes the first letter in NAME and SPECIE, if the word begins with a [SPACE]. It is used since, by experience, some rows begins with a space for these two columns which can results in errors.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
rmSpaceInBeginning <- function(data, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  # for each row, check if either the NAME or SPECIE column begins with a [SPACE] and remove this [SPACE] if true.
  data[,dataColnames$SUM_COMPOSITION] <- ifelse(substring(data[, dataColnames$SUM_COMPOSITION],1,1) == " ", substring(data[, dataColnames$SUM_COMPOSITION], 2), data[, dataColnames$SUM_COMPOSITION])
  data[, dataColnames$SPECIE_COMPOSITION] <- ifelse(substring(data[, dataColnames$SPECIE_COMPOSITION],1,1) == " ", substring(data[, dataColnames$SPECIE_COMPOSITION], 2), data[, dataColnames$SPECIE_COMPOSITION])


  return(data)
}
