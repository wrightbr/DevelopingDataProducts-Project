library(datasets)
library(shiny)
library(foreign)
library(ggplot2)
require(shinysky)
library(scales)


data <- airquality[,c("Ozone","Solar.R","Wind","Temp")]
Date.time <- paste(airquality$Day, airquality$Month, c(rep("1974",length(airquality$Day))))
Date.time <- strptime(Date.time, "%d %m %Y")
data$DateTime <- as.Date(as.character(strptime(Date.time, "%Y-%m-%d", tz="America/Los_Angeles")))
data <- data[complete.cases(data),]


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
    
        
#     observe({
#       xmin<-as.numeric(min(data[,input$varx]))
#       xmax<-as.numeric(max(data[,input$varx]))
#       updateSliderInput(session, "slider",min=xmin-10, max=xmax+10, value=c(xmin,45))
#       
#     })
    
            
    output$table <- renderDataTable(data, options=list(pageLength=5))
    
  
    output$Plot2 <- renderPlot({
      environment<-environment()   
      xmin<-min(data[,input$varx])
      xmax<-max(data[,input$varx])
      smin<-input$slider[1]
      smax<-input$slider[2]  
            
      
      if (input$fit_checkbox==TRUE) {
        if (input$area_checkbox==TRUE){
          if (input$varx=="DateTime"){
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_date(limits= as.Date(c(xmin+smin,xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) + geom_smooth(fill=paste("#",input$color_fill_fit,sep=""), color=paste("#",input$color_line_fit,sep="")) + geom_area(fill=paste("#",input$color_fill_area,sep=""), color=paste("#",input$color_line_area,sep=""))
          }
          else{
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_continuous(limits= c(as.numeric(xmin+smin),as.numeric(xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) + geom_smooth(fill=paste("#",input$color_fill_fit,sep=""), color=paste("#",input$color_line_fit,sep="")) + geom_area(fill=paste("#",input$color_fill_area,sep=""), color=paste("#",input$color_line_area,sep=""))
          } 
        }
        else{
          if (input$varx=="DateTime"){
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_date(limits=as.Date(c(xmin+smin,xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) + geom_smooth(fill=paste("#",input$color_fill_fit,sep=""), color=paste("#",input$color_line_fit,sep=""))  
          }
          else {
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_continuous(limits= c(as.numeric(xmin+smin),as.numeric(xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) + geom_smooth(fill=paste("#",input$color_fill_fit,sep=""), color=paste("#",input$color_line_fit,sep=""))
          } 
        }
      }
      else {
        if (input$area_checkbox==TRUE){
          if (input$varx=="DateTime"){
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_date(limits=as.Date(c(xmin+smin,xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) + geom_area(fill=paste("#",input$color_fill_area,sep=""), color=paste("#",input$color_line_area,sep=""))
          }
          else{
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_continuous(limits= c(as.numeric(xmin+smin),as.numeric(xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) + geom_area(fill=paste("#",input$color_fill_area,sep=""), color=paste("#",input$color_line_area,sep=""))
          }
        }
        else{
          if (input$varx=="DateTime"){
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_date(limits=as.Date(c(xmin+smin,xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) 
          }
          else{
            ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment) + geom_point() + scale_x_continuous(limits= c(as.numeric(xmin+smin),as.numeric(xmax-(100-smax)))) + xlab(as.character(input$varx)) + ylab(as.character(input$vary)) 
          }
        }
      }
    
    })
    
    output$LAB_DATE <- renderText({
      
      if (input$varx=="DateTime") TRUE
      else FALSE
      
    })
    
    
    output$fillcolor <- renderPrint({paste("#",input$color_fill,sep="")})
    output$linecolor <- renderPrint({paste("#",input$color_line,sep="")})

    output$fit_value <- renderPrint({input$fit_checkbox})
    output$x_min <- renderText({as.character(min(data[,input$varx]))})
    output$x_max <- renderText({as.character(max(data[,input$varx]))})
    output$y_min <- renderText({as.character(min(data[,input$vary]))})
    output$y_max <- renderText({as.character(max(data[,input$vary]))})
    
    output$s_max <- renderPrint({max(data[,input$varx])-(100-input$slider[2])})
    output$s_min <- renderPrint({min(data[,input$varx])+input$slider[1]})
    
    output$var_x <- renderText({as.character(input$varx)})
    output$var_y <- renderText({as.character(input$vary)})
    #output$var_x_min <- renderText({paste(as.character(input$varx),"min. value")})
    #output$var_x_max <- renderText({paste(as.character(input$varx),"max. value")})
    #output$var_y_min <- renderText({paste(as.character(input$vary),"min. value")})
    #output$var_y_max <- renderText({paste(as.character(input$vary),"max. value")})
  }
)