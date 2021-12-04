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

function(input, output) { 

# ____________________________________________________________________________________________________________________

#Data tab 
getData <- reactive({
        newData <- adultData %>% filter(Income == input$incomeChoice &
                                               Sex == input$sexChoice)
                                           #%>% select(c(input$variableChoice)))

    }) 

 #Data tab output
 output$Table <- renderDataTable({
     getData()
 })
#end data tab output

# data download handler
 # output$Download <- downloadHandler(
 #     filename = "Income_Prediction.csv",
 #     content = function(file) {
 #         write.csv(getData(), file)
 #     }
 # ) #end data download handler
}
#end data tab