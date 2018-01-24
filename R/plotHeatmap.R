#rm(list=ls(all=TRUE))
#library(ComplexHeatmap)
#library(circlize)
#library(colorspace)
#library(GetoptLong)
#library(latex2exp)

#getwd()
#data <- read.csv("../heatmaps/FC_Cluster_CP.csv", row.names = 1)
#dim(data)
#head(data)

#' @title Plot Heatmap
#' @author André Vidas Olsen
#' @description This function plots heatmaps of the data
#' @param data bla bla
#' @param controlStart bla bla
#' @param caseStart bla bla
#' @param filter safda
#' @param threshold_logFC adsfsafd
#' @param threshold_amountOfInsignificantLogFC asfdasf
#' @importFrom stats cor
#' @importFrom ComplexHeatmap Heatmap HeatmapAnnotation
#' @importFrom circlize colorRamp2
plotHeatmap <- function(data, controlStart, caseStart, filter = FALSE, threshold_logFC, threshold_amountOfInsignificantLogFC) {

  # implement dataGroups for defining groups on the sample columns.

  #### transform data values to logFC
  normal <- data[controlStart:(caseStart-1)] # background values to be used for calucation of logFC
  data <- data[,caseStart:ncol(data)] # remove the normal (background) column from the data set
  #dim(data)


  # calculate logFC for all columns in data
  for(i in 1:ncol(data)){
    data[,i] <- log2(data[,i]/normal)
  }
  #head(data)


  if(filter){
    # filter option: remove logFC values below a given threshold
    #threshold_logFC <- 0.66 # sets both threshold for up/down logFC
    #threshold_amountOfInsignificantLogFC <- 0.7 # between 0-1
    amountBelowThresholdPerRow <- sapply(1:nrow(data), FUN = function(x) sum(data[x,] < threshold_logFC & data[x,] > -threshold_logFC)/ncol(data))
    data <- data[amountBelowThresholdPerRow < threshold_amountOfInsignificantLogFC,] # filter data according to neglect option
  }









  #### samples - samples
  dataCor <- cor(data, method = "spearman")
  head(dataCor)
  dataCorMatrix <- data.matrix(dataCor)
  type <- substr(colnames(dataCorMatrix), 1, 4)
  # type colors : Luminal A/B = blue, Her2 = purple, TNBC = red
  ha = HeatmapAnnotation(df = data.frame(type = type), col = list(type = c("Lumi" =  "blue", "HER2" = "purple", "TNBC" = "red")))
  Heatmap(dataCorMatrix, name = "Spearman cor.", column_title = "Samples", column_title_side = "bottom", row_title = "Samples", row_title_side = "right", top_annotation = ha, col = colorRamp2(c(min(min(dataCorMatrix), -max(dataCorMatrix)), 0, max(-min(dataCorMatrix), max(dataCorMatrix))), c("blue", "white", "red")))


  # classes - classes
  dataTransposed <- t(data)
  dataCor <- cor(dataTransposed, method = "spearman")
  head(dataCor)
  dataCorMatrix <- data.matrix(dataCor)
  Heatmap(dataCorMatrix, name = "Spearman cor.", column_title = "Classes", column_title_side = "bottom", row_title = "Classes", row_title_side = "right", col = colorRamp2(c(min(min(dataCorMatrix), -max(dataCorMatrix)), 0, max(-min(dataCorMatrix), max(dataCorMatrix))), c("blue", "white", "red")))




  # classes - samples

  # change -Inf to something very small
  dataMatrix <- data.matrix(data)
  head(dataMatrix)
  dataMatrix[dataMatrix == -Inf] <- NA
  head(dataMatrix)
  type <- substr(colnames(dataMatrix), 1, 4)
  # type colors : Luminal A/B = blue, Her2 = purple, TNBC = red
  ha = HeatmapAnnotation(df = data.frame(type = type), col = list(type = c("Lumi" =  "blue", "HER2" = "purple", "TNBC" = "red")))
  Heatmap(dataMatrix, name = "LogFC", column_title = "Samples", column_title_side = "bottom", row_title = "Classes", row_title_side = "right", na_col = "black", top_annotation = ha, col = colorRamp2(c(min(min(dataMatrix, na.rm = TRUE), -max(dataMatrix, na.rm = TRUE)), 0, max(-min(dataMatrix, na.rm = TRUE), max(dataMatrix, na.rm = TRUE))), c("blue", "white", "red")))

  dataMatrix

  }




