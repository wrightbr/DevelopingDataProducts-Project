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
                tabPanel("About the App",
                  wellPanel(
                    h4("Welcome!"),
                    helpText("My name is Manu B. and I created this Shiny App for the 'Developing Data Products' course in coursera. 
                             You may find it simple or boring, but I consider it good enough for the available time we got. 
                             Using this App you'll be able to explore the 'Airquality' dataset, from 'R Datasets' package, which
                             you may find on the link below:"),
                    helpText(a("Air Quality Datasets Reference",href="http://stat.ethz.ch/R-manual/R-patched/library/datasets/html/airquality.html"))
                    #,
                  ),
                  #hr(),
                  wellPanel(
                    h4("About the airquality dataset"),
                    helpText("This dataset provides a total of 153 measurements of Ozone and Solar Radiation levels, wind velocity (in mph),
                             and Temperature (in Fahrenheit), taken from 1st May 1974 to 30th Sep of the same year at La Guardia Airport, NYC.")
                    #,
                  ),
                    #hr(),
                  wellPanel(
                    h4("App functionalities"),
                    helpText("With this app you'll be able to, basically:"),
                    tags$ul(
                      tags$li(h5("Plot the data:"),
                        tags$ul(
                          tags$li(
                            "Plot X vs Y plots with any of the variables contained."
                            ),
                          tags$li(
                            "See the maximum, minimum and average values for selected variables on plot."
                            ),
                          tags$li(
                            "Zoom at the X and Y axis to obtain a focused view of data."
                          ),
                          tags$li(
                            "Select the plot symbols (points, lines, area)."
                          ),
                          tags$li(
                            "Add, if desired, a fit line to the data plotted."
                          ),
                          tags$li(
                            "Change the colors for each of the lines, areas or points plotted."
                          )
                          )
                      ),
                        
                      tags$li(h5("See the data:"),
                              tags$ul(
                                tags$li(
                                  "See the whole datatable."
                                ),
                                tags$li(
                                  "Select the variables you want the table to show."
                                ),
                                tags$li(
                                  "Sort the data by different aspects (i.e., lower to higher temperature)."
                                ),
                                tags$li(
                                  "Search for specific data values for any variable."
                                )
                              )     
                        ),
                      
                      tags$li(h5("Download the data:"),
                              tags$ul(
                                tags$li(
                                  "Download the table (according to selected variables and choices)."
                                ),
                                tags$li(
                                  "Download and Save in your computer your custom plot."
                                )
                              )     
                      )
                      
                    )
                  )
                ),
               
               tabPanel("How to use this App",
                        wellPanel(
                            h4("How to use the Plot tab functions:"),
                            helpText("A")
                          ),
                        wellPanel(
                          h4("How to use the Table tab functions:"),
                          helpText("B")
                          )
                  
               ),
               
               tabPanel("Plot", 
                         h4("Plot of your Data", align='center'),
                         wellPanel(
                           fluidRow(
                             column(2,
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
                                    
                             ),
                             column(10,
                                    plotOutput('MainPlot'))
                           )
                           ),
                         hr(),
                         fluidRow(
                           column(3,wellPanel(
                             h4(textOutput('var_x')),
                             fluidRow(
                               column(5,
                                      h5('Average')
                                      ),
                               column(6,
                                      verbatimTextOutput('x_avg')
                                      )
                               ),

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
                               column(5,
                                      h5('Average')
                               ),
                               column(6,
                                      verbatimTextOutput('y_avg')
                               )
                             ),
                          
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
                                  
                           )),
                           
                           column(3,wellPanel(
                             helpText("Hey"),
                             h4("Save this plot as png"),
                             textInput("path_img", "Choose the destination folder:"),
                             actionButton("browse_img", "Browse"),
                             textInput("file_name_img", "Name the file:"),
                             br(),
                             actionButton("download_img", "Save")
                             
                           ))
                           
                           )
                         
                         ),
                
               tabPanel("Table", 
                         sidebarLayout(
                           sidebarPanel(
                             h4("Select variables to display:"),
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
    
                  ),
               
               tabPanel("Reference articles and code",
                        wellPanel(
                          h4("Github Repo:"),
                          helpText("The main code and files you can find on my Github Repository for this project (see link below):"),
                          helpText(a("AirQuality Data Analisys App 6.0 Github Repo:",href="https://github.com/manuelblancovalentin/DevelopingDataProducts-Project/"))
                        ),
                        wellPanel(
                          h4("How to use the Table tab functions:"),
                          helpText("B")
                        )
                        
               )
     

    )

)