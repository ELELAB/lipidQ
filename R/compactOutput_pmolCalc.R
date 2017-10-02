#' @title Make Compact Output Containing Pico Mol Calculations
#' @author André Vidas Olsen
#' @description compactOutput_pmolCalc saves a data.frame with only
#' NAME, CLASS_PMOL_SUBT_PMOL_PREC*, and MOL_PCT_CLASS_SUBT_PMOL_PREC* OMSKRIV!!!
#' @param data data formatted by the use of the mergeDataSet function from LipidQuan.
#' @export
compactOutput_pmolCalc <- function(data){

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
