#rm(list=ls(all=TRUE))
#library(ComplexHeatmap)
#library(circlize)
#library(NbClust)
#library(factoextra)

#getwd()
#data <- read.csv("../heatmaps/FC_Cluster_CP.csv", row.names = 1)
#dim(data)
#head(data)


#' @title Plot Heatmap
#' @author André Vidas Olsen
#' @description This function plots heatmaps of the data
#' @param data quantified data to be visualized (finalOutput_molPct.csv)
#' @param sampleTypes file that associates column names of MS1 with the sample types
#' @param K number of K in the Kmeans algorithm.
#' @param pathToOutput the directory path to save the plots
#' @param log2 logical argument that specifies whether or not data has to be log2 transformed
#' @param pseudoCount pseudo count added to the data if the data is log2 transformed in order to avoid negative infinite values in the data
#' @importFrom stats cor
#' @import ComplexHeatmap
#' @importFrom circlize colorRamp2
#' @importFrom NbClust NbClust
#' @importFrom factoextra fviz_nbclust
#' @export
plotHeatmap <- function(data, sampleTypes, K = NULL, pathToOutput, log2 = FALSE, pseudoCount = NULL) {


  print(K)
  # check that no Inf/-Inf/NA exists in the data and throw an error message if the data contains these values.
  if(any(data == Inf | data == -Inf | is.na(data))){
    stop("ERROR!! The data contains NA/NaN or infinite values. Please remove these from the data set and try again.")
  }


  # log2 transformation of data if specified by the user
  if(log2){
    data[,2:ncol(data)] <- log2(data[,2:ncol(data)] + pseudoCount)
  }




  # select relevant columns in data (mol procent species & mol procent classes)
  mol_pct_species_cols <- data[grep(":",data$"mol."),2:ncol(data)]
  mol_pct_classes_cols <- data[-grep(":",data$"mol."),2:ncol(data)]



  # classes - samples

  # specify start and end index for each group
  groupIndexes <- lapply(sampleTypes[1,], FUN = function(x) as.numeric(unlist(strsplit(x, split = "-"))))

  # evaluate the index range for each group
  ranges <- lapply(groupIndexes, FUN = function(x) x[1]:x[2])

  # specify sampleTypes for the heatmap
  type <- character(length(colnames(mol_pct_species_cols)))
  for(i in 1:ncol(sampleTypes)){
    type[unlist(ranges[colnames(sampleTypes)[i]])] <- colnames(sampleTypes)[i]
  }


  # make colors for sampleTypes
  colors <- c("green", "blue", "yellow", "brown", "purple", "red", "black", "orange", "grey", "pink")[1:length(unique(type))]
  names(colors) <- unique(type)



  #### specify the optimal number of K
  if(is.null(K)){
    nb <- NbClust(data[,2:ncol(data)], distance = "euclidean",
                  max.nc = ncol(data[,2:ncol(data)]), method = "kmeans")


    t <- as.data.frame(table(nb$Best.nc[1,]), stringsAsFactors = FALSE)
    t <- t[1:(nrow(t)-1),] # remove highest cluster (K == number of samples) from the possible optimal cluster list, since ComplexHeatmap can't have same number of clusters as observations
    listOfK <- as.numeric(t[t$Freq == max(t$Freq), "Var1"])

    # plot results
    nbclustResults <- fviz_nbclust(nb)
    ggsave(nbclustResults, filename=paste0(pathToOutput, "/nbclustResults.png"), width = 40, height = 25, units = "cm")


  }else{
    listOfK <- K
  }




  # make graphs for each optimal number of K's (there will be multiples if there are equally high number of choices for severeal K's)
  for(K in listOfK){

  #### heatmap species
  dataMatrix <- data.matrix(mol_pct_species_cols)
  rownames(dataMatrix) <- data[1:nrow(mol_pct_species_cols),1]

  # transpose matrix
  dataMatrix <- t(dataMatrix)

  #dataMatrix[dataMatrix == -Inf] <- 0
  #dataMatrix[dataMatrix == Inf] <- 0


  #print(data)
  print("test")
  #print(K)
  #print(sampleTypes)
  #print(log2)
  #print(pseudoCount)
  #print(pathToOutput)
  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row", col = list(type = colors))
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Classes", column_title_side = "bottom", row_title = "Samples", row_title_side = "right", na_col = "black", col = colorRamp2(c(min(dataMatrix, na.rm = TRUE), median(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")), show_row_dend = FALSE, show_column_dend = FALSE, cluster_rows = TRUE, km = K)
  heatPlot <- ha + heat
  #heatPlot <- heat
  png(file = paste0(pathToOutput, "/heatmapSpecies_K_", K, ".png"), height = 800, width = (22*nrow(mol_pct_species_cols)))
  draw(heatPlot)
  #draw("+.AdditiveUnit"(ha, heat))
  #draw(AdditiveUnit(ha, heat))
  dev.off()




  #### heatmap classes
  dataMatrix <- data.matrix(mol_pct_classes_cols)
  rownames(dataMatrix) <- data[(nrow(mol_pct_species_cols)+1):nrow(data),1]

  # transpose matrix
  dataMatrix <- t(dataMatrix)

  #dataMatrix[dataMatrix == -Inf] <- NA
  #dataMatrix[dataMatrix == Inf] <- NA


  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row", col = list(type = colors))
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Classes", column_title_side = "bottom", row_title = "Samples", row_title_side = "right", na_col = "black", col = colorRamp2(c(min(dataMatrix, na.rm = TRUE), median(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")), show_row_dend = FALSE, show_column_dend = FALSE, cluster_rows = TRUE, km = K)
  heatPlot <- ha + heat
  png(file = paste0(pathToOutput, "/heatmapClasses_K_", K, ".png"), height = 800, width = (22*nrow(mol_pct_classes_cols)))
  draw(heatPlot)
  #draw("+.AdditiveUnit"(ha, heat))
  #draw(AdditiveUnit(ha, heat))
  dev.off()

  print(dataMatrix)

  }
}



#sampleTypes <- read.csv("inst/extdata/sampleTypes.csv", as.is = TRUE)

#data <- read.csv("results/dataTables/finalOutput_molPct.csv")
#colnames(data)

#plotHeatmap(data = data, sampleTypes = sampleTypes, pathToOutput = "/data/user/andre/lipidomics/lipidQuan/", log2 = FALSE)

#data[1,2] <- Inf
#data[2,2] <- -Inf
#data[3,2] <- NA
#data[4,2] <- NaN

#any(data == Inf | data == -Inf | is.na(data))

