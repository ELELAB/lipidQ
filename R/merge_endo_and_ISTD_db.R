#' @title Merge Endogene and ISTD Database
#' @author André Vidas Olsen
#' @description This function merges the two components of the reference databaes together: the endogene lipid database and the ISTD lipid database.
#' @param endogene_lipid_db the endogene lipid database
#' @param ISTD_lipid_db the ISTD lipid database
#' @return a data set consisting of endogene and ISTD database merged together
merge_endo_and_ISTD_db <- function(endogene_lipid_db, ISTD_lipid_db){

  #### merge endogene_lipid_db and ISTD_lipid_db together

  # create database for merging containing all unique colnames from endogene & ISTD db
  database <- unique(colnames(endogene_lipid_db),colnames(ISTD_lipid_db))

  # find unique colnames for endogene & ISTD db
  endogene_lipid_db_unique <- setdiff(colnames(endogene_lipid_db), colnames(ISTD_lipid_db))
  ISTD_lipid_db_unique <- setdiff(colnames(ISTD_lipid_db), colnames(endogene_lipid_db))

  # give endogene & ISTD database all their unique colnames, so that they have the same dimensions (values set to NA)
  endogene_lipid_db[,ISTD_lipid_db_unique] <- NA
  ISTD_lipid_db[,endogene_lipid_db_unique] <- NA

  # merge endogene & ISTD db together
  database <- rbind(endogene_lipid_db, ISTD_lipid_db)

  return(database)
}
