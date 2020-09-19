library(pacman)
pacman::p_load(odbc, RMySQL, here, dplyr, shiny, pool)

source(here('DB_fun', 'AWS_readwrite.R'))
my_db <- FUN_DBpool()

ui <- fluidPage(
  tableOutput("tbl"),
  plotOutput("popPlot"),
  textInput('X', 'Add X, separated by comma', ''),
  textInput('Y', 'Add Y, separated by comma', ''),
  selectInput("overwriteappend", "OVERWRITE/APPEND:",
              c("OVERWRITE" = "OVERWRITE",
                "APPEND" = "APPEND")),
  actionButton("save", "Add data")
)

server <- function(input, output, session) {
  #generate table view of database
  output$tbl <- renderTable({
    my_db %>% tbl("sendtest1")
  })
  
  #simple plot view of database
  output$popPlot <- renderPlot({
    df <- my_db %>% tbl("sendtest1") %>% collect() %>% na.omit()
    plot(df[[1]], df[[2]], xlab = 'X', ylab = 'Y')
    lines(df[[1]], df[[2]], col = 'red')
  })
  
  #manipulate database datbles by append/overwrite
  observeEvent(input$save, {
    #convert comma separated text input to numeric list
    list2num = function(x){
      charlist = unlist(strsplit(x, split=','))
      charlist = gsub(' ', '', charlist)
      numlist = as.numeric(charlist)
    }
    
    #generate database column values as lists
    Xvals = list2num(input$X)
    Yvals = list2num(input$Y)
    
    #append NAs to make X and Y columns length match
    if(length(Xvals)>length(Yvals)){
      Yvals = append(rep(NA, length(Xvals)-length(Yvals)), Yvals)
    } else if(length(Yvals)>length(Xvals)){
      Xvals = append(rep(NA, length(Yvals)-length(Xvals)), Xvals)
    }
    dt = data.frame(X = Xvals, Y = Yvals) %>% filter(!(is.na(X) & is.na(Y)))
    #send write query to database
    FUN_DBwriteSQL(mydata = dt, 
                   tablename = 'sendtest1', 
                   OverwriteAppend = input$overwriteappend)
  })
  
}

shinyApp(ui, server)
