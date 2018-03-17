library(shiny)

shinyUI(
	fluidPage(
	  h2("Predict Next Word", align="center"),
	  sidebarPanel(
	    textInput("text", label = h4("Type below for prediction!"), value = ""),
	    htmlOutput("predictions")
	  ),
	  mainPanel(
	    p("This is a Shiny App designed for Natural Language Processing, Its algorithm builds n-grams with text from Tweets, News and Blogs."),
	    p(),
	    br(),
	    h4("How to use It?"),
	    p(textOutput("bestmatch"), "User types the text in the search box on the left panel then waits for the next word suggestions to show below.")
	  ),
		title = "Coursera - NLP Capstone Project - Next Word Prediction"
	)
)