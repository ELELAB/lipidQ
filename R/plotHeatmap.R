rm(list=ls(all=TRUE))
library(ComplexHeatmap)
library(circlize)
#library(colorspace)
library(GetoptLong)
library(latex2exp)

#getwd()
#data <- read.csv("../heatmaps/FC_Cluster_CP.csv", row.names = 1)
#dim(data)
#head(data)

#' @title Plot Heatmap
#' @author André Vidas Olsen
#' @description This function plots heatmaps of the data
#' @param data bla bla
#' @param groupFile file that associates column names of MS1 with groups
#' @param filter safda
#' @param threshold_logFC adsfsafd
#' @param threshold_amountOfInsignificantLogFC asfdasf
#' @importFrom stats cor
#' @importFrom ComplexHeatmap Heatmap HeatmapAnnotation
#' @importFrom circlize colorRamp2
plotHeatmap <- function(data, groupFile, filter = FALSE, threshold_logFC = 0, threshold_amountOfInsignificantLogFC = 0) {

  # change long MS1.* name to MS1_xx, where xx is a number
  #MS1x_tmp <- data[,c(colnames(data)[grep(paste0("^",dataColnames$MS1x),colnames(data))])]
  #colnames(MS1x_tmp) <- gsub("^(\\w+).*_(\\w+).raw", "\\1_\\2",colnames(MS1x_tmp))

  # select relevant columns in data (mol procent species & mol procent classes)
  #mol_pct_species_cols <- data[grep("^MOL_PCT_SPECIES_SUBT",colnames(data))]
  #mol_pct_classes_cols <- data[grep("^MOL_PCT_CLASS_SUBT",colnames(data))]
  mol_pct_species_cols <- data[1:(nrow(data)-9),2:ncol(data)]
  print(data[1:(nrow(data)-9),])
  # TO BE CONTINUED ...LAV DET HER OM SÅ DEN SELV FINDER SPECIES-DELEN OG CLASSES-DELEN (BRUGER finalOut_molPct, så indeholder begge dele)



  #### transform data values to logFC
  #normal <- data[controlStart:(caseStart-1)] # background values to be used for calucation of logFC
  #data <- data[,caseStart:ncol(data)] # remove the normal (background) column from the data set


  # calculate logFC for all columns in data
  #for(i in 1:ncol(data)){
  #  data[,i] <- log2(data[,i]/normal)
  #}



  if(filter){
    # filter option: remove logFC values below a given threshold
    #threshold_logFC <- 0.66 # sets both threshold for up/down logFC
    #threshold_amountOfInsignificantLogFC <- 0.7 # between 0-1
    amountBelowThresholdPerRow <- sapply(1:nrow(data), FUN = function(x) sum(data[x,] < threshold_logFC & data[x,] > -threshold_logFC)/ncol(data))
    data <- data[amountBelowThresholdPerRow < threshold_amountOfInsignificantLogFC,] # filter data according to neglect option
  }









  #### samples - samples
  #dataCor <- cor(data, method = "spearman")
  #head(dataCor)
  #dataCorMatrix <- data.matrix(dataCor)
  #type <- substr(colnames(dataCorMatrix), 1, 4)

  # type colors : Luminal A/B = blue, Her2 = purple, TNBC = red
  #ha = HeatmapAnnotation(df = data.frame(type = type), col = list(type = c("Lumi" =  "blue", "HER2" = "purple", "TNBC" = "red")))
  #Heatmap(dataCorMatrix, name = "Spearman cor.", column_title = "Samples", column_title_side = "bottom", row_title = "Samples", row_title_side = "right", top_annotation = ha, col = colorRamp2(c(min(min(dataCorMatrix), -max(dataCorMatrix)), 0, max(-min(dataCorMatrix), max(dataCorMatrix))), c("blue", "white", "red")))


  # classes - classes
  #dataTransposed <- t(data)
  #dataCor <- cor(dataTransposed, method = "spearman")
  #head(dataCor)
  #dataCorMatrix <- data.matrix(dataCor)
  #Heatmap(dataCorMatrix, name = "Spearman cor.", column_title = "Classes", column_title_side = "bottom", row_title = "Classes", row_title_side = "right", col = colorRamp2(c(min(min(dataCorMatrix), -max(dataCorMatrix)), 0, max(-min(dataCorMatrix), max(dataCorMatrix))), c("blue", "white", "red")))




  # classes - samples

  # specify start and end index for each group
  groupIndexes <- lapply(groups[1,], FUN = function(x) as.numeric(unlist(strsplit(x, split = "-"))))

  # evaluate the index range for each group
  ranges <- lapply(groupIndexes, FUN = function(x) x[1]:x[2])
  #unlist(ranges[colnames(groups)[1]])

  # specify groups for the heatmap
  type <- character(length(colnames(mol_pct_species_cols )))
  type[unlist(ranges[colnames(groups)[1]])] <- colnames(groups)[1]
  type[unlist(ranges[colnames(groups)[2]])] <- colnames(groups)[2]
  print(type)

  #print(head(mol_pct_species_cols))

  # change -Inf to something very small
  dataMatrix <- data.matrix(mol_pct_species_cols)
  rownames(dataMatrix) <- data[1:(nrow(data)-9),1] # TO BE CONTINUED ... LAV DET HER GENERISK OG IKKE BARE TIL - 9, SAA DEN SELV FINDER UD AF HVAD DER ER CLASSES OG HVAD DER ER SPECIES

  # transpose matrix
  dataMatrix <- t(dataMatrix)

  #print(head(dataMatrix))
  dataMatrix[dataMatrix == -Inf] <- 0
  dataMatrix[is.na(dataMatrix)] <- 0

  #type <- substr(colnames(dataMatrix), 1, 4)

  # make colors for groups
  colors <- c("green", "blue", "yellow", "brown", "purple", "red", "black", "orange", "pink")[1:length(unique(type))]
  names(colors) <- unique(type)


  # type colors : Luminal A/B = blue, Her2 = purple, TNBC = red
  #ha = HeatmapAnnotation(df = data.frame(type = type), col = list(type = c("Lumi" =  "blue", "HER2" = "purple", "TNBC" = "red")))
  ha <- HeatmapAnnotation(df = data.frame(type = type), which = "row", col = list(type = colors))

  #ha = rowAnnotation(df = df, col = list(type = c("a" = "red", "b" = "blue")),
  #heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Samples", column_title_side = "bottom", row_title = "Classes", row_title_side = "right", na_col = "black", col = colorRamp2(c(min(min(dataMatrix, na.rm = TRUE), -max(dataMatrix, na.rm = TRUE)), 0, max(-min(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE))), c("blue", "white", "red")), show_row_dend = FALSE)
  heat <- Heatmap(dataMatrix, name = "mol pct.", column_title = "Samples", column_title_side = "bottom", row_title = "Classes", row_title_side = "right", na_col = "black", col = colorRamp2(c(0, median(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE)), c("white", "yellow", "red")), show_row_dend = FALSE)
  ha + heat
  # TO BE CONTINUED ... FIND OUT HOW TO SET UP SIDE GROUPS (type) IN STEAD OF ON TOP.

  #dataMatrix

  }




#groups <- data.frame(group1 = c("1-2"), group2 = c("3-4"))
#write.csv(groups, file = "inst/extdata/groups.csv", quote = FALSE, row.names = FALSE)

groups <- read.csv("inst/extdata/groups.csv", as.is = TRUE)

#groupIndexes <- data.frame()
#for(col in colnames(groups)){
#  print(col)
#  range <- as.numeric(unlist(strsplit(groups[,col], split = "-")))
#  groupIndexes[,col] <- range[1]:range[2]
#  colnames(groupIndexes[,col]) <- col
#}


groups





#data <- read.csv("results/dataTables/pmolCalculatedDataSet.csv")
data <- read.csv("results/dataTables/finalOutput_molPct.csv")
colnames(data)

plotHeatmap(data = data, groupFile = groups)
