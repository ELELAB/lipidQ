#' @title Lipidomics Analysis Tool Graphical User Interface
#' @author André Vidas Olsen
#' @description runLipidQuan starts the graphical user interface (GUI) of
#' Lipidomics Analysis Tool. From this GUI, the user can specify different types
#' of procedures, input data, different parameter as well as the output
#' directory.
#' @export
#' @import shiny
#' @return start up lipidQuan graphical user interface
#' @examples
#' # run lipidQuan
#' #runLipidQuan()
runLipidQuan <- function(){
  #runApp("inst/app/") # for test purposes
  suppressMessages(shiny::runApp(system.file("app", package = "lipidQuan"),
                                 launch.browser=TRUE)) # for builds
}

