#' @author André Vidas Olsen
#' @import shiny
server <- function(input, output, session){



  observeEvent(input$runAnalysis, {
    #
    # This function runs when then "Start Analysis" button is triggered by the user
    #

    progress <- Progress$new(session, min=0, max=7)
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

    # load the endogene lipid database used by the filterDataSet() and the pmolCalc() functions
    endogene_lipid_db <- tryCatch(
      {
        endogene_lipid_db <- input$endogene_lipid_db
        endogene_lipid_db <- read.table(endogene_lipid_db$datapath, stringsAsFactors = FALSE, header = TRUE, sep = ",")
        endogene_lipid_db # return statement
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
    # load the ISTD lipid database used by the filterDataSet() and the pmolCalc() functions
    ISTD_lipid_db <- tryCatch(
      {
        ISTD_lipid_db <- input$ISTD_lipid_db
        ISTD_lipid_db <- read.table(ISTD_lipid_db$datapath, stringsAsFactors = FALSE, header = TRUE, sep = ",")
        ISTD_lipid_db # return statement
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


    # load multiplyMS1 list
    # MAYBE THE CHECKBOX FOR THIS FIELD IS NOT NECESSARY. IF THE BUTTON IS USED, THERE SHOULD AT LEAST BE IMPLEMENTED A WARNING, IF NO FILE IS CHOSEN, WHEN CHECKBOX = TRUE.
    if(input$multiplyMS1 == TRUE && !is.null(input$list)){
      list <- input$list
      list <- read.table(list$datapath, stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
    }else{
      list <- NULL
    }

    progress$set(value = 1)


    # Analysis start
    mergedDataSets <- lipidQuan:::sort_is(lipidQuan:::mergeDataSets(dataList, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames, correctionList = list, multiply = input$multiplyPREC_value))
    write.csv(mergedDataSets, file = paste0(input$dir,"/mergedDataSets.csv"), quote = FALSE, row.names = F)

    #if(input$numberOfReps > 1){
    #  mergedDataSets <- lipidQuan:::filterReplicates(mergedDataSets, userSpecifiedColnames = userSpecifiedColnames, numberOfReplicates = input$numberOfReps, blnkReplicates = input$blnkReplicates, numberOfInstancesThreshold = input$numberOfInstancesT, thresholdValue = input$thresholdValue)
    #  write.csv(mergedDataSets, file = paste0(input$dir,"/mergedDataSets.csv"), quote = FALSE, row.names = F)
    #}
    progress$set(value = 2)


    filteredDataSet <- lipidQuan:::filterDataSet(mergedDataSets, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames)
    write.csv(filteredDataSet, file = paste0(input$dir,"/filteredDataSet.csv"), quote = FALSE, row.names = F)
    progress$set(value = 3)


    pmolCalculatedDataSet <- lipidQuan:::pmolCalc(filteredDataSet, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames, input$spikeISTD, input$zeroThresh, input$LOQ, input$fixedDeviation,  numberOfReplicates = input$numberOfReps, blnkReplicates = input$blnkReplicates, numberOfInstancesThreshold = input$numberOfInstancesT, thresholdValue = input$thresholdValue)
    write.csv(pmolCalculatedDataSet, file = paste0(input$dir,"/pmolCalculatedDataSet.csv"), quote = FALSE, row.names = F)
    progress$set(value = 4)

    indexData <- lipidQuan::makeIndex_OH_DB_C(pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
    write.csv(indexData[1], file = paste0(input$dir,"/indexDataOH.csv"), quote = FALSE, row.names = F)
    write.csv(indexData[2], file = paste0(input$dir,"/indexDataDB.csv"), quote = FALSE, row.names = F)
    write.csv(indexData[3], file = paste0(input$dir,"/indexDataC.csv"), quote = FALSE, row.names = F)
    progress$set(value = 5)

    classPmol_molPctClass <- lipidQuan:::compactOutput_pmolCalc(pmolCalculatedDataSet)
    write.csv(classPmol_molPctClass, file = paste0(input$dir,"/classPmol_molPctClass.csv"), quote=F, row.names = F)
    progress$set(value = 6)

    finalOutput <- lipidQuan:::makeFinalOutput(classPmol_molPctClass, pmolCalculatedDataSet)
    write.csv(finalOutput, file = paste0(input$dir,"/finalOutput.csv"), quote = FALSE, row.names = FALSE)
    progress$set(value = 7)

    output$analysisDone <- renderText({
      paste("Quantification done!")
    })
  })

  observeEvent(input$runFinalOutputMerging, {
    #
    # This function runs when the "Merge Final Output Data Sets" button is triggered by the user
    #

    progress <- Progress$new(session, min=0, max=1)
    on.exit(progress$close())

    progress$set(message = 'Calculation in progress',
                 detail = 'This may take a while...')

    # load input data files to a list of directories used by the mergedDataSets() function
    finalOutputList <- character(nrow(input$finalOutputList))
    for(i in 1:nrow(input$finalOutputList)){
      finalOutputList[i] <- input$finalOutputList[[i, 'datapath']]
    }

    if (is.null(finalOutputList))
      return(NULL)



    # final output merging start
    mergedFinalOutputs <- lipidQuan:::mergeFinalOutputs(finalOutputList)
    write.csv(mergedFinalOutputs, file = paste0(input$dirFinalOutputs,"/mergedFinalOutputs.csv"), quote = FALSE, row.names = F)
    progress$set(value = 1)

    output$finalOutputMergingDone <- renderText({
      paste("Merging done!")
    })
  })
  observeEvent(input$createColnamesTemplate, {
    #
    #
    #

    progress <- Progress$new(session, min=0, max=1)
    on.exit(progress$close())

    progress$set(message = 'Calculation in progress',
                 detail = 'This may take a while...')




    # create column names template
    #newColnamesTemplate <- lipidQuan:::makeColnames(as.numeric(input$numberOfMS2ix), as.numeric(input$numberOfDECONVOLUTION_x))
    newColnamesTemplate <- lipidQuan:::makeColnames(as.numeric(input$numberOfMS2ix))
    write.csv(newColnamesTemplate, file = paste0(input$dirColnamesTemplate,"/userSpecifiedColnames.csv"), quote = FALSE, row.names = F)
    progress$set(value = 1)

    output$createColTemplateDone <- renderText({
      paste("Creation of column name template done!")
    })


  })
  observeEvent(input$createDatabase, {
    #
    #
    #

    progress <- Progress$new(session, min=0, max=1)
    on.exit(progress$close())

    progress$set(message = 'Calculation in progress',
                 detail = 'This may take a while...')


    # load userSpecifiedColnames.csv
    if(!is.null(input$userSpecifiedColnamesCreateDatabase)){
      userSpecifiedColnames <- input$userSpecifiedColnamesCreateDatabase
      userSpecifiedColnames <- read.table(userSpecifiedColnames$datapath, stringsAsFactors = FALSE, header = TRUE, sep = ",")
    } else{
      userSpecifiedColnames <- NULL
    }

    print(input$DB_type)
    newDatabase <- lipidQuan::makeDatabase(userSpecifiedColnames, input$DB_type)
    if(input$DB_type == "endo"){
      write.csv(newDatabase, file = paste0(input$dirDatabase,"/endogene_lipid_db_TEST.csv"), quote = FALSE, row.names = F)
    }
    if(input$DB_type == "ISTD"){
      write.csv(newDatabase, file = paste0(input$dirDatabase,"/ISTD_lipid_db_TEST.csv"), quote = FALSE, row.names = F)
    }
    progress$set(value = 1)


    output$createDatabaseDone <- renderText({
      paste("Creation of chosen database done!")
    })

  })



}
