% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotPCA.R
\name{plotPCA}
\alias{plotPCA}
\title{Plot Heatmap}
\usage{
plotPCA(data, sampleTypes, pathToOutput = "", log2 = FALSE,
  pseudoCount = NULL)
}
\arguments{
\item{data}{quantified data to be visualized (finalOutput_molPct.csv)}

\item{sampleTypes}{file that associates column names of MS1 with sampleTypes}

\item{pathToOutput}{the directory path to save the plots}

\item{log2}{logical argument that specifies whether or not data has to be
log2 transformed}

\item{pseudoCount}{pseudo count added to the data if the data is log2
transformed in order to avoid negative infinite values in the data}
}
\value{
four plot images: a scree plots (screePlot_species.png &
screePlot_classes.png) and a biplot (PCA_biplot_species.png &
PCA_biplot_classes.png) for both species and classes.
}
\description{
This function plots the following PCA plots: screeplot and
biplot
}
\examples{
# load sample types file and data to be used for visualization
sampleTypes <- read.csv(system.file("extdata", "sampleTypes.csv",
 package = "lipidQ"), stringsAsFactors = FALSE)

data <- read.csv(system.file("extdata/dataTables/checks",
 "finalOutput_molPct.csv", package = "lipidQ"), stringsAsFactors = FALSE)

# create pca scree and biplot from log2 transformed data with 0.0001 added
# pseudo counts
plotPCA(data, sampleTypes, pathToOutput = "", log2 = TRUE,
 pseudoCount = 0.0001)
}
\author{
André Vidas Olsen
}
