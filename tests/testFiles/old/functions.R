test.rmSpaceInBeginning <- function() {
  #DEACTIVATED('This function does not work at the moment...')
  
  # input: data.frame
  dataFrameTest <- data.frame(NAME = c(" hej", "med ", "dig"), SPECIE = c(" din", "smu kke", "  dukke"),stringsAsFactors = FALSE)
  dataFrameVali <- data.frame(NAME = c("hej", "med ", "dig"), SPECIE = c("din", "smu kke", " dukke"),stringsAsFactors = FALSE)
  checkEquals(rmSpaceInBeginning(dataFrameTest), dataFrameVali)
  

}


test.mergeDataSets <- function(){
  #DEACTIVATED('This function does not work at the moment...')
  
  #
  dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("data/test/Temporary_DataBase_V3.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("data/validation/mergedDataSets.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  checkEquals(mergeDataSets(dataPathTest, database), dataFrameVali)
  
  # with multiply = 2
  #list <- read.table("data/test/Correction_List.csv", stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
  #dataFrameVali <- read.table("data/validation/mergeDataSets_w_multiply_2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",", row.names = 1)
  #checkEquals(mergeDataSets(dataPathTest, database, multiply = 2, list = list), dataFrameVali)
  

}

test.sort_is <- function(){
  DEACTIVATED('This function does not work at the moment...')
  
  dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("data/test/Temporary_DataBase_V2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("data/validation/sort_is.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",", row.names = 1)
  checkEquals(sort_is(mergeDataSets(dataPathTest, database)), dataFrameVali)
  

}


test.filterDataSet <- function() {
  DEACTIVATED('This function does not work at the moment...')
  
  dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("data/test/Temporary_DataBase_V2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("data/validation/filterDataSet.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",", row.names = 1)
  checkEquals(filterDataSet(sort_is(mergeDataSets(dataPathTest, database)) , database), dataFrameVali)
  

}


test.pmolCalc <- function() {
  DEACTIVATED('This function does not work at the moment...')
  
  dataPathTest <- read.table("data/dataList.txt", stringsAsFactors = FALSE)[,1]
  database <- read.table("data/test/Temporary_DataBase_V2.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",")
  dataFrameVali <- read.table("data/validation/pmolCalc.csv", stringsAsFactors = FALSE, header = TRUE, sep = ",", row.names = 1)
  checkEquals(pmolCalc(filterDataSet(sort_is(mergeDataSets(dataPathTest, database)) , database),  database, 2, 0.25), dataFrameVali)
  

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

