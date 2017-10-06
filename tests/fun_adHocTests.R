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

################################################################################################################
# save new version of mergeDataSets validation dataset.
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#t <- mergeDataSets(dataPathTest, database)
endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
#write.csv(t,"inst/extdata/validation/mergedDataSets.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with multiply = 2
################################################################################################################
list <- read.table("inst/extdata/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database, correctionList = list, multiply = 2)
#write.csv(t,"inst/extdata/validation/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = FALSE)


################################################################################################################
# save new version of mergeDataSets validation dataset with user specified colnames
################################################################################################################
list <- read.table("inst/extdata/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database, userSpecifiedColnames = list)
#write.csv(t,"inst/extdata/validation/mergedDataSets_userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE)




################################################################################################################
# save new version of sort_is validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, database)
t <- sort_is(t)
#write.csv(t,"inst/extdata/validation/sort_is.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of filterDataSet validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
t <- sort_is(t)
t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
#write.csv(t,"inst/extdata/validation/filteredDataSet.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of pmolCalc validation dataset
################################################################################################################
dataPathTest <- read.table("inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
#database <- read.table("inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
endogene_lipid_db <- read.table("inst/extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
ISTD_lipid_db <- read.table("inst/extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
t <- mergeDataSets(dataPathTest, endogene_lipid_db, ISTD_lipid_db)
t <- sort_is(t)
t <- filterDataSet(t, endogene_lipid_db, ISTD_lipid_db)
t <- pmolCalc(t,endogene_lipid_db, ISTD_lipid_db, NULL, 2, 0.25)
#write.csv(t,"inst/extdata/validation/pmolCalc.csv", quote = FALSE, row.names = FALSE)



################################################################################################################
# save new version of mergedFinalOutput validation data set
################################################################################################################
dataPathTest <- read.table("inst/extdata/finalOutputList.txt", stringsAsFactors = FALSE)[,1]
mergedFinalOutputs <- mergeFinalOutputs(dataPathTest)
#write.csv(mergedFinalOutputs,"inst/extdata/validation/mergedFinalOutputs.csv", quote = FALSE, row.names = FALSE)








## Remove SUMFA from data set
#t <- read.table("../inst/extdata/test/mE494_NEG_LP-out.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#head(t)
#drops <- c("SUMFA.mE494_NEG_01.raw","SUMFA.mE494_NEG_02.raw", "SUMFA.mE494_NEG_03.raw")
#t <- t[ , !(names(t) %in% drops)]
#write.csv(t, file = "../inst/extdata/test/mE494_NEG_LP-out.csv", quote = FALSE, row.names = F)


#t <- read.table("../inst/extdata/test/mE494_POS_LP-out.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#head(t)
#drops <- c("SUMFA.mE494_POS_01.raw","SUMFA.mE494_POS_02.raw", "SUMFA.mE494_POS_03.raw")
#t <- t[ , !(names(t) %in% drops)]
#write.csv(t, file = "../inst/extdata/test/mE494_POS_LP-out.csv", quote = FALSE, row.names = F)

#t <- read.table("../inst/extdata/test/mE494_POS_Chol-out.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#head(t)
#drops <- c("SUMFA.mE494_POS_01.raw","SUMFA.mE494_POS_02.raw", "SUMFA.mE494_POS_03.raw")
#t <- t[ , !(names(t) %in% drops)]
#write.csv(t, file = "../inst/extdata/test/mE494_POS_Chol-out.csv", quote = FALSE, row.names = F)





# find negative values
#te1 <- read.table("inst/extdata/test/results/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#subset(te1, FRAG1_01 < 0)
#te1$FRAG1_01
#te2 <- read.table("inst/extdata/test/results/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#subset(te2, PREC_02 < 0)
#te3 <- read.table("inst/extdata/test/results/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
#subset(te3, FRAG1_01 < 0)

