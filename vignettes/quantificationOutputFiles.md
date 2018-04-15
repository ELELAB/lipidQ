---
title: "Output files"
author: "André Vidas Olsen"
date: "2018-04-15"
output: html_document
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



# Introduction
This vignettes describes the different output files produced in the
quantification of intensity data made by using lipidQ.


### mergedDataSet.csv
This file contains all the input data merged together into one file. Only
relevant columns are put into this data, while unrelevant columns are discarded.

### filteredDataSet.csv
This data contains the merged data after filtering based on requirements from
the two databases.

### pmolCalculatedDataSet.csv
Contains relevant data with quantification columns.

### finalOutput_pmol.csv & finalOutput_molPct.csv
The finalOutput_pmol.csv file, contains the calculated pmol of all the lipids
that is detected, whereas finalOutput_molPct.csv file, contains pmol values
normalized mol% (total lipid pmol is 100% 100mol%). Every row that only contains
0's in all rows are removed.

### indexDataC, indexDataDB, and indexDataOH 
The 3 index data output files contains information about the number of Carbons
(indexDataC), double bonds (indexDataDB) and hydroxygroups (indexDataOH) within
the lipid chains.
