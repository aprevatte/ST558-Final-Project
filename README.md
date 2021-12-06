ST558 Final Project
================
Alex Prevatte
12/5/2021

# Purpose

This app examines the 1996 Census Data Set to predict income level based
on demographic characteristics.

# Required Packages

To perform exploratory data analysis and modeling I used the following
packages:

-   [`shiny`](https://cran.r-project.org/web/packages/shiny/index.html):
    Build interactive web apps
-   [`shinydashboard`](https://cran.r-project.org/web/packages/shinydashboard/index.html):
    Create shiny dashboard
-   [`tidyverse`](https://cran.r-project.org/web/packages/tidyverse/index.html):
    Data cleaning
-   [`DT`](https://cran.r-project.org/web/packages/DT/index.html): Data
    tables
-   [`factoextra`](https://cran.r-project.org/web/packages/factoextra/index.html):Visualization
-   [`plotly`](https://plotly.com/r/): Graphing library
-   [`caret`](https://cran.r-project.org/web/packages/caret/caret.pdf):
    Machine Learning
-   [`tree`](https://cran.r-project.org/web/packages/tree/index.html):
    Classification Tree
-   [\`randomForest\`\`](https://cran.r-project.org/web/packages/randomForest/randomForest.pdf):
    Random Forest Model

To install all of the packages, run this code:

``` r
install.packages("shiny")
install.packages("shinydashboard")
install.packages("tidyverse")
install.packages("DT")
install.packages("factoextra")
install.packages("plotly")
install.packages("caret")
install.packages("tree")
install.packages("randomForest")
```

# Run the code below to run the app

``` r
shiny::runGitHub("aprevatte/ST558-Final-Project", ref="main")
```
