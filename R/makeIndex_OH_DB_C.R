#' @title Creation of OH Index, DB Index and C-chain Index
#' @author André Vidas Olsen
#' @description This function creates OH Index, DB Index and C-chain Index of data containing calculated %pmol values of samples.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @return a data set consisting of OH, DB, C indexes
#' @export
#' @examples
#' # load user specified column names file.
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase", "userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # load pmolCalculatedDataSet.csv made by using the pmolCalc() function
#' pmolCalculatedDataSet <- read.table(system.file("extdata/dataTables", "pmolCalculatedDataSet.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # make data of OH, DB and C indexes
#' indexData <- makeIndex_OH_DB_C(pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
#'
#' # print data
#' indexData[[1]] # OH index
#' indexData[[2]] # DB index
#' indexData[[3]] # C index
makeIndex_OH_DB_C <- function(data, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  # only use experimental data (exclude all internal standards)
  exData <- data[-grep("^is",data[,dataColnames$SUM_COMPOSITION]),]


  # find all filter columns (same amount as the amount of samples), which contains the values to be summed
  filterCols <- colnames(exData)[grep("FILTERED",colnames(exData))]

  # find all class names
  classNames <- unique(gsub("^(\\w+.)[[:space:]].*", "\\1",exData[,dataColnames$SUM_COMPOSITION]))

  #### do indexing for each class
  OHdata <- data.frame(CLASS = NULL, OH = NULL)
  DBdata <- data.frame(CLASS = NULL, DB = NULL)
  Cdata <- data.frame(CLASS = NULL, C = NULL)

  # make the same amount of PMOL_PCT as filterCols
  for(i in 1:length(filterCols)){
    OHdata[,paste0("PMOL_PCT_",i)] <- NULL
    DBdata[,paste0("PMOL_PCT_",i)] <- NULL
    Cdata[,paste0("PMOL_PCT_",i)] <- NULL
  }

  for(className in classNames){
    tmpSubset <- exData[grep(paste0("^",className," "),exData[,dataColnames$SUM_COMPOSITION]),]


    # make OH index
    uniqueOHs <- unique(tmpSubset[, dataColnames$OH_GROUP])
    OHdata_tmp <- data.frame(CLASS = className, OH = uniqueOHs)
    for(i in 1:length(filterCols)){
      OHdata_tmp[,paste0("PMOL_PCT_",i)] <- NA
    }

    for(OH in uniqueOHs){
      for(i in 1:length(filterCols)){
        OHdata_tmp[OHdata_tmp$OH == OH, paste0("PMOL_PCT_", i)] <- sum(tmpSubset[tmpSubset$OH_GROUP == OH, filterCols[i]])
      }
      OHdata <- rbind(OHdata, OHdata_tmp[OHdata_tmp$OH == OH,])
    }



    # make DB index
    uniqueDBs <- unique(tmpSubset[, dataColnames$DOUBLE_BOND])
    DBdata_tmp <- data.frame(CLASS = className, DB = uniqueDBs)
    for(i in 1:length(filterCols)){
      DBdata_tmp[,paste0("PMOL_PCT_",i)] <- NA
    }
    for(DB in uniqueDBs){
      for(i in 1:length(filterCols)){
        DBdata_tmp[DBdata_tmp$DB == DB, paste0("PMOL_PCT_", i)] <- sum(tmpSubset[tmpSubset$DB == DB, filterCols[i]])
      }
      DBdata <- rbind(DBdata, DBdata_tmp[DBdata_tmp$DB == DB,])
    }


    # make C index
    uniqueCs <- unique(tmpSubset[, dataColnames$C_CHAIN])
    Cdata_tmp <- data.frame(CLASS = className, C = uniqueCs)
    for(i in 1:length(filterCols)){
      Cdata_tmp[,paste0("PMOL_PCT_",i)] <- NA
    }
    for(C in uniqueCs){
      for(i in 1:length(filterCols)){
        Cdata_tmp[Cdata_tmp$C == C, paste0("PMOL_PCT_", i)] <- sum(tmpSubset[tmpSubset$LENGTH == C, filterCols[i]])

      }
      Cdata <- rbind(Cdata, Cdata_tmp[Cdata_tmp$C == C,])
    }

  }

  # output OH DB and C as seperate data contained in a list.
  indexData <- list(OHdata, DBdata, Cdata)
  return(indexData)

}

