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
	    p("The best predictions will happen for n<5 because the phrase would have higher probability of ocurrence."),
	    p("A technique like the Katz Back Off would be used to fall back to n-1 in case phrases with n words are not found."),
	    br(),
	    h4("How to use It?"),
	    p(textOutput("bestmatch"), "Just type the text in the search box on the left panel then wait for the next word suggestions to show below.")
	  ),
		title = "Coursera - NLP Capstone Project - Next Word Prediction"
	)
)