#ui.R

fluidPage(
    
    titlePanel(span(tags$img(src = "./hat-icon.png", width = "50px", height = "50px"), 
                    "Text Miner")),
    
    sidebarLayout(
        sidebarPanel(
            h5("This app will count the word/phrase frequencies of a text input in the box 
               below and return a word cloud. Association rules will help uncover 
               relationships between the words/phrases."),
            hr(),
            selectInput("ngram", 
                        label = "N-gram:",
                        choices = list("Unigram" = "1L", "Bigram" = "2L",
                                       "Trigram" = "3L"), selected = "1L"),
            helpText("Select no. of co-occuring words to be modeled. i.e. Unigram for
                     individual words; Bigram for word pairs; Trigram for word triples."),
            br(),
            tags$b("Text Input:"),
            br(),
            br(),
            tags$textarea(id = "text", rows = 3, cols = 40, "Paste your text here."),
            br(),
            actionButton("submit", "Submit", icon = icon("refresh")),
            hr(),
            sliderInput("freq",
                        label = "Minimum Frequency:",
                        min = 1,  max = 20, value = 2),
            helpText("Words with a frequency below the Minimum Frequency will not be plotted. 
                     Note: if you input a Minimum Frequency that is too high, it will revert 
                     to a value of 1."),
            br(),
            sliderInput("max",
                        label = "Maximum Number of Words:",
                        min = 1,  max = 100,  value = 20),
            helpText("Limit display to the Top-N occuring words.")
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Word Cloud", plotOutput("cloud")),
                tabPanel("Association Rules", textOutput("rules"))
            )
            
        )
    ), title = "Text Miner mines text for you"
)

