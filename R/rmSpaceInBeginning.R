#' @title Remove Space In Beginning of NAME and SPECIE Rows
#' @author André Vidas Olsen
#' @description Auxiliary function that removes the first letter in NAME and SPECIE, if the word begins with a [SPACE]. It is used since, by experience, some rows begins with a space for these two columns which can results in errors.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
rmSpaceInBeginning <- function(data, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  test_SUM_and_SPECIE_COMPOSITION_exists <- tryCatch(
    {

      data[,dataColnames$SUM_COMPOSITION]
      data[,dataColnames$SPECIE_COMPOSITION]

    },
    error=function(cond){
      message(paste0("ERROR: PROBLEMS WITH COLUMN NAMES! Please check that ", dataColnames$SUM_COMPOSITION, " and ", dataColnames$SPECIE_COMPOSITION, " exists in all input data sets"))
      message("")
      message("")
      message("")
      message("Original R error message:")
      message(cond)
    }
  )

  # for each row, check if either the NAME or SPECIE column begins with a [SPACE] and remove this [SPACE] if true.
  data[,dataColnames$SUM_COMPOSITION] <- ifelse(substring(data[, dataColnames$SUM_COMPOSITION],1,1) == " ", substring(data[, dataColnames$SUM_COMPOSITION], 2), data[, dataColnames$SUM_COMPOSITION])
  data[, dataColnames$SPECIE_COMPOSITION] <- ifelse(substring(data[, dataColnames$SPECIE_COMPOSITION],1,1) == " ", substring(data[, dataColnames$SPECIE_COMPOSITION], 2), data[, dataColnames$SPECIE_COMPOSITION])


  return(data)
}
