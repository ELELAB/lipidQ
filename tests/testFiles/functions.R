setwd("/data/user/andre/lipidomics/lipidQuan/R")

test.rmSpaceInBeginning <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # input: data.frame
  dataFrameTest <- data.frame(NAME = c(" hej", "med ", "dig"), SPECIE = c(" din", "smu kke", "  dukke"),stringsAsFactors = FALSE)
  dataFrameVali <- data.frame(NAME = c("hej", "med ", "dig"), SPECIE = c("din", "smu kke", " dukke"),stringsAsFactors = FALSE)
  checkEquals(rmSpaceInBeginning(dataFrameTest), dataFrameVali)
}


test.mergeDataSets <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- mergeDataSets(dataPathTest, database)
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/mergedDataSets.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeDataSets_multiply_2 <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  list <- read.table("../inst/extdata/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- mergeDataSets(dataPathTest, database, correctionList = list, multiply = 2)
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/mergedDataSets_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/mergedDataSets_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeDataSets_userSpecifiedColnames <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  list <- read.table("../inst/extdata/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- mergeDataSets(dataPathTest, database, userSpecifiedColnames = list)
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/mergedDataSets_userSpecifiedColnames.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/mergedDataSets_userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/mergedDataSets_userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}



test.sort_is <- function(){
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- sort_is(mergeDataSets(dataPathTest, database))
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/sort_is.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.filterDataSet <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- filterDataSet(sort_is(mergeDataSets(dataPathTest, database)), database)
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/filteredDataSet.csv", quote = FALSE, row.names = F)

  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.pmolCalc <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../inst/extdata/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- pmolCalc(filterDataSet(sort_is(mergeDataSets(dataPathTest, database)), database),database, userSpecifiedColnames = NULL, 2, 0.25)
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/pmolCalc.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeFinalOutputs <- function() {
  #DEACTIVATED('This function does not work at the moment...')

  # make test data.frame and save
  dataPathTest <- read.table("../inst/extdata/finalOutputList.txt", stringsAsFactors = FALSE)[,1]
  dataFrameTest <- mergeFinalOutputs(dataPathTest)
  write.csv(dataFrameTest, file = "../inst/extdata/test/results/mergedFinalOutputs.csv", quote = FALSE, row.names = F)


  # load test and validation data.frame
  dataFrameTest <- read.table("../inst/extdata/test/results/mergedFinalOutputs.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../inst/extdata/validation/mergedFinalOutputs.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")

  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}
