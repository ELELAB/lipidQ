#' @title Filter Data set
#' @author André Vidas Olsen
#' @description filterDataSet selects relevants columns from a data set and remove species
#' if the name does not exist in the global database.
#' @export
filterDataSet<-function(data, database){


  # if a row in the NAME or SPECIE column in the database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database)


  #### select relevant columns
  data_tmp <- subset(data, select = c("NAME","ERROR", "MASS","SPECIE","MODE", "LENGTH", "DB", "OH_GROUP"))
  PREC_tmp <- data[,c(colnames(data)[grep("^PREC",colnames(data))])]
  NLS_tmp <- data[,c(colnames(data)[grep("^NLS",colnames(data))])]

  FRAG_tmp <- data[,c(colnames(data)[grep("^FRAG",colnames(data))])]

  FA_tmp <- data[,c(colnames(data)[grep("^FA",colnames(data))])]
  FA_tmp <- FA_tmp[,-grep("^FA[0-9]$",colnames(FA_tmp))] # remove FA1, FA2, etc...

  # remove FAO in the FA_tmp cols if it's present
  if(length(FA_tmp[,grep("^FAO$",colnames(FA_tmp))]) > 0 ){
    FA_tmp <- FA_tmp[,-grep("^FAO$",colnames(FA_tmp))]
  }


  data <- cbind(data_tmp,PREC_tmp, NLS_tmp)



  # create QUAN column to data consisting of the QUAN column in database.
  data$QUAN <- database$QUAN[match(data$NAME, database$NAME)]


  # create SPECIE.GLOBAL column to data consisting of the SPECIE column in database.
  data$SPECIE.GLOBAL <- database$SPECIE[match(data$NAME, database$NAME)]


  # remove specie names that are not included in database
  GLOBAL.NAME.CHECK <- database$NAME[match(data$NAME, database$NAME)] # transfer NAME col from database to data
  data <- data[!is.na(GLOBAL.NAME.CHECK),] # remove all rows whose names were not found in database


  #### create SPECIE.ALL col: consists of all species within specie name seperated by "|", e.g. DAG 16:1-16:1|DAG 18:1-14:1
  data$SPECIE.ALL <- NA
  nameList <- unique(data$NAME)
  for(name in nameList){ # for each specie name, find all species and insert them into SPECIE.ALL seperated by "|"
    specie_tmp <- subset(data, NAME == name)$SPECIE
    #specie_tmp <- specie_tmp[!duplicated(specie_tmp)]
    specie_tmp <- paste(specie_tmp, collapse = '|')
    data[which(data$NAME == name),"SPECIE.ALL"]<-specie_tmp
  }


  #### remove duplicates

  # find potential value > 0 for each NAME in each PREC.* column and set this value as the default for this class name (if it exists), so that they appear after removal of duplicates. (PREC.* always have the same value > 0)
  classNames <- unique(data[,"NAME"])
  for(PREC in colnames(PREC_tmp)){
    for(className in classNames){
      data[data$NAME == className, PREC] <- max(data[data$NAME == className, PREC])
    }
  }

  # remove all duplicates of NAME.
  data <- data[!duplicated(data$NAME),]




  # (MAYBE DEPRECATED NOW THAT IT IS DONE IN THE mergeDataSet FUNCTION. CHECK SOON WITH RUnit) replace all "Keine" and "None" with the corresponding row value from the NAME column
  data$SPECIE <- ifelse(data$SPECIE == "Keine" | data$SPECIE == "None", data$NAME, data$SPECIE)


  # replace NA and "" with "none" in SPECIE.GLOBAL
  data$SPECIE.GLOBAL <- ifelse(is.na(data$SPECIE.GLOBAL) | data$SPECIE.GLOBAL == "", "none", data$SPECIE.GLOBAL)



  return(data)
}

