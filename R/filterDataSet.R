#' @title Filter Data set
#' @author André Vidas Olsen
#' @description filterDataSet selects relevants columns from a data set and remove species
#' if the name does not exist in the global database.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @export
#filterDataSet <- function(data, database, userSpecifiedColnames = NULL){
filterDataSet <- function(data, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = NULL){

  # merge endogene_lipid_db and ISTD_lipid_db together
  database <- merge_endo_and_ISTD_db(endogene_lipid_db, ISTD_lipid_db)

  # if a row in the SUM_COMPOSITION or SPECIE_COMPOSITION column in the database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database, userSpecifiedColnames)

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)


  #### select relevant columns
  data_tmp <- data[,c(dataColnames$SUM_COMPOSITION, dataColnames$PPM, dataColnames$MASS_TO_CHARGE, dataColnames$SPECIE_COMPOSITION, dataColnames$MODE, dataColnames$C_CHAIN, dataColnames$DOUBLE_BOND, dataColnames$OH_GROUP)]
  MS1x_tmp <- data[,c(colnames(data)[grep(paste0("^", dataColnames$MS1x),colnames(data))])]

  # find user specified columns of MS2ix column names -> MS2ix_userCols
  MS2ix_cols <- dataColnames[grep("MS2",colnames(dataColnames))]

  MS2ix_userCols <- c()
  for(userCol in as.character(MS2ix_cols)){
    MS2ix_userCols <- append(MS2ix_userCols, c(colnames(data)[grep(userCol,colnames(data))]))
  }
  MS2ix_userCols <- unique(MS2ix_userCols)

  MS2ix_tmp <- data[,MS2ix_userCols]
  data <- cbind(data_tmp,MS1x_tmp, MS2ix_tmp)



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
    specie_tmp <- data[data[,dataColnames$SUM_COMPOSITION] == name, dataColnames$SPECIE_COMPOSITION]
    specie_tmp <- paste(specie_tmp, collapse = '|')
    data[which(data[,dataColnames$SUM_COMPOSITION] == name),paste0(dataColnames$SPECIE_COMPOSITION, ".ALL")] <- specie_tmp
  }


  #### remove duplicates

  # find potential value > 0 for each SUM_COMPOSITION in each MS1x column and set this value as the default for this class name (if it exists), so that they appear after removal of duplicates. (MS1x always have the same value > 0)
  classNames <- unique(data[,dataColnames$SUM_COMPOSITION])
  for(MS1x in colnames(MS1x_tmp)){
    for(className in classNames){
      data[data[,dataColnames$SUM_COMPOSITION] == className, MS1x] <- max(data[data[,dataColnames$SUM_COMPOSITION] == className, MS1x])
    }
  }

  # remove all duplicates of SUM_COMPOSITION.
  data <- data[!duplicated(data[,dataColnames$SUM_COMPOSITION]),]


  # replace NA and "" with "none" in SPECIE_COMPOSITION.GLOBAL
  data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")] <- ifelse(is.na(data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")]) | data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")] == "", "none", data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")])


  return(data)
}

