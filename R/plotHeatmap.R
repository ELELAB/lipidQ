#rm(list=ls(all=TRUE))
#library(ComplexHeatmap)
#library(circlize)

#getwd()
#data <- read.csv("../heatmaps/FC_Cluster_CP.csv", row.names = 1)
#dim(data)
#head(data)

#' @title Plot Heatmap
#' @author André Vidas Olsen
#' @description This function plots heatmaps of the data
#' @param data quantified data to be visualized
#' @param groups file that associates column names of MS1 with groups
#' @param K number of K in the Kmeans algorithm.
#' @param pathToOutput the directory path to save the plots
#' @importFrom stats cor
#' @importFrom ComplexHeatmap Heatmap HeatmapAnnotation
#' @importFrom circlize colorRamp2
#' @importFrom NbClust NbClust
#' @export
plotHeatmap <- function(data, groups, K = NULL, pathToOutput) {

  # select relevant columns in data (mol procent species & mol procent classes)
  mol_pct_species_cols <- data[grep(":",data$mol.),2:ncol(data)]
  mol_pct_classes_cols <- data[-grep(":",data$mol.),2:ncol(data)]



  # classes - samples

  # specify start and end index for each group
  groupIndexes <- lapply(groups[1,], FUN = function(x) as.numeric(unlist(strsplit(x, split = "-"))))

  # evaluate the index range for each group
  ranges <- lapply(groupIndexes, FUN = function(x) x[1]:x[2])

  # specify groups for the heatmap
  type <- character(length(colnames(mol_pct_species_cols)))
  for(i in 1:ncol(groups)){
    type[unlist(ranges[colnames(groups)[i]])] <- colnames(groups)[i]
  }




  # make colors for groups
  colors <- c("green", "blue", "yellow", "brown", "purple", "red", "black", "orange", "pink")[1:length(unique(type))]
  names(colors) <- unique(type)


  print(head(data))
  #### specify the optimal number of K
  if(is.null(K)){
    nb <- NbClust(data[,2:ncol(data)], distance = "euclidean", min.nc = 2,
                  max.nc = ncol(data[,2:ncol(data)]), method = "kmeans")


    t <- as.data.frame(table(nb$Best.nc[1,]), stringsAsFactors = FALSE)
    #print(t)
    t <- t[1:(nrow(t)-1),] # remove highest cluster (K == number of samples) from the possible optimal cluster list, since ComplexHeatmap can't have same number of clusters as observations
    #print(t)
    listOfK <- as.numeric(t[t$Freq == max(t$Freq), "Var1"])
    #print(listOfK)


    # for test
    #t <- as.data.frame(table(c(1,1,2,2,2,1,2,3,4,4,4,4)), stringsAsFactors = FALSE)
    #t <- t[1:(nrow(t)-1),]
    #print(t)
    #listOfK <- as.numeric(t[t$Freq == max(t$Freq), "Var1"])
    #print(listOfK)

    # find next highest K, if K = number of samples in data (ComplexHeatmap can't have same number of clusters as observations)
    #if(max(listOfK) == ncol(data[,2:ncol(data)])){
    #  mostOptimalRemoved <- t[!(t$Var1 == max(t$Var1)),]
    #  listOfK <- as.numeric(mostOptimalRemoved[mostOptimalRemoved$Freq == max(mostOptimalRemoved$Freq), "Var1"])
    #}
  }else{
    listOfK <- K
  }
  print(listOfK)




  # make graphs for each optimal number of K's (there will be multiples if there are equally high number of choices for severeal K's)
  for(K in listOfK){

  #### heatmap species
  dataMatrix <- data.matrix(mol_pct_species_cols)
  rownames(dataMatrix) <- data[1:nrow(mol_pct_species_cols),1]

  # transpose matrix
  dataMatrix <- t(dataMatrix)

  #print(head(dataMatrix))
  dataMatrix[dataMatrix == -Inf] <- NA
  dataMatrix[dataMatrix == Inf] <- NA
  #dataMatrix[is.na(dataMatrix)] <- NA


  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row", col = list(type = colors))
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Classes", column_title_side = "bottom", row_title = "Samples", row_title_side = "right", na_col = "black", col = colorRamp2(c(0, median(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")), show_row_dend = FALSE, cluster_rows = TRUE, km = K)
  heatPlot <- ha + heat

  png(file = paste0(pathToOutput, "/heatmapSpecies_K_", K, ".png"), height = 800, width = (22*nrow(mol_pct_species_cols)))
  draw(heatPlot)
  dev.off()




  #### heatmap classes
  dataMatrix <- data.matrix(mol_pct_classes_cols)
  rownames(dataMatrix) <- data[(nrow(mol_pct_species_cols)+1):nrow(data),1]

  # transpose matrix
  dataMatrix <- t(dataMatrix)

  #print(head(dataMatrix))
  dataMatrix[dataMatrix == -Inf] <- NA
  dataMatrix[dataMatrix == Inf] <- NA
  #dataMatrix[is.na(dataMatrix)] <- 0


  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row", col = list(type = colors))
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Classes", column_title_side = "bottom", row_title = "Samples", row_title_side = "right", na_col = "black", col = colorRamp2(c(0, median(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")), show_row_dend = FALSE, cluster_rows = TRUE, km = K)
  heatPlot <- ha + heat
  png(file = paste0(pathToOutput, "/heatmapClasses_K_", K, ".png"), height = 800, width = (22*nrow(mol_pct_classes_cols)))
  draw(heatPlot)
  dev.off()

  }
}



#groups <- read.csv("inst/extdata/groups.csv", as.is = TRUE)

#data <- read.csv("results/dataTables/finalOutput_molPct.csv")
#colnames(data)

plotHeatmap(data = data, groups = groups, pathToOutput = "/data/user/andre/lipidomics/lipidQuan/")




