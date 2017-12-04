#' @title Filter Replicates
#' @author André Vidas Olsen
#' @description This function filter replicates for each specie based on a threshold value
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data. This file
#' @param numberOfReplicates the number of replicates for each sample
#' @param blnkReplicates logical parameter for specifying whether the blank sample contains replicates or not. FALSE: no replicates, TRUE: replicates.
#' @param numberOfInstancesThreshold the number of replicates for a given sample that has to have values above the specified threshold value (thesholdValue)
#' @param thresholdValue user specified threshold value based on technical noise and/or other variation sources. This paramter will determine the threshold in which a replicate will be considered as having an observed value or not.
#' @export
filterReplicates <- function(data, userSpecifiedColnames = NULL, numberOfReplicates = 1, blnkReplicates = FALSE, numberOfInstancesThreshold, thresholdValue){


  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)

  MS1x_names <- colnames(data)[grep(paste0("^",dataColnames$MS1x),colnames(data))] # names of all MS1x.* columns

  # define MS1x columns and BLNK column (last MS1x column)
  if(!blnkReplicates){
    BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.* column)
    MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from MS1x_names since this is BLNK
  }


  # calculate number of samples (including blnk if that have replicates. FYI: If blnk does not have replicates, then blnk is excluded from MS1x_names a few lines above this)
  numberOfSamples <- length(MS1x_names) / numberOfReplicates

  # check whether number of replicates is true or not
  if(!(numberOfSamples %% 1 == 0)){
    stop("Please check that the number of replicates is true and check whether blank contains replicates or not.")
  }


  # Check if instances are above threshold (numberOfInstancesThreshold) for all replicates for all samples
  for(i in 1:numberOfSamples){
    reps <- data[,MS1x_names[(i*numberOfReplicates-numberOfReplicates+1):(i*numberOfReplicates)]]
    # repsValid: if number of reps with values is valid; repsValid -> 1, else repsValid <- 0
    repsValid <- ifelse(rowSums(ifelse(reps >= thresholdValue, 1, 0)) >= numberOfInstancesThreshold, 1, 0)
    # insert zeros into data where the replicates of a given sample were not above the threshold (numberOfInstancesThreshold)
    data[repsValid == 0,MS1x_names[(i*numberOfReplicates-numberOfReplicates+1):(i*numberOfReplicates)]] <- 0

  }

  return(data)
}

