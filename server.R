library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(DT)
library(ggrepel)
library(factoextra)
library(caret)
library(tree)
library(randomForest)


#Load data
adultData <- read_delim("adult.data", 
                        delim = ",",
                        col_names = c("Age", "Workclass", "fnlwgt", "Education", "Education_Number", "Marital_Status", "Occupation", "Relationship", "Race", "Sex", "Capital_Gain", "Capital_Loss", "Hours_per_week", "Native_Country", "Income"),skip = 1)

#Remove leading spaces from character variables
adultData$Sex <- trimws(adultData$Sex, which = c("left"))
adultData$Workclass <- trimws(adultData$Workclass, which = c("left"))
adultData$Education <- trimws(adultData$Education, which = c("left"))
adultData$Native_Country <- trimws(adultData$Native_Country, which = c("left"))
adultData$Income <- trimws(adultData$Income, which = c("left"))

# Remove 'fnlwgt', 'education', 'capital-gain', and 'capital-loss'
adultDataSub <- select(adultData, -c(fnlwgt, Education, Capital_Gain, Capital_Loss))

# Replace '?' entries with 'NA' and drop NA's.
adultDataSub[adultDataSub == " ?"] <- NA
adultDataSub <- na.omit(adultDataSub)

function(input, output, session) { 
    
        output$distPlot <- renderPlot({
    #  Data Exploration Tab
     if(input$dist == "Gender classification and income level"){
         g <- ggplot(data = adultDataSub, aes(x = Sex))
         g + geom_bar(aes(fill = Income), 
                      position = "dodge") + labs(fill = "Income Level") +
             coord_flip()
     } else if(input$dist == "Race classification and income level"){
         g <- ggplot(data = adultDataSub, aes(x = Race))
         g + geom_bar(aes(fill = Income), 
                      position = "dodge") + labs(fill = "Income Level") +
             coord_flip()
     } else if(input$dist == "Occupation classification and Income Level"){
         g <- ggplot(data = adultDataSub, aes(x = Occupation))
         g + geom_bar(aes(fill = Income), 
                      position = "dodge") + labs(fill = "Income Level") +
             coord_flip()
     } else {
         g <- ggplot(data = adultDataSub, aes(x = Education_Number))
         g + geom_bar(aes(fill = Income), 
                      position = "dodge") + labs(fill = "Income Level") +
             coord_flip()
     }
    })
        output$summary <- DT::renderDataTable({
        var <- input$TI
        adultDataTable <- adultDataSub[, c("Income", var),drop = FALSE]
        tab <- aggregate(adultDataTable[[var]] ~ Income,
                         data = adultDataTable, FUN = c("mean"))
        tab[, 2] <- round(tab[, 2], input$NI)
        names(tab)[2] <- paste0("Average ", var)
        tab
        })
    
    #
        #
        #
        # #Model tab data
         # getModel <- reactive({
         #     newDataModel <- adultDataSuv %>% filter(position == input$positionSelectModel & year == input$yearsModel) %>% select_if(is.numeric)
         # }) #end explore tab data
        # 
        # #Model tab user inputs
        # #dependent variable
        # observe({
        #     newDataModel <- getDataModel()
        #     numVars <- newDataModel %>% select_if(is.numeric)
        #     numVars <- select_if(numVars, colSums(numVars)>0) %>% select(-year) %>% colnames()
        #     varList <- as.list(numVars)
        #     updateSelectInput(session, "varDependent", choices = varList, selected = "total_points")
        # }) #end dependent variable user input
        # 
        # #update plot outputs
         # observe({
         #     if(input$modelSelect == "Multiple Linear Regression") {
         #         updateSelectInput(session, "modelPlotSelect", choices = list("Residuals vs Fitted" = 1, "Normal Q-Q" = 2, 
        #                                                                      "Scale-Location" = 3, "Cook's Distance" = 4, 
        #                                                                      "Residuals vs Leverage" = 5, "Cook's Dist vs Leverage" = 6))
        #     } else {
        #         updateSelectInput(session, "modelPlotSelect", choices = list("Residuals vs Fitted" = 1, "RMSE vs Boosting Iterations" = 2, 
        #                                                                      "Relative Influence" = 3))
        #     }
        #     
        # }) #end plot outputs
        # 
        # #update summary outputs
        # observe({
        #     if(input$modelSelect == "Multiple Linear Regression") {
        #         updateSelectInput(session, "modelSummarySelect", choices = list("Summary"))
        #     } else {
        #         updateSelectInput(session, "modelSummarySelect", choices = list("Relative Influence" = 1, "Tune Values" = 2))
        #     }
        # })
        # 
        # #independent variables
        # observe({
        #     newDataModel <- getDataModel()
        #     numVars <- newDataModel %>% select_if(is.numeric)
        #     numVars <- select_if(numVars, colSums(numVars)>0) %>% select(-year) %>% colnames()
        #     varList <- as.list(numVars)
        #     updateCheckboxGroupInput(session, "varSelectModel", choices = varList, selected = varList[c(1,3:6)])
        # }) #end independent variable user input
        # 
        # #player select
        # observe({
        #     newDataModel <- epl %>% filter(position == input$positionSelectModel & year == input$yearsModel)
        #     
        #     #update player list
        #     updateSelectInput(session, "playerSelectModel",
        #                       choices = newDataModel$full_name %>% sort())
        # }) 
        # 
        # #update players
        # playerData <- reactive({
        #     epl %>% filter(full_name == input$playerSelectModel & year == input$yearsModel)
        # })
        # 
        # 
        # #update player values
        # observe({
        #     selectPlayerData <- playerData()
        #     updateNumericInput(session, "total_points", value = selectPlayerData$total_points)
        #     updateNumericInput(session, "now_cost", value = as.numeric(selectPlayerData$now_cost))
        #     updateNumericInput(session, "points_per_game", value = as.numeric(selectPlayerData$points_per_game))
        #     updateNumericInput(session, "minutes", value = as.numeric(selectPlayerData$minutes))
        #     updateNumericInput(session, "goals_scored", value = as.numeric(selectPlayerData$goals_scored))
        #     updateNumericInput(session, "assists", value = as.numeric(selectPlayerData$assists))
        #     updateNumericInput(session, "bonus", value = as.numeric(selectPlayerData$bonus))
        #     updateNumericInput(session, "bps", value = as.numeric(selectPlayerData$bps))
        #     updateNumericInput(session, "goals_conceded", value = as.numeric(selectPlayerData$goals_conceded))
        #     updateNumericInput(session, "own_goals", value = as.numeric(selectPlayerData$own_goals))
        #     updateNumericInput(session, "penalties_missed", value = as.numeric(selectPlayerData$penalties_missed))
        #     updateNumericInput(session, "yellow_cards", value = as.numeric(selectPlayerData$yellow_cards))
        #     updateNumericInput(session, "red_cards", value = as.numeric(selectPlayerData$red_cards))
        #     updateNumericInput(session, "saves", value = as.numeric(selectPlayerData$saves))
        #     updateNumericInput(session, "clean_sheets", value = as.numeric(selectPlayerData$clean_sheets))
        #     updateNumericInput(session, "creativity", value = as.numeric(selectPlayerData$creativity))
        #     updateNumericInput(session, "ict_index", value = as.numeric(selectPlayerData$ict_index))
        #     updateNumericInput(session, "influence", value = as.numeric(selectPlayerData$influence))
        #     updateNumericInput(session, "threat", value = as.numeric(selectPlayerData$threat))
        #     updateNumericInput(session, "selected_by_percent", value = as.numeric(selectPlayerData$selected_by_percent))
        # })
        # 
        # #end model tab user inputs
        # 
        # #training data set
        # train <- reactive({
        #     
        #     #get data
        #     dataModel <- getDataModel()
        #     
        #     #set seed prior to sampling
        #     set.seed(1)
        #     
        #     #sample observations for training data set
        #     train <- sample(1:nrow(dataModel), size = nrow(dataModel)*(as.numeric(input$train)/100))
        #     
        #     #use remaining samples for test data set
        #     test <- dplyr::setdiff(1:nrow(dataModel), train)
        #     
        #     return(list(train,test))
        #     
        # }) #end training data set
        # 
        # #Plot output
        # output$Modelplot <- renderPlot(
        #     if(input$modelSelect == "Multiple Linear Regression"){
        #         plot(plotModel()[[1]], which = as.numeric(input$modelPlotSelect), main = "Multiple Linear Regression")
        #     } else if(input$modelPlotSelect == 1) {
        #         fitModel <- plotModel()[[1]]
        #         predictValues <- predict(fitModel)
        #         actualValues <- fitModel$finalModel$data$y
        #         plot(predictValues-actualValues, ylab = "Residuals", xlab = "Fitted Values", main = "Boosted Trees Model: Residuals vs Fitted Values"); abline(h=0, lty=2)
        #     } else if(input$modelPlotSelect == 2) {
        #         plot(plotModel()[[1]], main = "Boosted Trees Model: RMSE vs # Boosting Iterations")
        #     } else {
        #         plot(summary(plotModel()[[1]]), main = "Boosted Trees Model: Relative Influence")
        #     }
        # ) #end plot output
        # 
        # #Model tab plots
        # plotModel <- reactive({
        #     
        #     #get value of user inputs
        #     center <- input$centerModel
        #     
        #     #get filtered data
        #     newDataModel <- getDataModel()
        #     
        #     #get test train
        #     train_test <- train()
        #     train <- train_test[[1]]
        #     test <- train_test[[2]]
        #     
        #     #create separate training and test data frames
        #     dfTrain <- newDataModel[train, ]
        #     dfTest <- newDataModel[test, ]
        #     
        #     #formula step 1
        #     if(input$varInteract == 1 & input$modelSelect == "Multiple Linear Regression") {
        #         independent <- paste(input$varSelectModel, collapse = "*")
        #     } else {
        #         independent <- paste(input$varSelectModel, collapse = "+")
        #     }
        #     
        #     #formula step 2
        #     fm <- paste(input$varDependent,"~",independent)
        #     
        #     #cross-validation
        #     trctrl <- trainControl(method = "repeatedcv", number = input$folds, repeats = input$repeats)
        #     
        #     #tuning grid
        #     gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
        #                             n.trees = input$numTrees, 
        #                             shrinkage = 0.1,
        #                             n.minobsinnode = 20
        #     )
        #     
        #     #fit models
        #     if(input$modelSelect == "Multiple Linear Regression") {
        #         #linear model
        #         fit <- lm(formula = as.formula(fm), data = as.data.frame(dfTrain))
        #     } else if(input$CV == 1){
        #         if(input$trees == 1) {
        #             fit <- caret::train(as.formula(fm), data = as.data.frame(dfTrain), method = "gbm", trControl = trctrl, verbose = FALSE, tuneGrid = gbmGrid)
        #         } else {
        #             fit <- caret::train(as.formula(fm), data = as.data.frame(dfTrain), method = "gbm", trControl = trctrl, verbose = FALSE)
        #         }
        #     } else {
        #         if(input$trees == 1) {
        #             fit <- caret::train(as.formula(fm), data = as.data.frame(dfTrain), method = "gbm", verbose = FALSE, tuneGrid = gbmGrid)
        #         } else {
        #             fit <- caret::train(as.formula(fm), data = as.data.frame(dfTrain), method = "gbm", verbose = FALSE)
        #         }    
        #     }
        #     
        #     return(list(fit, dfTest, dfTrain))
        #     
        # }) #end model plots reactive
        # 
        # #RMSE output
        # output$predictModel <- renderPrint({
        #     dfTest <- plotModel()[[2]]
        #     dependent <- as.data.frame(dfTest) %>% select(input$varDependent)
        #     predict <- predict(plotModel()[[1]], newdata = as.data.frame(dfTest))
        #     error <- unlist(predict-dependent)
        #     sqrt(mean((error)^2))
        # }) #end RMSE output
        # 
        # #summary output
        # output$summaryModel <- renderPrint({
        #     if(input$modelSelect == "Multiple Linear Regression"){
        #         summary(plotModel()[[1]])
        #     } else if(input$modelSummarySelect == 1) {
        #         summary(plotModel()[[1]])
        #     } else {
        #         fit <- plotModel()[[1]]
        #         fit$finalModel$tuneValue
        #     }
        #     
        # }) #end summary output
        # 
        # #predict value output
        # observe({
        #     #   #var dependent
        #     output$predictInfo <- renderText({
        #         paste0("Prediction for ", input$varDependent)
        #     })
        #     
        #     output$predictValue <- renderPrint({
        #         total_points <- input$total_points
        #         now_cost <- input$now_cost
        #         points_per_game <- input$points_per_game
        #         minutes <- input$minutes
        #         goals_scored <- input$goals_scored
        #         assists <- input$assists
        #         bonus <- input$bonus
        #         bps <- input$bps
        #         goals_conceded <- input$goals_conceded
        #         own_goals <- input$own_goals
        #         penalties_missed <- input$penalties_missed
        #         penalties_saved <- input$penalties_saved
        #         yellow_cards <- input$yellow_cards
        #         red_cards <- input$red_cards
        #         saves <- input$saves
        #         clean_sheets <- input$clean_sheets
        #         creativity <- input$creativity
        #         ict_index <- input$ict_index
        #         influence <- input$influence
        #         threat <- input$threat
        #         selected_by_percent <- input$selected_by_percent
        #         
        #         newData <- as.data.frame(cbind(total_points, now_cost, points_per_game, minutes, goals_scored, assists, bonus, bps, goals_conceded, own_goals, 
        #                                        penalties_missed, penalties_saved, yellow_cards, red_cards, saves, clean_sheets, creativity, ict_index, influence, threat, selected_by_percent))
        #         
        #         fit<-plotModel()[[1]]
        #         
        #         prediction <- predict(fit, newData)
        #         as.vector(prediction)
        #     }) #end predict value output
        # })
        # 
        # 
        # #plot download handler
        # output$downloadModelPlot <- downloadHandler(
        #     filename = function() {
        #         paste("EPL", input$modelSelect, input$positionSelectModel, input$yearsModel, ".png", sep ="_")
        #     },
        #     content = function(file) {
        #         png(file, width = 1200)
        #         if(input$modelSelect == "Multiple Linear Regression"){
        #             plot(plotModel()[[1]], which = as.numeric(input$modelPlotSelect), main = "Multiple Linear Regression")
        #         } else if(input$modelPlotSelect == 1) {
        #             fitModel <- plotModel()[[1]]
        #             predictValues <- predict(fitModel)
        #             actualValues <- fitModel$finalModel$data$y
        #             plot(predictValues-actualValues, ylab = "Residuals", xlab = "Fitted Values", main = "Boosted Trees Model: Residuals vs Fitted Values"); abline(h=0, lty=2)
        #         } else if(input$modelPlotSelect == 2) {
        #             plot(plotModel()[[1]], main = "Boosted Trees Model: RMSE vs # Boosting Iterations")
        #         } else {
        #             plot(summary(plotModel()[[1]]), main = "Boosted Trees Model: Relative Influence")
        #         }
        #         dev.off()
        #     }
        # ) #end plot download handler
        # 
        # #data download handler (training data)
        # output$downloadModelData <- downloadHandler(
        #     filename = function() {
        #         paste0("EPL_", input$modelSelect, "_training_data.csv")
        #     },
        #     content = function(file) {
        #         write.csv(plotModel()[[3]], file, row.names = FALSE)
        #     }
        # ) #end data download handler
        # 
        # #data download handler (testing data)
        # output$downloadTestData <- downloadHandler(
        #     filename = function() {
        #         paste0("EPL_", input$modelSelect, "_testing_data.csv")
        #     },
        #     content = function(file) {
        #         write.csv(plotModel()[[2]], file, row.names = FALSE)
        #     }
        # ) #end data download handler
        # 
        # # #end model tab
        # 
        # ____________________________________________________________________________________________________________________
    
    # Data Tab 
    getData <- reactive({
        newData <- adultData %>% filter(Income == input$incomeChoice &
                                            Sex == input$sexChoice) %>% 
            select(as.vector(input$variableChoice))
    }) 
    
    
    #Data tab output
    output$Table <- renderDataTable({
        getData()
    })
    
    output$downloadData <- downloadHandler(
         filename = function() {
             paste("Income_Prediction_Subset", ".csv")
         },
         content = function(file) {
            write.csv(getData(), file)
         }) #end data download handler
}
#end data tab