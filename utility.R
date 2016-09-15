# define utility functions

'%!in%' <- function(x,y)!('%in%'(x,y))

processTxt <- function(text, ngram, stopwords) {
    docs <- Corpus(DataframeSource(text))
    docs <- tm_map(docs, removePunctuation)
    docs <- tm_map(docs, content_transformer(tolower))
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