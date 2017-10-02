#' @title Get Column Names
#' @author André Vidas Olsen
#' @description Auxiliary function to get colnames for the input data set. If no user specified column names is provided as an argument, default column names will be returned.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
getColnames <- function(userSpecifiedColnames = NULL){
  # user specified colnames
  if(!is.null(userSpecifiedColnames)){

    # Check that all column names in userSpecifiedColnames.csv have the correct reference names, else throw an error message
    if(!isTRUE(all.equal(colnames(userSpecifiedColnames), c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", "MS2ax", "MS2bx", "MS2cx", "FAO", "QUAN_MODE", "QUAN_SCAN", "DECONVOLUTION_MODE", "DECONVOLUTION_MS2ax", "DECONVOLUTION_MS2bx", "MASS_MS2ax", "MASS_MS2bx", "MASS_MS2cx", "MODE","numberOfSamples", "numberOfReplicates")))){
      stop("ERROR: The userSpecifiedColnames.csv does not have correctly written reference column names (First line of the file). Please create a new userSpecifiedColnames.csv template file, by pressing THIS BUTTON in the lipidQuan GUI.")
    }

    dataColnames <- data.frame(PPM = userSpecifiedColnames$PPM, CLASS = userSpecifiedColnames$CLASS, C_CHAIN = userSpecifiedColnames$C_CHAIN, DOUBLE_BOND = userSpecifiedColnames$DOUBLE_BOND, SUM_COMPOSITION = userSpecifiedColnames$SUM_COMPOSITION, SPECIE_COMPOSITION = userSpecifiedColnames$SPECIE_COMPOSITION, MASS_TO_CHARGE = userSpecifiedColnames$MASS_TO_CHARGE, OH_GROUP = userSpecifiedColnames$OH_GROUP, ISTD = userSpecifiedColnames$ISTD, MS1x = userSpecifiedColnames$MS1x, MS2ax = userSpecifiedColnames$MS2ax, MS2bx = userSpecifiedColnames$MS2bx, MS2cx = userSpecifiedColnames$MS2cx, QUAN_MODE = userSpecifiedColnames$QUAN_MODE, QUAN_SCAN = userSpecifiedColnames$QUAN_SCAN, DECONVOLUTION_MODE = userSpecifiedColnames$DECONVOLUTION_MODE, DECONVOLUTION_MS2ax = userSpecifiedColnames$DECONVOLUTION_MS2ax, DECONVULOTION_MS2bx = userSpecifiedColnames$DECONVOLUTION_MS2bx, MASS_MS2ax = userSpecifiedColnames$MASS_MS2ax, MASS_MS2bx = userSpecifiedColnames$MASS_MS2bx, MASS_MS2cx = userSpecifiedColnames$MASS_MS2cx, MODE = userSpecifiedColnames$MODE, numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
  }

  # default colnames
  else{
    dataColnames <- data.frame(PPM = "ERROR", CLASS = "CLASS", C_CHAIN = "LENGTH", DOUBLE_BOND = "DB", SUM_COMPOSITION = "NAME", SPECIE_COMPOSITION = "SPECIE", MASS_TO_CHARGE = "MASS", OH_GROUP = "OH_GROUP", ISTD = "isLP", MS1x = "PREC", MS2ax = "FRAG", MS2bx = "FA", MS2cx = "NLS", FAO = "FAO", QUAN_MODE = "QUAN_MODE", QUAN_SCAN = "QUAN_SCAN", DECONVOLUTION_MODE = "DECONVOLUTION_MODE", DECONVULOTION_MS2ax = "DECONVOLUTION_FRAG", DECONVOLUTION_MS2bx = "DECONVOLUTION_FA", MASS_MS2ax = "MASSFRAG", MASS_MS2bx = "MASSFA", MASS_MS2cx = "MASSNLS", MODE = "MODE", numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
  }




  return(dataColnames)
}










