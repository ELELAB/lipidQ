#' @title Merge Data Sets
#' @author André Vidas Olsen
#' @description This function merges multiple data sets together. The data sets
#' are listed in the dataList parameter.
#' @param dataList a list of paths referring to input data
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @param userSpecifiedColnames the column names template file containing user
#' specified column names for the input data.
#' is used to translate the user specified column names to the program, so that
#' it uses the correct columns for the different analysis procedures.
#' @param correctionList a file containing a list of sum compositions to be
#' multiplied for in the MS1 column values (intensity values)
#' @param multiply a parameter used to multiply intensity values in the MS1
#' column on selected sum compositions. The parameter is useful if lipidX is
#' used to obtain the intensity data derived from overlapping MS scan ranges.
#' The sum composition are selected by the user and should appear in a
#' correction list file that is used as argument for the correctionList
#' parameter.
#' @return a data set consisting of merged input data
#' @export
#' @examples
#' # make input data path list
#' dataPathList <- c(system.file("extdata/mE504_Data",
#'                   "mE504_NEG_High-out.csv", package = "lipidQuan"),
#'                  system.file("extdata/mE504_Data",
#'                   "mE504_NEG_Low-out.csv", package = "lipidQuan"),
#'                  system.file("extdata/mE504_Data",
#'                   "mE504_POS_High-out.csv", package = "lipidQuan"),
#'                  system.file("extdata/mE504_Data",
#'                   "mE504_NEG_Low-out.csv", package = "lipidQuan"))
#'
#' # load endo & ISTD databases as well as user specified column names file.
#' endogene_lipid_db <- read.table(system.file("extdata/LipidQ_DataBase",
#'  "LP_DB_MS1_v1.csv", package = "lipidQuan"), stringsAsFactors = FALSE,
#'  header = TRUE, sep = ",")
#'
#' ISTD_lipid_db <- read.table(system.file("extdata/LipidQ_DataBase",
#'  "ISTD_LP_DB_MS1_v1.csv", package = "lipidQuan"), stringsAsFactors = FALSE,
#'  header = TRUE, sep = ",")
#'
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase",
#'  "userSpecifiedColnames.csv", package = "lipidQuan"),
#'  stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # merge input data sets into one file
#' mergeDataSets(dataList = dataPathList, endogene_lipid_db = endogene_lipid_db,
#'  ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames =
#'  userSpecifiedColnames)
mergeDataSets <- function(dataList, endogene_lipid_db, ISTD_lipid_db,
          userSpecifiedColnames = NULL, correctionList = NULL, multiply = NULL){

  # merge endogene_lipid_db and ISTD_lipid_db together
  database <- merge_endo_and_ISTD_db(endogene_lipid_db, ISTD_lipid_db)


  # get colnames for data
  dataColnames <- checkColnames(userSpecifiedColnames)

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
    MS2ix_userCols <-
      append(MS2ix_userCols, uniqueCols[grep(userCol,uniqueCols)])
  }
  MS2ix_userCols <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",MS2ix_userCols)
  MS2ix_userCols <- unique(MS2ix_userCols)




  # select user specified columns of MS2ix columns from database
  MS2ix_userCols_database <- c()
  for(userCol in as.character(MS2ix_cols)){
    MS2ix_userCols_database <- append(MS2ix_userCols_database,
                          colnames(database)[grep(userCol,colnames(database))])
  }




  #### merge data sets together ####
  firstRun <- TRUE
  for(dataPath in dataList){

    # load data from dataList
    data <- readFile(dataPath)

    # if a row in the SUM_COMPOSITION or SPECIE_COMPOSITION_COMPOSITION column
    # starts with a [SPACE], remove this [SPACE]
    data <- rmSpaceInBeginning(data, userSpecifiedColnames)

    selectedCols <- tryCatch(
      {
        # return statement
        data[, c(dataColnames$PPM, dataColnames$CLASS, dataColnames$C_CHAIN,
                 dataColnames$DOUBLE_BOND, dataColnames$SUM_COMPOSITION,
                 dataColnames$SPECIE_COMPOSITION, dataColnames$MASS_TO_CHARGE)]

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






    # Insert values from OH col to selectedCols, if present in the data set or
    # set value to NA.
    if(dataColnames$OH_GROUP %in% colnames(data)){
      selectedCols[, dataColnames$OH_GROUP] <-
        data[,which(dataColnames$OH_GROUP == colnames(data))]
    }else{
      selectedCols[, dataColnames$OH_GROUP] <- NA
    }


    # change long MS1.* name to MS1_xx, where xx is a number
    MS1x_tmp <- data[,c(colnames(data)[grep(paste0("^",dataColnames$MS1x),
                colnames(data))])]
    colnames(MS1x_tmp) <-
                gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",colnames(MS1x_tmp))

    # insert new MS1_xx col names to selectedCols
    selectedCols <- cbind(selectedCols,MS1x_tmp)




    # insert mode column describing whether the measurements comes from
    # POS or NEG measurements
    if("POS" %in% colnames(data)){
      mode <- "POS"
    }else{
      if("NEG" %in% colnames(data)){
        mode <- "NEG"
      }else{
        stop("ERROR: POS/NEG column is missing in the input data files. Please make sure that every input data file has a column describing the quan mode (POS or NEG).")
      }
    }

    # insert mode column into selectedCols
    selectedCols$MODE <- mode



    # convert FA, FRAG and NLS col names in the input data (e.g. FAxxINTENS*
    # name to FAxxINTENS_xx, where xx is a number), so they can be compared with
    # the obtained colnames in FA_FRAG_NLS_cols.
    colnames(data) <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",colnames(data))

    # insert FA, FRAG and NLS columns into selectedCols. If they do not exist in
    # the given data set, the value = NA
    dataNames <- colnames(data)
    for(col in MS2ix_userCols){
      if(col %in% dataNames){
        selectedCols[,paste(col)] <- data[,paste(col)]
      }else{
        selectedCols[,paste(col)] <- NA
      }
    }


    # remove all rows where SUM_COMPOSITION == ""
    selectedCols <- selectedCols[
                    selectedCols[,dataColnames$SUM_COMPOSITION] != "",]


    # merge all data sets into one data set (mergedDataSet).
    if(firstRun == TRUE){ # only used on first run, since mergedDataSet is not
      # defined yet
      mergedDataSet <- selectedCols
      firstRun <- FALSE
    }else{ # used for all runs except first run.
      mergedDataSet <- rbind(mergedDataSet, selectedCols)
    }
  }


  # convert different zero-symbols (e.g. " none" and NA) to the same symbol
  # ("0").
  mergedDataSet[mergedDataSet == "0.0" | mergedDataSet == "none" |
    mergedDataSet == " none" | mergedDataSet == "None" |
    mergedDataSet == " None" | mergedDataSet == "Keine" |
    is.na(mergedDataSet)] <- "0"


  # multiply MS1x values if multiply is set to a value
  if(!is.null(multiply) && !is.null(correctionList)){
    for(MS1x in colnames(MS1x_tmp)){
      mergedDataSet[,MS1x] <-
        ifelse(mergedDataSet[,dataColnames$SUM_COMPOSITION] %in% correctionList,
        mergedDataSet[,MS1x]*multiply, mergedDataSet[,MS1x])

    }
  }


  #### Test whether all MS1x and MS2x > 0 for all internal standards

  # merge MS1x and MS2x cols together
  MS1x_MS2x_cols <- c(colnames(MS1x_tmp), MS2ix_userCols)

  # select rows with internal standards
  isData <-
    mergedDataSet[grep("^is",mergedDataSet[,dataColnames$SUM_COMPOSITION]),]
  # remove all columns except from MS1x_MS2x_cols and SUM_COMPOSITION
  isData <- isData[, c(dataColnames$SUM_COMPOSITION,MS1x_MS2x_cols)]



  # remove any non-MS1x and MS2ix columns (MASS columns) except
  # from SUM_COMPOSITION, which is used for matching isData with ISTD_lipid_db
  isData <- isData[,
        grep(paste0("^", dataColnames$SUM_COMPOSITION ,"|_"),colnames(isData))]


  # match isData with ISTD_lipid_db
  ISTD_matched_w_isData <- ISTD_lipid_db[match(
    isData[,dataColnames$SUM_COMPOSITION],
    ISTD_lipid_db[, dataColnames$SUM_COMPOSITION]),]

  # remove all columns except MS1x and MS2ix
  ISTD_matched_w_isData <-
    ISTD_matched_w_isData[, as.character(dataColnames[,
    grep("^MS1|^MS2", colnames(dataColnames))])]


  for(col in colnames(ISTD_matched_w_isData)){
    tmp_col <- ISTD_matched_w_isData[, grep(paste0("^",col),
                                            colnames(ISTD_matched_w_isData))]
    if(sum(tmp_col) != 0){
      if(!all(isData[tmp_col, grep(paste0("^", col), colnames(isData))] != 0)){
        stop(paste0("ERROR: One or more internal standards in the ", col ," column contains 0 in MS1/MS2 column(s). Please ensure that this column contains the right 1/0 status for each internal standard in the ISTD lipid database."))
      }
    }
  }


  return(mergedDataSet)
}



