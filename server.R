library(shiny)

# data <- read.csv("items.csv", stringsAsFactors = FALSE)

math.items <- read.csv('items.csv', stringsAsFactors=FALSE)
source('ShinyAssessment.R')

server <- function(input, output) {


  assmt.results <- reactiveValues(
    math = logical()
    )
  
  # This function will be called when the assessment is completed.
  saveResults <- function(results) {
    assmt.results$math <- results == math.items$Answer
  }
  
  
  # Provide some basic feedback to students
  output$math.results <- renderText({
    txt <- ''
    if(length(assmt.results$math) > 0) {
      txt <- paste0('You got ', sum(assmt.results$math, na.rm=TRUE),
                    ' of ', length(assmt.results$math), ' items correct.')
    } else {
      txt <- 'No results found. Please complete the statistics assessment.'
    }
    return(txt)
  })
  
  
  # Multiple choice test example
  test <- ShinyAssessment(input, output, session,
                          name = 'GCSE Mathematics',
                          item.stems = math.items$Stem,
                          item.choices = math.items[,c(4:7)],
                          callback = saveResults,
                          start.label = 'Start the Statistics Assessment',
                          itemsPerPage = 1,
                          inline = FALSE)
  
 
  output$ui <- renderUI({
    if(SHOW_ASSESSMENT$show) { # The assessment will take over the entire page.
      fluidPage(width = 12, uiOutput(SHOW_ASSESSMENT$assessment))
    } else { # Put other ui components here
      fluidPage(	 			
        titlePanel("Shiny Assessment Example"),
        sidebarLayout(
          sidebarPanel(
            # Show the start assessment link
            h4('Example multiple choice assessment'),
            p('You can use a link'),
            uiOutput(test$link.name),
            p('Or a button to start the assessment'),
            uiOutput(test$button.name),
            hr()
          ),
          mainPanel(
            h3('Statistics Assessment Results'),
            textOutput('math.results'),
            hr()
          )
        )
      )
    }
  })
}
