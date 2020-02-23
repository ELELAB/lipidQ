
*Computational Biology Laboratory, Danish Cancer Society Research Center, Strandboulevarden 49, 2100, Copenhagen, Denmark*

if you use lipidQ please cite: Comprehensive Evaluation of a Quantitative Shotgun Lipidomics Platform for Mammalian Sample Analysis on a High-Resolution Mass Spectrometer.
Inger Ødum Nielsen, André Vidas Olsen, Jano Dicroce Giacobini, Elena Papaleo, Klaus Kaae Andersen, Marja Jäättelä, Kenji Maeda, and Mesut Bilgin J. Am. Soc. Mass Spectrom., Just Accepted Manuscript  DOI:
10.1021/jasms.9b00136 

correspondance on the tool: Elena Papaleo, elenap-at-cancer.dk


# LipidQ 
### An R/Bioconductor package quantification and visualization of lipidomics data

#### Installation

- From GitHub:

```R
devtools::install_github(repo = "ELELAB/LipidQ")
```

- From Bioconductor:

```R
# try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
biocLite("LipidQ")
```

- From source:

Once the user has cloned the repository locally, the package can be installed providing the path of the LipidQ repository on the local computer:

```R
install.packages("path_to_dir", repos=NULL, type="source")

```

where `path_to_dir` is the path to the repository. 

#### Requirements

Please refer to the `DESCRIPTION` file for details on the dependencies from other packages.
The user will need to install some of the manually before installing LipidQ.

#### Notes

We provide a dataset to use as an example to apply the different functionalities of the tool, 
along with the package. This dataset contains biological replicates of mouse tissue and serum samples.




