#' @author André Vidas Olsen
#' @import shiny
server <- function(input, output, session){

  #### Check that all required fields are specified

  # quantification
  output$validateFields_quant <- renderText({
    validate(

      need(!is.null(input$dataList), "Please select input data set"),
      need(!is.null(input$endogene_lipid_db), "Please select endogene database"),
      need(!is.null(input$ISTD_lipid_db), "Please select ISTD database"),
      need(!is.null(input$userSpecifiedColnames), "Please select user specified column names file"),
      need(!is.na(input$spikeISTD), "Please specify spike ISTD"),
      need(as.numeric(input$spikeISTD) >= 1 | is.na(input$spikeISTD), "Spike ISTD has to greater than 0"),
      need(input$dir != "", "Please select filepath for output folder")
    )
  })

  # merging of final outputs
  output$validateFields_merging <- renderText({
    validate(
      need(!is.null(input$finalOutputList), "Please select the input data to be merged"),
      need(input$dirFinalOutputs != "", "Please select filepath for output folder")
    )
  })


  # global options
  output$validateFields_globalOptions_userSpec <- renderText({
    validate(
      need(!is.na(input$numberOfMS2ix), "Please select number of MS2 columns (<= 20)"),
      need(input$numberOfMS2ix <= 20 | is.na(input$numberOfMS2ix), "The number of MS2 columns can not exceed 20"),
      need(input$dirColnamesTemplate != "", "Please select filepath for output folder")
    )
  })

  # global options
  output$validateFields_globalOptions_db <- renderText({
    validate(
      need(!is.null(input$userSpecifiedColnamesCreateDatabase), "Please select user specified column names file"),
      need(input$dirDatabase != "", "Please select filepath for output folder")
    )
  })




  observeEvent(input$runAnalysis, {
    #
    # This function runs when then "Start Analysis" button in the quantification tab is triggered by the user
    #

    if(!is.null(input$dataList) & !is.null(input$endogene_lipid_db) & !is.null(input$ISTD_lipid_db) & !is.null(input$userSpecifiedColnames) & !is.na(input$spikeISTD)  & input$dir != ""){
    print(input$spikeISTD)


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
    }


    # load multiplyMS1 list
    # TO BE CONTINUED ... MAYBE THE CHECKBOX FOR THIS FIELD IS NOT NECESSARY. IF THE BUTTON IS USED, THERE SHOULD AT LEAST BE IMPLEMENTED A WARNING, IF NO FILE IS CHOSEN, WHEN CHECKBOX = TRUE.
    if(input$multiplyMS1 == TRUE && !is.null(input$list)){
      list <- input$list
      list <- read.table(list$datapath, stringsAsFactors = FALSE, header = FALSE, sep = ",")$V1
    }else{
      list <- NULL
    }

    progress$set(value = 1)


    # Analysis start
    dir.create(file.path(input$dir, "dataTables"))
    mergedDataSets <- lipidQuan:::sort_is(lipidQuan:::mergeDataSets(dataList, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames, correctionList = list, multiply = input$multiplyPREC_value), userSpecifiedColnames = userSpecifiedColnames)
    write.csv(mergedDataSets, file = paste0(input$dir,"/dataTables/mergedDataSets.csv"), quote = FALSE, row.names = F)

    if(input$QC_plots_MS1){
      dir.create(file.path(input$dir, "QC"))
      dir.create(file.path(input$dir, "QC/pre"))
      lipidQuan:::plotQC_ISTD(data = mergedDataSets, endogene_lipid_db = endogene_lipid_db, ISTD_lipid_db = ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames, pathToOutput = paste0(input$dir, "/QC/pre/"), blnkReplicates = input$blnkReplicates, numberOfReplicates = input$numberOfReps)
    }

    #if(input$numberOfReps > 1){
    #  mergedDataSets <- lipidQuan:::filterReplicates(mergedDataSets, userSpecifiedColnames = userSpecifiedColnames, numberOfReplicates = input$numberOfReps, blnkReplicates = input$blnkReplicates, numberOfInstancesThreshold = input$numberOfInstancesT, thresholdValue = input$thresholdValue)
    #  write.csv(mergedDataSets, file = paste0(input$dir,"/mergedDataSets.csv"), quote = FALSE, row.names = F)
    #}
    progress$set(value = 2)

    # script to change file name in Shiny tmp folder https://groups.google.com/forum/#!topic/shiny-discuss/hGO4lC7BEI4
    filteredDataSet <- lipidQuan:::filterDataSet(mergedDataSets, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames)
    write.csv(filteredDataSet, file = paste0(input$dir,"/dataTables/filteredDataSet.csv"), quote = FALSE, row.names = F)
    progress$set(value = 3)


    pmolCalculatedDataSet <- lipidQuan:::pmolCalc(filteredDataSet, endogene_lipid_db, ISTD_lipid_db, userSpecifiedColnames = userSpecifiedColnames, input$spikeISTD, input$zeroThresh, input$LOQ, input$fixedDeviation,  numberOfReplicates = input$numberOfReps, blnkReplicates = input$blnkReplicates, numberOfInstancesThreshold = input$numberOfInstancesT, thresholdValue = input$thresholdValue)
    write.csv(pmolCalculatedDataSet, file = paste0(input$dir,"/dataTables/pmolCalculatedDataSet.csv"), quote = FALSE, row.names = F)
    progress$set(value = 4)

    indexData <- lipidQuan:::makeIndex_OH_DB_C(pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
    write.csv(indexData[1], file = paste0(input$dir,"/dataTables/indexDataOH.csv"), quote = FALSE, row.names = F)
    write.csv(indexData[2], file = paste0(input$dir,"/dataTables/indexDataDB.csv"), quote = FALSE, row.names = F)
    write.csv(indexData[3], file = paste0(input$dir,"/dataTables/indexDataC.csv"), quote = FALSE, row.names = F)
    progress$set(value = 5)

    classPmol_molPctClass <- lipidQuan:::compactOutput_pmolCalc(pmolCalculatedDataSet, userSpecifiedColnames = userSpecifiedColnames)
    #write.csv(classPmol_molPctClass, file = paste0(input$dir,"/dataTables/classPmol_molPctClass.csv"), quote=F, row.names = F)
    progress$set(value = 6)


    if(input$QC_plots_pmol){
      dir.create(file.path(input$dir, "QC"))
      dir.create(file.path(input$dir, "QC/post"))
      lipidQuan:::plotQC_totalLipids(data = classPmol_molPctClass, userSpecifiedColnames = userSpecifiedColnames, pathToOutput = paste0(input$dir, "/QC/post/"))
    }



    finalOutput <- lipidQuan:::makeFinalOutput(classPmol_molPctClass, pmolCalculatedDataSet)
    write.csv(finalOutput[1], file = paste0(input$dir,"/dataTables/finalOutput_molPct.csv"), quote = FALSE, row.names = FALSE)
    write.csv(finalOutput[2], file = paste0(input$dir,"/dataTables/finalOutput_pmol.csv"), quote = FALSE, row.names = FALSE)
    progress$set(value = 7)

    output$analysisDone <- renderText({
      paste("Quantification done!")
    })

    }

  })


  observeEvent(input$runFinalOutputMerging, {
    #
    # This function runs when the "Merge Final Output Data Sets" button is triggered by the user
    #

    if(!is.null(input$finalOutputList) & input$dirFinalOutputs != ""){

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
    }
  })


  observeEvent(input$createColnamesTemplate, {
    #
    #
    #
    if(!is.na(input$numberOfMS2ix) & input$numberOfMS2ix <= 20 & input$dirColnamesTemplate != ""){
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

    }


  })

  observeEvent(input$createDatabase, {
    #
    #
    #

    if(!is.null(input$userSpecifiedColnamesCreateDatabase) & input$dirDatabase != ""){
    progress <- Progress$new(session, min=0, max=1)
    on.exit(progress$close())

    progress$set(message = 'Calculation in progress',
                 detail = 'This may take a while...')


    # load userSpecifiedColnames.csv
    if(!is.null(input$userSpecifiedColnamesCreateDatabase)){
      userSpecifiedColnames <- input$userSpecifiedColnamesCreateDatabase
      userSpecifiedColnames <- read.table(userSpecifiedColnames$datapath, stringsAsFactors = FALSE, header = TRUE, sep = ",")


      #print(input$DB_type)
      #newDatabase <- lipidQuan::makeDatabase(userSpecifiedColnames = userSpecifiedColnames, DB_type = input$DB_type)
      #if(input$DB_type == "endo"){
      if(input$DB_type_endo){
        newDatabase_endo <- lipidQuan::makeDatabase(userSpecifiedColnames = userSpecifiedColnames, DB_type = "endo")
        write.csv(newDatabase_endo, file = paste0(input$dirDatabase,"/endogene_lipid_db.csv"), quote = FALSE, row.names = F)
      }
      #if(input$DB_type == "ISTD"){
      if(input$DB_type_ISTD){
        newDatabase_ISTD <- lipidQuan::makeDatabase(userSpecifiedColnames = userSpecifiedColnames, DB_type = "ISTD")
        write.csv(newDatabase_ISTD, file = paste0(input$dirDatabase,"/ISTD_lipid_db.csv"), quote = FALSE, row.names = F)
      }
      progress$set(value = 1)

      output$createDatabaseDone <- renderText({
        paste("Creation of chosen database done!")
      })

    } else{
      output$noUserSpecifiedColnames <- renderText({
        paste("Please select a user specified column names file!")
      })
    }

    }

  })



}
