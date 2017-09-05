sort_is<-function(data){
  #
  # This function moves all internal standards (is) in a given data set so that they appear after all
  # normal species.
  #


  # save all is-rows
  isTmp <- data[grep("^is",data$NAME),]

  # remove all is-rows from data
  data <- data[-grep("^is",data$NAME),]

  # rbind all saved is-rows at the buttom of data
  data <- rbind(data,isTmp)

  return(data)
}
