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
# save new version of mergeDataSets validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"../extdata/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset.
################################################################################################################
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#write.csv(t,"../extdata/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2 NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, multiply = 2)
#write.csv(t,"../extdata/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2
################################################################################################################
#list <- read.table("../extdata/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("../extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, database, correctionList = list, multiply = 2)
#write.csv(t,"../extdata/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of mergeDataSets validation dataset with user specified colnames
################################################################################################################
#list <- read.table("../extdata/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"../extdata/validation/mergedDataSets_userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with replicate filtering.
################################################################################################################
#dataPathTest <- read.table("../extdata/dataWithPrelicatesList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- filterReplicates(t,numberOfReplicates = 4, blnkReplicates = TRUE, numberOf..ancesThreshold = 2, thresholdValue = 0.005)
#write.csv(t,"../extdata/validation/mergedDataSets_replicateFiltering.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of sort_is validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
#write.csv(t,"../extdata/validation/sort_is.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of sort_is validation dataset
################################################################################################################
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("../extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, database)
#t <- sort_is(t)
#write.csv(t,"../extdata/validation/sort_is.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of filterDataSet validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"../extdata/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of filterDataSet validation dataset
################################################################################################################
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#write.csv(t,"../extdata/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of pmolCalc validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
#write.csv(t,"../extdata/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of pmolCalc validation dataset with LOQ calculated NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, LOQ = TRUE, fixedDeviation = 0)
#write.csv(t,"../extdata/validation/pmolCalc_LOQ.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of makeIndex_OH_DB_C validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
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

dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
t <- makeIndex_OH_DB_C(t, userSpecifiedColnames = list)
#write.csv(t[[1]],"../extdata/validation/indexDataOH.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[2]],"../extdata/validation/indexDataDB.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[3]],"../extdata/validation/indexDataC.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of makeFinalOutput validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
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
source("R/compactOutput_pmolCalc.R")
source("R/makeFinalOutput.R")

dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
classPmol_molPctClass <- compactOutput_pmolCalc(data = t, list)
t <- makeFinalOutput(classPmol_molPctClass, t)










################################################################################################################
# save new version of pmolCalc validation dataset
################################################################################################################
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25)
#write.csv(t,"../extdata/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of pmolCalc validation dataset with LOQ calculated
################################################################################################################
#dataPathTest <- read.table("../extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipids_DB_w_LOQ.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25, LOQ = TRUE, fixedDeviation = 0)
#write.csv(t,"../extdata/validation/pmolCalc_LOQ.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of pmolCalc validation dataset with replicate filtering DET HER ER IKKE REPLICATE DATA
################################################################################################################
#dataPathTest <- read.table("../extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

#data <- read.table("/data/user/andre/lipidomics/lipidQuan/../extdata/test/LQ_Training/mE518_Data_20171204/LCB-CD3-out.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")




#t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, numberOfReplicates = 4, blnkReplicates = FALSE, numberOf..ancesThreshold = 2, thresholdValue = 0.005)
#write.csv(t,"../extdata/validation/pmolCalc_replicateFiltering.csv", quote = FALSE, row.names = FALSE)


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
# save new version of pmolCalc validation dataset with replicate filtering
################################################################################################################
#dataPathTest <- read.table("../extdata/dataWithPrelicatesList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25, numberOfReplicates = 4, blnkReplicates = TRUE, numberOf..ancesThreshold = 2, thresholdValue = 0.005)
#write.csv(t,"../extdata/validation/pmolCalc_replicateFiltering.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of mergedFinalOutput validation data set
################################################################################################################
dataPathTest <- read.table("../extdata/finalOutputList.txt", stringsAsFactors = FALSE)[,1]
mergedFinalOutputs <- mergeFinalOutputs(dataPathTest)
#write.csv(mergedFinalOutputs,"../extdata/validation/mergedFinalOutputs.csv", quote = FALSE, row.names = FALSE)




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


dataPathTest <- read.table("../testData/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("../testData/DB/LP_DB_MS1_DAGMS2-TAG_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("../testData/DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)



ISTD_lipid_db$ISTD_CONC
ISTD_lipid_db$NAME







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




dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t, userSpecifiedColnames = list)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)


t_makeIndex <- makeIndex_OH_DB_C(t, userSpecifiedColnames = list)
#write.csv(t[[1]],"../extdata/validation/indexDataOH.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[2]],"../extdata/validation/indexDataDB.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[3]],"../extdata/validation/indexDataC.csv", quote = FALSE, row.names = FALSE)

classPmol_molPctClass <- compactOutput_pmolCalc(data = t, list)
t <- makeFinalOutput(classPmol_molPctClass, t)

