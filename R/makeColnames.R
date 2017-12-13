#setwd("/data/user/andre/lipidomics/lipidQuan") # for test purposes

#' @title Make column names
#' @author André Vidas Olsen
#' @description This function generates a new template file for standard column names (in the header) and with default column names as first row of the data.frame. These default column names
#' can be specified by the user. This function is useful if some error occur due to corruption of this file (for instance changes in the header section).
#' @param numberOfMS2ix a parameter that specifies how many MS2 columns there is in the input data, since this number can vary depending on experiment setup.
#' @param numberOfDECONVOLUTION_x a parameter that specifies how many DECONVOLUTION columns there is in the input data, since this number can vary depending on experiment setup.
#' @export
#makeColnames <- function(numberOfMS2ix = 7, numberOfDECONVOLUTION_x = 4){
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

  # create DECONVOLUTION_x columns. Number of DECONVOLUTION_x columns is specified by the numberOfDECONVOLUTION_x function argument
  #DECONVOLUTION_x <- character(numberOfDECONVOLUTION_x)
  #for(i in 1:numberOfDECONVOLUTION_x){
  #  DECONVOLUTION_x[i] <- paste0("DECONVOLUTION_",i)
  #}


  #defaultColnames <- c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", MS2ix, "QUAN_MODE", "QUAN_SCAN", DECONVOLUTION_x, "MODE","numberOfSamples", "numberOfReplicates")
  defaultColnames <- c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", MS2ix, "MODE")

  # create data.frame for user specified colnames
  userSpecifiedColnames <- matrix(ncol = length(defaultColnames), nrow = 1)
  colnames(userSpecifiedColnames) <- defaultColnames
  userSpecifiedColnames <- as.data.frame(userSpecifiedColnames)

  # set user specified names to "TYPE_NAME_HERE"
  userSpecifiedColnames[1,] <- "TYPE_NAME_HERE"


  #userSpecifiedColnames$PPM <- c("ERROR")
  #userSpecifiedColnames$CLASS <- c("CLASS")
  #userSpecifiedColnames$C_CHAIN <- c("LENGTH")
  #userSpecifiedColnames$DOUBLE_BOND <- c("DB")
  #userSpecifiedColnames$SUM_COMPOSITION <- c("NAME")
  #userSpecifiedColnames$SPECIE_COMPOSITION <- c("SPECIE")
  #userSpecifiedColnames$MASS_TO_CHARGE <- c("MASS")
  #userSpecifiedColnames$OH_GROUP <- c("OH_GROUP")
  #userSpecifiedColnames$ISTD <- c("isLP")
  #userSpecifiedColnames$MS1x <- c("PREC")
  #userSpecifiedColnames$MS2ax <- c("FRAG1")
  #userSpecifiedColnames$MS2bx <- c("FRAG2")
  #userSpecifiedColnames$MS2cx <- c("FRAG3")
  #userSpecifiedColnames$MS2dx <- c("FA1")
  #userSpecifiedColnames$MS2ex <- c("FA2")
  #userSpecifiedColnames$MS2fx <- c("FA3")
  #userSpecifiedColnames$MS2gx <- c("NLS")
  #userSpecifiedColnames$QUAN_MODE <- c("QUAN_MODE")
  #userSpecifiedColnames$QUAN_SCAN <- c("QUAN_SCAN")
  #userSpecifiedColnames$DECONVOLUTION_1 <- c("DECONVOLUTION_MODE")
  #userSpecifiedColnames$DECONVOLUTION_2 <- c("DECONVOLUTION_FRAG1")
  #userSpecifiedColnames$DECONVOLUTION_3 <- c("DECONVOLUTION_FA1")
  #userSpecifiedColnames$DECONVOLUTION_4 <- c("DECONVOLUTION_FA2")
  #userSpecifiedColnames$MODE <- c("MODE")
  #userSpecifiedColnames$numberOfSamples <- c("3")
  #userSpecifiedColnames$numberOfReplicates <- c("3")

  return(userSpecifiedColnames)

}


# save file # for test purposes
#userSpecifiedColnames <- makeColnames()
#write.csv(userSpecifiedColnames, "inst/extdata/test/userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE) # for test purposes


