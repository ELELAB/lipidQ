#' @title Merge Data Sets
#' @author André Vidas Olsen
#' @description This function merges multiple data sets together. The data sets are listed in the dataList parameter.
#' @export
mergeDataSets <- function(dataList, database, userSpecifiedColnames = NULL, multiply = NULL, list = NULL){

  # get colnames for data:
  dataColnames <- getColnames(userSpecifiedColnames)

  # Find all unique columns for all data sets
  tryCatch(
    {
      uniqueCols <- vector("list", length(dataList))
      for(i in 1:length(dataList)){
        data<-readFile(dataList[i])
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



  # take all *FA* columns except SUMFA columns
  FA_cols <- uniqueCols[grep("FA",uniqueCols)]
  # remove SUMFA columns
  FA_cols <- FA_cols[-grep("^SUM",FA_cols)]



  # take all *FRAG* columns
  #FRAG_cols <- uniqueCols[grep("FRAG",uniqueCols)]
  FRAG_cols <- uniqueCols[grep(dataColnames$MS2x,uniqueCols)]


  # take all *NLS* columns
  #NLS_cols <- uniqueCols[grep("NLS",uniqueCols)]
  NLS_cols <- uniqueCols[grep(dataColnames$NLS,uniqueCols)]



  # merge *FA* *FRAG* and *NLS* together
  FA_FRAG_NLS_cols <- c(FA_cols, FRAG_cols, NLS_cols)

  # change long FAxxINTENS* name to FAxxINTENS_xx, where xx is a number for all the different column types (FA, FRAG and NLS)
  FA_FRAG_NLS_cols <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",FA_FRAG_NLS_cols)
  FA_FRAG_NLS_cols <- unique(FA_FRAG_NLS_cols)



  #### merge data sets together ####
  firstRun <- TRUE
  for(dataPath in dataList){

    # load data from dataList
    data <- readFile(dataPath)

    # if a row in the NAME or SPECIE column starts with a [SPACE], remove this [SPACE]
    data <- rmSpaceInBeginning(data)

    # select specific columns for a given data set (columns that are always present in each dataset).
    #selectedCols <- subset(data, select = c("ERROR", "CLASS", "LENGTH", "DB", "NAME", "SPECIE", "MASS"))
    #selectedCols <- subset(data, select = c(ERROR, CLASS, LENGTH, DB, NAME, SPECIE, MASS))
    selectedCols <- tryCatch(
      {

        subset(data, select = c(dataColnames$PPM, dataColnames$CLASS, dataColnames$C_CHAIN, dataColnames$DOUBLE_BOND, dataColnames$NAME, dataColnames$SPECIE, dataColnames$MASS_TO_CHARGE)) # return statement

      },
      error=function(cond){
        message("ERROR: PROBLEMS WITH COLUMN NAMES! Please check that all colnames are correctly named, both in the dataset and in the userSpecifiedList, if it's used.")
        message("")
        message("")
        message("")
        message("Original R error message:")
        message(cond)
      }
    )






    # Insert values from OH col to selectedCols, if present in the data set or set value to NA.
    if(dataColnames$OH_GROUP %in% colnames(data)){
      selectedCols$OH_GROUP <- data[,which(dataColnames$OH_GROUP == colnames(data))]
    }else{
      selectedCols$OH_GROUP <- NA
    }


    # change long PREC* name to PREC_xx, where xx is a number
    PREC_tmp <- data[,c(colnames(data)[grep(paste0("^",dataColnames$MS1x),colnames(data))])]
    colnames(PREC_tmp) <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",colnames(PREC_tmp))

    # insert new PREC_xx col names to selectedCols
    selectedCols <- cbind(selectedCols,PREC_tmp)



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
    for(col in FA_FRAG_NLS_cols){
      if(col %in% dataNames){
        selectedCols[,paste(col)] <- data[,paste(col)]
      }else{
        selectedCols[,paste(col)] <- NA
      }
    }


    # remove all rows where NAME == ""
    selectedCols <- selectedCols[selectedCols[,dataColnames$NAME] != "",]


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


  # multiply PREC* values if multiply is set to a value
  if(!is.null(multiply) && !is.null(list)){
    for(PREC in colnames(PREC_tmp)){
      mergedDataSet[,PREC] <- ifelse(mergedDataSet[,dataColnames$NAME] %in% list, mergedDataSet[,PREC]*multiply, mergedDataSet[,PREC])

    }
  }



  # select columns from database
  FRAG_database <- colnames(database)[grep("^FRAG",colnames(database))]
  FA_database <- colnames(database)[grep("^FA",colnames(database))]
  NLS_database <- colnames(database)[grep("^NLS",colnames(database))]
  FRAG_FA_NLS_database <- c(FRAG_database, FA_database, NLS_database)




  #### Filtering based on 1/0 columns in database

  # find all class names in database
  classNames <- unique(database[,dataColnames$NAME])

  # for each class in database, chose all species in mergedData
  for(className in classNames){
    #print(className)
    # select relevant columns (based on the 1/0's in the database)
    col_index <- (database[database[,dataColnames$NAME] == className, FRAG_FA_NLS_database] == 1)[1,] # the [1,] ensures that only the first row of columns is chosen (if there are multiple rows with the same className in the NAME column)

    selectedColNames <- FRAG_FA_NLS_database[col_index]


    if(length(selectedColNames) > 0){ # avoid error by ensuring that there exists some selected columns.

      # use selectedColNames to select all relevant columns for each sample in mergedDataSet
      for(k in 1:(ncol(PREC_tmp))){

        if(k <= 9){
          selectedColRows <- subset(mergedDataSet, mergedDataSet[,dataColnames$NAME] == className, select = paste0(selectedColNames, "_0",k))

        }else{
          selectedColRows <- subset(mergedDataSet, mergedDataSet[,dataColnames$NAME] == className, select = paste0(selectedColNames, "_",k))
        }



        if(nrow(selectedColRows) > 0){ # only check condition on column-row values if selectedColRows actually contains rows
          for(i in 1:nrow(selectedColRows)){
            # check that all relevant columns (selected by 1/0 in the database) has a value > 0 for a given row. If at least one has a value <= 0, then this row == 0 for all columns.
            if(any(selectedColRows[i,] <= 0)){
              selectedColRows[i,] <- 0
            }
          }
          # set PREC.* to 0 if all rows for the 1. columns has values <= 0. (The remaining columns are not neccesary to check, since checks and modifications of all columns for each row have been made).
          if(all(selectedColRows[,1] <= "0")){
            mergedDataSet[mergedDataSet[,dataColnames$NAME] == className, colnames(PREC_tmp)[k]] <- 0
          }
        }



        # set PREC.* to 0 if all rows for at least 1 columns has values <= 0
        #        for(i in 1:(length(selectedColNames))){



        #print((selectedColRows[,i]))

        #          if(nrow(selectedColRows) > 0){ # only check condition on column-row values if selectedColRows actually contains rows
        #            if(all(selectedColRows[,i] <= "0")){
        #              mergedDataSet[mergedDataSet$NAME == className, colnames(PREC_tmp)[k]] <- 0
        #              break
        #            }
        #
        #
        #          }
        #        }
      }
    }

    #  #### set PREC* to 0, if at least one of the selected columns has the value = 0. (THIS PART IS SLOW AND MIGHT BE OPTIMIZED IN THE FUTURE)
    #  # OPTIMIZATION: LOOK FOR EACH CLASS (WITHOUT NUMBERS) IN THE DATABASE, SINCE THEY ALWAYS HAVE THE SAME COMBINATION OF 1/0'S.
    #
    #  # find all class names (without number) in database (NEW: )
    #  #classNames <- unique(gsub("^(\\w+.)[[:space:]].*", "\\1",database[,"NAME"])) # ADAPT TO userSpecifiedColnames
    #
    #
    #  for(i in 1:length(database$NAME)){
    #  #for(i in 1:length(classNames)){
    #    # select relevant columns (based on the 1/0's in the database)
    #
    #
    #
    #    col_index <- (database[i, FRAG_FA_NLS_database] == 1)
    #    #col_index <- (database[grep(paste0("^",classNames[i]," *"), database$NAME),FRAG_FA_NLS_database][1,] == 1)
    #
    #    selectedColNames <- FRAG_FA_NLS_database[col_index]
    #
    #    # use selectedColNames to select all relevant columns for each sample in mergedDataSet
    #    for(k in 1:(ncol(PREC_tmp))){
    #
    #      if(length(selectedColNames) > 0){ # avoid error by ensuring that there exists some selected columns.
    #
    #        selectedColAndRow <- subset(mergedDataSet, NAME == database[i,"NAME"], select = paste0(selectedColNames, "_0",k))
    #        #selectedColAndRow <- mergedDataSet[grep(paste0("^",classNames[i]," *"), database$NAME), paste0(selectedColNames, "_0",k)]
    #
    #
    #        if(nrow(selectedColAndRow) > 0){ # avoid error by ensuring that the selected cols. and rows contain values.
    #        #if(nrow(selectedColAndRow) > 0 || length(selectedColAndRow) > 0){ # avoid error by ensuring that the selected cols. and rows contain values.
    #            if(any(selectedColAndRow == "0.0") || any(selectedColAndRow == "0") || any(selectedColAndRow == "none") || any(selectedColAndRow == " none") || any(selectedColAndRow == "None") || any(selectedColAndRow == " None") || any(selectedColAndRow == "Keine") || any(is.na(selectedColAndRow))){
    #
    #            mergedDataSet[mergedDataSet$NAME == database[i,"NAME"], colnames(PREC_tmp)[k]] <- 0
    #
    #          }
    #        }
    #      }
    #    }
  }

  return(mergedDataSet)
}



