library(shiny)

shinyUI(fluidPage(
	title = "NYC Air Quality",
	# format(Sys.time(), "%B %d, %Y")
	plotOutput("aq_plot", height=340),
	radioButtons("month", "Select Month:",
		c("June"=6,"July"=7,"August"=8,"September"=9))
	
))