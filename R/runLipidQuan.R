#' Lipidomics Analysis Tool
#' @author André Vidas Olsen
#' @export
#' @import shiny
runLipidQuan <- function(){
  #shinyApp(ui = ui, server = server)
  #runApp("inst/app/") # for test purposes
  suppressMessages(shiny::runApp(system.file("app", package = "lipidQuan"),launch.browser=TRUE)) # for builds
}
