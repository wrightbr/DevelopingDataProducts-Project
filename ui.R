library(shiny)
library(foreign)
library(datasets)
library(ggplot2)
require(shinysky)
library(scales)

data <- airquality[,c("Ozone","Solar.R","Wind","Temp")]
Date.time <- paste(airquality$Day, airquality$Month, c(rep("1974",length(airquality$Day))))
Date.time <- strptime(Date.time, "%d %m %Y")
data$DateTime <- as.Date(as.character(strptime(Date.time, "%Y-%m-%d", tz="America/Los_Angeles")))
data <- data[complete.cases(data),]

shinyUI(
    navbarPage("AirQuality Data Analysis App v6.0",
                tabPanel("About the App",helpText("With this Shiny App you'll be able to explore the 'Airquality' dataset, from 'R Datasets' package.")),
                tabPanel("Plot", 
                         h4("Plot of your Data", align='center'),
                         wellPanel(plotOutput('MainPlot')),
                         hr(),
                         fluidRow(
                           column(3,wellPanel(
                                  h4("Choose data"),
                                  
                                  selectInput("vary", "Y Variable:", 
                                              choices=c("Ozone","Solar.R","Wind","Temp")),
                                  selectInput("varx", "X Variable:", 
                                              choices=c("DateTime","Ozone","Solar.R","Wind","Temp")),
                                  hr(),
                                  h4("Plot Var"),
                                  checkboxInput("points_checkbox", label = "Plot Points", value = TRUE),
                                  checkboxInput("line_checkbox", label = "Plot Line", value = FALSE),
                                  checkboxInput("fit_checkbox", label = "Add Fit Line", value = FALSE),
                                  checkboxInput("area_checkbox", label = "Plot Data Area", value = FALSE)
                                  )),
                           
                           column(3,wellPanel(
                             h4(textOutput('var_x')),
                             fluidRow(
                               column(6,
                                      h5('min. value'),
                                      verbatimTextOutput("x_min")
                                      ),
                               column(6,
                                      h5('max. value'),
                                      verbatimTextOutput("x_max")
                                      )
                               ),
                             h4(textOutput('var_y')),
                             fluidRow(
                               column(6,
                                      h5('min. value'),
                                      verbatimTextOutput("y_min")
                               ),
                               column(6,
                                      h5('max. value'),
                                      verbatimTextOutput("y_max")
                               )
                             )

                             )),                           
                           
                           column(3, wellPanel(
                                  tabsetPanel(
                                    tabPanel("Fit",
                                              h5("Line Color"),
                                              jscolorInput("color_line_fit"),
                                              helpText("Configure data fitted line color."),
                                              h5("Fill Color"),
                                              jscolorInput("color_fill_fit"),
                                              helpText("Configure data fitted fill color.")
                                    ),
                                    
                                    tabPanel("Area",
                                             h5("Line Color"),
                                             jscolorInput("color_line_area"),
                                             helpText("Configure Data area plot line color."),
                                             h5("Fill Color"),
                                             jscolorInput("color_fill_area"),
                                             helpText("Configure Data area plot fill color.")
                                      ),
                                    
                                    tabPanel("Points",
                                             jscolorInput("color_points"),
                                             helpText("Configure data points color.")
                                      
                                      ),
                                    
                                    tabPanel("Line",
                                             jscolorInput("color_lines"),
                                             helpText("Configure data-values line color.")
                                             )
  
                                )
                                  
                           )),
                           column(3, wellPanel(
                                  
                                  sliderInput("slider_x", label = h4("X Axis Zoom"), min = 0, 
                                              max = 100, value=c(0,100), format="### %"),
                                  
                                  fluidRow(
                                    column(6,
                                           h5('min. x'),
                                           verbatimTextOutput("s_min_x")
                                    ),
                                    column(6,
                                           h5('max. x'),
                                           verbatimTextOutput("s_max_x")
                                    )
                                  ),                                
                                  
                                  hr(),
                                  
                                  sliderInput("slider_y", label = h4("Y Axis Zoom"), min = 0, 
                                              max = 100, value=c(0,100), format="### %"),
                                  fluidRow(
                                    column(6,
                                           h5('min. y'),
                                           h4(verbatimTextOutput("s_min_y"))
                                    ),
                                    column(6,
                                           h5('max. y'),
                                           verbatimTextOutput("s_max_y")
                                    )
                                  ) 
                                  
                           ))
                           
                           )
                         
                         ),
                
               tabPanel("Table", 
                         sidebarLayout(
                           sidebarPanel(
                             checkboxGroupInput('show_vars','Columns in airquality dataset to show:',
                                                names(data), selected = names(data)),
                             hr(),
                             h4("Download this datatable"),
                             textInput("path", "Choose the destination for your data file:"),
                             actionButton("browse", "Browse"),
                             textInput("file_name", "Name the file:"),
                             br(),
                             selectInput("ext", "Choose file extension:", 
                                         choices=c("txt","csv","xls","xlsx", "dta")),
                             selectInput("separ", "Choose separator character:", 
                                         choices=c("\t",",",";",".","-")),
                             helpText("First character is tab."),
                             actionButton("download", "Download")

                             ),
                           
                           mainPanel(
                             dataTableOutput('table')
                             )
                          
                        )
    
                  )
     
#                 tabPanel("Download Data File", 
#                          h4("Choose the destination of your data file:"),
#                          textInput("path", "Path:"),
#                          actionButton("browse", "Browse"),
#                          actionButton("download", "Download")
#                 )
    )

)