#' @title Set Column Names
#' @author André Vidas Olsen
#' @description Auxiliary function to set colnames for the input data set. If no user specified column names is provided as an argument, default column names will be used
getColnames <- function(userSpecifiedColnames = NULL){
  # user specified colnames
  if(!is.null(userSpecifiedColnames)){
    dataColnames <- data.frame(PPM = userSpecifiedColnames$PPM, CLASS = userSpecifiedColnames$CLASS, C_CHAIN = userSpecifiedColnames$C_CHAIN, DOUBLE_BOND = userSpecifiedColnames$DOUBLE_BOND, NAME = userSpecifiedColnames$NAME, SPECIE = userSpecifiedColnames$SPECIE, MASS_TO_CHARGE = userSpecifiedColnames$MASS_TO_CHARGE, OH_GROUP = userSpecifiedColnames$OH_GROUP, ISTD = userSpecifiedColnames$ISTD, MS1x = userSpecifiedColnames$MS1x, MS2x = userSpecifiedColnames$MS2x, NLS = userSpecifiedColnames$NLS, QUAN_MODE = userSpecifiedColnames$QUAN_MODE, QUAN_SCAN = userSpecifiedColnames$QUAN_SCAN, DECONVOLUTION_MODE = userSpecifiedColnames$DECONVOLUTION_MODE, DECONVULOTION_FRAGx = userSpecifiedColnames$DECONVOLUTION_FRAGx, DECONVOLUTION_FAx = userSpecifiedColnames$DECONVOLUTION_FAx, MASSNLS = userSpecifiedColnames$MASSNLS, MASSFA = userSpecifiedColnames$MASSFA, MASSFRAG = userSpecifiedColnames$MASSFRAG, MODE = userSpecifiedColnames$MODE, numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
  }

  # default colnames
  else{
    dataColnames <- data.frame(PPM = "ERROR", CLASS = "CLASS", C_CHAIN = "LENGTH", DOUBLE_BOND = "DB", NAME = "NAME", SPECIE = "SPECIE", MASS_TO_CHARGE = "MASS", OH_GROUP = "OH_GROUP", ISTD = "isLP", MS1x = "PREC", MS2x = "FRAG", FAxINTENS <- "FAxINTENS", NLS = "NLS", FAOINTENS <- "FAOINTENS", QUAN_MODE = "QUAN_MODE", QUAN_SCAN = "QUAN_SCAN", DECONVOLUTION_MODE = "DECONVOLUTION_MODE", DECONVULOTION_FRAGx = "DECONVOLUTION_FRAG", DECONVOLUTION_FAx = "DECONVOLUTION_FA", MASSNLS = "MASSNLS", MASSFA = "MASSFA", MASSFRAG = "MASSFRAG", MODE = "MODE", numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
  }




  return(dataColnames)
}










