# load default colnames
#defaultColnames <- colnames(read.csv("data/test/Temporary_DataBase_V3.csv", header = TRUE))
#defaultColnames_ <- colnames(read.csv("results/mergedDataSets.csv", header = TRUE))
defaultColnames <- c("ERROR", "CLASS", "LENGTH", "DB", "NAME", "SPECIE", "MASS", "OH", "isLP", "PRECx", "FRAGx", "FAxINTENS", "NLS", "FAOINTENS", "QUAN_MODE", "QUAN", "DECONVULOTION_MODE", "DECONVULOTION_FRAGx", "DECONVULOTION_FAx", "MASSNLS", "MASSFA", "MASSFRAG", "MODE")

# create data.frame for user specified colnames
userSpecifiedColnames <- matrix(ncol = length(defaultColnames), nrow = 2)
colnames(userSpecifiedColnames) <- defaultColnames
userSpecifiedColnames <- as.data.frame(userSpecifiedColnames)

# set user specified names and the amount of each names to be used
# ANTALLET AF HVER KOLONNE ER MULIGVIS OVERFLØDIGT, DA DER I mergeDataSets.R BURDE VÆRE NOGET KODE DER FINDER UD AF HVOR MANGE PREC'S, FRAG'S OSV DER ER DER.
userSpecifiedColnames$ERROR <- c("ERROR", 1)
userSpecifiedColnames$CLASS <- c("CLASS", 1)
userSpecifiedColnames$LENGTH <- c("LENGTH", 1)
userSpecifiedColnames$DB <- c("DB", 1)
userSpecifiedColnames$NAME <- c("NAME", 1)
userSpecifiedColnames$SPECIE <- c("SPECIE", 1)
userSpecifiedColnames$MASS <- c("MASS", 1)
userSpecifiedColnames$OH <- c("OH", 1)
userSpecifiedColnames$isLP <- c("isLP", 1)
userSpecifiedColnames$PRECx <- c("PREC", 8)
userSpecifiedColnames$FRAGx <- c("FRAG", 8)
userSpecifiedColnames$FAxINTENS <- c("FAxINTES", 8)
userSpecifiedColnames$NLS <- c("NLS", 1)
userSpecifiedColnames$FAOINTENS <- c("FAOINTENS", 1)
userSpecifiedColnames$QUAN_MODE <- c("QUAN_MODE", 1)
userSpecifiedColnames$QUAN <- c("QUAN", 1)
userSpecifiedColnames$DECONVULOTION_MODE <- c("DECONVULOTION_MODE", 1)
userSpecifiedColnames$DECONVULOTION_FRAGx <- c("DECONVULOTION_FRAG", 8)
userSpecifiedColnames$DECONVULOTION_FAx <- c("DECONVULOTION_FA", 8)
userSpecifiedColnames$MASSNLS <- c("MASSNLS", 1)
userSpecifiedColnames$MASSFA <- c("MASSFA", 1)
userSpecifiedColnames$MASSFRAG <- c("MASSFRAG", 1)
userSpecifiedColnames$MODE <- c("MODE", 1)




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

