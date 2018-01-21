library(shiny)

# define server logic for rendering the plot
shinyServer(function(input, output){
  output$aq_plot <- renderPlot({
	# load data from R built-in data set
	data("airquality")
	# create a Linear Model
	fit.data <- airquality[airquality$Month == input$month,]
	fit.lm <- lm(
	    formula=Temp ~ Day, # I would have included 'Ozone+Solar.R+Wind' only for prediction 
	    data=fit.data, 
	    na.action=na.exclude
	) 

	# plot the Temp per Day
	plot(x=fit.data$Day, y=fit.data$Temp, 
		xlim=c(0,31), ylim=c(50,110), 
		xlab="Day", ylab="Temperature (Farenheit)", 
		col="white", pch='.', axes=T, bty="n")
	title(main="New York City's Temperature by Day")
	# add the dependent variable Ozone
	points(x=fit.data$Day, y=fit.data$Temp, cex = (fit.data$Ozone/max(fit.data$Ozone, na.rm=T))*10, col = "yellow")
	# add the dependent variable Solar.R
	points(x=fit.data$Day, y=fit.data$Temp, cex = (fit.data$Solar.R/max(fit.data$Solar.R, na.rm=T))*10, col = "orange")
	# add the dependent variable Wind
	points(x=fit.data$Day, y=fit.data$Temp, cex = (fit.data$Wind/max(fit.data$Wind, na.rm=T))*10, col = "light blue")
	# add the regression line
	abline(lm(formula=Temp ~ Day, data=fit.data, na.action=na.exclude), col="green", lty=2)
	abline(lm(formula=Temp ~ Ozone, data=fit.data, na.action=na.exclude), col="yellow", lty=2)
	abline(lm(formula=Temp ~ Solar.R, data=fit.data, na.action=na.exclude), col="orange", lty=2)
	abline(lm(formula=Temp ~ Wind, data=fit.data, na.action=na.exclude), col="light blue", lty=2)
	# add legend for dependent variables
	legend(-1, 115, legend=c("Ozone", "Solar.R", "Wind", "Temp"), 
		col = c("yellow", "orange", "light blue", "green"),
    	text.col = "gray", lty = 2, box.lty=0,
    	bg="transparent"
 	)

  })
})