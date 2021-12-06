library(tidyverse)
library(shinydashboard)
library(DT)
library(factoextra)
library(plotly)

dashboardPage(
    dashboardHeader(title = "Census Dashboard"),
    dashboardSidebar(sidebarMenu(
        menuItem("About", tabName = "about", icon = icon("table")),
        menuItem("Data Exploration", tabName = "dataexp", icon = icon("chart-bar")),
        menuItem("Modeling", tabName = "modeling", icon = icon("chart-pie")),
        menuItem("Data", tabName = "data", icon = icon("chart-pie"))
    )
    ),
    dashboardBody(tabItems(
        #start about tab
        tabItem(tabName = "about",
                tabsetPanel(
                    tabPanel("About",
                             h3(tags$b("Purpose of the Application")),
                             h4("The Census Income App is used to show historical demographic and income data from individuals living in the U.S. This data can be used to model and predict income levels based on a variety of characteristics inputted by the user such as age, education, sex, etc."),
                             h3(tags$b("Data Description")),
                             h4("This data set contains attributes from the 1994 Census database. Data available for the Census Income app is located ", tags$a(href="https://archive.ics.uci.edu/ml/datasets/adult", "here"), "and is sourced from the UCI Machine Learning Repository. The following variables were used for exploratory data analysis and prediction:"),
                             h4(tags$b("age:"), "continuous"),
                             h4(tags$b("workclass:"), "Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked"),
                             h4(tags$b("fnlwgt:"), "continuous"),
                             h4(tags$b("education:"), "Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool"),
                             h4(tags$b("education-num:"), "continuous"),
                             h4(tags$b("marital-status:"), "Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse"),
                             h4(tags$b("occupation:"), "Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces"),
                             h4(tags$b("relationship:"), "Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried"),
                             h4(tags$b("race:"), "White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black"),
                             h4(tags$b("sex:"), "Female, Male"),
                             h4(tags$b("capital-gain:"), "continuous"),
                             h4(tags$b("capital-loss:"), "continuous"),
                             h4(tags$b("hours-per-week:"), "continuous"),
                             h4(tags$b("native-country:"), "United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands"),
                             h3(tags$b("Purpose of the Data Exploration Page")),
                             h4("The purpose of this page is to examine trends in gender, race, occupation, and education as it relates to income level. The average age variable is also summarized within each income category"),
                             h3(tags$b("Purpose of the Modeling and Prediction Page")),
                             h4("The modeling and prediction page has the purpose of examining three different models for summarizing and determining the best model fit for the data. The models used in this application include logistic regression, classification tree, and random forest. After determining the best model, predictions were made from subsets of the data chosen by the user."),
                             h3(tags$b("Purpose of the Data Page")),
                             h4("The purpose of the data page is to have the user filter the entire data set and download copies of the data.")
                    )
                )
        ),
        

        # Start Data Exploration Tab
        tabItem(tabName = "dataexp",
                fluidRow(
                    column(3,
                           box(width = 12,
                               "You can create a few bar plots using the radio buttons below:",
                               br(),
                               radioButtons(inputId = "dist",
                                            label = list("Select the Plot Type"),
                                            choices = list("Gender classification and income level", 
                                                           "Race classification and income level",
                                                           "Occupation classification and Income Level",
                                                           "Education classification and Income Level")),
                               "You can find the ",
                               strong("sample mean"),
                               "for a few variables below:",
                               selectInput("TI", "Variables to Summarize", choices = list("Age")), 
                               #                                                            "Amount",
                               #                                                            "Duration")),
                               numericInput("NI", "Select the number of digits for rounding", 
                                            min = 0,max = 5, value = 0, step = 1)
                           )),
                    
                    column(9, 
                           plotOutput("distPlot"),
                           #textOutput("myText"),
                           dataTableOutput("summary")
                    )
                )),
        
        #Start models tab
        tabItem(tabName = "modeling",
                tabsetPanel(
                    tabPanel("Info",
                             fluidRow(
                                 h2("Modeling Approaches"),
                                 h3("Generalized Linear Regression - Logistic Regression"),
                                 h4("Logistic regression measures the relationship between the dependent and independent variables by estimating probabilities of success using the logit function. The benefits of this approach is that it is easy to implement and efficient to train. The disadvantage to this modeling technique is that it should not be used if the number of observations is less than the number of predictor variables. Another disadvantage is the assumption of linearity between the response and the predictors."),
                                 h3("Classification Tree"),
                                 h4("Classification trees are used for assigning a variable to a categorical class. The algorithm then identifies the class in which the target variable would fall under. The advantages to this procedure is that normalization and scaling are not required. Also, interpretation through tree visualizations can be straight forward. The disadvantage to this method is that small changes in the data can dramatically change the structure of the tree. In addition, there is a high probability of over-fitting."),
                                 h3("Random Forest Model"),
                                 h4("The random forest model is used to build an ensemble of decision trees and average them together. The advantage of this method is that due to averaging and randomization, this model is less likely to overfit the data. The disadvantage to this technique is the complexity of combining many trees and how this relates to interpretability. The training time for a random forest model can be much longer compared to regular decision trees."),
                                 h3("Equation to evaluate model performance"),
                                 h4(withMathJax(helpText("$$Accuracy = {\\frac{TP+TN}{TP+TN+FP+FN}}$$"))),
                             )),
                    
                    tabPanel("Fitting",
                             fluidRow(
                                 column(12,
                                        box(width = 12, title = "Model Parameters",
                                            checkboxGroupInput("variables", label = "Predictor variables",
                                                               choices = list("Age", "Education_Number", "Marital_Status", "Relationship", "Sex", "Hours_per_week")),
                                            
                                            selectInput("modelChoice", label = "Model Type",                                                choices = list("Logistic Regression", "Classification Tree", "Random Forest")),
                                            selectInput("varDependent", label = "Select Dependent Variable", choices = "Income"),
                                            
                                            column(12,
                                                   box(width = 12,
                                                       verbatimTextOutput("modelSummary"))
                                            ))
                                 ))),
                    
                    
                    tabPanel("Prediction",
                             column(3,
                                    box(width = 12, title = "Select the following attributes",
                                        actionButton("Prediction", label = "Predict"),
                                        numericInput("Age","Age", value = NULL), 
                                        numericInput("Education_Number","Education_Number", value = NULL),
                                        selectInput("Marital_Status","Marital_Status", choices = list("Married-civ-spouse", "Divorced", "Never-married", "Separated", "Widowed", "Married-spouse-absent", "Married-AF-spouse")), 
                                        selectInput("Relationship","Relationship", choices = list("Wife", "Own-child", "Husband", "Not-in-family", "Other-relative", "Unmarried")), 
                                        selectInput("Sex","Sex", choices = list("Female", "Male")),
                                        numericInput("Hours_per_week","Hours_per_week", value = NULL),
                                    ), 
                                    box(width = 12,
                                        textOutput("predict"),
                                        verbatimTextOutput("predictValue")
                                    ))))), 
        
        
        # Data tab
        tabItem(tabName = "data",
                fluidRow(
                    column(3,
                           box(width = 12,
                               selectInput("incomeChoice", label = "Income", 
                                           choices = list("<=50K" = "<=50K", ">50K" = ">50K")),
                               selectInput("sexChoice", label = "Gender", 
                                           choices = list("Male" = "Male", "Female" = "Female")),
                               checkboxGroupInput("variableChoice", label = "Variable Choice",
                                                  choices = list("Age", "Workclass", "fnlwgt", "Education", "Education_Number", "Marital_Status", "Occupation", "Relationship", "Race", "Capital_Gain", "Capital_Loss", "Native_Country"),
                                                  selected = list("Age", "Workclass", "Education"))
                           )
                    ),
                    column(9, 
                           dataTableOutput("Table"),
                           downloadButton("downloadData", "Download")
                    )
                )
        ) 
    ) 
    ))  
