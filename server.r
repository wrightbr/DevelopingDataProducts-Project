library(datasets)
library(shiny)
library(foreign)
library(ggplot2)
require(shinysky)
library(scales)

Plotfunction <- function(varx, vary, slider_x, slider_y, points_checkbox, line_checkbox, color_lines, area_checkbox, color_fill_area, color_line_area, fit_checkbox, color_fill_fit, color_line_fit, session){
  
  environment<-environment()   
  
  xmin<-min(data[,varx])
  xmax<-max(data[,varx])
  
  ymin<-min(data[,vary])
  ymax<-max(data[,vary])
  
  smin_x<-slider_x[1]
  smax_x<-slider_x[2]  
  
  smin_y<-slider_y[1]
  smax_y<-slider_y[2]
  
  #Basic Plot Params
  p <- ggplot(aes(data[,varx], data[,vary]),data = data, environment=environment)
  
  lab_x <- xlab(as.character(varx))
  lab_y <- ylab(as.character(vary))
  
  sy <- coord_cartesian(ylim = c(as.numeric(ymin+(smin_y*(ymax-ymin)/100)),as.numeric(ymax-((100-smax_y)*(ymax-ymin))/100)))
  
  p <- p + lab_x + lab_y + sy
  
  
  #Check if need for date X scale or not
  if (varx=="DateTime"){
    p <- p + scale_x_date(limits=as.Date(c(xmin+(smin_x*(xmax-xmin)/100),xmax-((100-smax_x)*(xmax-xmin))/100)))
  }
  else{
    p <- p + scale_x_continuous(limits= c(as.numeric(xmin+(smin_x*(xmax-xmin)/100)),as.numeric(xmax-((100-smax_x)*(xmax-xmin))/100)))
  }
  
  #Check if points have to be added
  if (points_checkbox==TRUE){
    if (as.character(color_lines) != "FFFFFF"){
      p <- p + geom_point(fill=paste("#",color_points,sep=""), color=paste("#",color_points,sep=""))
    }
    else{
      p <- p + geom_point(fill=paste("#","000000",sep=""), color=paste("#","000000",sep=""))
    }
    
  }
  
  #Check if line has to be added
  if (line_checkbox==TRUE){
    p <- p + geom_line(fill=paste("#",color_lines,sep=""), color=paste("#",color_lines,sep=""))
  }
  
  #Check if area has to be added
  if (area_checkbox==TRUE){
    p <- p + geom_area(fill=paste("#",color_fill_area,sep=""), color=paste("#",color_line_area,sep="")) 
  }
  
  #Check if fit line has to be added
  if (fit_checkbox==TRUE) {
    p <- p + geom_smooth(fill=paste("#",color_fill_fit,sep=""), color=paste("#",color_line_fit,sep=""))
  }
  
  return(p)

}


data <- airquality[,c("Ozone","Solar.R","Wind","Temp")]
Date.time <- paste(airquality$Day, airquality$Month, c(rep("1974",length(airquality$Day))))
Date.time <- strptime(Date.time, "%d %m %Y")
data$DateTime <- as.Date(as.character(strptime(Date.time, "%Y-%m-%d", tz="America/Los_Angeles")))
data <- data[complete.cases(data),]


shinyServer(
  function(input, output, session){
        
 
##Download data table    
    observe({ 
      if (input$browse == 0) return()
      updateTextInput(session, "path", value = choose.dir())
    })

    
    observe({
      if (input$download == 0)
        return()
      dir_0 <- getwd()
      setwd(input$path)
      write.table(data[, input$show_vars, drop=FALSE], paste(input$file_name,input$ext,sep="."), sep=as.character(input$separ))
      setwd(dir_0)
    })

    observe({ 
      if (input$browse == 0) return()
      updateTextInput(session, "path", value = choose.dir())
    })    
    

    

#Download printed plot
    observe({
      if (input$download_img == 0)
        return()
      dir_0 <- getwd()
      setwd(input$path_img)
      png(as.character(paste(input$file_name_img,"png",sep="."), width = 480, height = 720))
      print(Plotfunction(input$varx, input$vary, input$slider_x, input$slider_y, 
                   input$points_checkbox, input$line_checkbox, input$color_lines, 
                   input$area_checkbox, input$color_fill_area, input$color_line_area, 
                   input$fit_checkbox, input$color_fill_fit, input$color_line_fit, session))
      dev.off()
      setwd(dir_0)
    })
    
    observe({
      if ((input$points_checkbox==FALSE) & (input$line_checkbox==FALSE) & (input$area_checkbox==FALSE) & (input$fit_checkbox==FALSE)) {
        updateCheckboxInput(session, "points_checkbox", value = TRUE)
      }
    }) 

    
    observe({ 
      if (input$browse_img == 0) return()
      updateTextInput(session, "path_img", value = choose.dir())
    })  
 

#Safety function
    observe({
      if ((input$points_checkbox==FALSE) & (input$line_checkbox==FALSE) & (input$area_checkbox==FALSE) & (input$fit_checkbox==FALSE)) {
        updateCheckboxInput(session, "points_checkbox", value = TRUE)
      }
    }) 


    
    output$table <- renderDataTable({
      data[, input$show_vars, drop=FALSE] 
      }, options = list(pageLength=15))
    
  
    output$MainPlot <- renderPlot({
      
      Plotfunction(input$varx, input$vary, input$slider_x, input$slider_y, 
                 input$points_checkbox, input$line_checkbox, input$color_lines, 
                 input$area_checkbox, input$color_fill_area, input$color_line_area, 
                 input$fit_checkbox, input$color_fill_fit, input$color_line_fit, session)
                
      
      
#       environment<-environment()   
#       
#       xmin<-min(data[,input$varx])
#       xmax<-max(data[,input$varx])
#       
#       ymin<-min(data[,input$vary])
#       ymax<-max(data[,input$vary])
#       
#       smin_x<-input$slider_x[1]
#       smax_x<-input$slider_x[2]  
#       
#       smin_y<-input$slider_y[1]
#       smax_y<-input$slider_y[2]
#           
#       #Basic Plot Params
#       p <- ggplot(aes(data[,input$varx], data[,input$vary]),data = data, environment=environment)
#       
#       lab_x <- xlab(as.character(input$varx))
#       lab_y <- ylab(as.character(input$vary))
#       
#       sy <- coord_cartesian(ylim = c(as.numeric(ymin+(smin_y*(ymax-ymin)/100)),as.numeric(ymax-((100-smax_y)*(ymax-ymin))/100)))
#       
#       p <- p + lab_x + lab_y + sy
#       
#       
#       #Check if need for date X scale or not
#       if (input$varx=="DateTime"){
#         p <- p + scale_x_date(limits=as.Date(c(xmin+(smin_x*(xmax-xmin)/100),xmax-((100-smax_x)*(xmax-xmin))/100)))
#       }
#       else{
#         p <- p + scale_x_continuous(limits= c(as.numeric(xmin+(smin_x*(xmax-xmin)/100)),as.numeric(xmax-((100-smax_x)*(xmax-xmin))/100)))
#       }
#       
#       #Check if points have to be added
#       if (input$points_checkbox==TRUE){
#           if (as.character(input$color_lines) != "FFFFFF"){
#             p <- p + geom_point(fill=paste("#",input$color_points,sep=""), color=paste("#",input$color_points,sep=""))
#           }
#           else{
#             p <- p + geom_point(fill=paste("#","000000",sep=""), color=paste("#","000000",sep=""))
#           }
# 
#       }
#       
#       #Check if line has to be added
#       if (input$line_checkbox==TRUE){
#         p <- p + geom_line(fill=paste("#",input$color_lines,sep=""), color=paste("#",input$color_lines,sep=""))
#       }
#       
#       #Check if area has to be added
#       if (input$area_checkbox==TRUE){
#         p <- p + geom_area(fill=paste("#",input$color_fill_area,sep=""), color=paste("#",input$color_line_area,sep="")) 
#       }
#       
#       #Check if fit line has to be added
#       if (input$fit_checkbox==TRUE) {
#         p <- p + geom_smooth(fill=paste("#",input$color_fill_fit,sep=""), color=paste("#",input$color_line_fit,sep=""))
#       }
# 
#       return(p)
#     
    })
    
      
    output$x_avg<- renderText({
      if (input$varx=="DateTime"){
        as.character(mean(data[,input$varx]))
      }
      else{
        as.character(round(mean(data[,input$varx])),0)
      }
    })
    
    output$y_avg<- renderText({as.character(round(mean(data[,input$vary])),2)})
    
    output$fillcolor <- renderPrint({paste("#",input$color_fill,sep="")})
    output$linecolor <- renderPrint({paste("#",input$color_line,sep="")})

    output$x_min <- renderText({as.character(min(data[,input$varx]))})
    output$x_max <- renderText({as.character(max(data[,input$varx]))})
    output$y_min <- renderText({as.character(min(data[,input$vary]))})
    output$y_max <- renderText({as.character(max(data[,input$vary]))})
    
    output$s_max_x <- renderText({as.character(max(data[,input$varx])-(100-input$slider_x[2])*(max(data[,input$varx])-min(data[,input$varx]))/100  ) })
    output$s_min_x <- renderText({as.character(min(data[,input$varx])+input$slider_x[1]*(max(data[,input$varx])-min(data[,input$varx]))/100 ) })
    
    output$s_max_y <- renderText({as.character(max(data[,input$vary])-(100-input$slider_y[2])*(max(data[,input$vary])-min(data[,input$vary]))/100  ) })
    output$s_min_y <- renderText({as.character(min(data[,input$vary])+input$slider_y[1]*(max(data[,input$vary])-min(data[,input$vary]))/100 ) })
    
    output$var_x <- renderText({as.character(input$varx)})
    output$var_y <- renderText({as.character(input$vary)})
    

  
  }
)