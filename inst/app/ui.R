#' @author André Vidas Olsen
#' @import shiny
ui <- fluidPage(
  titlePanel("LipidQuan"),

  navbarPage("CHOOSE OPERATION: ",
             tabPanel("Quantification",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput(inputId = "dataList", multiple = TRUE, label = "Choose the input data sets (.csv-files):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          fileInput(inputId = "database", label = "Choose the database (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          fileInput(inputId = "userSpecifiedColnames", label = "Choose list of colnames (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          br(),
                          br(),
                          checkboxInput("multiplyPREC", "Multiply PREC columns by a factor (for LipidX users)", FALSE),
                          fileInput(inputId = "list", label = "Choose the list of classes to be multiplied (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          numericInput("multiplyPREC_value", "Set multiply factor:", 2, min = 1, max = 100),

                          br(),
                          br(),
                          br(),

                          numericInput("spikeISTD", "spike ISTD (uL):", 2, min = 1, max = 100),
                          numericInput("zeroThresh", "Threshold for rounding down to zero for mol% species:", 0.25, min = 0, max = 10),

                          br(),

                          textInput("dir", "Paste the filepath for the output files to be saved.", "/data/user/andre/lipidomics/lipidQuan/results/"),

                          br(),
                          br(),
                          br(),

                          actionButton("runAnalysis", "Run Analysis"),

                          br(),
                          br(),
                          textOutput("analysisDone")

                        ),

                        mainPanel()
                      )
             ),
             tabPanel("Merging of Final Output Data Sets",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput(inputId = "finalOutputList", multiple = TRUE, label = "Choose the final output data sets (.csv-files):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          textInput("dirFinalOutputs", "Paste the filepath for the output files to be saved.", "/data/user/andre/lipidomics/lipidQuan/results/"),

                          br(),

                          actionButton("runFinalOutputMerging", "Merge Final Output Data Sets"),

                          br(),
                          br(),
                          textOutput("finalOutputMergingDone")
                        ),
                        mainPanel()
                      )
             ),
             tabPanel("Global Options",
                      sidebarLayout(
                        sidebarPanel(


                          actionButton("resetColnamesTemplate", "Reset column template file"),

                          br(),
                          textInput("numberOfMS2ix", "Write the number of MS2 columns in the input data", "3"),

                          br(),
                          textInput("dirColnamesTemplate", "Paste the filepath for the column template file to be saved.", "/data/user/andre/lipidomics/lipidQuan/inst/extdata/test/"),

                          br(),
                          textOutput("resetColTemplateDone")
                        ),
                        mainPanel()
                      )
             )
  )
)
