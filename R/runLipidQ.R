#' @title Lipidomics Analysis Tool Graphical User Interface
#' @author André Vidas Olsen
#' @description runLipidQ starts the graphical user interface (GUI) of
#' Lipidomics Analysis Tool. From this GUI, the user can specify different types
#' of procedures, input data, different parameter as well as the output
#' directory.
#' @export
#' @import shiny
#' @return start up lipidQ graphical user interface
#' @examples
#' info <- "Write the following command to run runLipidQ:"
#' \donttest{
#' runLipidQ()
#' }
runLipidQ <- function(){
    suppressMessages(runApp(system.file("app", package = "lipidQ"),
                          launch.browser=TRUE)) # for builds
}
