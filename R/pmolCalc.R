#' @title Pico mol Calculation
#' @author André Vidas Olsen
#' @description This function calculates pico mol (pmol) of species based on intensity from measurements (target specie + internal standard) and known quantity of internal standard
#' @export
pmolCalc <- function(data, database, userSpecifiedColnames = NULL, spikeVariable, zeroThresh){


  #### if a row in the NAME or SPECIE column in database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database)


  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)


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


  # define MS1x columns and BLNK column (last MS1x column)
  MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
  BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.* column)
  MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from PREC_names since this is BLNK

  #### zero adapter: check value >= 0. if not, value <- 0.
  for(MS1x in MS1x_names){ # for PREC columns
    data[,MS1x] <- ifelse(data[,MS1x] < 0, 0, data[,MS1x])
  }
  # for BLNK column (equal to last PREC column)
  data[,BLNK] <- ifelse(data[,BLNK] < 0, 0, data[,BLNK])




  # split data set into exData (all experimental classes) and isData (all internal classes)
  exData <- data[-grep("^is",data[,dataColnames$NAME]),]
  isData <- data[grep("^is",data[,dataColnames$NAME]),]

  # find all class names (without number) in exData
  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",exData[,dataColnames$NAME])

  #### pmol calculation ( MS1x*(NAME)/MS1x*(isNAME)   x   pmol(isSpecie) )
  for(MS1x in MS1x_names){

    for(i in 1:nrow(exData)){
      # find corresponding internal standard for the current class name.
      is <- isData[grep(paste0("is",classNames[i]," "),isData[,dataColnames$NAME]),]


      # pmol_isSpecie = spikeVariabel(uL) x [isLP]
      pmol_isSpecie <- spikeVariable * subset(database, NAME == is[,dataColnames$NAME])$isLP

      # pmol calculation ( MS1x*(NAME)/MS1x*(isNAME) x pmol(isSpecie) )
      #pmol_calc <- exData[i,MS1x] / is[,MS1x] * pmol_isSpecie
      pmol_calc <- tryCatch(
        {
          exData[i,MS1x] / is[,MS1x] * pmol_isSpecie # return statement
        },
        error=function(cond){
          message("ERROR: PROBLEMS WITH VALUES IN INTENSITY COLUMNS! Please check that all intensity columns only contain numbers and not text-based values like NA, Inf etc.")
          message("")
          message("")
          message("")
          message("Original R error message:")
          message(cond)
        })

      data[i,paste0("PMOL_",MS1x)] <- pmol_calc
    }
  }



  #### pmol BLNK calculation ( BLNK(NAME)/BLNK(isNAME)   x   pmol(isSpecie) )
  for(i in 1:nrow(exData)){
    # find corresponding internal standard.
    is <- isData[grep(paste0("is",classNames[i]," "),isData[,dataColnames$NAME]),]

    # pmol_isSpecie <- spikeVariabel(uL) x [isLP]
    pmol_isSpecie <- spikeVariable * subset(database, NAME == is[,dataColnames$NAME])$isLP

    # pmol calculation ( MS1x:*(NAME)/MS1x:*(isNAME) x pmol(isSpecie) )
    pmol_calc <- exData[i,BLNK] / is[,BLNK] * pmol_isSpecie
    data[i,paste0("PMOL_BLNK_",BLNK)] <- pmol_calc
  }

  #### subtract pmol BLNK from pmol MS1x*
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
  data <- data[apply(data[MS1x_names],1,function(value) any(value != 0)),]
  # update exData and isData with the newly created columns, and removed rows
  exData <- data[-grep("is",data[,dataColnames$NAME]),]
  isData <- data[grep("is",data[,dataColnames$NAME]),]





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
  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",data[1:nrow(exData),dataColnames$NAME])
  classNames <-unique(classNames)


  sumClassValueList <- matrix(numeric(), nrow = length(classNames), ncol = length(SUBT_PMOL_PREC_names)) # store all sumClassValue to be used later in mol% class calculation
  for(i in 1:length(classNames)){

    for(j in 1:length(SUBT_PMOL_PREC_names)){
      # sum values for each class
      sumClassValue <- sum(data[grep(paste0("^",classNames[i]," "),data[,dataColnames$NAME]),SUBT_PMOL_PREC_names[j]],na.rm = TRUE)
      sumClassValueList[i,j] <- sumClassValue

      # add sum value to all species with the same class
      data[grep(paste0("^",classNames[i]," "),data[,dataColnames$NAME]),paste0("CLASS_PMOL_",SUBT_PMOL_PREC_names[j])] <- sumClassValue
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
      data[grep(paste0("^",classNames[i]," "),data[,dataColnames$NAME]),paste0("MOL_PCT_CLASS_",SUBT_PMOL_PREC_names[j])]<-mol_pct_class

    }
  }


  return(data)

}
