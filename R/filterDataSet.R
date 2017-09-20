#' @title Filter Data set
#' @author André Vidas Olsen
#' @description filterDataSet selects relevants columns from a data set and remove species
#' if the name does not exist in the global database.
#' @export
filterDataSet<-function(data, database, userSpecifiedColnames = NULL){


  # if a row in the SUM_COMPOSITION or SPECIE_COMPOSITION column in the database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database)

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)


  #### select relevant columns
  data_tmp <- subset(data, select = c(dataColnames$SUM_COMPOSITION, dataColnames$PPM, dataColnames$MASS_TO_CHARGE, dataColnames$SPECIE_COMPOSITION, dataColnames$MODE, dataColnames$C_CHAIN, dataColnames$DOUBLE_BOND, dataColnames$OH_GROUP))
  PREC_tmp <- data[,c(colnames(data)[grep(paste0("^", dataColnames$MS1x),colnames(data))])]
  NLS_tmp <- data[,c(colnames(data)[grep("^NLS",colnames(data))])] # INVESTIGATE WITH MESUT WHAT NLS SHOULD BE (MS2X SOMETHING)..

  FRAG_tmp <- data[,c(colnames(data)[grep("^FRAG",colnames(data))])]

  FA_tmp <- data[,c(colnames(data)[grep("^FA",colnames(data))])]
  FA_tmp <- FA_tmp[,-grep("^FA[0-9]$",colnames(FA_tmp))] # remove FA1, FA2, etc...

  # remove FAO in the FA_tmp cols if it's present
  if(length(FA_tmp[,grep("^FAO$",colnames(FA_tmp))]) > 0 ){
    FA_tmp <- FA_tmp[,-grep("^FAO$",colnames(FA_tmp))]
  }


  data <- cbind(data_tmp,PREC_tmp, NLS_tmp)



  # create QUAN_SCAN column to data consisting of the QUAN_SCAN column in database.
  data$QUAN_SCAN <- database$QUAN_SCAN[match(data[,dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION])]


  # create SPECIE_COMPOSITION.GLOBAL column to data consisting of the SPECIE_COMPOSITION column in database.
  data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")] <- database[match(data[,dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION]), dataColnames$SPECIE_COMPOSITION]



  # remove specie names that are not included in database
  GLOBAL.SUM_COMPOSITION.CHECK <- database[match(data[,dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION]), dataColnames$SUM_COMPOSITION] # transfer SUM_COMPOSITION col from database to data
  data <- data[!is.na(GLOBAL.SUM_COMPOSITION.CHECK),] # remove all rows whose names were not found in database


  #### create SPECIE_COMPOSITION.ALL col: consists of all species within specie name seperated by "|", e.g. DAG 16:1-16:1|DAG 18:1-14:1
  data[,paste0(dataColnames$SPECIE_COMPOSITION,".ALL")] <- NA
  nameList <- unique(data[,dataColnames$SUM_COMPOSITION])
  for(name in nameList){ # for each specie name, find all species and insert them into SPECIE_COMPOSITION.ALL seperated by "|"
    specie_tmp <- subset(data, data[,dataColnames$SUM_COMPOSITION] == name)[,dataColnames$SPECIE_COMPOSITION]
    specie_tmp <- paste(specie_tmp, collapse = '|')
    data[which(data[,dataColnames$SUM_COMPOSITION] == name),paste0(dataColnames$SPECIE_COMPOSITION, ".ALL")] <- specie_tmp
  }


  #### remove duplicates

  # find potential value > 0 for each SUM_COMPOSITION in each PREC.* column and set this value as the default for this class name (if it exists), so that they appear after removal of duplicates. (PREC.* always have the same value > 0)
  classNames <- unique(data[,dataColnames$SUM_COMPOSITION])
  for(PREC in colnames(PREC_tmp)){
    for(className in classNames){
      data[data[,dataColnames$SUM_COMPOSITION] == className, PREC] <- max(data[data[,dataColnames$SUM_COMPOSITION] == className, PREC])
    }
  }

  # remove all duplicates of SUM_COMPOSITION.
  data <- data[!duplicated(data[,dataColnames$SUM_COMPOSITION]),]





  # replace NA and "" with "none" in SPECIE_COMPOSITION.GLOBAL
  data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")] <- ifelse(is.na(data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")]) | data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")] == "", "none", data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")])



  return(data)
}

