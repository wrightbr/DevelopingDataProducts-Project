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
    navbarPage("AirQuality Data Analysis App v8.0",
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
                            helpText("As you can see on the Plot tab, first you can select the variables to plot. By default
                                   an 'Ozone' vs 'DateTime' will be shown. By using these selectboxes you can access to the 
                                   variables stored at 'airquality' dataset (previously downloaded automatically by using the
                                   datasets R library) and select the variables you want to plot. Under them you can see 4
                                   checkboxes which allow you to plot the measures points, the line they create between each 
                                   measure-point, add a fit line for all measures of range selected and add the area all points
                                   create."),
                            helpText("At the right of this panel the plot is shown, it refreshes the new information
                                   you selected at the checkbox just in a second. Notice labels on both axes are
                                   displayed according to selected variables. This is also implemented on the 'server.R'."),
                            helpText("Below these a big panel with 4 subpanels is shown. These subpanels will allow
                                   the user to control some parameters of the data displayed on the plot:
                                   ")
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
                    tabsetPanel(    
                        tabPanel("Basic",
                          wellPanel(
                          
                          h4("Github Repo:"),
                          helpText("The main code and files you can find on my Github Repository for this project (see link below):"),
                          helpText(a("AirQuality Data Analisys App v8.0 Github Repository",href="https://github.com/manuelblancovalentin/DevelopingDataProducts-Project/")),
                          helpText("There you'll find both the 'server.R' and the 'ui.R' files. You can run the App with these files, just following the
                                   steps shown at Shiny Tutorial Lesson 1 (see link below):"),
                          helpText(a("Shiny Ref: How to run this App with R on your computer",href="http://shiny.rstudio.com/tutorial/lesson1/")),
                          
                          h4("Basic Notions:"),
                          helpText("There are a few things to remind before explaining detailed code: the whole App is structured with a 'navbarPage'. 
                                   Basically this Shiny interface widget creates the top navigation bar shown at the top of it.
                                   The title is defined and then each one of the tabs you want to create on this bar
                                   has to be inserted using the function 'tabPanel'. Then, if you look up the code at 'ui.R' file 
                                   you'll find a basic (huge) structure with a 'navBarPage' with as many 'tabPage' inside it as 
                                   tabs in the top bar of the App. See Shiny reference below:"),
                          helpText(a("Shiny Ref: navbarPage",href="http://shiny.rstudio.com/reference/shiny/latest/navbarPage.html")),
                          helpText(a("Shiny Ref: Application Layour Guide(tabPage explained on it)",href="http://shiny.rstudio.com/articles/layout-guide.html")),
                          helpText("Another function I used a lot on this app too is 'wellPanel'. Do you see the 'gray-shadowed rectangle'
                                   under this text? Well, that's a 'wellPanel'. Rather than letting this (ugly) blank default background
                                   I find this function more interesting and stylish."),
                          helpText(a("Shiny Ref: wellPanel", href="http://shiny.rstudio.com/reference/shiny/latest/wellPanel.html")),
                          helpText("Before digging into the whole code there's this last thing to talk about: User Interface. So Shiny is an html based
                                   App creator (or sort of), and that makes it possible to use a bunch of html parameters for improving your App.
                                   If you don't know anything about HTML I'm refering to bold titles, headers, tabs, separators, lists, and all this stuff
                                   I used all the time on this App. See Shiny reference below:"),
                          helpText(a("Shiny Ref: User-interface", href="http://shiny.rstudio.com/tutorial/lesson2/")),
                          
                          h4("Control Widgets"),
                          helpText("Control widgets are some interface tools that allow the user to communicate with the App.
                                   They can be buttons, text input boxes, checkboxes, radio buttons and so on. 
                                   They make your App a lot more interesting and valuable. This project required to use 
                                   some of these widgets so you'll see them everywhere. With them you can insert values and
                                   variables to your main R function (which is stored and specified at 'server.R' file, and 
                                   which will do the hard calculation job) and a lot of different things. The control widgets
                                   are called at the 'ui.R' file (user interface), and then its value can be got at the 
                                   'server.R' value by simply using the 'input$' prefix (followed by the widget ID). See the 
                                   Shiny reference and documentation about control widgets below:"),
                          helpText(a("Shiny Ref: Control widgets Tutorial",href="http://shiny.rstudio.com/tutorial/lesson3/")),
                          helpText(a("Shiny Ref: Widget Gallery", href="http://shiny.rstudio.com/gallery/widget-gallery.html"))
                        )
                      ),
                      tabPanel("Code",
                        wellPanel(
                          h4("server.R"),
                          helpText("Find it here:"),
                          helpText(a("server.R",href="https://github.com/manuelblancovalentin/DevelopingDataProducts-Project/blob/master/server.r")),
                          h4("ui.R:"),
                          helpText("Find it here:"),
                          helpText(a("ui.R",href="https://github.com/manuelblancovalentin/DevelopingDataProducts-Project/blob/master/ui.r"))
                        )
                      )
                    )
               )
     

    )

)