library(shiny)
library(foreign)
library(datasets)
library(ggplot2)
require(shinysky)
library(scales)


shinyUI(
    navbarPage("App v1.0",
                tabPanel("Intro",helpText("WHATEVER. GO TO PLOT TAB.")),
                tabPanel("Plot", 
                         h4("Plot of your Data", align='center'),
                         wellPanel(plotOutput('Plot2')),
                         hr(),
                         fluidRow(
                           column(3,wellPanel(
                                  h4("Choose data"),
                                  
                                  selectInput("vary", "vary:", 
                                              choices=c("Ozone","Solar.R","Wind","Temp")),
                                  selectInput("varx", "varx:", 
                                              choices=c("DateTime","Ozone","Solar.R","Wind","Temp")),
                                  hr(),
                                  h4("Plot Var"),
                                  checkboxInput("fit_checkbox", label = "Fit Line", value = FALSE),
                                  checkboxInput("area_checkbox", label = "Plot Area", value = FALSE),
                                  verbatimTextOutput("LAB_DATE")
                                  )),
                           
                           column(3,wellPanel(
                             h4(textOutput('var_x')),
                             fluidRow(
                               column(6,
                                      h5('min. value'),
                                      #h5(textOutput('var_x_min')),
                                      verbatimTextOutput("x_min")
                                      #textOutput("x_min")
                                      ),
                               column(6,
                                      h5('max. value'),
                                      #h5(textOutput('var_x_max')),
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
                                  h4("Fit Line Params"),
                                  h5("Line Color"),
                                  jscolorInput("color_line_fit"),
                                  h5("Fill Color"),
                                  jscolorInput("color_fill_fit"),
                                  
                                  h4("Area Params"),
                                  h5("Line Color"),
                                  jscolorInput("color_line_area"),
                                  h5("Fill Color"),
                                  jscolorInput("color_fill_area")
                                  
                           )),
                           column(3, wellPanel(
                                  sliderInput("slider", label = h4("X Axis Zoom Select"), min = 0, 
                                              max = 100, value=c(0,100), format="## Days"),
                                  br(),
                                  h4(verbatimTextOutput("s_min")),
                                  h4("X Max"),
                                  verbatimTextOutput("s_max")
 
#                                   h5(textOutput('var_x_min')),
#                                   verbatimTextOutput("x_min"),
#                                   h5(textOutput('var_x_max')),
#                                   verbatimTextOutput("x_max"),
#                                   h5(textOutput('var_y_min')),
#                                   verbatimTextOutput("y_min"),
#                                   h5(textOutput('var_y_max')),
#                                   verbatimTextOutput("y_max")
                           ))
                           
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