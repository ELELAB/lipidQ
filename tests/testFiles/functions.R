setwd("/data/user/andre/lipidomics/lipidQ/R")

test.rmSpaceInBeginning <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # input: data.frame
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- data.frame(NAME = c(" hej", "med ", "dig"), SPECIE = c(" din", "smu kke", "  dukke"),stringsAsFactors = FALSE)
  dataFrameVali <- data.frame(NAME = c("hej", "med ", "dig"), SPECIE = c("din", "smu kke", " dukke"),stringsAsFactors = FALSE)
  checkEquals(rmSpaceInBeginning(dataFrameTest, userSpecifiedColnames = list), dataFrameVali)
}


test.mergeDataSets <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  dataFrameTest <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
  write.csv(dataFrameTest, file = "../tests/data/test/mergedDataSets.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../tests/data/test/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../tests/data/validation/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeDataSets_multiply_2 <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  dataFrameTest <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, correctionList = list, multiply = 2)
  write.csv(dataFrameTest, file = "../tests/data/test/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = F)



  # load test and validation data.frame
  dataFrameTest <- read.table("../tests/data/test/mergedDataSets_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../tests/data/validation/mergedDataSets_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}





test.sort_is <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")



  dataFrameTest <- sort_is(mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), userSpecifiedColnames = list)
  write.csv(dataFrameTest, file = "../tests/data/test/sort_is.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../tests/data/test/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../tests/data/validation/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.filterDataSet <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  dataFrameTest <- filterDataSet(sort_is(mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
  write.csv(dataFrameTest, file = "../tests/data/test/filteredDataSet.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../tests/data/test/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../tests/data/validation/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.pmolCalc <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  dataFrameTest <- pmolCalc(filterDataSet(sort_is(mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), endogene_lipid_db =  endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD =  2, zeroThresh = 0.25)
  write.csv(dataFrameTest, file = "../tests/data/test/pmolCalc.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest <- read.table("../tests/data/test/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../tests/data/validation/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.pmolCalc_LOQ <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  dataFrameTest <- pmolCalc(filterDataSet(sort_is(mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, LOQ = TRUE, fixedDeviation = 0)

  write.csv(dataFrameTest, file = "../tests/data/test/pmolCalc_LOQ.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest <- read.table("../tests/data/test/pmolCalc_LOQ.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../tests/data/validation/pmolCalc_LOQ.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.pmolCalc_replicateFilteringSingleBlnk <- function(){
  DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  #dataPathTest <- read.table("../../extdata/dataWithPrelicatesList.txt", stringsAsFactors = FALSE)[,1]
  #endogene_lipid_db <- read.table("../../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  #ISTD_lipid_db <- read.table("../../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  dataPathTest <- read.table("../../extdata/dataWithReplicatesSingleBlnkList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../../extdata/test/endogene_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../../extdata/test/ISTD_lipid_db.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../../extdata/test/LQ_Training/MS1_DB/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  dataFrameTest <- pmolCalc(filterDataSet(sort_is(mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25, numberOfReplicates = 4, blnkReplicates = FALSE, numberOfInstancesThreshold = 2, thresholdValue = 0.005)
  write.csv(dataFrameTest, file = "../../extdata/test/results/pmolCalc_replicateFiltering_singleBlank.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../../extdata/test/results/pmolCalc_replicateFiltering_singleBlank.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../../extdata/validation/pmolCalc_replicateFiltering_singleBlank.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}




test.makeIndex_OH_DB_C <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  dataFrameTest <- pmolCalc(filterDataSet(sort_is(mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list), endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
  dataFrameTest <- makeIndex_OH_DB_C(dataFrameTest, userSpecifiedColnames = list)
  write.csv(dataFrameTest[[1]], file = "../tests/data/test/indexDataOH.csv", quote = FALSE, row.names = F)
  write.csv(dataFrameTest[[2]], file = "../tests/data/test/indexDataDB.csv", quote = FALSE, row.names = F)
  write.csv(dataFrameTest[[3]], file = "../tests/data/test/indexDataC.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest1 <- read.table("../tests/data/test/indexDataOH.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest2 <- read.table("../tests/data/test/indexDataDB.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest3 <- read.table("../tests/data/test/indexDataC.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  dataFrameVali1 <- read.table("../tests/data/validation/indexDataOH.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali2 <- read.table("../tests/data/validation/indexDataDB.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali3 <- read.table("../tests/data/validation/indexDataC.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest1, dataFrameVali1)
  checkEquals(dataFrameTest2, dataFrameVali2)
  checkEquals(dataFrameTest3, dataFrameVali3)
}


test.makeFinalOutput <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  endogene_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  ISTD_lipid_db <- read.table("../inst/extdata/LipidQ_DataBase/ISTD_LP_DB_MS1_v1.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  list <- read.table("../inst/extdata/LipidQ_DataBase/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")


  t <- mergeDataSets(dataList = dataPathTest, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
  t <- sort_is(t, userSpecifiedColnames = list)
  t <- filterDataSet(data = t, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list)
  t <- pmolCalc(data = t,endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = list, spikeISTD = 2, zeroThresh = 0.25)
  classPmol_molPctClass <- compactOutput_pmolCalc(data = t, list)
  dataFrameTest <- makeFinalOutput(classPmol_molPctClass, t, userSpecifiedColnames = list)
  write.csv(dataFrameTest[[1]], file = "../tests/data/test/finalOutput_molPct.csv", quote = FALSE, row.names = F)
  write.csv(dataFrameTest[[2]], file = "../tests/data/test/finalOutput_pmol.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest1 <- read.table("../tests/data/test/finalOutput_molPct.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest2 <- read.table("../tests/data/test/finalOutput_pmol.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  dataFrameVali1 <- read.table("../tests/data/validation/finalOutput_molPct.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali2 <- read.table("../tests/data/validation/finalOutput_pmol.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest1, dataFrameVali1)
  checkEquals(dataFrameTest2, dataFrameVali2)
}


test.mergeFinalOutputs <- function() {
  DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../../extdata/finalOutputList.txt", stringsAsFactors = FALSE)[,1]
  dataFrameTest <- mergeFinalOutputs(dataPathTest)
  write.csv(dataFrameTest, file = "../../extdata/test/results/mergedFinalOutputs.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest <- read.table("../../extdata/test/results/mergedFinalOutputs.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../../extdata/validation/mergedFinalOutputs.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}
