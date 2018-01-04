#' @title Make Final Output
#' @author André Vidas Olsen
#' @description This function creates the final output file of the results which consists of both all filtered pmol% species and filtered pmol% classes.
#' @param classPmol_molPctClass compact output file created by using the compactOutput_pmolCalc() script.
#' @param pmolCalculatedDataSet data of pmol calculations made by using the pmolCalc() script.
#' @export
makeFinalOutput <- function(classPmol_molPctClass, pmolCalculatedDataSet){

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
  output <- rbind(lipidSpecies, classes)


  # change classes/species with "O-": insert [SPACE] before "O-" and remove [SPACE] after "O-"
  namesWithOIndexes <- grep("O-",output$"mol%")
  for(i in namesWithOIndexes){
    nameWithO <- output$"mol%"[i]
    nameWithO <- strsplit(nameWithO," ")

    if(length(nameWithO[[1]]) == 2){ # used when name represents a specie (contains number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]),nameWithO[[1]][2])
    }else{ # used when name represents a class (without number specs.)
      nameWithO <- paste0(gsub("O-", " O-", nameWithO[[1]][1]))
    }
    output$"mol%"[i] <- nameWithO
  }


  # remove every row that only contains 0's in the columns
  output <- output[apply(output[,-1], 1, FUN = function(x) !all(x == 0)),]


  return(output)
}
