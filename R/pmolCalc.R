#' @title picomol Calculation
#' @author André Vidas Olsen
#' @description This function calculates pico mol (pmol) of species based on intensity from measurements (target specie + internal standard) and known quantity of internal standard
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @param spikeISTD internal standard spike amount in uL
#' @param zeroThresh an optional threshold that determines if a given small value in mol pct. specie composition columns should be rounded down to zero.
#' @param LOQ logical parameter to indicate whether or not limit of quantification (LOQ) threshold is activated.
#' @param fixedDeviation the amount in percentages (-100 - 100) that values has to be above the LOQ threshold
#' @param numberOfReplicates the number of replicates for each sample
#' @param blnkReplicates logical parameter for specifying whether the blank sample contains replicates or not. FALSE: no replicates, TRUE: replicates.
#' @param numberOfInstancesThreshold the number of replicates for a given sample that has to have values above the specified threshold value (thesholdValue)
#' @param thresholdValue user specified threshold value based on technical noise and/or other variation sources. This paramter will determine the threshold in which a replicate will be considered as having an observed value or not.
#' @export
pmolCalc <- function(data, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = NULL, spikeISTD, zeroThresh, LOQ = FALSE, fixedDeviation = 0, numberOfReplicates = 1, blnkReplicates = FALSE, numberOfInstancesThreshold, thresholdValue){

  # merge endogene_lipid_db and ISTD_lipid_db together
  database <- merge_endo_and_ISTD_db(endogene_lipid_db, ISTD_lipid_db)


  #### if a row in the SUM_COMPOSITION or SPECIE_COMPOSITION column in database starts with a [SPACE], remove this row
  database <- rmSpaceInBeginning(database, userSpecifiedColnames)


  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)



  #### define MS1x columns and BLNK column (last MS1x column)

  # single blnk
  if(blnkReplicates == FALSE){

    MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
    BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.* column)
    MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from MS1x_names since this is BLNK
  }
  # blnk replicates
  else{
    MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
    BLNK <- MS1x_names[(length(MS1x_names)-numberOfReplicates+1):length(MS1x_names)] # name of BLNK column (last MS1x.* column)
    MS1x_names <- MS1x_names[-((length(MS1x_names)-numberOfReplicates+1):length(MS1x_names))] # remove last column from MS1x_names since this is BLNK
  }


  #### zero adapter for MS1x: check value >= 0. if not, value <- 0.
  for(MS1x in MS1x_names){ # for MS1x columns
    data[,MS1x] <- ifelse(data[,MS1x] < 0, 0, data[,MS1x])
  }
  # single blnk
  if(blnkReplicates == FALSE){
    data[,BLNK] <- ifelse(data[,BLNK] < 0, 0, data[,BLNK])
  }
  # blnk replicates
  else{
    for(blnk_rep in BLNK){
      data[,blnk_rep] <- ifelse(data[,blnk_rep] < 0, 0, data[,blnk_rep])
    }
  }


  # define MS2x user specified columns
  MS2ix_cols <- dataColnames[grep("MS2",colnames(dataColnames))]

  MS2ix_userCols <- c()
  for(userCol in as.character(MS2ix_cols)){
    MS2ix_userCols <- append(MS2ix_userCols, c(colnames(data)[grep(userCol,colnames(data))]))
  }
  MS2ix_userCols <- unique(MS2ix_userCols)



  #### zero adapter for MS2ix: check value >= 0. if not, value <- 0.
  for(MS2ix in MS2ix_userCols){ # for MS1x columns
    data[,MS2ix] <- ifelse(data[,MS2ix] < 0, 0, data[,MS2ix])
  }



  # split data set into exData (all experimental classes) and isData (all internal classes)
  exData <- data[-grep("^is",data[,dataColnames$SUM_COMPOSITION]),]
  isData <- data[grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

  # find all class names (without number) in exData
  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",exData[,dataColnames$SUM_COMPOSITION])

  #### pmol calculation ( MS1x*(SUM_COMPOSITION)/MS1x*(isSUM_COMPOSITION)   x   pmol(isSpecie) )
  for(MS1x in MS1x_names){




    for(i in 1:nrow(exData)){
      # find and replace the MS1x part with the QUAN_SCAN character (e.g. MS1x = PREC_01, QUAN_SCAN = FRAG1: PREC_01 -> FRAG1_01)
      MS1x <- gsub(unlist(strsplit(MS1x, "_"))[1], exData[i, "QUAN_SCAN"], MS1x)


      # find corresponding internal standard for the current class name.
      is <- isData[grep(paste0("is",classNames[i]," "),isData[,dataColnames$SUM_COMPOSITION]),]

      # pmol_isSpecie = spikeISTD(uL) x ISTD_CONC
      pmol_isSpecie <- spikeISTD * database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "ISTD_CONC"]
      if(length(pmol_isSpecie) > 1){
        stop("ERROR: Check that no duplicates of lipids/ISTD's exists in both the endogene and ISTD database.")
      }

      # pmol calculation ( MS1x*(SUM_COMPOSITION)/MS1x*(isSUM_COMPOSITION) x pmol(isSpecie) )
      pmol_calc <- tryCatch(
        {
          as.numeric(exData[i,MS1x]) / as.numeric(is[,MS1x]) * as.numeric(pmol_isSpecie) # return statement
        },
        error=function(cond){
          message("ERROR: PROBLEMS WITH VALUES IN INTENSITY COLUMNS! Please check that all intensity columns only contain numbers and not text-based values like NA, Inf etc.")
          message("")
          message("")
          message("")
          message("Original R error message:")
          message(cond)
        })
      # TO BE CONTINUED ... exData?? when does it merge exData + isData into data?
      data[i,paste0("PMOL_SAMPLE_",unlist(strsplit(MS1x, "_"))[2])] <- pmol_calc
    }
  }





  #### pmol BLNK calculation ( BLNK(SUM_COMPOSITION)/BLNK(isSUM_COMPOSITION)   x   pmol(isSpecie) ) (AT THE MOMENT FOR SINGLE BLNK)

  # single blnk
  if(blnkReplicates == FALSE){
    for(i in 1:nrow(exData)){
      # find and replace the MS1x part with the QUAN_SCAN character (e.g. MS1x = PREC_01, QUAN_SCAN = FRAG1: PREC_01 -> FRAG1_01)
      BLNK <- gsub(unlist(strsplit(BLNK, "_"))[1], exData[i, "QUAN_SCAN"], BLNK)

      # find corresponding internal standard.
      is <- isData[grep(paste0("is",classNames[i]," "),isData[,dataColnames$SUM_COMPOSITION]),]

      # pmol_isSpecie <- spikeISTD(uL) x [ISTD_CONC]
      pmol_isSpecie <- spikeISTD * database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "ISTD_CONC"]

      # pmol calculation ( MS1x:*(SUM_COMPOSITION)/MS1x:*(isSUM_COMPOSITION) x pmol(isSpecie) )
      pmol_calc <- as.numeric(exData[i,BLNK]) / as.numeric(is[,BLNK]) * as.numeric(pmol_isSpecie)

      data[i,paste0("PMOL_BLNK_",unlist(strsplit(BLNK, "_"))[2])] <- pmol_calc
    }
  }
  #IMPLEMENT_REP
  # blnk replicates
  else{
    for(i in 1:nrow(exData)){


      # find corresponding internal standard.
      is <- isData[grep(paste0("is",classNames[i]," "),isData[,dataColnames$SUM_COMPOSITION]),]

      # pmol_isSpecie <- spikeISTD(uL) x [ISTD_CONC]
      pmol_isSpecie <- spikeISTD * database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "ISTD_CONC"]

      # pmol calculation ( MS1x:*(SUM_COMPOSITION)/MS1x:*(isSUM_COMPOSITION) x pmol(isSpecie) )
      for(blnk_rep in BLNK){

        # find and replace the MS1x part with the QUAN_SCAN character (e.g. MS1x = PREC_01, QUAN_SCAN = FRAG1: PREC_01 -> FRAG1_01)
        blnk_rep <- gsub(unlist(strsplit(blnk_rep, "_"))[1], exData[i, "QUAN_SCAN"], blnk_rep)

        pmol_calc <- as.numeric(exData[i,blnk_rep]) / as.numeric(is[,blnk_rep]) * as.numeric(pmol_isSpecie)
        data[i,paste0("PMOL_BLNK_",unlist(strsplit(blnk_rep, "_"))[2])] <- pmol_calc
      }
    }
  }


  # TO BE CONTINUED ... LAV BLNK REPLICATE IMPLEMENT FAERDIG. # TJEK ALLE #IMPLEMENT_REP. SE OGSAA FILTERREPLICATES IGENNEM.
  # replicate filtering on BLNK
  if(blnkReplicates){
    data[1:nrow(exData),paste0("PMOL_BLNK_",unlist(strsplit(blnk_rep, "_"))[2])] <- filterReplicates(data = data[1:nrow(exData),paste0("PMOL_BLNK_",unlist(strsplit(blnk_rep, "_"))[2])], userSpecifiedColnames = userSpecifiedColnames, numberOfReplicates = numberOfReplicates, numberOfInstancesThreshold = numberOfInstancesThreshold, thresholdValue = thresholdValue)
  }


  #### subtract pmol BLNK from pmol MS1x*
  PMOL_MS1x_names <- colnames(data)[grep("^PMOL_SAMPLE",colnames(data))]
  PMOL_BLNK <- colnames(data)[grep("^PMOL_BLNK",colnames(data))]


  # single blnk
  if(blnkReplicates == FALSE){
    for(PMOL_MS1x in PMOL_MS1x_names){
      data[,paste0("SUBT_",PMOL_MS1x)] <- data[,PMOL_MS1x] - data[,PMOL_BLNK]
    }
  }
  # blnk replicates
  else{
    PMOL_BLNK_max <- apply(data[,PMOL_BLNK], 1, FUN=max)
    for(PMOL_MS1x in PMOL_MS1x_names){
      data[,paste0("SUBT_",PMOL_MS1x)] <- data[,PMOL_MS1x] - PMOL_BLNK_max
    }
  }



  #### zero adapter: check value >= 0. if not, value <- 0.
  SUBT_PMOL_MS1x_names <- colnames(data)[grep("^SUBT_PMOL_SAMPLE",colnames(data))]
  for(SUBT_PMOL_MS1x in SUBT_PMOL_MS1x_names){ # for MS1x's
    data[,SUBT_PMOL_MS1x] <- ifelse(data[,SUBT_PMOL_MS1x] < 0, 0, data[,SUBT_PMOL_MS1x])
  }

  # calculate LOQ if user has selected LOQ
  if(LOQ){
    for(SUBT_PMOL_MS1x in SUBT_PMOL_MS1x_names){ # for MS1x's
      for(i in 1:nrow(exData)){
        # find corresponding internal standard for the current class name.
        is <- isData[grep(paste0("is",classNames[i]," "),isData[,dataColnames$SUM_COMPOSITION]),]
        #print(SUBT_PMOL_MS1x)
        #print(colnames(data))
        #print(data[i,SUBT_PMOL_MS1x])
        #print(database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION],"DISSOLVED_AMOUNT"])
        #print((1/database[database$NAME == is[,dataColnames$SUM_COMPOSITION],"DF_INFUSION"])*1000)
        #print(( database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "LOQ"] + fixedDeviation ))

        # insert LOQ column with 1/0 according to whether SUBT_PMOL_MS1x has values above LOQ threshold or not (1: above, 0: not above)
        #data[1:nrow(exData),paste0("LOQ_",SUBT_PMOL_MS1x)] <- ifelse(data[1:nrow(exData),SUBT_PMOL_MS1x]/database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION],"DISSOLVED_AMOUNT"]*(1/database[database$NAME == is[,dataColnames$SUM_COMPOSITION],"DF_INFUSION"])*1000 > ( database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "LOQ"] + fixedDeviation ), 1, 0)
        #print(data[i, dataColnames$SUM_COMPOSITION])
        #print(is[,dataColnames$SUM_COMPOSITION])
        #print(paste0("Beregning: ",data[i,SUBT_PMOL_MS1x]/database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION],"DISSOLVED_AMOUNT"]*(1/database[database$NAME == is[,dataColnames$SUM_COMPOSITION],"DF_INFUSION"])*1000))
        #print(paste0("Threshold: ", ( database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "LOQ"] + fixedDeviation )))
        if(data[i,SUBT_PMOL_MS1x]/database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION],"DISSOLVED_AMOUNT"]*(1/database[database$NAME == is[,dataColnames$SUM_COMPOSITION],"DF_INFUSION"])*1000 > ( database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "LOQ"] + fixedDeviation )){
          data[i,paste0("LOQ_",SUBT_PMOL_MS1x)] <- 1
         }
        else{
          data[i,paste0("LOQ_",SUBT_PMOL_MS1x)] <- 0
          #print("UNDER THRESHOLD")
          #print(SUBT_PMOL_MS1x)
          #print("")
          #print("")
        }

        #print(paste0("Formula: ",data[1,SUBT_PMOL_MS1x]/database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION],"DISSOLVED_AMOUNT"]*(1/database[database$NAME == is[,dataColnames$SUM_COMPOSITION],"DF_INFUSION"])*1000))
        #print(paste0("Bigger than: ",( database[database[,dataColnames$SUM_COMPOSITION] == is[,dataColnames$SUM_COMPOSITION], "LOQ"] + fixedDeviation )))




      }
      # change SUBT_PMOL_MS1x to 0 if LOQ column == 0.
      #data[data[1:nrow(exData),paste0("LOQ_",SUBT_PMOL_MS1x)] == 0 ,SUBT_PMOL_MS1x] <- 0
      data[data[1:nrow(exData),paste0("LOQ_",SUBT_PMOL_MS1x)] == 0 ,SUBT_PMOL_MS1x] <- 0

    }
  }



  # filter values in replicates
  if(numberOfReplicates > 1){
    data[1:nrow(exData), SUBT_PMOL_MS1x_names] <- filterReplicates(data[1:nrow(exData), SUBT_PMOL_MS1x_names], userSpecifiedColnames = userSpecifiedColnames, numberOfReplicates = numberOfReplicates, numberOfInstancesThreshold = numberOfInstancesThreshold, thresholdValue = thresholdValue)
  }
  # remove a given row if all MS1x* (except last BLNK MS1x) values contains zeros.
  data <- data[apply(data[MS1x_names],1,function(value) any(value != 0)),]
  # update exData and isData with the newly created columns, and removed rows
  exData <- data[-grep("is",data[,dataColnames$SUM_COMPOSITION]),]
  isData <- data[grep("is",data[,dataColnames$SUM_COMPOSITION]),]




  #### mol% specie calucated from MS1x* values after BLNK subtraction
  for(SUBT_PMOL_MS1x in SUBT_PMOL_MS1x_names){

    # calculate mol% species for each specie
    sumSpecies <- sum(data[1:nrow(exData),SUBT_PMOL_MS1x],na.rm = TRUE)
    data[1:nrow(exData),paste0("MOL_PCT_",dataColnames$SPECIE_COMPOSITION,"S_",SUBT_PMOL_MS1x)] <- 100/sumSpecies*exData[1:nrow(exData),SUBT_PMOL_MS1x]

  }


  #### zero adapter: check value >= zeroThresh. if not, value <- 0.
  MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_names <- colnames(data)[grep(paste0("^MOL_PCT_",dataColnames$SPECIE_COMPOSITION,"S_SUBT_PMOL_SAMPLE_"),colnames(data))]

  # set all values that are under an user defined threshold (zeroThresh) to 0 for mol% species in exData.
  for(MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x in MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_names){ # for MS1x columns

    data[1:nrow(exData),MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x] <- ifelse(data[1:nrow(exData),MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x] < zeroThresh, 0, data[1:nrow(exData),MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x])
  }



  # re-calculation of the mol% specie after removal of rows below an user defined threshold (zeroThresh)
  for(MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_re in MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_names){
    sumSpecies<-sum(data[1:nrow(exData),MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_re], na.rm = TRUE)
    data[1:nrow(exData),paste0("FILTERED_",MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_re)] <- 100/sumSpecies*data[1:nrow(exData),MOL_PCT_SPECIE_COMPOSITIONS_SUBT_PMOL_MS1x_re]
  }


  #### sum pmol values for each classes in each MS1x* after BLNK subtraction

  # find all unique class names (without numbers)
  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",exData[,dataColnames$SUM_COMPOSITION])
  classNames <-unique(classNames)




  sumClassValueList <- matrix(numeric(), nrow = length(classNames), ncol = length(SUBT_PMOL_MS1x_names)) # store all sumClassValue to be used later in mol% class calculation
  for(i in 1:length(classNames)){

    for(j in 1:length(SUBT_PMOL_MS1x_names)){

      # sum values for each class
      sumClassValue <- sum(data[grep(paste0("^",classNames[i]," "),data[,dataColnames$SUM_COMPOSITION]),SUBT_PMOL_MS1x_names[j]],na.rm = TRUE)
      sumClassValueList[i,j] <- sumClassValue


      # add sum value to all species with the same class
      data[grep(paste0("^",classNames[i]," "),data[,dataColnames$SUM_COMPOSITION]),paste0("CLASS_PMOL_",SUBT_PMOL_MS1x_names[j])] <- sumClassValue
    }
  }


  #### mol% class (100/sum(sumClassValueList) * sumClassValue[j,i]) calculation

  # find sum of all class values for each SUBT_PMOL_MS1x*
  for(j in 1:length(SUBT_PMOL_MS1x_names)){
    totalSumClassValueList<-sum(sumClassValueList[,j],na.rm = TRUE)

    # calculate mol% class for each sumClassValueList col, which corresponds to each SUBT_PMOL_MS1x
    for(i in 1:nrow(sumClassValueList)){
      mol_pct_class<-100/totalSumClassValueList * sumClassValueList[i,j]

      # insert mol% class calculation into the respective class in data
      data[grep(paste0("^",classNames[i]," "),data[,dataColnames$SUM_COMPOSITION]),paste0("MOL_PCT_CLASS_",SUBT_PMOL_MS1x_names[j])] <- mol_pct_class

    }
  }


  return(data)

}
