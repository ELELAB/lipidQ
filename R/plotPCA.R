#' @title Plot Heatmap
#' @author André Vidas Olsen
#' @description This function plots the following PCA plots: screeplot and
#' biplot
#' @param data quantified data to be visualized (finalOutput_molPct.csv)
#' @param sampleTypes file that associates column names of MS1 with sampleTypes
#' @param pathToOutput the directory path to save the plots
#' @param log2 logical argument that specifies whether or not data has to be
#' log2 transformed
#' @param pseudoCount pseudo count added to the data if the data is log2
#' transformed in order to avoid negative infinite values in the data
#' @importFrom factoextra fviz_eig fviz_pca_biplot
#' @importFrom stats prcomp
#' @return four plot images: a scree plots (screePlot_species.png &
#' screePlot_classes.png) and a biplot (PCA_biplot_species.png &
#' PCA_biplot_classes.png) for both species and classes.
#' @export
#' @examples
#' # load sample types file and data to be used for visualization
#' sampleTypes <- read.csv(system.file("extdata", "sampleTypes.csv",
#'  package = "lipidQ"), stringsAsFactors = FALSE)
#'
#' data <- read.csv(system.file("extdata/dataTables/checks",
#'  "finalOutput_molPct.csv", package = "lipidQ"), stringsAsFactors = FALSE)
#'
#' # create pca scree and biplot from log2 transformed data with 0.0001 added
#' # pseudo counts
#' plotPCA(data, sampleTypes, pathToOutput = "", log2 = TRUE,
#'  pseudoCount = 0.0001)
plotPCA <- function(data, sampleTypes, pathToOutput = "", log2 = FALSE,
                    pseudoCount = NULL){

  # insert a "/" in the pathToOutput if used to ensure that the folder name is
  # separated from the file name
  if(pathToOutput != ""){
    pathToOutput <- paste0(pathToOutput, "/")
  }


  # check that no Inf/-Inf/NA exists in the data and throw an error message if
  # the data contains these values.
  if(any(data == Inf | data == -Inf | is.na(data))){
    stop(paste0("ERROR!! The data contains NA/NaN or infinite values. Please ",
      "remove these from the data set and try again."))
  }

  # log2 transformation of data if specified by the user
  if(log2){
    data[,2:ncol(data)] <- log2(data[,2:ncol(data)] + pseudoCount)
  }


  # select relevant columns in data (mol procent species & mol procent classes)
  mol_pct_species_cols <- data[grep(":",data$"molPct"),2:ncol(data)]
  mol_pct_classes_cols <- data[-grep(":",data$"molPct"),2:ncol(data)]

  species <- data[grep(":",data$"molPct"),1]
  classes <- data[-grep(":",data$"molPct"),1]



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

  # insert row and col names to be used for the biplots
  rownames(mol_pct_species_cols) <- species
  colnames(mol_pct_species_cols) <-
    paste0(colnames(mol_pct_species_cols),"_",type)

  rownames(mol_pct_classes_cols) <- classes
  colnames(mol_pct_classes_cols) <-
    paste0(colnames(mol_pct_classes_cols),"_",type)



  pca_species <- prcomp(mol_pct_species_cols, scale=TRUE, center= TRUE)
  pca_classes <- prcomp(mol_pct_classes_cols, scale=TRUE, center= TRUE)


  #### scree plot for species and classes
  screePlot_species <- fviz_eig(pca_species)
  ggsave(screePlot_species,
         filename=paste0(pathToOutput, "screePlot_species.png"), width = 40,
         height = 25, units = "cm")

  screePlot_classes <- fviz_eig(pca_classes)
  ggsave(screePlot_classes, filename=paste0(pathToOutput,
            "screePlot_classes.png"), width = 40, height = 25, units = "cm")



  #### biplot for species and classes
  biplot_species <-fviz_pca_biplot(pca_species, repel = TRUE,
                  col.var = "#2E9FDF", # Variables color
                  col.ind = "#696969"  # Individuals color
  )
  ggsave(biplot_species, filename=paste0(pathToOutput,
              "PCA_biplot_species.png"), width = 40, height = 25, units = "cm")

  biplot_classes <-fviz_pca_biplot(pca_classes, repel = TRUE,
                           col.var = "#2E9FDF", # Variables color
                           col.ind = "#696969"  # Individuals color
  )
  ggsave(biplot_classes, filename=paste0(pathToOutput,
              "PCA_biplot_classes.png"), width = 40, height = 25, units = "cm")

}



