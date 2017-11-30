#' @title Make Database
#' @author André Vidas Olsen
#' @description This function creates a database based on the user specified column names template
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
#' @param DB_type a string describing which of the two databases that is should be reset. "endo" for the endogene_lipid_db.csv database and "ISTD" for the ISTD_lipid_db.csv database.
#' @export
makeDatabase <- function(userSpecifiedColnames = NULL, DB_type){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  # find user specified columns of MS2ix column names -> MS2ix_userCols
  MS2ix_cols <- dataColnames[grep("^MS2",colnames(dataColnames))]


  DECONVOLUTION_cols <- dataColnames[grep("^DECONVOLUTION",colnames(dataColnames))]



  if(DB_type == "endo"){
    #### extract relevant column names from userSpecifiedColnames to database

    colnames_DB <- c(dataColnames$SUM_COMPOSITION, dataColnames$SPECIE_COMPOSITION, dataColnames$MS1x, as.character(MS2ix_cols), dataColnames$QUAN_MODE, dataColnames$QUAN_SCAN, as.character(DECONVOLUTION_cols))
  }
  if(DB_type == "ISTD"){
    colnames_DB <- c(dataColnames$SUM_COMPOSITION, "isLP", dataColnames$MS1x, as.character(MS2ix_cols), dataColnames$QUAN_MODE, dataColnames$QUAN_SCAN, as.character(DECONVOLUTION_cols), "LOQ", "DISSOLVED_AMOUNT", "DF_INFUSION")
  }


  # make databae with extracted column names
  database <- data.frame(matrix(ncol = length(colnames_DB), nrow = 0))
  colnames(database) <- colnames_DB

  return(database)
}

#userSpecifiedColnames <- read.csv("inst/extdata/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE)
#t<-makeDatabase(userSpecifiedColnames, DB_type = "ISTD")

#endo_db <- read.csv("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE)
#head(endo_db)

#ISTD_db <- read.csv("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE)
#head(ISTD_db)

