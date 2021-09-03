library(shiny)
library(stringr)
library(lubridate)
library(dplyr)
library(DT)

source('functions.R')

# The UI
ui <- bootstrapPage(
    
    textAreaInput('my_input', "Paste Capital One Output Here:"),
    h3('Press "copy" below for formatted output.'),
    h6('"Missing value" error is normal before you enter text above.'),
    DTOutput('output.table')
    
)

# The server
server <- function(input, output) {
    
    # Make the table
    formatted.table <- reactive({
        format_capitalone(input$my_input)
    })
    
    output$output.table <- renderDT(server=FALSE,{

        # Show data
        datatable(formatted.table(), 
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