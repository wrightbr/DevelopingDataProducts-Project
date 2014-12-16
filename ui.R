library(shiny)
library(foreign)
library(datasets)
library(ggplot2)
require(shinysky)


shinyUI(
    navbarPage("App v1.0",
                tabPanel("Intro",helpText("WHATEVER. GO TO PLOT TAB.")),
                tabPanel("Plot", 
                         plotOutput('Plot2'),
                         hr(),
                         fluidRow(
                           column(3,
                                  h4("Choose data"),
                                  
                                  selectInput("vary", "vary:", 
                                              choices=c("Ozone","Solar.R","Wind","Temp")),
                                  selectInput("varx", "varx:", 
                                              choices=c("DateTime","Ozone","Solar.R","Wind","Temp")),
                                  hr(),
                                  h4("Plot Var"),
                                  checkboxInput("fit_checkbox", label = "Fit Line", value = FALSE),
                                  checkboxInput("area_checkbox", label = "Plot Area", value = FALSE)
                                  ),
                           
                           column(3, offset=1,
                                  h4("Fit Line Params"),
                                  h5("Line Color"),
                                  jscolorInput("color_line_fit"),
                                  h5("Fill Color"),
                                  jscolorInput("color_fill_fit"),
                                  
                                  h4("Area Params"),
                                  h5("Line Color"),
                                  jscolorInput("color_line_area"),
                                  h5("Fill Color"),
                                  jscolorInput("color_fill_area"),
                                  
                                  br(),
                                  sliderInput("slider", label = h4("X Axis Zoom Select"), min = 0, 
                                              max = 100, value=c(0,100))
                                  ),
                           
                           column(3,offset=1,
                                  h4("X Min"),
                                  verbatimTextOutput("s_min"),
                                  h4("X Max"),
                                  verbatimTextOutput("s_max"),
                                  h4("X Minimum"),
                                  verbatimTextOutput("x_min"),
                                  h4("X Max"),
                                  verbatimTextOutput("x_max")
                           )
                           
                           )
                         
                         ),
                tabPanel("Table",dataTableOutput('table')),
                tabPanel("Input File", 
                         h4("Choose your data file"),
                         textInput("path", "File"),
                         actionButton("browse", "Browse"),
                         actionButton("upload", "Upload")),
                         dataTableOutput('table')
    )

)