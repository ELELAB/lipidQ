#' @author André Vidas Olsen
#' @import shiny
ui <- fluidPage(
  titlePanel("LipidQuan"),

  navbarPage("CHOOSE OPERATION: ",
             tabPanel("Quantification",
                      sidebarLayout(
                        sidebarPanel(
                          # input data
                          fileInput(inputId = "dataList", multiple = TRUE, label = "Choose the input data sets (.csv-files):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),

                          # endogene database
                          fileInput(inputId = "endogene_lipid_db", label = "Choose the endogene lipid database (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),

                          # ISTD database
                          fileInput(inputId = "ISTD_lipid_db", label = "Choose the ISTD lipid database (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),

                          # userspecified colnames
                          fileInput(inputId = "userSpecifiedColnames", label = "Choose list of colnames (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          br(),
                          br(),

                          # replicate filtering
                          numericInput("numberOfReps", "Number of replicates per sample (1 = no replicates):", 1, min = 1, max = 100),
                          checkboxInput("blnkReplicates", "Blank contains replicates", FALSE),
                          numericInput("numberOfInstancesT", "Number of instances threshold:", 1, min = 1, max = 100),
                          numericInput("thresholdValue", "Threshold of instance:", 500, min = 0, max = 100),

                          br(),
                          br(),
                          br(),

                          # LOQ
                          checkboxInput("LOQ", "LOQ activated", FALSE),
                          numericInput("fixedDeviation", "Fixed deviation (%):", 0, min = 0, max = 100),

                          br(),
                          br(),
                          br(),

                          # multiply parameter
                          checkboxInput("multiplyMS1", "Multiply MS1 columns by a factor (for LipidX users)", FALSE),
                          fileInput(inputId = "list", label = "Choose the list of classes to be multiplied (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                          ),
                          numericInput("multiplyPREC_value", "Set multiply factor:", 2, min = 1, max = 100),

                          br(),
                          br(),
                          br(),

                          # spikeISTD
                          numericInput("spikeISTD", "Spike ISTD (uL):", 2, min = 1, max = 100),

                          # Threshold for rounding down to zero for mol% species
                          numericInput("zeroThresh", "Threshold for rounding down to zero for mol% species:", 0.25, min = 0, max = 10),

                          br(),

                          # output folder
                          textInput("dir", "Paste the filepath for the output files to be saved.", "/data/user/andre/lipidomics/lipidQuan/results/"),

                          br(),
                          br(),
                          checkboxInput("QC_plots_MS1", "Create QC plots of MS1 intensity data", FALSE),
                          checkboxInput("QC_plots_pmol", "Create QC plots of class pmol data", FALSE),

                          br(),
                          br(),
                          br(),

                          actionButton("runAnalysis", "Run Analysis"),



                          # Button
                          #downloadButton("downloadData", "Download"), # TO BE CONTINUED
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



                          h4("Create new user specified column names template"),

                          textInput("numberOfMS2ix", "Number of MS2 columns in the input data", "7"),

                          #br(),
                          #textInput("numberOfDECONVOLUTION_x", "Write the number of DECONVOLUTION columns in the input data", "4"),

                          br(),
                          textInput("dirColnamesTemplate", "Paste the filepath for the column template file to be saved.", "/data/user/andre/lipidomics/lipidQuan/inst/extdata/test/"),
                          textOutput("createColTemplateDone"),

                          actionButton("createColnamesTemplate", "Create column template file"),



                          br(),
                          br(),
                          br(),
                          h4("Create new database file"),
                          radioButtons("DB_type", "Database Type", c("endogene"="endo", "ISTD"="ISTD")),

                          fileInput(inputId = "userSpecifiedColnamesCreateDatabase", label = "Choose list of colnames (.csv-file):",
                                    accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),

                          textInput("dirDatabase", "Paste the filepath for the database file to be saved.", "/data/user/andre/lipidomics/lipidQuan/inst/extdata/test/"),



                          actionButton("createDatabase", "Create database"),

                          textOutput("createDatabaseDone")
                        ),
                        mainPanel()
                      )
             )
  )
)
