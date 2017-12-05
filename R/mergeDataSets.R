#' @title Merge Data Sets
#' @author André Vidas Olsen
#' @description This function merges multiple data sets together. The data sets are listed in the dataList parameter.
#' @param dataList a list of paths referring to input data
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' is used to translate the user specified column names to the program, so that it uses the correct columns for the different analysis procedures.
#' @param correctionList a file containing a list of sum compositions to be multiplied for in the MS1 column values (intensity values)
#' @param multiply a parameter used to multiply intensity values in the MS1 column on selected sum compositions. The parameter is useful if lipidX is used to obtain the intensity data derived from overlapping MS scan ranges. The sum composition are selected by the user and should appear in a correction list file that is used as argument for the correctionList parameter.
#' @export
#mergeDataSets <- function(dataList, database, userSpecifiedColnames = NULL, correctionList = NULL, multiply = NULL){
mergeDataSets <- function(dataList, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = NULL, correctionList = NULL, multiply = NULL){

  # merge endogene_lipid_db and ISTD_lipid_db together
  database <- merge_endo_and_ISTD_db(endogene_lipid_db, ISTD_lipid_db)


  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  # find all unique columns for all data sets
  tryCatch(
    {
      uniqueCols <- vector("list", length(dataList))
      for(i in 1:length(dataList)){
        data <- readFile(dataList[i])
        uniqueCols[[i]] <- colnames(data)
      }
      uniqueCols <- unique(unlist(uniqueCols))
      uniqueCols # return statement
    },
    error=function(cond){
      message("ERROR: NUMBER OF COLUMN NAMES IS NOT EQUAL TO NUMBER OF COLUMNS! Please make sure that every column has a column name.")
      message("")
      message("")
      message("")
      message("Original R error message:")
      message(cond)
    }
  )


  # find user specified columns of MS2ix column names -> MS2ix_userCols
  MS2ix_cols <- dataColnames[grep("MS2",colnames(dataColnames))]
  MS2ix_userCols <- c()
  for(userCol in as.character(MS2ix_cols)){
    MS2ix_userCols <- append(MS2ix_userCols, uniqueCols[grep(userCol,uniqueCols)])
  }
  MS2ix_userCols <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",MS2ix_userCols)
  MS2ix_userCols <- unique(MS2ix_userCols)




  # select user specified columns of MS2ix columns from database (To be used in the "#### Filtering based on 1/0 columns in database" in this function)
  MS2ix_userCols_database <- c()
  for(userCol in as.character(MS2ix_cols)){
    MS2ix_userCols_database <- append(MS2ix_userCols_database, colnames(database)[grep(userCol,colnames(database))])
  }




  #### merge data sets together ####
  firstRun <- TRUE
  for(dataPath in dataList){

    # load data from dataList
    data <- readFile(dataPath)

    # if a row in the SUM_COMPOSITION or SPECIE_COMPOSITION_COMPOSITION column starts with a [SPACE], remove this [SPACE]
    data <- rmSpaceInBeginning(data, userSpecifiedColnames)

    selectedCols <- tryCatch(
      {

        data[, c(dataColnames$PPM, dataColnames$CLASS, dataColnames$C_CHAIN, dataColnames$DOUBLE_BOND, dataColnames$SUM_COMPOSITION, dataColnames$SPECIE_COMPOSITION, dataColnames$MASS_TO_CHARGE)] # return statement

      },
      error=function(cond){
        message("ERROR: PROBLEMS WITH COLUMN NAMES! Please check that all colnames are correctly named, both in the data set and in the userSpecifiedList, if it's used.")
        message("")
        message("")
        message("")
        message("Original R error message:")
        message(cond)
      }
    )






    # Insert values from OH col to selectedCols, if present in the data set or set value to NA.
    if(dataColnames$OH_GROUP %in% colnames(data)){
      selectedCols[, dataColnames$OH_GROUP] <- data[,which(dataColnames$OH_GROUP == colnames(data))]
    }else{
      selectedCols[, dataColnames$OH_GROUP] <- NA
    }


    # change long MS1.* name to MS1_xx, where xx is a number
    MS1x_tmp <- data[,c(colnames(data)[grep(paste0("^",dataColnames$MS1x),colnames(data))])]
    colnames(MS1x_tmp) <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",colnames(MS1x_tmp))

    # insert new MS1_xx col names to selectedCols
    selectedCols <- cbind(selectedCols,MS1x_tmp)




    # insert mode column describing whether the measurements comes from POS or NEG measurements
    if(grepl("POS", basename(dataPath))){
      mode <- "POS"
    }else{
      if(grepl("NEG", basename(dataPath))){
        mode <- "NEG"
      }else{
        mode <- NA
      }
    }

    # insert mode column into selectedCols
    selectedCols$MODE <- mode



    # convert FA, FRAG and NLS col names in the input data (e.g. FAxxINTENS* name to FAxxINTENS_xx, where xx is a number), so they can be compared with the obtained colnames in FA_FRAG_NLS_cols.
    colnames(data) <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",colnames(data))

    # insert FA, FRAG and NLS columns into selectedCols. If they do not exist in the given data set, the value = NA
    dataNames <- colnames(data)
    for(col in MS2ix_userCols){
      if(col %in% dataNames){
        selectedCols[,paste(col)] <- data[,paste(col)]
      }else{
        selectedCols[,paste(col)] <- NA
      }
    }


    # remove all rows where SUM_COMPOSITION == ""
    selectedCols <- selectedCols[selectedCols[,dataColnames$SUM_COMPOSITION] != "",]


    # merge all data sets into one data set (mergedDataSet).
    if(firstRun == TRUE){ # only used on first run, since mergedDataSet is not defined yet
      mergedDataSet <- selectedCols
      firstRun <- FALSE
    }else{ # used for all runs except first run.
      mergedDataSet <- rbind(mergedDataSet, selectedCols)
    }
  }


  # convert different zero-symbols (e.g. " none" and NA) to the same symbol ("0").
  mergedDataSet[mergedDataSet == "0.0" | mergedDataSet == "none" | mergedDataSet == " none" | mergedDataSet == "None" | mergedDataSet == " None" | mergedDataSet == "Keine" | is.na(mergedDataSet)] <- "0"


  # multiply MS1x values if multiply is set to a value
  if(!is.null(multiply) && !is.null(correctionList)){
    for(MS1x in colnames(MS1x_tmp)){
      mergedDataSet[,MS1x] <- ifelse(mergedDataSet[,dataColnames$SUM_COMPOSITION] %in% correctionList, mergedDataSet[,MS1x]*multiply, mergedDataSet[,MS1x])

    }
  }


  #### Filtering based on 1/0 columns in database

  # find all class names in database
  classNames <- unique(database[,dataColnames$SUM_COMPOSITION])


  # for each class in database, chose all species in mergedData
  for(className in classNames){
    # select relevant columns (based on the 1/0's in the database)
    col_index <- (database[database[,dataColnames$SUM_COMPOSITION] == className, MS2ix_userCols_database] == 1)[1,] # the [1,] ensures that only the first row of columns is chosen (if there are multiple rows with the same className in the SUM_COMPOSITION column)

    selectedColNames <- MS2ix_userCols_database[col_index]



    if(length(selectedColNames) > 0){ # avoid error by ensuring that there exists some selected columns.

      # use selectedColNames to select all relevant columns for each sample in mergedDataSet
      for(k in 1:(ncol(MS1x_tmp))){


        if(k <= 9){


          selectedColRows <- subset(mergedDataSet, mergedDataSet[,dataColnames$SUM_COMPOSITION] == className, select = paste0(selectedColNames, "_0",k))
          #selectedColRows <- mergedDataSet[mergedDataSet[,dataColnames$SUM_COMPOSITION] == className, paste0(selectedColNames, "_0",k)]
          #print(paste0("nrow: ",nrow(selectedColRows)))
          #print(paste0("data: ",selectedColRows))
        }else{
          selectedColRows <- subset(mergedDataSet, mergedDataSet[,dataColnames$SUM_COMPOSITION] == className, select = paste0(selectedColNames, "_",k))

        }


        if(nrow(selectedColRows) > 0){ # only check condition on column-row values if selectedColRows actually contains rows
        #if(!is.null(selectedColRows)){ # only check condition on column-row values if selectedColRows actually contains rows
          for(i in 1:nrow(selectedColRows)){
            # check that all relevant columns (selected by 1/0 in the database) has a value > 0 for a given row. If at least one has a value <= 0, then this row == 0 for all columns.
            if(any(selectedColRows[i,] <= 0)){
              selectedColRows[i,] <- 0
            }
          }
          # set MS1x to 0 if all rows for the 1. columns has values <= 0. (The remaining columns are not neccesary to check, since checks and modifications of all columns for each row have been made).
          if(all(selectedColRows[,1] <= "0")){
            mergedDataSet[mergedDataSet[,dataColnames$SUM_COMPOSITION] == className, colnames(MS1x_tmp)[k]] <- 0
          }
        }
      }
    }
  }

  #### Test whether all MS1x and MS2x > 0 for all internal standards
  # merge MS1x and MS2x cols together
  #MS1x_MS2x_cols <- c(colnames(MS1x_tmp), MS2ix_userCols)


  # select rows with internal standards
  #isData <- mergedDataSet[grep("^is",mergedDataSet[,dataColnames$SUM_COMPOSITION]),]
  # remove all columns except from MS1x_MS2x_cols
  #isData <- isData[, c("NAME",MS1x_MS2x_cols)]



  #isData <- isData[, grep("_",colnames(isData))]


  # check 0 in MS1x_MS2_cols for internal standards
  #print(isData)
  #print(isData != 0)



  return(mergedDataSet)
}



