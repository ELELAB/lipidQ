#' @title Filter Data set
#' @author André Vidas Olsen
#' @description filterDataSet selects relevants columns from a data set and remove species
#' if the name does not exist in the global database.
#' @export
filterDataSet<-function(data, database, userSpecifiedColnames = NULL){


  # if a row in the NAME or SPECIE column in the database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database)

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)


  #### select relevant columns
  data_tmp <- subset(data, select = c(dataColnames$NAME, dataColnames$PPM, dataColnames$MASS_TO_CHARGE, dataColnames$SPECIE, dataColnames$MODE, dataColnames$C_CHAIN, dataColnames$DOUBLE_BOND, dataColnames$OH_GROUP))
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



  # create QUAN column to data consisting of the QUAN column in database.
  data$QUAN <- database$QUAN[match(data[,dataColnames$NAME], database[,dataColnames$NAME])] # FIND OUT WHETHER IT IS QUAN_SCAN OR QUAN_MODE


  # create SPECIE.GLOBAL column to data consisting of the SPECIE column in database.
  data$SPECIE.GLOBAL <- database$SPECIE[match(data[,dataColnames$NAME], database[,dataColnames$NAME])]


  # remove specie names that are not included in database
  GLOBAL.NAME.CHECK <- database$NAME[match(data[,dataColnames$NAME], database[,dataColnames$NAME])] # transfer NAME col from database to data
  data <- data[!is.na(GLOBAL.NAME.CHECK),] # remove all rows whose names were not found in database


  #### create SPECIE.ALL col: consists of all species within specie name seperated by "|", e.g. DAG 16:1-16:1|DAG 18:1-14:1
  data[,paste0(dataColnames$SPECIE,".ALL")] <- NA
  nameList <- unique(data[,dataColnames$NAME])
  for(name in nameList){ # for each specie name, find all species and insert them into SPECIE.ALL seperated by "|"
    specie_tmp <- subset(data, data[,dataColnames$NAME] == name)[,dataColnames$SPECIE]
    specie_tmp <- paste(specie_tmp, collapse = '|')
    data[which(data[,dataColnames$NAME] == name),"SPECIE.ALL"] <- specie_tmp
  }


  #### remove duplicates

  # find potential value > 0 for each NAME in each PREC.* column and set this value as the default for this class name (if it exists), so that they appear after removal of duplicates. (PREC.* always have the same value > 0)
  classNames <- unique(data[,dataColnames$NAME])
  for(PREC in colnames(PREC_tmp)){
    for(className in classNames){
      data[data[,dataColnames$NAME] == className, PREC] <- max(data[data[,dataColnames$NAME] == className, PREC])
    }
  }

  # remove all duplicates of NAME.
  data <- data[!duplicated(data[,dataColnames$NAME]),]





  # replace NA and "" with "none" in SPECIE.GLOBAL
  data$SPECIE.GLOBAL <- ifelse(is.na(data$SPECIE.GLOBAL) | data$SPECIE.GLOBAL == "", "none", data$SPECIE.GLOBAL)



  return(data)
}

