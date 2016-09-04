#server.R

options(shiny.maxRequestSize=30*1024^2,
        shiny.reactlog=TRUE)

library(readr)
library(tm)
library(SnowballC)
library(wordcloud)

# define utility functions

'%!in%' <- function(x,y)!('%in%'(x,y))

processTxt <- function(text, ngram, stopwords) {
      docs <- Corpus(VectorSource(text))
      docs <- tm_map(docs, removePunctuation)
      docs <- tm_map(docs,content_transformer(tolower))
      docs <- tm_map(docs, removeWords, stopwords)
      docs <- tm_map(docs, stripWhitespace)
      #docs <- tm_map(docs,stemDocument)
      
      # Option to do n-grams
      if(ngram == "2L") {
          
          ngramTokenizer <- function(x) {
              temp <- unlist(x)[[1]]
              temp <- strsplit(temp, " ", fixed = TRUE)[[1L]]  # L specifies integer type
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
    
    # Reactive dataset on file upload
    data <- reactive({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        readr::read_file(inFile$datapath)
        
    })
    
    
    # Reactive dtm when dataset is read
    dtm <- reactive({
        
        # Only run when submit is clicked
        if(input$submit == 0)
            return()
        
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                processTxt(data(), input$ngram, stopwords_r())
            })
        })
        
    })
    
    # Define non-reactive stopword variable to be the counter
    words <- stopwords("english")
    
    stopwords_r <- reactive({
        
        # Only run when submit is clicked
        if(input$add == 0)
            return()
        
        isolate({
            
            temp <- strsplit(input$addword, " ", fixed = TRUE)[[1L]]
            return(c(words, temp))
            
            # DEPRECATED: to remove stopwords
            temp <- strsplit(input$addword, " ", fixed = TRUE)[[1L]]
            words[words %!in% temp]
  
        })
        
    })
    
    
    output$debug <- renderPrint({
        
        # Only run when submit is clicked
        if(input$add == 0)
            return()
        
        isolate({
            
            
        })
        
    })
    
    output$stopwords <- renderText({
        
        if(is.null(stopwords_r())) {
            
            return(paste(words, sep=" ", collapse=" "))
            
        } else {
            
           return(paste(stopwords_r(), sep=" ", collapse=" "))
            
        }
    
    })
    
    # Plot Word Cloud
    output$cloud <- renderPlot({
        
        # Only run when submit is clicked
        if(input$submit == 0)
            return()
        
        isolate({
            
            # Count Frequencies
            set.seed(42)
            freq <- sort(colSums(as.matrix(dtm())), decreasing=T)
            wordcloud(names(freq),
                      freq,
                      min.freq = input$freq, 
                      max.words = input$max,
                      colors = brewer.pal(6,"Dark2"))
            
        })
        
          
    })
    
}