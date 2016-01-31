#ui.R

fluidPage(
    
    titlePanel("Word Cloud Generator"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("This app will count the word frequencies of a text input in the box below 
                     and return a word cloud."),
            br(),
            tags$textarea(id="text", rows=3, cols=40, "Paste your text here."),
            br(),
            actionButton("submit", "Submit"),
            hr(),
            sliderInput("freq",
                        "Minimum Frequency:",
                        min = 1,  max = 20, value = 2),
            helpText("Words with a frequency below the Minimum Frequency will not be plotted. 
                     Note that if you input a Minimum Frequency that is too high, it will revert 
                     to a value of 1."),
            br(),
            sliderInput("max",
                        "Maximum Number of Words:",
                        min = 1,  max = 100,  value = 20)
        ),
        
        mainPanel(
            plotOutput("plot")
        )
    )
)

