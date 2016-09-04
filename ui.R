#ui.R

fluidPage(
    
    titlePanel(span(tags$img(src = "./hat-icon.png", width = "50px", height = "50px"), 
                    "Text Miner")),
    
    sidebarLayout(
        sidebarPanel(
            h5("This app will count word/phrase frequencies and display a word cloud. 
               Association rules will help uncover relationships between the words/phrases.
               Currently, the app consider your text file as a single string."),
            hr(),
            fileInput('file1', 'Choose file to upload',
                      accept = c(
                          'text/csv',
                          'text/comma-separated-values',
                          'text/tab-separated-values',
                          'text/plain',
                          '.csv',
                          '.tsv'
                      )
            ),
            selectInput("ngram", 
                        label = "N-gram:",
                        width= "200px",
                        choices = list("Unigram" = "1L", "Bigram" = "2L",
                                       "Trigram" = "3L"), selected = "1L"),
            helpText("Select no. of co-occuring words to be modeled. i.e. Unigram for
                     individual words; Bigram for word pairs; Trigram for word triples."),
            hr(),
            fluidRow(
                column(8, textInput("addword", "Add stopwords", value = "", width = "200px")),
                column(4, actionButton("add", "Add", icon = icon("plus")))
            ),
            tags$style(type='text/css', "#add { width:100%; margin-top: 25px;}"),
            helpText("Stopwords will be excluded from the model. You can add multiple words
                     using a space delimiter. Note: You cannot remove basic stopwords."),
            hr(),
            sliderInput("freq",
                        label = "Minimum Frequency:",
                        min = 1,  max = 20, value = 2),
            helpText("Words with a frequency below the Minimum Frequency will not be plotted. 
                     Note: If you input a Minimum Frequency that is too high, it will revert 
                     to a value of 1."),
            hr(),
            sliderInput("max",
                        label = "Maximum Number of Words:",
                        min = 1,  max = 100,  value = 20),
            helpText("Limit display to the Top-N occuring words."),
            hr(),
            actionButton("submit", "Submit", icon = icon("refresh"))
        ),
        
        mainPanel(
            tabsetPanel(
                #tabPanel("Debug", textOutput("debug")),
                tabPanel("Word Cloud", plotOutput("cloud")),
                tabPanel("Stopwords", 
                         h3(tags$span(style="color:rgb(0, 153, 204)", 
                                      textOutput("stopwords"))
                            )
                         )
                
            )
        )
        
    ), title = "Text Miner mines text for you"
)

