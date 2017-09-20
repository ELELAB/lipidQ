# load default colnames
#defaultColnames <- colnames(read.csv("data/test/Temporary_DataBase_V3.csv", header = TRUE))
#defaultColnames_ <- colnames(read.csv("results/mergedDataSets.csv", header = TRUE))
defaultColnames <- c("PPM", "CLASS", "C_CHAIN", "DOUBLE_BOND", "SUM_COMPOSITION", "SPECIE_COMPOSITION", "MASS_TO_CHARGE", "OH_GROUP", "ISTD", "MS1x", "MS2x", "FAxINTENS", "NLS", "FAOINTENS", "QUAN_MODE", "QUAN_SCAN", "DECONVOLUTION_MODE", "DECONVOLUTION_FRAGx", "DECONVOLUTION_FAx", "MASSNLS", "MASSFA", "MASSFRAG", "MODE","numberOfSamples", "numberOfReplicates")

# create data.frame for user specified colnames
userSpecifiedColnames <- matrix(ncol = length(defaultColnames), nrow = 1)
colnames(userSpecifiedColnames) <- defaultColnames
userSpecifiedColnames <- as.data.frame(userSpecifiedColnames)

# set user specified names and the amount of each names to be used
# ANTALLET AF HVER KOLONNE ER MULIGVIS OVERFLØDIGT, DA DER I mergeDataSets.R BURDE VÆRE NOGET KODE DER FINDER UD AF HVOR MANGE PREC'S, FRAG'S OSV DER ER DER.
userSpecifiedColnames$PPM <- c("ERROR")
userSpecifiedColnames$CLASS <- c("CLASS")
userSpecifiedColnames$C_CHAIN <- c("LENGTH")
userSpecifiedColnames$DOUBLE_BOND <- c("DB")
userSpecifiedColnames$SUM_COMPOSITION <- c("NAME")
userSpecifiedColnames$SPECIE_COMPOSITION <- c("SPECIE")
userSpecifiedColnames$MASS_TO_CHARGE <- c("MASS")
userSpecifiedColnames$OH_GROUP <- c("OH_GROUP")
userSpecifiedColnames$ISTD <- c("isLP")
userSpecifiedColnames$MS1x <- c("PREC")
userSpecifiedColnames$MS2x <- c("FRAG")
userSpecifiedColnames$FAxINTENS <- c("FAxINTES")
userSpecifiedColnames$NLS <- c("NLS")
userSpecifiedColnames$FAOINTENS <- c("FAOINTENS")
userSpecifiedColnames$QUAN_MODE <- c("QUAN_MODE")
userSpecifiedColnames$QUAN_SCAN <- c("QUAN_SCAN")
userSpecifiedColnames$DECONVOLUTION_MODE <- c("DECONVOLUTION_MODE")
userSpecifiedColnames$DECONVOLUTION_FRAGx <- c("DECONVOLUTION_FRAG")
userSpecifiedColnames$DECONVOLUTION_FAx <- c("DECONVOLUTION_FA")
userSpecifiedColnames$MASSNLS <- c("MASSNLS")
userSpecifiedColnames$MASSFA <- c("MASSFA")
userSpecifiedColnames$MASSFRAG <- c("MASSFRAG")
userSpecifiedColnames$MODE <- c("MODE")
userSpecifiedColnames$numberOfSamples <- c("3")
userSpecifiedColnames$numberOfReplicates <- c("3")


#userSpecifiedColnames$ERROR <- c("ERROR", 1)
#userSpecifiedColnames$CLASS <- c("CLASS", 1)
#userSpecifiedColnames$LENGTH <- c("LENGTH", 1)
#userSpecifiedColnames$DB <- c("DB", 1) # herfra og opefter mangler ændring af navn
#userSpecifiedColnames$NAME <- c("navn", 1)
#userSpecifiedColnames$SPECIE <- c("art", 1)
#userSpecifiedColnames$MASS <- c("MASS", 1) # mangler ændring af navn
#userSpecifiedColnames$OH <- c("OH", 1) # mangler ændring af navn
#userSpecifiedColnames$isLP <- c("internStandard", 1)
#userSpecifiedColnames$PRECx <- c("CERP", 8)
#userSpecifiedColnames$FRAGx <- c("GARF", 8)
#userSpecifiedColnames$FAxINTENS <- c("AFxSENTNI", 8)
#userSpecifiedColnames$NLS <- c("SLN", 1)
#userSpecifiedColnames$FAOINTENS <- c("AF0SENTNI", 1)
#userSpecifiedColnames$QUAN_MODE <- c("NAUQ_EDOM", 1)
#userSpecifiedColnames$QUAN <- c("NAUQ", 1)
#userSpecifiedColnames$DECONVULOTION_MODE <- c("dekonvulere_EDOM", 1)
#userSpecifiedColnames$DECONVULOTION_FRAGx <- c("dekonvulere_GARF", 8)
#userSpecifiedColnames$DECONVULOTION_FAx <- c("dekonvulere_AF", 8)
#userSpecifiedColnames$DB <- c("MASSNLS", 1) # herfra mangler ændring af navn
#userSpecifiedColnames$DB <- c("MASSFA", 1)
#userSpecifiedColnames$DB <- c("MASSFRAG", 1)
#userSpecifiedColnames$DB <- c("MODE", 1)

# save file
write.csv(userSpecifiedColnames, "data/test/userSpecifiedColnames.csv", quote = FALSE, row.names = FALSE)

test <- read.csv("data/test/userSpecifiedColnames.csv", header = TRUE)
colnames(test)
