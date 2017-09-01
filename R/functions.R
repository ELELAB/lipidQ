# ref for tryCatch: https://stackoverflow.com/questions/12193779/how-to-write-trycatch-in-r

################################################################################################################
# Auxiliary functions
################################################################################################################
readFile <- function(dataPath){
  #
  # Auxiliary function that reads a data set by using the destination stored in the dataPath parameter.
  #
  data <- read.table(file=paste0(dataPath), sep=",",header = TRUE, as.is = TRUE, fill = TRUE, row.names = NULL)
  return(data)
}


rmSpaceInBeginning <- function(data){
  #
  # Auxiliary function that removes the first letter in NAME and SPECIE, if the word begins with at [SPACE]
  #


  # for each row, check if either the NAME or SPECIE column begins with a [SPACE] and remove this [SPACE] if true.
  data[,"NAME"] <- ifelse(substring(data$NAME,1,1) == " ", substring(data$NAME, 2), data$NAME)
  data[, "SPECIE"] <- ifelse(substring(data$SPECIE,1,1) == " ", substring(data$SPECIE, 2), data$SPECIE)


  return(data)
}





################################################################################################################
# Merge Files
################################################################################################################
mergeDataSets<-function(dataList, database, userSpecifiedColnames = NULL, multiply = NULL, list = NULL){
  #
  # this function merges multiple data sets together. The data sets are listed in
  # the dataList parameter.
  #

  #### set colnames for data:
  # if user has specified colnames (userSpecifiedColnames)
  if(!is.null(userSpecifiedColnames)){
    ERROR <- userSpecifiedColnames$ERROR[1]
    CLASS <- userSpecifiedColnames$CLASS[1]
    LENGTH <- userSpecifiedColnames$LENGTH[1]
    DB <- userSpecifiedColnames$DB[1]
    NAME <- userSpecifiedColnames$NAME[1]
    SPECIE <- userSpecifiedColnames$SPECIE[1]
    MASS <- userSpecifiedColnames$MASS[1]
    OH <- userSpecifiedColnames$OH[1]
    isLP <- userSpecifiedColnames$isLP[1]
    PRECx <- userSpecifiedColnames$PRECx[1]
    FRAGx <- userSpecifiedColnames$FRAGx[1]
    #FAxINTES <-
    NLS <- userSpecifiedColnames$NLS[1]
    FA0INTENS <- userSpecifiedColnames$FAOINTENS[1]
    QUAN_MODE <- userSpecifiedColnames$QUAN_MODE[1]
    QUAN <- userSpecifiedColnames$QUAN[1]
    DECONVULOTION_MODE <- userSpecifiedColnames$DECONVULOTION_MODE[1]
    DECONVULOTION_FRAGx <- userSpecifiedColnames$DECONVULOTION_FRAGx[1]
    DECONVULOTION_FAx <- userSpecifiedColnames$DECONVULOTION_FAx[1]
    MASSNLS <- userSpecifiedColnames$MASSNLS[1]
    MASSFA <- userSpecifiedColnames$MASSFA[1]
    MASSFRAG <- userSpecifiedColnames$MASSFRAG[1]
    MODE <- userSpecifiedColnames$MODE[1]
  }
  # Default colnames
  else{
    ERROR <- "ERROR"
    CLASS <- "CLASS"
    LENGTH <- "LENGTH"
    DB <- "DB"
    NAME <- "NAME"
    SPECIE <- "SPECIE"
    MASS <- "MASS"
    OH <- "OH"
    isLP <- "isLP"
    PRECx <- "PREC"
    FRAGx <- "FRAG"
    #FAxINTES <- "FAxINTENS"
    NLS <- "NLS"
    FA0INTENS <- "FAOINTENS"
    QUAN_MODE <- "QUAN_MODE"
    QUAN <- "QUAN"
    DECONVULOTION_MODE <- "DECONVULOTION_MODE"
    DECONVULOTION_FRAGx <- "DECONVULOTION_FRAG"
    DECONVULOTION_FAx <- "DECONVULOTION_FA"
    MASSNLS <- "MASSNLS"
    MASSFA <- "MASSFA"
    MASSFRAG <- "MASSFRAG"
    MODE <- "MODE"
  }


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
  FRAG_cols <- uniqueCols[grep(FRAGx,uniqueCols)]


  # take all *NLS* columns
  #NLS_cols <- uniqueCols[grep("NLS",uniqueCols)]
  NLS_cols <- uniqueCols[grep(NLS,uniqueCols)]



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
        subset(data, select = c(ERROR, CLASS, LENGTH, DB, NAME, SPECIE, MASS)) # return statement
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
    #if("OH" %in% colnames(data)){
    if(OH %in% colnames(data)){
      selectedCols$OH <- data$OH
    }else{
      selectedCols$OH <- NA
    }



    # change long PREC* name to PREC_xx, where xx is a number
    PREC_tmp <- data[,c(colnames(data)[grep(paste0("^",PRECx),colnames(data))])]
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
    selectedCols <- selectedCols[selectedCols$NAME != "",]



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
      mergedDataSet[,PREC] <- ifelse(mergedDataSet[,"NAME"] %in% list, mergedDataSet[,PREC]*multiply, mergedDataSet[,PREC])
    }
  }



  # select columns from database
  FRAG_database <- colnames(database)[grep("^FRAG",colnames(database))]
  FA_database <- colnames(database)[grep("^FA",colnames(database))]
  NLS_database <- colnames(database)[grep("^NLS",colnames(database))]
  FRAG_FA_NLS_database <- c(FRAG_database, FA_database, NLS_database)




  #### Filtering based on 1/0 columns in database

  # find all class names in database
  classNames <- unique(database[,"NAME"])

  # for each class in database, chose all species in mergedData
  for(className in classNames){
    #print(className)
    # select relevant columns (based on the 1/0's in the database)
    col_index <- (database[database$NAME == className, FRAG_FA_NLS_database] == 1)[1,] # the [1,] ensures that only the first row of columns is chosen (if there are multiple rows with the same className in the NAME column)

    selectedColNames <- FRAG_FA_NLS_database[col_index]


    if(length(selectedColNames) > 0){ # avoid error by ensuring that there exists some selected columns.

      # use selectedColNames to select all relevant columns for each sample in mergedDataSet
      for(k in 1:(ncol(PREC_tmp))){

        if(k <= 9){
          selectedColRows <- subset(mergedDataSet, NAME == className, select = paste0(selectedColNames, "_0",k))
        }else{
          selectedColRows <- subset(mergedDataSet, NAME == className, select = paste0(selectedColNames, "_",k))
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
            mergedDataSet[mergedDataSet$NAME == className, colnames(PREC_tmp)[k]] <- 0
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
#  #classNames <- unique(gsub("^(\\w+.)[[:space:]].*", "\\1",database[,"NAME"]))
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


sort_is<-function(data){
  #
  # This function moves all internal standards (is) in a given data set so that they appear after all
  # normal species.
  #


  # save all is-rows
  isTmp <- data[grep("^is",data$NAME),]

  # remove all is-rows from data
  data <- data[-grep("^is",data$NAME),]

  # rbind all saved is-rows at the buttom of data
  data <- rbind(data,isTmp)

  return(data)
}




################################################################################################################
# ID & Filtrations
################################################################################################################
filterDataSet<-function(data, database){
  #
  # This function selects relevants columns from a data set remove species if the name does not exit
  # in the global ref. list.
  #


  # if a row in the NAME or SPECIE column in the database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database)


  #### select relevant columns
  data_tmp <- subset(data, select = c("NAME","ERROR", "MASS","SPECIE","MODE"))
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



################################################################################################################
# pmol & Clean Up
################################################################################################################
pmolCalc <- function(data, database, spikeVariable, zeroThresh){
  #
  # This function calculates pico mol (pmol) of species based on intensity from measurements
  # (target specie + internal standard) and known quantity of internal standard
  #

  #### if a row in the NAME or SPECIE column in database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database)


#  # find all unique elements in the QUAN column
#  QUAN_elements <- unique(data$QUAN)
#  print(QUAN_elements)
#  # GENERALIZÉR
#  for(element in QUAN_elements){
#    # define PREC columns and BLNK column (last PREC column)
#    element_Colnames <- colnames(data)[grep(element,colnames(data))] # names of all element.* columns
#    BLNK <- element_Colnames[length(element_Colnames)] # name of BLNK column (last element.* column)
#    element_Colnames <- element_Colnames[-length(element_Colnames)] # remove last column from element_Colnames since this is BLNK
#    print(element_Colnames)
#
#    #### zero adapter: check value >= 0. if not, value <- 0.
#    for(elementCol in element_Colnames){ # for each element column
#      data[,elementCol] <- ifelse(data[,elementCol] < 0, 0, data[,elementCol])
#    }
#    # for BLNK column (equal to last PREC column)
#    data[,BLNK] <- ifelse(data[,BLNK] < 0, 0, data[,BLNK])
#  }


  # define PREC columns and BLNK column (last PREC column)
  PREC_names <- colnames(data)[grep("PREC",colnames(data))] # names of all PREC.* columns
  BLNK <- PREC_names[length(PREC_names)] # name of BLNK column (last PREC.* column)
  PREC_names <- PREC_names[-length(PREC_names)] # remove last column from PREC_names since this is BLNK

  #### zero adapter: check value >= 0. if not, value <- 0.
  for(PREC in PREC_names){ # for PREC columns
    data[,PREC] <- ifelse(data[,PREC] < 0, 0, data[,PREC])
  }
  # for BLNK column (equal to last PREC column)
  data[,BLNK] <- ifelse(data[,BLNK] < 0, 0, data[,BLNK])




  # split data set into exData (all experimental classes) and isData (all internal classes)
  exData <- data[-grep("^is",data$NAME),]
  isData <- data[grep("^is",data$NAME),]

  # find all class names (without number) in exData
  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",exData[,"NAME"])

  #### pmol calculation ( PREC*(NAME)/PREC*(isNAME)   x   pmol(isSpecie) )
  for(PREC in PREC_names){

    for(i in 1:nrow(exData)){
      # find corresponding internal standard for the current class name.
      is <- isData[grep(paste0("is",classNames[i]," "),isData$NAME),]


      # pmol_isSpecie = spikeVariabel(uL) x [isLP]
      pmol_isSpecie <- spikeVariable * subset(database, NAME == is[,"NAME"])$isLP

      # pmol calculation ( PREC*(NAME)/PREC*(isNAME) x pmol(isSpecie) )
      #pmol_calc <- exData[i,PREC] / is[,PREC] * pmol_isSpecie
      pmol_calc <- tryCatch(
        {
          exData[i,PREC] / is[,PREC] * pmol_isSpecie # return statement
        },
        error=function(cond){
          message("ERROR: PROBLEMS WITH VALUES IN INTENSITY COLUMNS! Please check that all intensity columns only contain numbers and not text-based values like NA, Inf etc.")
          message("")
          message("")
          message("")
          message("Original R error message:")
          message(cond)
        })

      data[i,paste0("PMOL_",PREC)] <- pmol_calc
    }
  }



  #### pmol BLNK calculation ( BLNK(NAME)/BLNK(isNAME)   x   pmol(isSpecie) )
  for(i in 1:nrow(exData)){
    # find corresponding internal standard.
    is <- isData[grep(paste0("is",classNames[i]," "),isData$NAME),]

    # pmol_isSpecie <- spikeVariabel(uL) x [isLP]
    pmol_isSpecie <- spikeVariable * subset(database, NAME == is[,"NAME"])$isLP

    # pmol calculation ( PREC:*(NAME)/PREC:*(isNAME) x pmol(isSpecie) )
    pmol_calc <- exData[i,BLNK] / is[,BLNK] * pmol_isSpecie
    data[i,paste0("PMOL_BLNK_",BLNK)] <- pmol_calc
  }

  #### subtract pmol BLNK from pmol PREC*
  PMOL_PREC_names <- colnames(data)[grep("^PMOL_PREC",colnames(data))]
  PMOL_BLNK <- colnames(data)[grep("^PMOL_BLNK",colnames(data))]

  for(PMOL_PREC in PMOL_PREC_names){
    data[,paste0("SUBT_",PMOL_PREC)] <- data[,PMOL_PREC] - data[,PMOL_BLNK]
  }


  #### zero adapter: check value >= 0. if not, value <- 0.
  SUBT_PMOL_PREC_names <- colnames(data)[grep("^SUBT_PMOL_PREC",colnames(data))]
  for(SUBT_PMOL_PREC in SUBT_PMOL_PREC_names){ # for PREC's
    data[,SUBT_PMOL_PREC] <- ifelse(data[,SUBT_PMOL_PREC] < 0, 0, data[,SUBT_PMOL_PREC])
  }



  # remove a given row if all PREC* (except last BLNK PREC) values contains zeros.
  data <- data[apply(data[PREC_names],1,function(value) any(value != 0)),]
  # update exData and isData with the newly created columns, and removed rows
  exData <- data[-grep("is",data$NAME),]
  isData <- data[grep("is",data$NAME),]





  #### mol% specie calucated from PREC* values after BLNK subtraction
  for(SUBT_PMOL_PREC in SUBT_PMOL_PREC_names){

    # calculate mol% species for each specie
    sumSpecies <- sum(data[1:nrow(exData),SUBT_PMOL_PREC],na.rm = TRUE)
    data[1:nrow(exData),paste0("MOL_PCT_SPECIES_",SUBT_PMOL_PREC)] <- 100/sumSpecies*exData[1:nrow(exData),SUBT_PMOL_PREC]

  }


  #### zero adapter: check value >= zeroThresh. if not, value <- 0.
  MOL_PCT_SPECIES_SUBT_PMOL_PREC_names <- colnames(data)[grep("^MOL_PCT_SPECIES_SUBT_PMOL_PREC_",colnames(data))]

  # set all values that are under an user defined threshold (zeroThresh) to 0 for mol% species in exData.
  for(MOL_PCT_SPECIES_SUBT_PMOL_PREC in MOL_PCT_SPECIES_SUBT_PMOL_PREC_names){ # for PREC columns

    data[1:nrow(exData),MOL_PCT_SPECIES_SUBT_PMOL_PREC] <- ifelse(data[1:nrow(exData),MOL_PCT_SPECIES_SUBT_PMOL_PREC] < zeroThresh, 0, data[1:nrow(exData),MOL_PCT_SPECIES_SUBT_PMOL_PREC])
  }



  # re-calculation of the mol% specie after removal of rows below an user defined threshold (zeroThresh)
  for(MOL_PCT_SPECIES_SUBT_PMOL_PREC_re in MOL_PCT_SPECIES_SUBT_PMOL_PREC_names){
    sumSpecies<-sum(data[1:nrow(exData),MOL_PCT_SPECIES_SUBT_PMOL_PREC_re], na.rm = TRUE)
    data[1:nrow(exData),paste0("FILTERED_",MOL_PCT_SPECIES_SUBT_PMOL_PREC_re)] <- 100/sumSpecies*data[1:nrow(exData),MOL_PCT_SPECIES_SUBT_PMOL_PREC_re]
  }


  #### sum pmol values for each classes in each PREC* after BLNK subtraction
  # find all unique class names (without numbers)
  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",data[1:nrow(exData),"NAME"])
  classNames <-unique(classNames)


  sumClassValueList <- matrix(numeric(), nrow = length(classNames), ncol = length(SUBT_PMOL_PREC_names)) # store all sumClassValue to be used later in mol% class calculation
  for(i in 1:length(classNames)){

    for(j in 1:length(SUBT_PMOL_PREC_names)){
      # sum values for each class
      sumClassValue <- sum(data[grep(paste0("^",classNames[i]," "),data$NAME),SUBT_PMOL_PREC_names[j]],na.rm = TRUE)
      sumClassValueList[i,j] <- sumClassValue

      # add sum value to all species with the same class
      data[grep(paste0("^",classNames[i]," "),data$NAME),paste0("CLASS_PMOL_",SUBT_PMOL_PREC_names[j])] <- sumClassValue
    }
  }


  #### mol% class (100/sum(sumClassValueList) * sumClassValue[j,i]) calculation
  # find sum of all class values for each SUBT_PMOL_PREC*
  for(j in 1:length(SUBT_PMOL_PREC_names)){
    totalSumClassValueList<-sum(sumClassValueList[,j],na.rm = TRUE)

    # calculate mol% class for each sumClassValueList col, which corresponds to each SUBT_PMOL_PREC
    for(i in 1:nrow(sumClassValueList)){
      mol_pct_class<-100/totalSumClassValueList * sumClassValueList[i,j]

      # insert mol% class calculation into the respective class in data
      data[grep(paste0("^",classNames[i]," "),data$NAME),paste0("MOL_PCT_CLASS_",SUBT_PMOL_PREC_names[j])]<-mol_pct_class

    }
  }


  return(data)

}


compactOutput_pmolCalc <- function(data){
  #
  # This function saves a data.frame with only NAME, CLASS_PMOL_SUBT_PMOL_PREC*, and MOL_PCT_CLASS_SUBT_PMOL_PREC*
  #

  # create the new data set with NAME
  classPmol_molPctClass <- subset(data, select = c(NAME))

  # remove numbers in the NAME column, so only the class name is used for NAME.
  for(i in 1:nrow(data)){
    classPmol_molPctClass$NAME[i] <- unlist(strsplit(classPmol_molPctClass$NAME[i], " "))[[1]]
  }

  # insert CLASS_PMOL_SUBT_PMOL_PREC*, and MOL_PCT_CLASS_SUBT_PMOL_PREC* columns
  classPmol_molPctClass <- cbind( classPmol_molPctClass, data[,c(colnames(data)[grep("^CLASS_PMOL_SUBT_PMOL_PREC",colnames(data))])] )
  classPmol_molPctClass <- cbind( classPmol_molPctClass, data[,c(colnames(data)[grep("^MOL_PCT_CLASS_SUBT_PMOL_PREC",colnames(data))])] )



  #### sum filtered values for each classes for each sample after BLNK subtraction
  # find all unique class names (without numbers)
  exData <- data[-grep("is",data$NAME),]

  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",data[1:nrow(exData),"NAME"])
  classNames <-unique(classNames)

  FILTERED_names <- colnames(data)[grep("^FILTERED",colnames(data))]

  sumClassValueList <- matrix(numeric(), nrow = length(classNames), ncol = length(FILTERED_names)) # store all sumClassValue to be used later in mol% class calculation
  for(i in 1:length(classNames)){

    for(j in 1:length(FILTERED_names)){
      # sum values for each class
      sumClassValue <- sum(data[grep(paste0("^",classNames[i]," "),data$NAME),FILTERED_names[j]],na.rm = TRUE)
      sumClassValueList[i,j] <- sumClassValue

      # add sum value to all species with the same class
      data[grep(paste0("^",classNames[i]," "),data$NAME),paste0("CLASS_",FILTERED_names[j])] <- sumClassValue
    }
  }



  classPmol_molPctClass <- cbind( classPmol_molPctClass, data[,c(colnames(data)[grep("^CLASS_FILTERED",colnames(data))])] )

  # remove duplicates of NAME
  classPmol_molPctClass <- classPmol_molPctClass[!duplicated(classPmol_molPctClass$NAME),]


  return(classPmol_molPctClass)

}


makeTableauOutput <- function(classPmol_molPctClass, pmolCalculatedDataSet){
  #
  # This function creates an output file of the results in a format that can be used by Tableau.
  #

  # take all lipid species (NAME col) from pmolCalculatedDataSet without using the is-rows and their respective
  lipidSpecies <- pmolCalculatedDataSet[,c(1,grep("^FILTERED*", colnames(pmolCalculatedDataSet)))]
  lipidSpecies <- lipidSpecies[-grep("^is",lipidSpecies$NAME),]

  # change colnames: NAME -> mol%, FILTERED* -> Sample_01
  sampleNames <- paste0("Sample_",1:(length(colnames(lipidSpecies))-1))
  colnames(lipidSpecies) <- c("mol%", sampleNames)




  # take NAME from classPmol_molPctClass without using the is-rows
  classes <- classPmol_molPctClass[,c(1,grep("^CLASS_FILTERED*", colnames(classPmol_molPctClass)))]
  classes <- classes[-grep("^is",classes$NAME),]

  # change colnames: NAME -> mol%, FILTERED* -> Sample_01
  sampleNames <- paste0("Sample_",1:(length(colnames(classes))-1))
  colnames(classes) <- c("mol%", sampleNames)




  # merge data sets together
  tableauOutput <- rbind(lipidSpecies, classes)


  # change classes/species with "O-": insert [SPACE] before "O-" and remove [SPACE] after "O-"
  namesWithOIndexes <- grep("O-",tableauOutput$"mol%")
  for(i in namesWithOIndexes){
    nameWithO <- tableauOutput$"mol%"[i]
    nameWithO <- strsplit(nameWithO," ")

    if(length(nameWithO[[1]]) == 2){ # used when name represents a specie (contains number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]),nameWithO[[1]][2])
    }else{ # used when name represents a class (without number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]))
    }
    tableauOutput$"mol%"[i] <- nameWithO
  }

  return(tableauOutput)
}




mergeTableauDataSets <- function(dataList){
  #
  # This function merges tableau output files into one data file
  #


  # Find all unique "mol." values for all data sets
  uniqueRows <- vector("list", length(dataList))
  for(i in 1:length(dataList)){
    data<-readFile(dataList[i])
    uniqueRows[[i]] <- data$"mol."
  }
  uniqueRows <- unique(unlist(uniqueRows))



  #mergedTableau <- data.frame()
  mergedTableau <- data.frame("mol." = uniqueRows)


  #firstRun <- TRUE
  for(i in 1:length(dataList)){
    data <- readFile(dataList[i])

    for(colIndex in 2:ncol(data)){

      mergedTableau$"newTmp" <- NA # create initial NA for new column to be merged

      colnames(mergedTableau)[ncol(mergedTableau)] <- colnames(data)[colIndex] # insert appropriate column name from data into new column in mergedTableau

      # match rows of incoming tableau data sets with existing merged data set to ensure correct placement of rows.
      mergedTableau[, ncol(mergedTableau)] <- data[match(mergedTableau$"mol.", data$"mol."), colIndex]
    }

  }


  # change 1st column name from "mol." to "mol%" due to conversion of "%" -> "." when reading data into R
  colnames(mergedTableau)[1] <- "mol%"

  return(mergedTableau)
}
#' Lipidomics Analysis Tool
#' @author André Vidas Olsen
#' @export
runLipidQuan <- function(){
  shiny::runApp("R/Main.R", launch.browser=TRUE)
}



#data$SPECIE.GLOBAL <- database$SPECIE[match(data$NAME, database$NAME)]


