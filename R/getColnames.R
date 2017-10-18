#' @title Get Column Names
#' @author André Vidas Olsen
#' @description Auxiliary function to get colnames for the input data set. If no user specified column names is provided as an argument, default column names will be returned.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
getColnames <- function(userSpecifiedColnames = NULL){
  # user specified colnames
  if(!is.null(userSpecifiedColnames)){

    # check that all column names in userSpecifiedColnames.csv have the correct reference names, else throw an error message
    if(!isTRUE(all.equal(colnames(userSpecifiedColnames), c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", "MS2ax", "MS2bx", "MS2cx", "MS2dx", "MS2ex", "MS2fx", "MS2gx", "QUAN_MODE", "QUAN_SCAN", "DECONVOLUTION_MODE", "DECONVOLUTION_MS2ax", "DECONVOLUTION_MS2bx", "MODE","numberOfSamples", "numberOfReplicates")))){
      stop("ERROR: The userSpecifiedColnames.csv does not have correctly written reference column names (First line of the file). Please create a new userSpecifiedColnames.csv template file, by pressing THIS BUTTON in the lipidQuan GUI.")
    }

    #dataColnames <- data.frame(PPM = userSpecifiedColnames$PPM, CLASS = userSpecifiedColnames$CLASS, C_CHAIN = userSpecifiedColnames$C_CHAIN, DOUBLE_BOND = userSpecifiedColnames$DOUBLE_BOND, SUM_COMPOSITION = userSpecifiedColnames$SUM_COMPOSITION, SPECIE_COMPOSITION = userSpecifiedColnames$SPECIE_COMPOSITION, MASS_TO_CHARGE = userSpecifiedColnames$MASS_TO_CHARGE, OH_GROUP = userSpecifiedColnames$OH_GROUP, ISTD = userSpecifiedColnames$ISTD, MS1x = userSpecifiedColnames$MS1x, MS2ax = userSpecifiedColnames$MS2ax, MS2bx = userSpecifiedColnames$MS2bx, MS2cx = userSpecifiedColnames$MS2cx, MS2dx = userSpecifiedColnames$MS2dx, MS2ex = userSpecifiedColnames$MS2ex, MS2fx = userSpecifiedColnames$MS2fx, MS2gx = userSpecifiedColnames$MS2gx, QUAN_MODE = userSpecifiedColnames$QUAN_MODE, QUAN_SCAN = userSpecifiedColnames$QUAN_SCAN, DECONVOLUTION_MODE = userSpecifiedColnames$DECONVOLUTION_MODE, DECONVOLUTION_MS2ax = userSpecifiedColnames$DECONVOLUTION_MS2ax, DECONVULOTION_MS2bx = userSpecifiedColnames$DECONVOLUTION_MS2bx, MASS_MS2ax = userSpecifiedColnames$MASS_MS2ax, MASS_MS2bx = userSpecifiedColnames$MASS_MS2bx, MASS_MS2cx = userSpecifiedColnames$MASS_MS2cx, MODE = userSpecifiedColnames$MODE, numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
    dataColnames <- data.frame(PPM = userSpecifiedColnames$PPM, CLASS = userSpecifiedColnames$CLASS, C_CHAIN = userSpecifiedColnames$C_CHAIN, DOUBLE_BOND = userSpecifiedColnames$DOUBLE_BOND, SUM_COMPOSITION = userSpecifiedColnames$SUM_COMPOSITION, SPECIE_COMPOSITION = userSpecifiedColnames$SPECIE_COMPOSITION, MASS_TO_CHARGE = userSpecifiedColnames$MASS_TO_CHARGE, OH_GROUP = userSpecifiedColnames$OH_GROUP, ISTD = userSpecifiedColnames$ISTD, MS1x = userSpecifiedColnames$MS1x, MS2ax = userSpecifiedColnames$MS2ax, MS2bx = userSpecifiedColnames$MS2bx, MS2cx = userSpecifiedColnames$MS2cx, MS2dx = userSpecifiedColnames$MS2dx, MS2ex = userSpecifiedColnames$MS2ex, MS2fx = userSpecifiedColnames$MS2fx, MS2gx = userSpecifiedColnames$MS2gx, QUAN_MODE = userSpecifiedColnames$QUAN_MODE, QUAN_SCAN = userSpecifiedColnames$QUAN_SCAN, DECONVOLUTION_MODE = userSpecifiedColnames$DECONVOLUTION_MODE, DECONVOLUTION_MS2ax = userSpecifiedColnames$DECONVOLUTION_MS2ax, DECONVULOTION_MS2bx = userSpecifiedColnames$DECONVOLUTION_MS2bx, MODE = userSpecifiedColnames$MODE, numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)

    # check that all user specified column names does not violate reserved column names, else throw an error message
    if(any(dataColnames[1,] %in% c("FILTERED", "PMOL_", "SUBT_PMOL", "MOL_PCT", "CLASS_PMOL", "MOL_PCT_CLASS", "CLASS_FILTERED", "Sample_", "mol"))){
      stop("ERROR: One or severeal user specified column names uses reserved column names in the. Please change these.\nThe following names are reserved and must be avoided at the beggining of the column name:\n FILTERED\n PMOL_\n MOL_PCT\n CLASS_PMOL\n MOL_PCT_CLASS\n CLASS_FILTERED\n Sample_\n mol")
    }
  }

  # default colnames
  else{
    dataColnames <- data.frame(PPM = "ERROR", CLASS = "CLASS", C_CHAIN = "LENGTH", DOUBLE_BOND = "DB", SUM_COMPOSITION = "NAME", SPECIE_COMPOSITION = "SPECIE", MASS_TO_CHARGE = "MASS", OH_GROUP = "OH_GROUP", ISTD = "isLP", MS1x = "PREC", MS2ax = "FRAG1", MS2bx = "FRAG2", MS2cx = "FRAG3", MS2dx = "FA1", MS2ex = "FA2", MS2fx = "FA3", MS2gx = "NLS", QUAN_MODE = "QUAN_MODE", QUAN_SCAN = "QUAN_SCAN", DECONVOLUTION_MODE = "DECONVOLUTION_MODE", DECONVULOTION_MS2ax = "DECONVOLUTION_FRAG", DECONVOLUTION_MS2bx = "DECONVOLUTION_FA", MODE = "MODE", numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
  }




  return(dataColnames)
}










