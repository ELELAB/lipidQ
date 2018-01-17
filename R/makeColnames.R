#' @title Make column names
#' @author André Vidas Olsen
#' @description This function generates a new template file for standard column names (in the header) and with default column names as first row of the data.frame. These default column names
#' can be specified by the user. This function is useful if some error occur due to corruption of this file (for instance changes in the header section).
#' @param numberOfMS2ix a parameter that specifies how many MS2 columns there is in the input data, since this number can vary depending on experiment setup.
#' @param numberOfDECONVOLUTION_x a parameter that specifies how many DECONVOLUTION columns there is in the input data, since this number can vary depending on experiment setup.
#' @export
makeColnames <- function(numberOfMS2ix = 7, numberOfDECONVOLUTION_x = 4){
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


  defaultColnames <- c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", MS2ix, "MODE")

  # create data.frame for user specified colnames
  userSpecifiedColnames <- matrix(ncol = length(defaultColnames), nrow = 1)
  colnames(userSpecifiedColnames) <- defaultColnames
  userSpecifiedColnames <- as.data.frame(userSpecifiedColnames)

  # set user specified names to "TYPE_NAME_HERE"
  userSpecifiedColnames[1,] <- "TYPE_NAME_HERE"


  return(userSpecifiedColnames)

}

