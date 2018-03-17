library(shiny)

source("predModel.R")

shinyServer(function(input, output, session){
  observeEvent(input$text, {
    if(nchar(input$text)==0) return(0)
    words <- unlist(strsplit(input$text, split=" "))
    lastChar <- tail(unlist(strsplit(input$text,"")),1)
    if(lastChar == " "){
      data <- predictNextWord(input$text)
      nextWords <- unlist(data$nextWord)
      removeUI(selector = "#predictions > *", multiple = T, immediate = F)
      lapply(1:length(nextWords), function(i){
        if(last(words)!=nextWords[i])
          insertUI(selector ="#predictions", where="beforeEnd", ui = div(nextWords[i]))
      })
    }
  })
})