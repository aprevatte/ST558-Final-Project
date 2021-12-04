library(ggplot2)
library(shinydashboard)
library(DT)
library(factoextra)
library(plotly)

dashboardPage(
    dashboardHeader(title = "Census Dashboard"),
    dashboardSidebar(sidebarMenu(
        menuItem("About", tabName = "about", icon = icon("calendar")),
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
        
        
        #_____________________________________________________________________________________
        
        #Data table tab
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