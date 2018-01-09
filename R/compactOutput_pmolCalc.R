#' @title Make Compact Output Containing Pico Mol Calculations
#' @author André Vidas Olsen
#' @description compactOutput_pmolCalc saves a data.frame with only
#' NAME, CLASS_PMOL_SUBT_PMOL_PREC*, and MOL_PCT_CLASS_SUBT_PMOL_PREC* OMSKRIV!!!
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @export
compactOutput_pmolCalc <- function(data, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames)


  # create the new data set with SUM_COMPOSITION
  #classPmol_molPctClass <- subset(data, select = c(dataColnames$SUM_COMPOSITION))
  classPmol_molPctClass <- data.frame(x = data[,dataColnames$SUM_COMPOSITION], stringsAsFactors = FALSE)

  colnames(classPmol_molPctClass) <- dataColnames$SUM_COMPOSITION[1]

  # remove numbers in the SUM_COMPOSITION column, so only the class name is used for SUM_COMPOSITION.
  for(i in 1:nrow(data)){
    #classPmol_molPctClass$NAME[i] <- unlist(strsplit(classPmol_molPctClass$NAME[i], " "))[[1]]
    classPmol_molPctClass[i, dataColnames$SUM_COMPOSITION] <- unlist(strsplit(classPmol_molPctClass[i,dataColnames$SUM_COMPOSITION], " "))[[1]]
  }

  # insert CLASS_PMOL_SUBT_PMOL_*, and MOL_PCT_CLASS_SUBT_PMOL_* columns
  classPmol_molPctClass <- cbind( classPmol_molPctClass, data[,c(colnames(data)[grep("^CLASS_PMOL_SUBT_PMOL_",colnames(data))])] )
  classPmol_molPctClass <- cbind( classPmol_molPctClass, data[,c(colnames(data)[grep("^MOL_PCT_CLASS_SUBT_PMOL_",colnames(data))])] )



  #### sum filtered values for each classes for each sample after BLNK subtraction
  # find all unique class names (without numbers)
  exData <- data[-grep("is",data[,dataColnames$SUM_COMPOSITION]),]

  classNames <- gsub("^(\\w+.)[[:space:]].*", "\\1",data[1:nrow(exData),dataColnames$SUM_COMPOSITION])
  classNames <-unique(classNames)

  FILTERED_names <- colnames(data)[grep("^FILTERED",colnames(data))]

  sumClassValueList <- matrix(numeric(), nrow = length(classNames), ncol = length(FILTERED_names)) # store all sumClassValue to be used later in mol% class calculation
  for(i in 1:length(classNames)){

    for(j in 1:length(FILTERED_names)){
      # sum values for each class
      sumClassValue <- sum(data[grep(paste0("^",classNames[i]," "),data[,dataColnames$SUM_COMPOSITION]),FILTERED_names[j]],na.rm = TRUE)
      sumClassValueList[i,j] <- sumClassValue

      # add sum value to all species with the same class
      data[grep(paste0("^",classNames[i]," "),data[,dataColnames$SUM_COMPOSITION]),paste0("CLASS_",FILTERED_names[j])] <- sumClassValue
    }
  }



  classPmol_molPctClass <- cbind( classPmol_molPctClass, data[,c(colnames(data)[grep("^CLASS_FILTERED",colnames(data))])] )

  # remove duplicates of SUM_COMPOSITION
  classPmol_molPctClass <- classPmol_molPctClass[!duplicated(classPmol_molPctClass[,dataColnames$SUM_COMPOSITION]),]


  return(classPmol_molPctClass)

}
