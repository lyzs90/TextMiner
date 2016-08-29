#server.R

library(tm)
library(SnowballC)
library(wordcloud)
library(arules)

processTxt <- function(text, ngram) {
      docs <- Corpus(VectorSource(text))
      docs <- tm_map(docs, removePunctuation)
      docs <- tm_map(docs,content_transformer(tolower))
      docs <- tm_map(docs, removeWords, stopwords("english"))
      docs <- tm_map(docs, stripWhitespace)
      #docs <- tm_map(docs,stemDocument)
      
      # Option to do n-grams
      if(ngram == "2L") {
          
          ngramTokenizer <- function(x) {
              temp <- unlist(x)[[1]]
              temp <- strsplit(temp, " ", fixed = TRUE)[[1L]]
              vapply(ngrams(temp, 2L), paste, "", collapse = " ")
          }
          
      } else if(ngram == "3L") {
          
          ngramTokenizer <- function(x) {
              temp <- unlist(x)[[1]]
              temp <- strsplit(temp, " ", fixed = TRUE)[[1L]]
              vapply(ngrams(temp, 3L), paste, "", collapse = " ")
          }
          
      } else {
          
          ngramTokenizer <- function(x) {
              temp <- unlist(x)[[1]]
              temp <- strsplit(temp, " ", fixed = TRUE)[[1L]]
              vapply(ngrams(temp, 1L), paste, "", collapse = " ")
          }
          
      }
      
      
      
      # Create document-term matrix (DTM)and remove words 2 characters or shorter
      dtm <-DocumentTermMatrix(docs, control=list(wordLengths = c(2, 20),
                                                   tokenize = ngramTokenizer))
      
}

function(input, output, session) {
    
    # Define a reactive expression for the document term matrix
    dtm <- reactive({
        
        # Change when the "submit" button is pressed
        input$submit
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                processTxt(input$text, input$ngram)
            })
        })
        
    })
    
    # Plot Word Cloud
    output$cloud <- renderPlot({
        set.seed(42)
        # Count Frequencies
        freq <- sort(colSums(as.matrix(dtm())), decreasing=T)
        wordcloud(names(freq),
                  freq,
                  min.freq = input$freq, 
                  max.words = input$max,
                  colors = brewer.pal(6,"Dark2"))  
    })
    
    # List Association Rles
    output$rules <- renderText({
        freqTerms <- findFreqTerms(dtm(), lowfreq = input$freq)
        
    })
    
}