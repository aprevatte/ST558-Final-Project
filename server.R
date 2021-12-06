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

# Remove 'fnlwgt', 'education', 'capital-gain', and, 'capital-loss'
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
    
    # # #Model  data
    adultDataSubset <- subset(adultDataSub, select = c("Age", "Education_Number", "Marital_Status", "Relationship", "Sex", "Hours_per_week", "Income"))
    
    adultDataSubset$Income <- as.factor(adultDataSubset$Income)
    adultDataSubset$Marital_Status <- as.factor(adultDataSubset$Marital_Status)
    adultDataSubset$Relationship <- as.factor(adultDataSubset$Relationship)
    adultDataSubset$Sex <- as.factor(adultDataSubset$Sex)
    adultDataSubset$Hours_per_week <- as.numeric(adultDataSubset$Hours_per_week)
    adultDataSubset$Education_Number <- as.numeric(adultDataSubset$Education_Number)
    
    # training data set
    glm <- reactive({
        set.seed(123)
        trainIndex <- createDataPartition(adultDataSubset$Income, p = 0.7, list = FALSE)
        adultTrain <- adultDataSubset[trainIndex, ]
        adultTest <- adultDataSubset[-trainIndex, ]
        
        if(input$modelChoice == "Logistic Regression") {
            
            fit <- train(Income ~ ., data = adultTrain, 
                         method = "glm", 
                         family = "binomial",
                         preProcess = c("center", "scale"),
                         trControl = trainControl(method = "cv", number = 10))
            mat <- confusionMatrix(data = adultTest$Income, reference = predict(fit, newdata = adultTest))
            
            accuracyClassification <- mat$overall[1]
            return(fit)
            
        }
        else if(input$modelChoice == "Classification Tree") {
            fullFit <- tree(Income ~ ., data = adultTrain)
            fullPred <- predict(fullFit, dplyr::select(adultTest, -"Income"), type = "class")
            fullTbl <- table(data.frame(fullPred, adultTest[, "Income"]))
            accuracyTree <- sum(fullTbl[1,1], fullTbl[2,2]) / sum(fullTbl)
            return(fullFit)
        }
        else{
            rfFit <- randomForest(Income ~ ., data = adultTrain, mtry = sqrt(6),
                                  ntree = 200, importance = TRUE)
            adultPred <- predict(rfFit, newdata=adultTest)
            adultTable <- table(adultPred, adultTest$Income)
            accuracyRF <- (sum(diag(adultTable)))/sum(adultTable)
            return(adultTable)
        }
    })
    
    #  summary output
    output$modelSummary <- renderPrint({
        if(input$modelChoice == "Logistic Regression") {
            summary(glm())
        }
        else if(input$modelChoice == "Classification Tree") {
            summary(glm())
        }
        else{
            print(glm())
        }
    })
    
    
    #predict value output
    observe({
        output$predict <- renderText({
            paste0("Prediction for Income")
        })
        
        output$predictValue <- renderPrint({
            Age <- input$Age
            Education_Number <- input$Education_Number
            Marital_Status <- input$Marital_Status
            Relationship <- input$Relationship
            Sex <- input$Sex
            Hours_per_week <- input$Hours_per_week
            
            
            data <- as.data.frame(cbind(Age, Education_Number, 
                                        Marital_Status, Relationship, Sex,
                                        Hours_per_week))
            
        }) 
        
    })
    
    
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
        }) 
}