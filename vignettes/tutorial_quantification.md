---
title: "Tutorial: Quantification"
author: "André Vidas Olsen"
date: "2018-04-15"
output: html_document
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



#Introduction
This tutorial will cover all the basic steps involved in lipidQ
quantification analysis of lipidomics data from loading the input data to the
creation of the results.

#Data
The data for this tutorial will consist of the following files:

1. Input data files
2. Endgogene & ISTD databases
3. User specified column names file

For convenience in tutorial, all these files are already made and ready to use.
However, when a new project needs to be analysed, the user has to create both
user specified column names files as well as endogene & ISTD databases. See the
Global Options tutorial to get a detailed description of how to create these
files. 

#Step 1: open LipidQ
Start by open up LipidQ. This can be done by doing these 3 steps:

1. Open Rstudio

2. Write "library(lipidQ)"

3. Write "runLipidQ()"

If the web browser encounters problems doing any of the steps in the tutorial,
LipidQ can also be open by going to:

```
#> [1] "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/lipidQ/app/"
```
, open either ui.R or server.R and hit the Run button at the right top corner of
Rstudio. 


#Step 2: load data into LipidQ
After opening LipidQ, the operation tab will start at the Quantification tab.
In this tab section, start by choosing the input file to be used by clicking on
the "Browse..." button below "Choose the input data sets (.csv-files)". For this
tutorial we will be using the following files: 

mE504_NEG_High-out.csv

mE504_NEG_Low-out.csv

mE504_POS_High-out.csv

mE504_POS_Low-out.csv

These files are located in the following folder:  

```
#> [1] "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/lipidQ/extdata/mE504_Data/"
```
Go to this folder and select these 4 files and click "Open".


Next, the endogene and ISTD databases has to be chosen for the project. Click on
the "Browse..." buttons below "Choose the endogene lipid database (.csv-file)"
and "Choose ISTD lipid database (.csv-file)" to do so. The database files are
located in the following folder:

```
#> [1] "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/lipidQ/extdata/LipidQ_DataBase"
```

The endogene database is called LP_DB_MS1_v1.csv and the ISTD database is called
ISTD_LP_DB_MS1_v1.csv.


Lastly, the user specified column names file called userSpecifiedColnames.csv
also has to be chosen, by the clicking "Browse..." button below "Choose user
specified column names (.csv-file)". The user specified column names file is
located in the same folder as the two database files.


#Step 3: set parameters
###Replicates
The next step in the analysis is to set the parameters properly to the data. The
first thing that we have to define is the number of replicates in the data. For
this data, there is only one extract per sample, hence one replicate, which is
the sample itself. Therefore we set the value to 1 (default). In this section we
can also specify whether the blanks contains replicates under the "Blank
contains replicate" box. We'll leave the box unchecked since the blank does not
contain replicates. Since we don't have replicates, the last two fields in the
replicate section ("Number of instances threshold" and "Threshold of instance")
will not affect the calculation, so we'll leave these unchanged as well.



###LOQ
The next section deals with the limit of quantification threshold, which are
defined in the two databases. The field consists of a checkbox defining if we
want LOQ to filter the data quantification results, and field for specifiyng if
we want to have a fixed deviation on the defined LOQ which should be the new
threshold. In this case we simply want LOQ without the fixed deviation, so we
check the "LOQ activated" checkbox.


###Multiplication of MS1 columns
With our data set, we don't need to correct lipids with a multiplication factor,
so we'll leave the "Multiply MS1 columns by a factor (for LipidX users)"
checkbox unmarked.



###Spike ISTD
In this section, we'll specify the parameter for spike ISTD. We'll set the value
to 10.

###Zero threshold
The last parameter is a threshold for rounding to zero for mol% species (see the
parameter vignette for more info). We'll set that to 0.001 (default)


#QC plots
LipidQ offers the possibility to create quality control (QC) plots both
before and after quantification of the intensity data. Here we'll select both
before (pre) and after (post) QC plots by marking the checkboxes "Create QC
plots of MS1 intensity data" and "Create QC plots of class pmol data".

#Output folder
Lastly, the folder where the output files should be saved to has to be defined.
Write here the filepath to where you wish to save the files. The following
describes how to obtain the full path:

From Mac OS X El Capitan 2015 onwards (As of February 2018): Go to the folder of
interest, right click on the folder, press the alt button + click on 'Copy
"folder-name" as Pathname'. Go back to LipidQ and paste the folder path
(&#8984; Command button + V) into the output folder field.

Windows: Go to the folder of interest, right click on the folder, go to
properties, find Location and copy the path there (Ctrl + C). Go back to
LipidQ and paste the full path (Ctrl + V) into the output folder field.
Remember to change every "\\" in the path to "/". 

After this is done, press "Run Analysis" to start the quantification.

#Results
After quantification, LipidQ will write "Quantification done!" below the "Run
Analysis" button. After this all output files will be available in the chosen
folder. Let's have a look at it. 

###Data sets
All the calculated data sets will be stored in folder named "dataTables" within
the chosen output folder. This folder contains the following output files:

mergedDataSets.csv: This file contains all the input data merged together into
one file. Only relevant columns are put into this data, while unrelevant columns
are discarded.

filteredDataSet.csv: This data contains the merged data after filtering based on
requirements from the two databases.

pmolCalculatedDataSet.csv: Contains relevant data with quantification columns.

finalOutput_molPct.csv: Contains mol% of (MESUT) for each sample.

finalOutput_pmol.csv:

indexDataC.csv (MESUT)
indexDataDB.csv (MESUT)
indexDataOH.csv (MESUT)



###Plots
The plots are saved into two folders: one called "pre" which contains intensity
QC plots and one called "post" which contains quantification QC plots. (MAYBE
CALL IN intensity_QC AND quantification_QC).


