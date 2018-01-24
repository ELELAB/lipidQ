## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=FALSE---------------------------------------------------------
system.file("extdata/LipidQ_DataBase", package = "lipidQuan")

## ---- echo=FALSE---------------------------------------------------------
system.file("app/", package = "lipidQuan")

## ----echo = FALSE--------------------------------------------------------
library(knitr)
data <- read.csv(system.file("extdata/LipidQ_DataBase/userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE)
data[1,] <- "TYPE_NAME_HERE"
kable(data[,1:7])
kable(data[,8:ncol(data)])

## ----echo = FALSE--------------------------------------------------------
library(knitr)
data <- read.csv(system.file("extdata/LipidQ_DataBase/userSpecifiedColnames.csv", package = "lipidQuan"), stringsAsFactors = FALSE)
kable(data[,1:7])
kable(data[,8:ncol(data)])

