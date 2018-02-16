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
#' @param sampleTypes file that associates column names of MS1 with the sample
#' types
#' @param k number of k in the k-means algorithm.
#' @param pathToOutput the directory path to save the plots
#' @param log2 logical argument that specifies whether or not data has to be
#' log2 transformed
#' @param pseudoCount pseudo count added to the data if the data is log2
#' transformed in order to avoid negative infinite values in the data
#' @importFrom stats cor median
#' @import ComplexHeatmap
#' @importFrom circlize colorRamp2
#' @importFrom NbClust NbClust
#' @importFrom factoextra fviz_nbclust
#' @importFrom grDevices dev.off png
#' @return Two heatmap images: heatmap of species (heatmapSpecies_k_n.png) and
#' heatmap of classes (heatmapClasses_k_n.png), where n indicates the amount of
#' clusters k. If clusters are not chosen by the user, a majority vote chart
#' will also be included called nbclustResults.png.
#' @export
#' @examples
#' # load sample types file and data to be used for visualization
#' sampleTypes <- read.csv(system.file("extdata", "sampleTypes.csv",
#'  package = "lipidQuan"), stringsAsFactors = FALSE)
#'
#' data <- read.csv(system.file("extdata/",
#'  "finalOutput_molPct.csv", package = "lipidQuan"), stringsAsFactors = FALSE)
#'
#'
#' # create heatmap from log2 transformed data with 0.0001 added pseudo counts
#' plotHeatmap(data = data, sampleTypes = sampleTypes, k = 2,
#'  pathToOutput = "",
#'  log2 = TRUE, pseudoCount = 0.0001)
plotHeatmap <- function(data, sampleTypes, k = NULL, pathToOutput, log2 = FALSE,
                        pseudoCount = NULL) {



  # check that no Inf/-Inf/NA exists in the data and throw an error message if
  # the data contains these values.
  if(any(data == Inf | data == -Inf | is.na(data))){
    stop("ERROR!! The data contains NA/NaN or infinite values. Please remove these from the data set and try again.")
  }


  # log2 transformation of data if specified by the user
  if(log2){
    data[,2:ncol(data)] <- log2(data[,2:ncol(data)] + pseudoCount)
  }




  # select relevant columns in data (mol procent species & mol procent classes)
  mol_pct_species_cols <- data[grep(":",data$"molPct"),2:ncol(data)]
  mol_pct_classes_cols <- data[-grep(":",data$"molPct"),2:ncol(data)]



  # classes - samples

  # specify start and end index for each group
  groupIndexes <- lapply(sampleTypes[1,],
                FUN = function(x) as.numeric(unlist(strsplit(x, split = "-"))))

  # evaluate the index range for each group
  ranges <- lapply(groupIndexes, FUN = function(x) x[1]:x[2])

  # specify sampleTypes for the heatmap
  type <- character(length(colnames(mol_pct_species_cols)))
  for(i in 1:ncol(sampleTypes)){
    type[unlist(ranges[colnames(sampleTypes)[i]])] <- colnames(sampleTypes)[i]
  }


  # make colors for sampleTypes
  colors <- c("green", "blue", "yellow", "brown", "purple", "red", "black",
              "orange", "grey", "pink")[1:length(unique(type))]
  names(colors) <- unique(type)



  #### specify the optimal number of k
  if(is.null(k)){
    nb <- NbClust(data[,2:ncol(data)], distance = "euclidean",
                  max.nc = ncol(data[,2:ncol(data)]), method = "kmeans")


    t <- as.data.frame(table(nb$Best.nc[1,]), stringsAsFactors = FALSE)
    t <- t[1:(nrow(t)-1),] # remove highest cluster (k == number of samples)
    # from the possible optimal cluster list, since ComplexHeatmap can't have
    # same number of clusters as observations
    listOf_k <- as.numeric(t[t$Freq == max(t$Freq), "Var1"])

    # plot results
    nbclustResults <- fviz_nbclust(nb)
    ggsave(nbclustResults, filename=paste0(pathToOutput, "/nbclustResults.png"),
           width = 40, height = 25, units = "cm")


  }else{
    listOf_k <- k
  }




  # make graphs for each optimal number of k's (there will be multiples if there
  # are equally high number of choices for severeal k's)
  for(k in listOf_k){

  #### heatmap species
  dataMatrix <- data.matrix(mol_pct_species_cols)
  rownames(dataMatrix) <- data[1:nrow(mol_pct_species_cols),1]

  # transpose matrix
  dataMatrix <- t(dataMatrix)

  #dataMatrix[dataMatrix == -Inf] <- 0
  #dataMatrix[dataMatrix == Inf] <- 0



  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row",
                          col = list(type = colors))
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Classes",
                  column_title_side = "bottom", row_title = "Samples",
                  row_title_side = "right", na_col = "black",
                  col = colorRamp2(c(min(dataMatrix, na.rm = TRUE),
                  median(dataMatrix, na.rm = TRUE),
                  max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")),
                  show_row_dend = FALSE, show_column_dend = FALSE,
                  cluster_rows = TRUE, km = k)
  heatPlot <- ha + heat
  png(filename = paste0(pathToOutput, "heatmapSpecies_k_", k, ".png"),
      height = 800, width = (22*nrow(mol_pct_species_cols)))
  draw(heatPlot)
  dev.off()




  #### heatmap classes
  dataMatrix <- data.matrix(mol_pct_classes_cols)
  rownames(dataMatrix) <- data[(nrow(mol_pct_species_cols)+1):nrow(data),1]

  # transpose matrix
  dataMatrix <- t(dataMatrix)


  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row",
                          col = list(type = colors))
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Classes",
                  column_title_side = "bottom", row_title = "Samples",
                  row_title_side = "right", na_col = "black",
                  col = colorRamp2(c(min(dataMatrix, na.rm = TRUE),
                  median(dataMatrix, na.rm = TRUE),
                  max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")),
                  show_row_dend = FALSE, show_column_dend = FALSE,
                  cluster_rows = TRUE, km = k)
  heatPlot <- ha + heat
  png(filename = paste0(pathToOutput, "heatmapClasses_k_", k, ".png"),
      height = 800, width = (22*nrow(mol_pct_classes_cols)))
  draw(heatPlot)
  dev.off()


  }
}


