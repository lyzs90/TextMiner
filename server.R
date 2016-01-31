#server.R

library(tm)
library(SnowballC)
library(wordcloud)

processTxt <- function(text) {
      docs <- Corpus(VectorSource(text))
      docs <- tm_map(docs, removePunctuation)
      docs <- tm_map(docs,content_transformer(tolower))
      docs <- tm_map(docs, removeWords, stopwords("english"))
      docs <- tm_map(docs, stripWhitespace)
      docs <- tm_map(docs,stemDocument)
      # Create document-term matrix (DTM)and remove words 2 characters or shorter
      dtmr <-DocumentTermMatrix(docs, control=list(wordLengths=c(2, 20)))
      # Count Frequencies
      sort(colSums(as.matrix(dtmr)), decreasing=T)
}

function(input, output, session) {
    
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        # Change when the "submit" button is pressed
        input$submit
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                processTxt(input$text)
            })
        })
    })
    
    # Plot Word Cloud
    output$plot <- renderPlot({
        set.seed(42)
        freq <- terms()
        wordcloud(names(freq),
                  freq,
                  min.freq=input$freq, 
                  max.words=input$max,
                  colors=brewer.pal(6,"Dark2"))  
    })
}