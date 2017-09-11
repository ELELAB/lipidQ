#' @title Remove Space In Beginning of NAME and SPECIE Rows
#' @author André Vidas Olsen
#' @description Auxiliary function that removes the first letter in NAME and SPECIE, if the word begins with a [SPACE]. It is used since, by experience, some rows begins with a space for these two columns which can results in errors.
rmSpaceInBeginning <- function(data){


  # for each row, check if either the NAME or SPECIE column begins with a [SPACE] and remove this [SPACE] if true.
  data[,"NAME"] <- ifelse(substring(data$NAME,1,1) == " ", substring(data$NAME, 2), data$NAME)
  data[, "SPECIE"] <- ifelse(substring(data$SPECIE,1,1) == " ", substring(data$SPECIE, 2), data$SPECIE)


  return(data)
}
