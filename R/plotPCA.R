# adapted from /data/user/andre/NilsProject/SP21_NormalizedValues_LabRunInfo_2016-11-15/setupData.R
#rm(list=ls(all=TRUE))
#library(ggplot2)

# LipidQuan PCAplot
#library(factoextra)


#' @title Plot Heatmap
#' @author André Vidas Olsen
#' @description This function plots the following PCA plots: screeplot and biplot
#' @param data quantified data to be visualized
#' @param groups file that associates column names of MS1 with groups
#' @importFrom factoextra fviz_eig fviz_pca_biplot
#' @export
plotPCA <- function(data, groups, pathToOutput){

  # select relevant columns in data (mol procent species & mol procent classes)
  mol_pct_species_cols <- data[grep(":",data$mol.),2:ncol(data)]
  mol_pct_classes_cols <- data[-grep(":",data$mol.),2:ncol(data)]

  species <- data[grep(":",data$mol.),1]
  classes <- data[-grep(":",data$mol.),1]



  # specify start and end index for each group
  groupIndexes <- lapply(groups[1,], FUN = function(x) as.numeric(unlist(strsplit(x, split = "-"))))

  # evaluate the index range for each group
  ranges <- lapply(groupIndexes, FUN = function(x) x[1]:x[2])

  # specify groups for the heatmap
  type <- character(length(colnames(mol_pct_species_cols)))
  for(i in 1:ncol(groups)){
    type[unlist(ranges[colnames(groups)[i]])] <- colnames(groups)[i]
  }

  # insert row and col names to be used for the biplots
  rownames(mol_pct_species_cols) <- species
  colnames(mol_pct_species_cols) <- paste0(colnames(mol_pct_species_cols),"_",type)

  rownames(mol_pct_classes_cols) <- classes
  colnames(mol_pct_classes_cols) <- paste0(colnames(mol_pct_classes_cols),"_",type)



  pca_species <- prcomp(mol_pct_species_cols, scale=TRUE, center= TRUE)
  pca_classes <- prcomp(mol_pct_classes_cols, scale=TRUE, center= TRUE)


  #### scree plot for species and classes
  screePlot_species <- fviz_eig(pca_species)
  ggsave(screePlot_species, filename=paste0(pathToOutput, "/screePlot_species.png"), width = 40, height = 25, units = "cm")

  screePlot_classes <- fviz_eig(pca_classes)
  ggsave(screePlot_classes, filename=paste0(pathToOutput, "/screePlot_classes.png"), width = 40, height = 25, units = "cm")



  #### biplot for species and classes
  biplot_species <-fviz_pca_biplot(pca_species, repel = TRUE,
                  col.var = "#2E9FDF", # Variables color
                  col.ind = "#696969"  # Individuals color
  )
  ggsave(biplot_species, filename=paste0(pathToOutput, "/PCA_biplot_species.png"), width = 40, height = 25, units = "cm")

  biplot_classes <-fviz_pca_biplot(pca_classes, repel = TRUE,
                           col.var = "#2E9FDF", # Variables color
                           col.ind = "#696969"  # Individuals color
  )
  ggsave(biplot_classes, filename=paste0(pathToOutput, "/PCA_biplot_classes.png"), width = 40, height = 25, units = "cm")

}






groups <- read.csv("inst/extdata/groups.csv", as.is = TRUE)


data <- read.csv("results/dataTables/finalOutput_molPct.csv", stringsAsFactors = FALSE)
#colnames(data)



plotPCA(data, groups, pathToOutput = "/data/user/andre/lipidomics/lipidQuan/")








#fviz_pca_ind(pca,
#             col.ind = "cos2", # Color by the quality of representation
#             gradient.cols = c("yellow", "red"),
#             repel = TRUE,      # Avoid text overlapping
#             axes = c(1,2)
#)

#fviz_pca_ind(pca, label="none", habillage=species_class,
#             addEllipses=TRUE, ellipse.level=0.95, palette = "Dark2")


#fviz_pca_var(pca,
#             col.var = "contrib", # Color by contributions to the PC
#             gradient.cols = c("yellow", "red"),
#             repel = TRUE     # Avoid text overlapping
#)


