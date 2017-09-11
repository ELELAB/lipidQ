source("R/mergeDataSets.R")
source("R/sort_is.R")
source("R/filterDataSet.R")
source("R/pmolCalc.R")
source("R/mergeTableauDataSets.R")
source("R/readFile.R")
source("R/rmSpaceInBeginning.R")
source("R/setColnames.R")

################################################################################################################
# save new version of mergeDataSets validation dataset
################################################################################################################
dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database)
#write.csv(t,"data/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2
################################################################################################################
list <- read.table("data/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database, multiply = 2, list = list)
#write.csv(t,"data/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with user specified colnames
################################################################################################################
list <- read.table("data/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database, userSpecifiedColnames = list)
#write.csv(t,"data/validation/mergedDataSets_userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of sort_is validation dataset
################################################################################################################
dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database)
t <- sort_is(t)
#write.csv(t,"data/validation/sort_is.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of filterDataSet validation dataset
################################################################################################################
dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database)
t <- sort_is(t)
t <- filterDataSet(t,database)
#write.csv(t,"data/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of pmolCalc validation dataset
################################################################################################################
dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database)
t <- sort_is(t)
t <- filterDataSet(t,database)
t <- pmolCalc(t,database, 2, 0.25)
#write.csv(t,"data/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)





################################################################################################################
# save new version of tableauOutput validation data set
################################################################################################################
dataPathTest <- read.table("data/tableauList.txt", stringsAsFactors = FALSE)[,1]
mergedTableauDataSets <- mergeTableauDataSets(dataPathTest)
#write.csv(mergedTableauDataSets,"data/validation/mergedTableauDataSets.csv", quote = FALSE, row.names = FALSE)
