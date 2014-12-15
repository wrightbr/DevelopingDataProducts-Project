library(foreign)
library(datasets)
library(shiny)
library(ggplot2)

data <- airquality[,c("Ozone","Solar.R","Wind","Temp")]
Date.time <- paste(airquality$Day, airquality$Month, c(rep("1974",length(airquality$Day))))
Date.time <- strptime(Date.time, "%d %m %Y")
data$DateTime <- as.character(strptime(Date.time, "%Y-%m-%d", tz="America/Los_Angeles"))



shinyUI(pageWithSidebar(
  headerPanel("Weather App v1.0"),
  sidebarPanel(
    h4("Choose data"),
    
    selectInput("vary", "vary:", 
                choices=c("Ozone","Solar.R","Wind","Temp")),
    selectInput("varx", "varx:", 
                choices=c("DateTime","Ozone","Solar.R","Wind","Temp")),
    hr(),
    helpText("Data from AT&T (1961) The World's Telephones.")
  ),
  mainPanel(
    tabsetPanel(type="tabs",
                tabPanel("Plot", plotOutput('Plot2')),
                tabPanel("Table",dataTableOutput('table')),
                tabPanel("Input File", 
                         h4("Choose your data file"),
                         textInput("path", "File"),
                         actionButton("browse", "Browse"),
                         actionButton("upload", "Upload")),
                         dataTableOutput('table')
    )
    #p('Names Read'),
    #textOutput('text1')
    #p('Time Req. Read'),
    #textOutput('text2'),
    #verbatimTextOutput('content')
      
    )
))