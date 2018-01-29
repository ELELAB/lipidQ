# adapted from /data/user/andre/NilsProject/SP21_NormalizedValues_LabRunInfo_2016-11-15/setupData.R
rm(list=ls(all=TRUE))
library(ggplot2)

# LipidQuan PCAplot
library(factoextra)



plotPCA <- function(data, groups){
  # specify start and end index for each group
  groupIndexes <- lapply(groups[1,], FUN = function(x) as.numeric(unlist(strsplit(x, split = "-"))))

  # evaluate the index range for each group
  ranges <- lapply(groupIndexes, FUN = function(x) x[1]:x[2])

  # specify groups for the heatmap
  type <- character(length(colnames(mol_pct_species_cols)))
  for(i in 1:ncol(groups)){
    type[unlist(ranges[colnames(groups)[i]])] <- colnames(groups)[i]
  }

  # select relevant columns in data (mol procent species & mol procent classes)
  mol_pct_species_cols <- data[grep(":",data$mol.),2:ncol(data)]
  mol_pct_classes_cols <- data[-grep(":",data$mol.),2:ncol(data)]

  species <- data[grep(":",data$mol.),1]
  #classes <- data[-grep(":",data$mol.),1]

  rownames(mol_pct_species_cols) <- species
  colnames(mol_pct_species_cols) <- paste0(colnames(mol_pct_species_cols),"_",type)
  #species_class <- sapply(species, FUN = function(x) unlist(strsplit(x, " "))[1])

  #rownames(mol_pct_classes_cols) <- classes


  pca <- prcomp(mol_pct_species_cols, scale=TRUE, center= TRUE)
  #pca <- prcomp(mol_pct_classes_cols, scale=TRUE, center= TRUE)


  png(file = "/data/user/andre/lipidomics/lipidQuan/screePlot.png", height = 800, width = 1300)
  fviz_eig(pca)
  dev.off()

  t<-fviz_pca_biplot(pca, repel = TRUE,
                  col.var = "#2E9FDF", # Variables color
                  col.ind = "#696969"  # Individuals color
  )

  ggsave(t, filename = "/data/user/andre/lipidomics/lipidQuan/PCA_biplot.png", width = 40, height = 25, units = "cm")



}






groups <- read.csv("inst/extdata/groups.csv", as.is = TRUE)


data <- read.csv("results/dataTables/finalOutput_molPct.csv", stringsAsFactors = FALSE)
colnames(data)



plotPCA(data, groups)








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


