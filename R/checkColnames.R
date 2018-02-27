#' @title Check Column Names
#' @author André Vidas Olsen
#' @description Auxiliary function to check colnames for the input data set.
#' @param userSpecifiedColnames the column names template file containing user
#' specified column names for the input data. This file
#' @return a validated user specified column names data set
checkColnames <- function(userSpecifiedColnames = NULL){
  # user specified colnames
  if(!is.null(userSpecifiedColnames)){

    # count number of MS2ix's
    numberOfMS2ix <- length(grep("^MS2", colnames(userSpecifiedColnames)))

    # create validation MS2ix columns.
    MS2ix <- character(numberOfMS2ix)
    for(i in 1:numberOfMS2ix){
      MS2ix[i] <- paste0("MS2",letters[i], "x")
    }


    # check that mandatory column names exist: SUM_COMPOSITION, and either MS1
    # or MS2
    if( !("SUM_COMPOSITION" %in% colnames(userSpecifiedColnames) &
       ("MS1" %in% colnames(userSpecifiedColnames) | numberOfMS2ix > 0)) ){

      stop(paste0("ERROR: The user specified column names file does not contain"
        ," mandatory column names (at least SUM_COMPOSITION, MS1 or MS2 is ",
        "missing). Please create a new userSpecifiedColnames.csv template file "
        , "in the lipidQ GUI Global Option procedure tab."))
    }


    # check that all internal column names of userSpecifiedColnames are written
    # correctly
    if(!all(colnames(userSpecifiedColnames) %in% c("PPM", "CLASS", "C_CHAIN",
      "DOUBLE_BOND", "OH_GROUP", "SUM_COMPOSITION", "SPECIE_COMPOSITION",
      "MASS_TO_CHARGE", "MS1x", MS2ix)
            )){
      stop(paste0("ERROR: The user specified column names file does not have ",
          "correctly written reference column names (First line of the file). ",
          "Please create a new userSpecifiedColnames.csv template file in the ",
          "lipidQ GUI Global Option procedure tab."))
    }

    # check that no duplicates exists among the internal column names
    if(!all(!duplicated(colnames(userSpecifiedColnames)))){
      stop(paste0("ERROR: The user specified column names file contains ",
        "duplicates. Please remove this or create a new ",
        "userSpecifiedColnames.csv template file in the ",
        "lipidQ GUI Global Option procedure tab."))
    }


    dataColnames <- userSpecifiedColnames

    # check that all user specified column names does not violate reserved
    # column names, else throw an error message
    if(any(c("FILTERED", "PMOL_", "SUBT_PMOL", "MOL_PCT", "CLASS_PMOL",
             "MOL_PCT_CLASS", "CLASS_FILTERED", "Sample_", "mol") %in%
           dataColnames[1,])){
      stop(paste0("ERROR: One or severeal user specified column names uses ",
          "reserved column names in the. Please change these.\nThe following ",
          "names are reserved and must be avoided at the beggining of the ",
          "column name:\n FILTERED\n PMOL_\n MOL_PCT\n CLASS_PMOL\n ",
          "MOL_PCT_CLASS\n CLASS_FILTERED\n Sample_\n mol"))
    }
  }
  else{
    stop("ERROR: No user specified column names file found.")
  }


  return(dataColnames)
}






