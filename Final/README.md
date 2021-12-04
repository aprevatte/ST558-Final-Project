ST558 Final Project
================
Alex Prevatte
12/4/2021

-   [Purpose](#purpose)
-   [Required Packages](#required-packages)
-   [Run the code below to run the
    app](#run-the-code-below-to-run-the-app)

# Purpose

This app examines the 1996 Census Data Set to predict income level based
on demographic characteristics.

# Required Packages

To perform exploratory data analysis and modeling I used the following
packages:

-   [`shiny`](https://cran.r-project.org/web/packages/jsonlite/): JSON
    parser for R
-   [`shinydashboard`](https://cran.r-project.org/web/packages/jsonlite/):
    JSON parser for R
-   [`tidyverse`](https://cran.r-project.org/web/packages/knitr/index.html):
    Report generation
-   [`DT`](https://www.tidyverse.org/): Data cleaning, filtering,
    graphing
-   [`factoextra`](https://cran.r-project.org/web/packages/RCurl/RCurl.pdf):
-   [`plotly`](https://cran.r-project.org/web/packages/RCurl/RCurl.pdf):
-   [`ggrepel`](https://cran.r-project.org/web/packages/RCurl/RCurl.pdf):
-   [`caret`](https://cran.r-project.org/web/packages/RCurl/RCurl.pdf):

To install all of the packages, run this code:

``` r
install.packages("shiny")
install.packages("shinydashboard")
install.packages("tidyverse")
install.packages("plotly")
install.packages("DT")
install.packages("caret")
install.packages("factoextra")
install.packages("ggrepel")
```

# Run the code below to run the app

``` r
shiny::runGitHub("aprevatte/ST558-Final-Project", ref="main")
```
