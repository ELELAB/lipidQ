## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo = FALSE--------------------------------------------------------
library(knitr)
data <- data.frame("sampleType1" = "start-end", "sampleType2" = "start-end", "sampleType3" = "start-end", "sampleType4" = "start-end", "sampleType5" = "start-end", "sampleType6" = "start-end")
kable(data)

## ----echo = FALSE--------------------------------------------------------
library(knitr)
data <- read.csv(system.file("extdata/sampleTypes.csv", package = "lipidQuan"), stringsAsFactors = FALSE)
kable(data)

