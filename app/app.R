library(shiny)
library(stringr)
library(lubridate)
library(dplyr)
library(DT)

source('functions.R')

# The UI
ui <- bootstrapPage(
    h3('Input data below:'),
    textAreaInput('posted.input', "Paste Copied Capital One 'Posted' Transactions Here:"),
    textAreaInput('pending.input', "Paste Copied Capital One 'Pending' Transactions Here:"),
    fileInput(
        'checking', 
        'Upload checking .csv here',
        accept=c(
            "text/csv",
            "text/comma-separated-values,text/plain",
            ".csv"
        )
    ),
    fileInput(
        'apple', 
        'Upload DCU .csv here',
        accept=c(
            "text/csv",
            "text/comma-separated-values,text/plain",
            ".csv"
        )
    ),
    h3('Press "copy" for formatted output.'),
    h4('Posted Output'),
    DTOutput('posted.table'),
    h4('Pending Output'),
    DTOutput('pending.table'),
    h4('Checking Output'),
    DTOutput('output.checking'),
    h4('DCU Output'),
    DTOutput('output.dcu')
    
)

# The server
server <- function(input, output) {
    
    # Make the tables
    formatted.table.posted <- reactive({
        format_capitalone_no_print(input$posted.input)
    })
    
    formatted.table.pending <- reactive({
        format_capitalone_no_print(input$pending.input)
    })
    
    output$posted.table <- renderDT(server=FALSE,{

        # Show data
        datatable(formatted.table.posted(), 
                  extensions = 'Buttons', 
                  options = list(dom = 'tB',
                                 style='bootstrap',
                                 buttons = list(
                                     list(
                                         extend = 'copy', 
                                         title = NULL
                                     ) 
                                 )),
                  rownames = F)
    })
    
    output$pending.table <- renderDT(server=FALSE,{
        
        # Show data
        datatable(formatted.table.pending(), 
                  extensions = 'Buttons', 
                  options = list(dom = 'tB',
                                 style='bootstrap',
                                 buttons = list(
                                     list(
                                         extend = 'copy', 
                                         title = NULL
                                     ) 
                                 )),
                  rownames = F)
    })
    
    # Make the checking csv table
    output$output.checking <- renderDT(server=FALSE,{
        
        inFile <- input$checking
        if (is.null(inFile)){
            return(
                datatable(
                    data.frame(
                        Upload='',
                        File='',
                        For='',
                        Table=''
                    ),
                    extensions = 'Buttons', 
                    options = list(dom = 'tB',
                                   style='bootstrap',
                                   buttons = list(
                                       list(
                                           extend = 'copy', 
                                           title = NULL
                                       ) 
                                   )),
                    rownames = F
                )
            )
        } 
        # Show data
        datatable(read.csv(inFile$datapath), 
                  extensions = 'Buttons', 
                  options = list(dom = 'tB',
                                 style='bootstrap',
                                 buttons = list(
                                     list(
                                         extend = 'copy', 
                                         title = NULL
                                     ) 
                                 )),
                  rownames = F)
    })
    
    # Make the DCU csv table
    output$output.dcu <- renderDT(server=FALSE,{
        
        inFile <- input$apple
        if (is.null(inFile)){
            return(
                datatable(
                    data.frame(
                        Upload='',
                        File='',
                        For='',
                        Table=''
                    ),
                    extensions = 'Buttons', 
                    options = list(dom = 'tB',
                                   style='bootstrap',
                                   buttons = list(
                                       list(
                                           extend = 'copy', 
                                           title = NULL
                                       ) 
                                   )),
                    rownames = F
                )
            )
        } 
        # Show data
        datatable(read.csv(inFile$datapath) %>% 
                    as_tibble() %>% 
                    mutate(
                      DATE = mdy(DATE),
                      AMOUNT = gsub('\\$', '', AMOUNT) %>% 
                        gsub(',', '', .) %>% 
                        as.numeric() 
                    ) %>% 
                    select(
                      Date = DATE, Description = DESCRIPTION, Amount = AMOUNT
                    ), 
                  extensions = 'Buttons', 
                  options = list(dom = 'tB',
                                 style='bootstrap',
                                 buttons = list(
                                     list(
                                         extend = 'copy', 
                                         title = NULL
                                     ) 
                                 )),
                  rownames = F)
    })
}

shinyApp(ui = ui, server = server)        