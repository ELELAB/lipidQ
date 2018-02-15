#' @title Filter Replicates
#' @author André Vidas Olsen
#' @description This function filter replicates for each specie based on a
#' threshold value
#' @param data data formatted by the use of the mergeDataSet function from
#' LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user
#' specified column names for the input data. This file
#' @param numberOfReplicates the number of replicates for each sample
#' @param numberOfInstancesThreshold the number of replicates for a given sample
#' that has to have values above the specified threshold value (thesholdValue)
#' @param thresholdValue user specified threshold value based on technical noise
#' and/or other variation sources. This paramter will determine the threshold in
#' which a replicate will be considered as having an observed value or not.
#' @return a data set filtered by a user specified threshold of pmol between
#' replicates
filterReplicates <- function(data, userSpecifiedColnames = NULL,
            numberOfReplicates = 1, numberOfInstancesThreshold, thresholdValue){


  # get colnames for data
  dataColnames <- checkColnames(userSpecifiedColnames)


  # calculate number of samples
  numberOfSamples <- length(colnames(data)) / numberOfReplicates


  # check whether number of replicates is true or not
  if(!(numberOfSamples %% 1 == 0)){
    stop("Please check that the number of replicates is true and check whether blank contains replicates or not.")
  }


  # Check if instances are above threshold (numberOfInstancesThreshold) for all
  # replicates for all samples
  for(i in 1:numberOfSamples){
    reps <-
      data[,(i*numberOfReplicates-numberOfReplicates+1):(i*numberOfReplicates)]

    repsValid <- ifelse(rowSums(
      ifelse(reps >= thresholdValue, 1, 0)) >= numberOfInstancesThreshold, 1, 0)

    data[repsValid == 0,
      (i*numberOfReplicates - numberOfReplicates+1):(i*numberOfReplicates)] <- 0


  }
  return(data)
}

