rm(list = ls())
setwd("/data/user/andre/lipidomics/lipidQuan/R")
library('RUnit')
source('compactOutput_pmolCalc.R')
source('filterDataSet.R')
source('makeFinalOutput.R')
source('mergeDataSets.R')
source('mergeFinalOutputs.R')
source('pmolCalc.R')
source('readFile.R')
source('rmSpaceInBeginning.R')
source('sort_is.R')
source("checkColnames.R")
source("merge_endo_and_ISTD_db.R")
source("filterReplicates.R")
source("makeIndex_OH_DB_C.R")

test.suite <- defineTestSuite("auxFunctions",
                              dirs = file.path("../tests/testFiles"),
                              testFileRegexp = '*.R')


test.result <- runTestSuite(test.suite)

printTextProtocol(test.result)



