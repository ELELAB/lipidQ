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
