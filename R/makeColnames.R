#setwd("/data/user/andre/lipidomics/lipidQuan") # for test purposes

#' @title Make column names
#' @author André Vidas Olsen
#' @description This function generates a new template file for standard column names (in the header) and with default column names as first row of the data.frame. These default column names
#' can be specified by the user. This function is useful if some error occur due to corruption of this file (for instance changes in the header section).
#' @param numberOfMS2ix a parameter that specifies how many MS2 columns there is in the input data, since this number can vary depending on experiment setup.
#' @export
makeColnames <- function(numberOfMS2ix = 3){

  # throw an error if numberOfMS2ix > 20.
  if(numberOfMS2ix > 20){
    stop("ERROR!! The number of MS2 columns can not exceed 20.")
  }

  # create MS2ix columns. Number of MS2ix columns is specified by the numberOfMS2ix function argument
  MS2ix <- character(numberOfMS2ix)
  for(i in 1:numberOfMS2ix){
    MS2ix[i] <- paste0("MS2",letters[i], "x")
  }

  defaultColnames <- c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", MS2ix, "QUAN_MODE", "QUAN_SCAN", "DECONVOLUTION_MODE", "DECONVOLUTION_MS2ax", "DECONVOLUTION_MS2bx", "MASS_MS2ax", "MASS_MS2bx", "MASS_MS2cx", "MODE","numberOfSamples", "numberOfReplicates")


  # create data.frame for user specified colnames
  userSpecifiedColnames <- matrix(ncol = length(defaultColnames), nrow = 1)
  colnames(userSpecifiedColnames) <- defaultColnames
  userSpecifiedColnames <- as.data.frame(userSpecifiedColnames)

  # set user specified names to be used
  userSpecifiedColnames$PPM <- c("ERROR")
  userSpecifiedColnames$CLASS <- c("CLASS")
  userSpecifiedColnames$C_CHAIN <- c("LENGTH")
  userSpecifiedColnames$DOUBLE_BOND <- c("DB")
  userSpecifiedColnames$SUM_COMPOSITION <- c("NAME")
  userSpecifiedColnames$SPECIE_COMPOSITION <- c("SPECIE")
  userSpecifiedColnames$MASS_TO_CHARGE <- c("MASS")
  userSpecifiedColnames$OH_GROUP <- c("OH_GROUP")
  userSpecifiedColnames$ISTD <- c("isLP")
  userSpecifiedColnames$MS1x <- c("PREC")
  userSpecifiedColnames$MS2ax <- c("FRAG")
  userSpecifiedColnames$MS2bx <- c("FA")
  userSpecifiedColnames$MS2cx <- c("NLS")
  userSpecifiedColnames$QUAN_MODE <- c("QUAN_MODE")
  userSpecifiedColnames$QUAN_SCAN <- c("QUAN_SCAN")
  userSpecifiedColnames$DECONVOLUTION_MODE <- c("DECONVOLUTION_MODE")
  userSpecifiedColnames$DECONVOLUTION_MS2ax <- c("DECONVOLUTION_FRAG")
  userSpecifiedColnames$DECONVOLUTION_MS2bx <- c("DECONVOLUTION_FA")
  userSpecifiedColnames$MASS_MS2ax <- c("MASSFRAG")
  userSpecifiedColnames$MASS_MS2bx <- c("MASSFA")
  userSpecifiedColnames$MASS_MS2cx <- c("MASSNLS")
  userSpecifiedColnames$MODE <- c("MODE")
  userSpecifiedColnames$numberOfSamples <- c("3")
  userSpecifiedColnames$numberOfReplicates <- c("3")

  return(userSpecifiedColnames)

}


# save file # for test purposes
#write.csv(userSpecifiedColnames, "inst/extdata/test/userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE) # for test purposes


