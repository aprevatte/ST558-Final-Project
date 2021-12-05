library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(DT)
library(ggrepel)
library(factoextra)
library(caret)


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