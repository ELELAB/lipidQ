rmSpaceInBeginning <- function(data){
  #
  # Auxiliary function that removes the first letter in NAME and SPECIE, if the word begins with at [SPACE]
  #


  # for each row, check if either the NAME or SPECIE column begins with a [SPACE] and remove this [SPACE] if true.
  data[,"NAME"] <- ifelse(substring(data$NAME,1,1) == " ", substring(data$NAME, 2), data$NAME)
  data[, "SPECIE"] <- ifelse(substring(data$SPECIE,1,1) == " ", substring(data$SPECIE, 2), data$SPECIE)


  return(data)
}
