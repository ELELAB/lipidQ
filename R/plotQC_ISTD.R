library(ggplot2)
source("R/getColnames.R")
data <- read.table("inst/extdata/test/results/mergedDataSets.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)


head(data)
# get colnames for data
dataColnames <- getColnames(NULL)


# find MS1x columns and BLNK column (last MS1x column)
MS1x_names <- colnames(data)[grep(dataColnames$MS1x,colnames(data))] # names of all MS1x.* columns
BLNK <- MS1x_names[length(MS1x_names)] # name of BLNK column (last MS1x.* column)
MS1x_names <- MS1x_names[-length(MS1x_names)] # remove last column from MS1x_names since this is BLNK


# find only is classes
isData <- data[grep("^is",data[,dataColnames$SUM_COMPOSITION]),]

isData$PREC_02

# find median of MS1x values for each is class
isData[,paste0(dataColnames$MS1x,"_median")] <- apply(isData[, MS1x_names], 1, FUN = median)

isData[,paste0(dataColnames$MS1x,"_std")] <- apply(isData[, MS1x_names], 1, FUN = sd)
head(isData)


# default plot
#barplot(isData$PREC_median)


#TO BE CONTINUED .. FIND OUT IF THE OVERALL PLOT ALSO NEEDS REPLICATES.. SO MEDIAN OF REPLICATES -> MEDIAN OF SAMPLES.

# ggplot2
lower <- isData$PREC_median - isData$PREC_std
upper <- isData$PREC_median + isData$PREC_std
p <- ggplot()
p + geom_bar(data = isData, aes(x = NAME, y = PREC_median), stat = "identity", position = position_dodge(width = 0.9)) +
  geom_errorbar(data=isData, position = position_dodge(width = 0.9), mapping=aes(x=NAME, ymin=lower, ymax=upper, width=0.2)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + labs(x = "Classes", y = "Intensity") + scale_fill_discrete(guide = guide_legend(title = "Classes"))

