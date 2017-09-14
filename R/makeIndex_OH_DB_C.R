#' @title Creation of OH Index, DB Index and C-chain Index
#' @author André Vidas Olsen
#' @description This function creates OH Index, DB Index and C-chain Index of data containing calculated %pmol values of samples.
makeIndex_OH_DB_C <- function(data){
  # only use experimental data (exclude all internal standards)
  exData <- data[-grep("^is",data$NAME),]


  # find all filter columns (same amount as the amount of samples), which contains the values to be summed
  filterCols <- colnames(exData)[grep("FILTERED",colnames(exData))]

  # find all class names
  classNames <- unique(gsub("^(\\w+.)[[:space:]].*", "\\1",exData[,"NAME"]))

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
    tmpSubset <- exData[grep(paste0("^",className," "),exData$NAME),]


    # make OH index
    uniqueOHs <- unique(tmpSubset$OH_GROUP)
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
    uniqueDBs <- unique(tmpSubset$DB)
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
    uniqueCs <- unique(tmpSubset$LENGTH)
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

  # merge OHdata, DBdata and Cdata into one data set
  OH_DB_C_data <- data.frame(CLASS = NULL, OH = NULL, DB = NULL, C = NULL)
  for(i in 1:length(filterCols)){
    OH_DB_C_data[,paste0("PMOL_PCT_",i)] <- NULL
  }

  OHdata$DB <- NA
  OHdata$C <- NA

  DBdata$OH <- NA
  DBdata$C <- NA

  Cdata$OH <- NA
  Cdata$DB <- NA

  OH_DB_C_data_ <- rbind(OHdata, DBdata, Cdata)

  # reorder columns so that PML_PCT* are the last columns
  OH_DB_C_data <- OH_DB_C_data_[c("CLASS", "OH", "DB", "C")]
  OH_DB_C_data <- cbind(OH_DB_C_data, OH_DB_C_data_[grep("PMOL_PCT",colnames(OH_DB_C_data_))])

  return(OH_DB_C_data)
}




