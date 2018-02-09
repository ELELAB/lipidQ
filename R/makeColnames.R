#' @title Make column names
#' @author André Vidas Olsen
#' @description This function generates a new template user specified column names file. This data file's first row can then be modified by the user so that each column match the users data columns.
#' can be specified by the user. This function is useful if some error occur due to corruption of this file (for instance changes in the header section).
#' @param numberOfMS2ix a parameter that specifies how many MS2 columns there is in the input data, since this number can vary depending on experiment setup.
#' @return a user specified column names template file
#' @export
#' @examples
#' # make a template user specified column names file.
#' dataColnamesTemplate <- makeColnames(numberOfMS2ix = 9)
makeColnames <- function(numberOfMS2ix = 7){
  # throw an error if numberOfMS2ix > 20.
  if(numberOfMS2ix > 20){
    stop("ERROR!! The number of MS2 columns can not exceed 20.")
  }

  # create MS2ix columns. Number of MS2ix columns is specified by the numberOfMS2ix function argument
  MS2ix <- character(numberOfMS2ix)
  for(i in 1:numberOfMS2ix){
    MS2ix[i] <- paste0("MS2",letters[i], "x")
  }

  # TO BE CONTINUED ... SHOULD THIS BE IMPLEMENTED FOR OUR FIRST VERSION??
  # create DECONVOLUTION_x columns. Number of DECONVOLUTION_x columns is specified by the numberOfDECONVOLUTION_x function argument
  #DECONVOLUTION_x <- character(numberOfDECONVOLUTION_x)
  #for(i in 1:numberOfDECONVOLUTION_x){
  #  DECONVOLUTION_x[i] <- paste0("DECONVOLUTION_",i)
  #}


  defaultColnames <- c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "MS1x", MS2ix)

  # create data.frame for user specified colnames
  userSpecifiedColnames <- matrix(ncol = length(defaultColnames), nrow = 1)
  colnames(userSpecifiedColnames) <- defaultColnames
  userSpecifiedColnames <- as.data.frame(userSpecifiedColnames)

  # set user specified names to "TYPE_NAME_HERE"
  userSpecifiedColnames[1,] <- "TYPE_NAME_HERE"


  return(userSpecifiedColnames)

}

