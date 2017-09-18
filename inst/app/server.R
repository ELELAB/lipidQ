#' @import shiny
server <- function(input, output, session){



  observeEvent(input$runAnalysis, {
    #
    # This function runs when then "Start Analysis" button is triggered by the user
    #

    progress <- Progress$new(session, min=0, max=6)
    on.exit(progress$close())

    progress$set(message = 'Calculation in progress',
                 detail = 'This may take a while...')



    # load list of file paths representing input data used by the mergedDataSets() function
    dataList <- tryCatch(
      {
        dataList <- character(nrow(input$dataList))
        for(i in 1:nrow(input$dataList)){
          dataList[i] <- input$dataList[[i, 'datapath']]
        }
        dataList # return statement
      },
      error=function(cond){
        message("ERROR: NO DATA SELECTED! Please select input data to be analysed")
        message("")
        message("")
        message("")
        message("Original R error message:")
        message(cond)
      }
    )

    # load database used by the filterDataSet() and the pmolCalc() functions
    database <- tryCatch(
      {
        database <- input$database
        database <- read.table(database$datapath, stringsAsFactors = FALSE, header = TRUE, sep = ",")
        database # return statement
      },
      error=function(cond){
        message("ERROR: NO DATABASE SELECTED! Please select a database to be used together with the input data")
        message("")
        message("")
        message("")
        message("Original R error message:")
        message(cond)
      }
    )



    # load userSpecifiedColnames.csv
    if(!is.null(input$userSpecifiedColnames)){
      userSpecifiedColnames <- input$userSpecifiedColnames
      userSpecifiedColnames <- read.table(userSpecifiedColnames$datapath, stringsAsFactors = FALSE, header = TRUE, sep = ",")
    } else{
      userSpecifiedColnames <- NULL
    }


    # load multiplyPREC list
    # MAYBE THE CHECKBOX FOR THIS FIELD IS NOT NECESSARY. IF THE BUTTON IS USED, THERE SHOULD AT LEAST BE IMPLEMENTED A WARNING, IF NO FILE IS CHOSEN, WHEN CHECKBOX = TRUE.
    if(input$multiplyPREC == TRUE && !is.null(input$list)){
      list <- input$list
      list <- read.table(list$datapath, stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
    }else{
      list <- NULL
    }

    progress$set(value = 1)


    # Analysis start
    mergedDataSets <- lipidQuan:::sort_is(lipidQuan:::mergeDataSets(dataList, database, userSpecifiedColnames = userSpecifiedColnames, multiply = input$multiplyPREC_value, list = list))
    write.csv(mergedDataSets, file = paste0(input$dir,"/mergedDataSets.csv"), quote = FALSE, row.names = F)
    progress$set(value = 2)

    filteredDataSet <- lipidQuan:::filterDataSet(mergedDataSets, database, userSpecifiedColnames = userSpecifiedColnames)
    write.csv(filteredDataSet, file = paste0(input$dir,"/filteredDataSet.csv"), quote = FALSE, row.names = F)
    progress$set(value = 3)

    pmolCalculatedDataSet <- lipidQuan:::pmolCalc(filteredDataSet, database, input$spikeVar, input$zeroThresh)
    write.csv(pmolCalculatedDataSet, file = paste0(input$dir,"/pmolCalculatedDataSet.csv"), quote = FALSE, row.names = F)
    progress$set(value = 4)

    classPmol_molPctClass <- lipidQuan:::compactOutput_pmolCalc(pmolCalculatedDataSet)
    write.csv(classPmol_molPctClass, file = paste0(input$dir,"/classPmol_molPctClass.csv"), quote=F, row.names = F)
    progress$set(value = 5)

    tableauOutput <- lipidQuan:::makeTableauOutput(classPmol_molPctClass, pmolCalculatedDataSet)
    write.csv(tableauOutput, file = paste0(input$dir,"/tableauOutput.csv"), quote = FALSE, row.names = FALSE)
    progress$set(value = 6)

    output$analysisDone <- renderText({
      paste("Quantification done!")
    })
  })

  observeEvent(input$runTableauMerging, {
    #
    # This function runs when the "Merge Tableau Data Sets" button is triggered by the user
    #

    progress <- Progress$new(session, min=0, max=1)
    on.exit(progress$close())

    progress$set(message = 'Calculation in progress',
                 detail = 'This may take a while...')

    # load input data files to a list of directories used by the mergedDataSets() function
    tableauList <- character(nrow(input$tableauList))
    for(i in 1:nrow(input$tableauList)){
      tableauList[i] <- input$tableauList[[i, 'datapath']]
    }

    if (is.null(tableauList))
      return(NULL)



    # Tableau merging start
    mergedTableauDataSets <- lipidQuan:::mergeTableauDataSets(tableauList)
    write.csv(mergedTableauDataSets, file = paste0(input$dirTableau,"mergedTableauDataSets.csv"), quote = FALSE, row.names = F)
    progress$set(value = 1)

    output$tableauMergingDone <- renderText({
      paste("Merging done!")
    })
  })


}
