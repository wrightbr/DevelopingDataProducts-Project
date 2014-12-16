Month <- c("None")
Day <- c("None")
Year <- c("None")
Temp_F <- c("None")
init_data_to_print <- data.frame(Month, Day, Year, Temp_F)
dataset<-init_data_to_print


library(datasets)
library(shiny)
library(foreign)
library(ggplot2)


data <- airquality[,c("Ozone","Solar.R","Wind","Temp")]
Date.time <- paste(airquality$Day, airquality$Month, c(rep("1974",length(airquality$Day))))
Date.time <- strptime(Date.time, "%d %m %Y")
data$DateTime <- as.Date(as.character(strptime(Date.time, "%Y-%m-%d", tz="America/Los_Angeles")))


shinyServer(
  function(input, output, session){
    
    observe({ 
      if (input$browse == 0) return()
      updateTextInput(session, "path", value = file.choose())
    })
      
    observe({ 
      if (input$browse == 0) return()
      updateTextInput(session, "path", value = file.choose())
    })
    
    data_to_print <- reactiveValues(values=init_data_to_print)
    observe({
      if (input$upload > 0)
        return()
      data_to_print$values <- init_data_to_print 
    })
    
    
    observe({
      if (input$upload == 0)
        return()
      dataset <- read.table(input$path, header=TRUE, sep="\t", skipNul=TRUE)
      dataset$Month <- as.character(dataset$Name)
      dataset$Day <- as.character(dataset$DueDate)
      dataset$Year <- as.character(dataset$EstimatedTimeRequired)
      dataset$Temp_F <- as.character(dataset$Hyperlink)
      data_to_print$values <- dataset 
    })
    
    
    #THIS IS THE ONE THAT WORKS
    #output$table<-renderDataTable(dataset, options=list(pageLength=5))
            
    output$table <- renderDataTable(data, options=list(pageLength=5))
    
    #output$text1 <- renderText(data)
    #output$text2 <- renderText({as.numeric(data_to_print$values$EstimatedTimeRequired)})
    #output$text3 <- renderText({
#       input$goButton
#       isolate(paste(input$text1, input$text2))
#      if(input$goButton == 0) "You haven't pressed the button yet"
#      else if(input$goButton == 1) "You pressed it once"
#      else "OK quit pressing"
#    })
#     output$Plot1 <- renderPlot({
#         plot(
#            data$DateTime,
#            data[,input$varx],
#            main=input$varx,
#            xlab = "XLAB",
#            ylab = "YLAB")
#     })

  
    output$Plot2 <- renderPlot({
      environment<-environment() 
      ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment)+geom_point()  

      
    })


  }
)