#' @title Make Final Output
#' @author André Vidas Olsen
#' @description This function creates the final output file of the results which consists of both all filtered pmol% species and filtered pmol% classes.
#' @param classPmol_molPctClass compact output file created by using the compactOutput_pmolCalc() script.
#' @param pmolCalculatedDataSet data of pmol calculations made by using the pmolCalc() script.
#' @param userSpecifiedColnames the column names template file containing user specified column names for the input data.
#' @return a final output file containing pmol and mol% of species
#' @export
#' @examples
#' # load endo & ISTD databases as well as user specified column names file.
#' endogene_lipid_db <- read.table(system.file("extdata/LipidQ_DataBase", "LP_DB_MS1_v1.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#' ISTD_lipid_db <- read.table(system.file("extdata/LipidQ_DataBase", "ISTD_LP_DB_MS1_v1.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#' userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase", "userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # load pmolCalculatedDataSet.csv made by using the pmolCalc() function
#' pmolCalculatedDataSet <- read.table(system.file("extdata/dataTables", "pmolCalculatedDataSet.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
#'
#' # make compact output from pmolCalculatedDataSet
#' classPmol_molPctClass_compact <- compactOutput_pmolCalc(pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
#'
#' # make final outout
#' finalOutput <- makeFinalOutput(classPmol_molPctClass_compact, pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
#'
#' # print mol% final output
#' finalOutput[[1]]
#'
#' # print pmol final output
#' finalOutput[[2]]
makeFinalOutput <- function(classPmol_molPctClass, pmolCalculatedDataSet, userSpecifiedColnames = NULL){

  # get colnames for data
  dataColnames <- getColnames(userSpecifiedColnames = userSpecifiedColnames)



  #### create finalOutput_molPct file

  # take all lipid species (NAME col) from pmolCalculatedDataSet without using the is-rows
  lipidSpecies <- pmolCalculatedDataSet[,c(1,grep("^FILTERED*", colnames(pmolCalculatedDataSet)))]
  lipidSpecies <- lipidSpecies[-grep("^is",lipidSpecies[,dataColnames$SUM_COMPOSITION]),]

  # change colnames: NAME -> mol%, FILTERED* -> Sample_01
  sampleNames <- paste0("Sample_",1:(length(colnames(lipidSpecies))-1))
  colnames(lipidSpecies) <- c("mol%", sampleNames)




  # take NAME from classPmol_molPctClass without using the is-rows
  classes <- classPmol_molPctClass[,c(1,grep("^CLASS_FILTERED*", colnames(classPmol_molPctClass)))]
  classes <- classes[-grep("^is",classes[, dataColnames$SUM_COMPOSITION]),]

  # change colnames: NAME -> mol%, CLASS_FILTERED* -> Sample_01
  sampleNames <- paste0("Sample_",1:(length(colnames(classes))-1))
  colnames(classes) <- c("mol%", sampleNames)




  # merge data sets together
  output_molPct <- rbind(lipidSpecies, classes)


  # change classes/species with "O-": insert [SPACE] before "O-" and remove [SPACE] after "O-"
  namesWithOIndexes <- grep("O-",output_molPct$"mol%")
  for(i in namesWithOIndexes){
    nameWithO <- output_molPct$"mol%"[i]
    nameWithO <- strsplit(nameWithO," ")

    if(length(nameWithO[[1]]) == 2){ # used when name represents a specie (contains number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]),nameWithO[[1]][2])
    }else{ # used when name represents a class (without number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]))
    }
    output_molPct$"mol%"[i] <- nameWithO
  }


  # remove every row that only contains 0's in the columns
  output_molPct <- output_molPct[apply(output_molPct[,-1], 1, FUN = function(x) !all(x == 0)),]



  #### create finalOutput_pmol file

  # take all lipid species (NAME col) from pmolCalculatedDataSet without using the is-rows
  lipidSpecies <- pmolCalculatedDataSet[,c(1,grep("^SUBT_PMOL_SAMPLE*", colnames(pmolCalculatedDataSet)))]
  lipidSpecies <- lipidSpecies[-grep("^is",lipidSpecies[, dataColnames$SUM_COMPOSITION]),]

  # change colnames: NAME -> mol%, SUBT_PMOL_SAMPLE* -> Sample_01
  sampleNames <- paste0("Sample_",1:(length(colnames(lipidSpecies))-1))
  colnames(lipidSpecies) <- c("pmol", sampleNames)


  # take NAME from classPmol_molPctClass without using the is-rows
  classes <- pmolCalculatedDataSet[,c(1,grep("^CLASS_PMOL_SUBT_PMOL*", colnames(pmolCalculatedDataSet)))]
  classes <- classes[-grep("^is",classes[, dataColnames$SUM_COMPOSITION]),]

  # change colnames: NAME -> mol%, CLASS_PMOL_SUBT_PMOL* -> Sample_01
  sampleNames <- paste0("Sample_",1:(length(colnames(classes))-1))
  colnames(classes) <- c("pmol", sampleNames)

  # remove numbers in the SUM_COMPOSITION column, so only the class name is used for SUM_COMPOSITION.
  for(i in 1:nrow(classes)){
    classes[i, "pmol"] <- unlist(strsplit(classes[i,"pmol"], " "))[[1]]
  }

  # remove rows containing duplicates of SUM_COMPOSITION
  classes <- classes[!duplicated(classes[,"pmol"]),]


  output_pmol <- rbind(lipidSpecies, classes)


  # change classes/species with "O-": insert [SPACE] before "O-" and remove [SPACE] after "O-"
  namesWithOIndexes <- grep("O-",output_pmol$"mol%")
  for(i in namesWithOIndexes){
    nameWithO <- output_pmol$"mol%"[i]
    nameWithO <- strsplit(nameWithO," ")

    if(length(nameWithO[[1]]) == 2){ # used when name represents a specie (contains number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]),nameWithO[[1]][2])
    }else{ # used when name represents a class (without number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]))
    }
    output_pmol$"mol%"[i] <- nameWithO
  }



  output <- list(output_molPct, output_pmol)

  return(output)
}
