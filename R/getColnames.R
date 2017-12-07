#' @title Get Column Names
#' @author André Vidas Olsen
#' @description Auxiliary function to get colnames for the input data set. If no user specified column names is provided as an argument, default column names will be returned.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
getColnames <- function(userSpecifiedColnames = NULL){
  # user specified colnames
  if(!is.null(userSpecifiedColnames)){

    # count number of MS2ix's
    numberOfMS2ix <- length(grep("^MS2", colnames(userSpecifiedColnames)))

    # create validation MS2ix columns.
    MS2ix <- character(numberOfMS2ix)
    for(i in 1:numberOfMS2ix){
      MS2ix[i] <- paste0("MS2",letters[i], "x")
    }


    # check that all column names in userSpecifiedColnames.csv have the correct reference names else throw an error message
    if(!all(c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "OH_GROUP", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "ISTD", "MS1x", MS2ix, "QUAN_MODE", "QUAN_SCAN", "MODE") %in% colnames(userSpecifiedColnames))){

      stop("ERROR: The userSpecifiedColnames.csv does not have correctly written reference column names (First line of the file). Please create a new userSpecifiedColnames.csv template file, by pressing THIS BUTTON in the lipidQuan GUI.")
    }

    dataColnames <- userSpecifiedColnames

    # check that all user specified column names does not violate reserved column names, else throw an error message
    if(any(c("FILTERED", "PMOL_", "SUBT_PMOL", "MOL_PCT", "CLASS_PMOL", "MOL_PCT_CLASS", "CLASS_FILTERED", "Sample_", "mol") %in% dataColnames[1,])){
      stop("ERROR: One or severeal user specified column names uses reserved column names in the. Please change these.\nThe following names are reserved and must be avoided at the beggining of the column name:\n FILTERED\n PMOL_\n MOL_PCT\n CLASS_PMOL\n MOL_PCT_CLASS\n CLASS_FILTERED\n Sample_\n mol")
    }
  }

  # default colnames
  else{
    dataColnames <- data.frame(PPM = "ERROR", CLASS = "CLASS", C_CHAIN = "LENGTH", DOUBLE_BOND = "DB", SUM_COMPOSITION = "NAME", SPECIE_COMPOSITION = "SPECIE", MASS_TO_CHARGE = "MASS", OH_GROUP = "OH_GROUP", ISTD = "isLP", MS1x = "PREC", MS2ax = "FRAG1", MS2bx = "FRAG2", MS2cx = "FRAG3", MS2dx = "FA1", MS2ex = "FA2", MS2fx = "FA3", MS2gx = "NLS", QUAN_MODE = "QUAN_MODE", QUAN_SCAN = "QUAN_SCAN", DECONVOLUTION_1 = "DECONVOLUTION_MODE", DECONVULOTION_2 = "DECONVOLUTION_FRAG1", DECONVOLUTION_3 = "DECONVOLUTION_FA1", DECONVOLUTION_4 = "DECONVOLUTION_FA2", MODE = "MODE", numberOfSamples = "numberOfSamples", numberOfReplicates = "numberOfReplicates", stringsAsFactors = FALSE)
  }




  return(dataColnames)
}










