# server.R

options(shiny.maxRequestSize=30*1024^2,
        shiny.reactlog=TRUE)

library(tm)
library(SnowballC)
library(wordcloud)
library(ggplot2)
library(ggdendro)

source("utility.R", local = FALSE)
words <- stopwords("english")

function(input, output, session) {
    
    # Reactive dataset on file upload
    data <- reactive({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        read.csv(inFile$datapath, header = FALSE, sep = "|")
        
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
    
    stopwords_r <- reactive({
        
        # Only run when submit is clicked
        if(input$add == 0)
            return()
        
        isolate({
            
            temp <- strsplit(input$addword, " ", fixed = TRUE)[[1L]]
            return(c(words, temp))
  
        })
        
    })
    
#     output$debug <- renderPrint({
#         
#         # Only run when submit is clicked
#         if(input$add == 0)
#             return()
#         
#         isolate({
#             
#             
#         })
#         
#     })
    
    # Display stopwords
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
    
    # Hierarchical Agglomerative Clustering
    output$cluster <- renderPlot({
        
        # Only run when submit is clicked
        if(input$submit == 0)
            return()
        
        isolate({
        
        # remove sparse terms to simplify cluster plot
        dtm2 <- removeSparseTerms(dtm(), sparse = 0.85)
        
        # convert into distance matrix
        df <- t(as.data.frame(as.matrix(dtm2)))
        df.scale <- scale(df)
        d <- dist(df.scale, method = "euclidean")
        model <- hclust(d, method="ave")
        ggdendrogram(model, rotate = T)
        
        })
    
    })
    
}