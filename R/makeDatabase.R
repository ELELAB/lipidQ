#' @title Make Database
#' @author André Vidas Olsen
#' @description This function creates a database based on the user specified column names template
makeDatabase <- function(userSpecifiedColnames = NULL, typeOfDB){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)



  if(typeOfDB == "endo"){
    # extract relevant columns from userSpecifiedColnames to database
    colnames_DB <- dataColnames[, c(dataColnames$SUM_COMPOSITION, dataColnames$SPECIE_COMPOSITION, dataColnames$MS1x, dataColnames$MS2ax, dataColnames$MS2bx, dataColnames$MS2cx, dataColnames$QUAN_MODE, dataColnames$QUAN_SCAN, dataColnames$DECONVOLUTION_MODE, dataColnames$DECONVOLUTION_MS2ax, dataColnames$DECONVOLUTION_MS2bx)]
    # TO BE CONTINUED ... MAKE SURE THAT ALL FRAG1..3 DECONVOLUTION_FRAG1..3 ETC. IS INCLUDED IN THE TWO CURRENT DATABASES BEFORE CONINUING. ALSO, MAKE SURE THAT getColnames.R IS CHANGED SO THAT FRAG1..3 ETC ARE SEPERATED INTO EACH UNIQUE MS2x.
  }
  if(typeOfDB == "ISTD"){

  }
}


endo_db <- read.csv("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE)
head(endo_db)

userSpecifiedColnames$SUM_COMPOSITION <- c("NAME")
userSpecifiedColnames$SPECIE_COMPOSITION <- c("SPECIE")
userSpecifiedColnames$MS1x <- c("PREC")
userSpecifiedColnames$MS2ax <- c("FRAG")
userSpecifiedColnames$MS2bx <- c("FA")
userSpecifiedColnames$MS2cx <- c("NLS")
userSpecifiedColnames$QUAN_MODE <- c("QUAN_MODE")
userSpecifiedColnames$QUAN_SCAN <- c("QUAN_SCAN")
userSpecifiedColnames$DECONVOLUTION_MODE <- c("DECONVOLUTION_MODE")
userSpecifiedColnames$DECONVOLUTION_MS2ax <- c("DECONVOLUTION_FRAG")
userSpecifiedColnames$DECONVOLUTION_MS2bx <- c("DECONVOLUTION_FA")


ISTD_db <- read.csv("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE)
head(ISTD_db)




