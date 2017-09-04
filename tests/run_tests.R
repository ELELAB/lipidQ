rm(list = ls())
setwd("/data/user/andre/lipidomics/lipidQuan/R")
library('RUnit')
source('functions.R')


test.suite <- defineTestSuite("auxFunctions",
                              dirs = file.path("../tests/testFiles"),
                              testFileRegexp = '*.R')


test.result <- runTestSuite(test.suite)

printTextProtocol(test.result)

