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
        menuItem("Data", tabName = "data", icon = icon("dashboard"))
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
                             h4("something"),
                             h3(tags$b("Purpose of the Modeling and Prediction Page")),
                             h4("something"),
                             h3(tags$b("Purpose of the Data Page")),
                             h4("something")
                    )
                )
        ),
        
        #
        #
        #
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
        
        #
        #
        #
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
                     column(4,
            box(width = 12, title = "Model Parameters",
               selectInput("variables", label = "Predictor variables",
                                        choices = list("Age" = "AGE", "Education_Number" = "EDNUM", "Marital_Status" = "MS", "Relationship" = "RELATIONSHIP", "Sex" = "SEX", "Hours_per_week" = "HPW", "Income" = "INCOME")),
               
               selectInput("modelChoice", label = "Model Type",                                                choices = list("Logistic Regression", "Classification Tree", "Random Forest")),
                 sliderInput("train", "Percent of Training Data to Partition",
                             min = 20, max = 100, step = 5, value = 70),
                 # conditionalPanel(condition = "input.modelSelect == 'Logistic Regression'"),
                 # conditionalPanel(condition = "input.modelSelect == 'Classification Tree'"),
                 # conditionalPanel(condition = "input.modelSelect == 'Random Forest'",
                 # checkboxInput("CV", "Cross Validation", value = FALSE)),
                
                 # conditionalPanel(condition = "input.CV == 1",
                 # sliderInput("folds", "Folds", min = 2, max = 10, value = 10),
                 # sliderInput("repeats", "Repeats", min = 2, max = 10, value = 3)
                 #                                 ),
                 checkboxInput("trees", tags$b("Select Trees"), value = FALSE),
                 conditionalPanel(condition = "input.trees == 1",
                 sliderInput("numTrees", "Trees", min = 50, max = 1000, step = 50, value = 500)
                                                 )
                                            ),
                                box(width = 12, title = "Output",
                                selectInput("modelSummary", "Summary",
                                                         choices = NULL),
                                selectInput("modelSummarySelect", "Summary",
                                                         choices = NULL)
                                         ),
                                 column(9,
                                         box(width = 14,
                                             plotOutput("Modelplot", height = 500),
                                             downloadButton("downloadModelPlot", "Plot"),
                                             downloadButton("downloadModelData", "Training Data"),
                                             downloadButton("downloadTestData", "Testing Data")
                                         ))))),
        #                                 h4("Testing Data RMSE"),
        #                                 verbatimTextOutput(("predictModel")),
        #                                 h4("Model Summary"),
        #                                 verbatimTextOutput(("summaryModel"))
        #                          )
        #                      ) #end fluidRow
        #             ), #end tabPanel "Model"
    
        
                     tabPanel("Prediction"))),
                              
        #                          column(3,
        #                                 box(width = 12, title = "Select Player or Enter Values",
        #                                     # actionButton("predictButton", label = "Predict"),
        #                                     # br(),
        #                                     # br(),
        #                                     selectInput("playerSelectModel", label = "Player", 
        #                                                 choices = NULL),
        #                                     numericInput("total_points","total_points", value = NULL), #total_points
        #                                     numericInput("now_cost","now_cost", value = NULL), #now_cost
        #                                     numericInput("points_per_game","points_per_game", value = NULL), #points_per_game
        #                                     numericInput("minutes","minutes", value = NULL), #minutes
        #                                     numericInput("goals_scored","goals_scored", value = NULL), #goals_scored
        #                                     numericInput("assists","assists", value = NULL), #assists
        #                                     numericInput("bonus","bonus", value = NULL), #bonus
        #                                     numericInput("bps","bps", value = NULL), #bps
        #                                     numericInput("goals_conceded","goals_conceded", value = NULL), #goals_conceded
        #                                     numericInput("own_goals","own_goals", value = NULL), #own_goals
        #                                     numericInput("penalties_missed","penalties_missed", value = NULL), #penalties_missed
        #                                     numericInput("penalties_saved","penalties_saved", value = NULL), #penalties_saved
        #                                     numericInput("yellow_cards","yellow_cards", value = NULL), #yellow_cards
        #                                     numericInput("red_cards","red_cards", value = NULL), #red_cards
        #                                     numericInput("saves","saves", value = NULL), #saves
        #                                     numericInput("clean_sheets","clean_sheets", value = NULL), #clean_sheets
        #                                     numericInput("creativity","creativity", value = NULL), #creativity
        #                                     numericInput("ict_index","ict_index", value = NULL), #ict_index
        #                                     numericInput("influence","influence", value = NULL), #influence
        #                                     numericInput("threat","threat", value = NULL), #threat
        #                                     numericInput("selected_by_percent","selected_by_percent", value = NULL) #threat
        #                                 ) #end box
        #                                 
        #                          ), #end column1
        #                          column(3,
        #                                 box(width = 12,
        #                                     textOutput("predictInfo"),
        #                                     verbatimTextOutput("predictValue")
        #                                 ) #end box
        #                          ) #end column2
        #                          
        #                      ) #end fluidRow
        #             ) #end tabPanel "Predict"
        #             
        #         ) #end tabsetPanel
        #         
        # ), #end model tab
   
        
        
        
        
        
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
    ) #end data tab
    ))
)  #end tabItems
#)  #end dashboardBody

#_____________________________________________________________________________________

#App arguments
# dashboardPage(
#     dashboardHeader(title = "FPL Data Analysis"),
#     sidebar,
#     body
# )