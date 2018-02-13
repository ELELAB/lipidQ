#' @title Make Database
#' @author André Vidas Olsen
#' @description This function creates a database based on the user specified column names template
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
#' @param DB_type a string describing which of the two databases that is should be reset. "endo" for the endogene_lipid_db.csv database and "ISTD" for the ISTD_lipid_db.csv database.
#' @export
#' @return a database template file in the form of either endogene or ISTD
#' @examples
#' # load user specified column names files
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase", "userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # make endo database
#' makeDatabase(userSpecifiedColnames = userSpecifiedColnames, DB_type = "endo")
#'
#' # make ISTD database
#' makeDatabase(userSpecifiedColnames = userSpecifiedColnames, DB_type = "ISTD")
makeDatabase <- function(userSpecifiedColnames = NULL, DB_type){

  # get colnames for data
  dataColnames <- checkColnames(userSpecifiedColnames)

  # find user specified columns of MS2ix column names -> MS2ix_userCols
  MS2ix_cols <- dataColnames[grep("^MS2",colnames(dataColnames))]

  # TO BE CONTINUED ... SHOULD THIS BE IMPLEMENTED FOR THE FIRST VERSION???
  #DECONVOLUTION_cols <- dataColnames[grep("^DECONVOLUTION",colnames(dataColnames))]



  if(DB_type == "endo"){
    #### extract relevant column names from userSpecifiedColnames to database
    colnames_DB <- c(dataColnames$SUM_COMPOSITION, dataColnames$SPECIE_COMPOSITION, dataColnames$MS1x, as.character(MS2ix_cols), "QUAN_MODE", "QUAN_SCAN")
  }
  if(DB_type == "ISTD"){
    colnames_DB <- c(dataColnames$SUM_COMPOSITION, "ISTD_CONC", dataColnames$MS1x, as.character(MS2ix_cols), "QUAN_MODE", "QUAN_SCAN", "LOQ", "DISSOLVED_AMOUNT", "DF_INFUSION")
  }


  # make database with extracted column names
  database <- data.frame(matrix(ncol = length(colnames_DB), nrow = 0))
  colnames(database) <- colnames_DB

  return(database)
}
