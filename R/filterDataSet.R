#' @title Filter Data set
#' @author André Vidas Olsen
#' @description filterDataSet selects relevants columns from a data set and remove species
#' if the name does not exist in the global database.
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @export
filterDataSet <- function(data, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = NULL){

  # merge endogene_lipid_db and ISTD_lipid_db together
  database <- merge_endo_and_ISTD_db(endogene_lipid_db, ISTD_lipid_db)

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)


  # for each row, check if either the NAME or SPECIE column begins with a [SPACE] and remove this [SPACE] if true. (TO BE CONTINUED ... Nodvendigt?)
  database[,dataColnames$SUM_COMPOSITION] <- ifelse(substring(database[, dataColnames$SUM_COMPOSITION],1,1) == " ", substring(database[, dataColnames$SUM_COMPOSITION], 2), database[, dataColnames$SUM_COMPOSITION])




  #### select relevant columns
  data_tmp <- data[,c(dataColnames$SUM_COMPOSITION, dataColnames$PPM, dataColnames$MASS_TO_CHARGE, dataColnames$SPECIE_COMPOSITION, "MODE", dataColnames$C_CHAIN, dataColnames$DOUBLE_BOND, dataColnames$OH_GROUP)]
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



  #if(TRUE){ # TO BE CONTINUED ... IF FUTURE ERRORS OCCUR, THIS COULD BE A CAUSE, SINCE IT HAS VERY RECENTLY BEEN ACTIVATED.
  #### Filtering based on 1/0 columns in database

  # select user specified columns of MS2ix columns from database
  MS2ix_userCols_database <- c()
  for(userCol in as.character(MS2ix_cols)){
    MS2ix_userCols_database <- append(MS2ix_userCols_database, colnames(database)[grep(userCol,colnames(database))])
  }

  # find all class names in database
  classNames <- unique(database[,dataColnames$SUM_COMPOSITION])


  # for each class in database, choose all species in data
  for(className in classNames){
    # select relevant columns (based on the 1/0's in the database)
    col_index <- (database[database[,dataColnames$SUM_COMPOSITION] == className, MS2ix_userCols_database] == 1)[1,] # the [1,] ensures that only the first row of columns is chosen (if there are multiple rows with the same className in the SUM_COMPOSITION column)

    selectedColNames <- MS2ix_userCols_database[col_index]



    if(length(selectedColNames) > 0){ # avoid error by ensuring that there exists some selected columns.

      # use selectedColNames to select all relevant columns for each sample in data
      for(k in 1:(ncol(MS1x_tmp))){


        if(k <= 9){


          selectedColRows <- subset(data, data[,dataColnames$SUM_COMPOSITION] == className, select = paste0(selectedColNames, "_0",k))
        }else{
          selectedColRows <- subset(data, data[,dataColnames$SUM_COMPOSITION] == className, select = paste0(selectedColNames, "_",k))

        }


        if(nrow(selectedColRows) > 0){ # only check condition on column-row values if selectedColRows actually contains rows
          for(i in 1:nrow(selectedColRows)){
            # check that all relevant columns (selected by 1/0 in the database) has a value > 0 for a given row. If at least one has a value <= 0, then this row == 0 for all columns.
            if(any(selectedColRows[i,] <= 0)){
              selectedColRows[i,] <- 0
            }
          }
          # set MS1x to 0 if all rows for the 1. columns in a given class has values <= 0. (The remaining columns are not neccesary to check, since checks and modifications of all columns for each row have been made).
          if(all(selectedColRows[,1] <= "0")){
            data[data[,dataColnames$SUM_COMPOSITION] == className, colnames(MS1x_tmp)[k]] <- 0
          }
        }
      }
    }
  }
  #}


  # create QUAN_SCAN column to data consisting of the QUAN_SCAN column in database.
  data$QUAN_SCAN <- database$QUAN_SCAN[match(data[,dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION])]


  # create SPECIE_COMPOSITION.GLOBAL column to data consisting of the SPECIE_COMPOSITION column in database.
  data[, paste0(dataColnames$SPECIE_COMPOSITION, ".GLOBAL")] <- database[match(data[,dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION]), dataColnames$SPECIE_COMPOSITION]


  # remove specie names that are not included in database
  GLOBAL.SUM_COMPOSITION.CHECK <- database[match(data[,dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION]), dataColnames$SUM_COMPOSITION] # transfer SUM_COMPOSITION col from database to data
  data <- data[!is.na(GLOBAL.SUM_COMPOSITION.CHECK),] # remove all rows whose names were not found in database


  # only include rows that have been monitored with the specified MODE (POS/NEG) in the database column
  data <- data[data[,"MODE"] == database[match(data[, dataColnames$SUM_COMPOSITION], database[,dataColnames$SUM_COMPOSITION]), "QUAN_MODE"],]


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

