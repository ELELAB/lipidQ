setwd("/data/user/andre/lipidomics/lipidQuan")
source("R/mergeDataSets.R")
source("R/sort_is.R")
source("R/filterDataSet.R")
source("R/pmolCalc.R")
source("R/mergeFinalOutputs.R")
source("R/readFile.R")
source("R/rmSpaceInBeginning.R")
source("R/getColnames.R")
source("R/merge_endo_and_ISTD_db.R")
source("R/filterReplicates.R")
source("R/makeIndex_OH_DB_C.R")
source("R/compactOutput_pmolCalc.R")
source("R/makeFinalOutput.R")




################################################################################################################
# save new version of mergeDataSets validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"tests/data/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, multiply = 2)
#write.csv(t,"tests/data/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of sort_is validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
#write.csv(t,"tests/data/validation/sort_is.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of filterDataSet validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"tests/data/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of pmolCalc validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
#write.csv(t,"tests/data/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of pmolCalc validation dataset with LOQ calculated
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, LOQ = TRUE, fixedDeviation = 0)
#write.csv(t,"tests/data/validation/pmolCalc_LOQ.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of makeIndex_OH_DB_C validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
t <- makeIndex_OH_DB_C(t, userSpecifiedColnames = list)
#write.csv(t[[1]],"tests/data/validation/indexDataOH.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[2]],"tests/data/validation/indexDataDB.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[3]],"tests/data/validation/indexDataC.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of makeFinalOutput validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
classPmol_molPctClass <- compactOutput_pmolCalc(data = t, list)
t <- makeFinalOutput(classPmol_molPctClass, t, userSpecifiedColnames = list)
#write.csv(t[[1]],"tests/data/validation/finalOutput_molPct.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[2]],"tests/data/validation/finalOutput_pmol.csv", quote = FALSE, row.names = FALSE)





############################################################################################################
#END END END END END END END END END END END END END END END END END END END END END END END END END END END
############################################################################################################































setwd("/data/user/andre/lipidomics/lipidQuan")
source("R/mergeDataSets.R")
source("R/sort_is.R")
source("R/filterDataSet.R")
source("R/pmolCalc.R")
source("R/mergeFinalOutputs.R")
source("R/readFile.R")
source("R/rmSpaceInBeginning.R")
source("R/getColnames.R")
source("R/merge_endo_and_ISTD_db.R")
source("R/filterReplicates.R")


################################################################################################################
# save new version of pmolCalc validation dataset with replicate filtering (blnk replicates) NEW DATA SET
################################################################################################################
dataPathTest <- read.table("../extdata/dataWithReplicatesBlnkReplicatesList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(data = t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, numberOfReplicates = 3, blnkReplicates = TRUE, numberOf..ancesThreshold = 3, thresholdValue = 0.005)
#write.csv(t,"../extdata/validation/pmolCalc_replicateFiltering.csv", quote = FALSE, row.names = FALSE)
subset(t, select = c(SUBT_PMOL_PREC_07,SUBT_PMOL_PREC_08,SUBT_PMOL_PREC_09))













################################################################################################################
# user guide example
################################################################################################################
setwd("/data/user/andre/lipidomics/lipidQuan")
source("R/mergeDataSets.R")
source("R/sort_is.R")
source("R/filterDataSet.R")
source("R/pmolCalc.R")
source("R/mergeFinalOutputs.R")
source("R/readFile.R")
source("R/rmSpaceInBeginning.R")
source("R/getColnames.R")
source("R/merge_endo_and_ISTD_db.R")
source("R/filterReplicates.R")
source("R/makeIndex_OH_DB_C.R")
source("R/compactOutput_pmolCalc.R")
source("R/makeFinalOutput.R")

data <- read.csv(system.file("extdata/LipidQ_DataBase/userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE)
data[1,] <- "TYPE_NAME_HERE"

dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, LOQ = TRUE)

t[t$NAME == "PC 38:6","SUBT_PMOL_SAMPLE_04" ]

subset(t, select = c("NAME","PREC_01", "PREC_02", "PREC_03"))

#write.csv(t, file = "test_results.csv")

t$CLASS_PMOL_SUBT_PMOL_SAMPLE_01

head(t, n = 50)

t_makeIndex <- makeIndex_OH_DB_C(t, userSpecifiedColnames = list)
#write.csv(t[[1]],"../extdata/validation/indexDataOH.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[2]],"../extdata/validation/indexDataDB.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[3]],"../extdata/validation/indexDataC.csv", quote = FALSE, row.names = FALSE)

classPmol_molPctClass <- compactOutput_pmolCalc(data = t, list)
t <- makeFinalOutput(classPmol_molPctClass, t)




#### FOR MANUALS IN THE R PACKAGE

#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table(system.file("extdata/LipidQ_DataBase", "LP_DB_MS1_v1.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table(system.file("extdata/LipidQ_DataBase", "ISTD_LP_DB_MS1_v1.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
userSpecifiedColnames <- read.table(system.file("extdata/LipidQ_DataBase", "userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
mergedDataSetsIsSorted <- read.table(system.file("extdata/dataTables", "mergedDataSetsIsSorted.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
filteredDatasets <- read.table(system.file("extdata/dataTables", "filteredDataSet.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")
pmolCalculatedDataSet <- read.table(system.file("extdata/dataTables", "pmolCalculatedDataSet.csv", package = "lipidQuan"), stringsAsFactors = FALSE, header = TRUE, sep = ",")


#t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
sort_is <- sort_is(mergedDataSets, userSpecifiedColnames = list)
filteredDatasets <- filterDataSet(data = mergedDataSetsIsSorted, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames)
pmolCalculatedDataSet <- pmolCalc(data = filteredDatasets, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames, spikeISTD = 2, zeroThresh = 0.25)
