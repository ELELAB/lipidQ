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
  dataPathTest <- read.table("../data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- mergeDataSets(dataPathTest, database)
  write.csv(dataFrameTest, file = "../data/test/results/mergedDataSets.csv", quote = FALSE, row.names = F)
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeDataSets_multiply_2 <- function(){
  #DEACTIVATED('This function does not work at the moment...')
  
  # make test data.frame and save
  list <- read.table("../data/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
  dataPathTest <- read.table("../data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- mergeDataSets(dataPathTest, database, multiply = 2, list = list)
  write.csv(dataFrameTest, file = "../data/test/results/mergedDataSets_multiply_2.csv", quote = FALSE, row.names = F)
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/mergedDataSets_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/mergedDataSets_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeDataSets_userSpecifiedColnames <- function(){
  #DEACTIVATED('This function does not work at the moment...')
  
  # make test data.frame and save
  list <- read.table("../data/test/userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataPathTest <- read.table("../data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- mergeDataSets(dataPathTest, database, userSpecifiedColnames = list)
  write.csv(dataFrameTest, file = "../data/test/results/mergedDataSets_userSpecifiedColnames.csv", quote = FALSE, row.names = F)
  
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/mergedDataSets_userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/mergedDataSets_userSpecifiedColnames.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}



test.sort_is <- function(){
  #DEACTIVATED('This function does not work at the moment...')
  
  # make test data.frame and save
  dataPathTest <- read.table("../data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- sort_is(mergeDataSets(dataPathTest, database))
  write.csv(dataFrameTest, file = "../data/test/results/sort_is.csv", quote = FALSE, row.names = F)
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.filterDataSet <- function() {
  #DEACTIVATED('This function does not work at the moment...')
  
  # make test data.frame and save
  dataPathTest <- read.table("../data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- filterDataSet(sort_is(mergeDataSets(dataPathTest, database)), database)
  write.csv(dataFrameTest, file = "../data/test/results/filteredDataSet.csv", quote = FALSE, row.names = F)
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/filteredDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.pmolCalc <- function() {
  #DEACTIVATED('This function does not work at the moment...')
  
  # make test data.frame and save
  dataPathTest <- read.table("../data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("../data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameTest <- pmolCalc(filterDataSet(sort_is(mergeDataSets(dataPathTest, database)), database),database, 2, 0.25)
  write.csv(dataFrameTest, file = "../data/test/results/pmolCalc.csv", quote = FALSE, row.names = F)
  
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


test.mergeTableauDataSets <- function() {
  #DEACTIVATED('This function does not work at the moment...')
  
  # make test data.frame and save
  dataPathTest <- read.table("../data/tableauList.txt", stringsAsFactors = FALSE)[,1]
  dataFrameTest <- mergeTableauDataSets(dataPathTest)
  write.csv(dataFrameTest, file = "../data/test/results/mergedTableauDataSets.csv", quote = FALSE, row.names = F)
  
  
  # load test and validation data.frame
  dataFrameTest <- read.table("../data/test/results/mergedTableauDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("../data/validation/mergedTableauDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  
  # validate
  checkEquals(dataFrameTest, dataFrameVali)
}


#test.generic <- function() {

# input: data.frame
#dataFrameTest <- data.frame(NAME = c(" hej", "med ", "dig"), SPECIE = c(" din", "smu kke", "  dukke"),stringsAsFactors = FALSE)
#dataFrameVali <- data.frame(NAME = c("hej", "med ", "dig"), SPECIE = c("din", "smu kke", " dukke"),stringsAsFactors = FALSE)
#checkEquals(rmSpaceInBeginning(dataFrameTest), dataFrameVali)

# input: decimal numbers
#checkEqualsNumeric(divideBy(4.1, 1.2345), 3.321, tolerance=1.0e-4)

# 0 as denominator, check for NA output
#checkTrue(is.na(divideBy(4, 0)))

# input: character, check for exception handling
#checkException(divideBy("xx",2), silent = TRUE)
#checkException(divideBy(2,"xx"), silent = TRUE)

#DEACTIVATED('This function does not work at the moment...')
#}
