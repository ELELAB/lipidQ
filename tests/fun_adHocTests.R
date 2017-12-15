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
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"inst/extdata/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of mergeDataSets validation dataset.
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#write.csv(t,"inst/extdata/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2 NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, multiply = 2)
#write.csv(t,"inst/extdata/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2
################################################################################################################
#list <- read.table("inst/extdata/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, database, correctionList = list, multiply = 2)
#write.csv(t,"inst/extdata/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of mergeDataSets validation dataset with user specified colnames
################################################################################################################
#list <- read.table("inst/extdata/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"inst/extdata/validation/mergedDataSets_userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with replicate filtering.
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataWithPrelicatesList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- filterReplicates(t,numberOfReplicates = 4, blnkReplicates = TRUE, numberOfInstancesThreshold = 2, thresholdValue = 0.005)
#write.csv(t,"inst/extdata/validation/mergedDataSets_replicateFiltering.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of sort_is validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
#write.csv(t,"inst/extdata/validation/sort_is.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of sort_is validation dataset
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, database)
#t <- sort_is(t)
#write.csv(t,"inst/extdata/validation/sort_is.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of filterDataSet validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#write.csv(t,"inst/extdata/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of filterDataSet validation dataset
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#write.csv(t,"inst/extdata/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of pmolCalc validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
#write.csv(t,"inst/extdata/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of pmolCalc validation dataset with LOQ calculated NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, LOQ = TRUE, fixedDeviation = 0)
#write.csv(t,"inst/extdata/validation/pmolCalc_LOQ.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of makeIndex_OH_DB_C validation dataset NEW DATA SET WITH USERSPECIFIED COLNAMES.
################################################################################################################
dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
t <- makeIndex_OH_DB_C(t, userSpecifiedColnames = list)
#write.csv(t[[1]],"inst/extdata/validation/indexDataOH.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[2]],"inst/extdata/validation/indexDataDB.csv", quote = FALSE, row.names = FALSE)
#write.csv(t[[3]],"inst/extdata/validation/indexDataC.csv", quote = FALSE, row.names = FALSE)









################################################################################################################
# save new version of pmolCalc validation dataset
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25)
#write.csv(t,"inst/extdata/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of pmolCalc validation dataset with LOQ calculated
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipids_DB_w_LOQ.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25, LOQ = TRUE, fixedDeviation = 0)
#write.csv(t,"inst/extdata/validation/pmolCalc_LOQ.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of pmolCalc validation dataset with replicate filtering DET HER ER IKKE REPLICATE DATA
################################################################################################################
#dataPathTest <- read.table("inst/extdata/test/LQ_Training/dataList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

#data <- read.table("/data/user/andre/lipidomics/lipidQuan/inst/extdata/test/LQ_Training/mE518_Data_20171204/LCB-CD3-out.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")




#t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, numberOfReplicates = 4, blnkReplicates = FALSE, numberOfInstancesThreshold = 2, thresholdValue = 0.005)
#write.csv(t,"inst/extdata/validation/pmolCalc_replicateFiltering.csv", quote = FALSE, row.names = FALSE)


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
dataPathTest <- read.table("inst/extdata/dataWithReplicatesBlnkReplicatesList.txt", stringsAsFactors = FALSE)[,1]
endogene_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/LQ_Training/MS1_DB/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
list <- read.table("inst/extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- sort_is(data = t)
t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, numberOfReplicates = 3, blnkReplicates = TRUE, numberOfInstancesThreshold = 3, thresholdValue = 0.005)
#write.csv(t,"inst/extdata/validation/pmolCalc_replicateFiltering.csv", quote = FALSE, row.names = FALSE)
subset(t, select = c(SUBT_PMOL_PREC_07,SUBT_PMOL_PREC_08,SUBT_PMOL_PREC_09))


################################################################################################################
# save new version of pmolCalc validation dataset with replicate filtering
################################################################################################################
#dataPathTest <- read.table("inst/extdata/dataWithPrelicatesList.txt", stringsAsFactors = FALSE)[,1]
#endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#t <- sort_is(t)
#t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25, numberOfReplicates = 4, blnkReplicates = TRUE, numberOfInstancesThreshold = 2, thresholdValue = 0.005)
#write.csv(t,"inst/extdata/validation/pmolCalc_replicateFiltering.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of mergedFinalOutput validation data set
################################################################################################################
dataPathTest <- read.table("inst/extdata/finalOutputList.txt", stringsAsFactors = FALSE)[,1]
mergedFinalOutputs <- mergeFinalOutputs(dataPathTest)
#write.csv(mergedFinalOutputs,"inst/extdata/validation/mergedFinalOutputs.csv", quote = FALSE, row.names = FALSE)







