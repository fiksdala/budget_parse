library(shiny)
library(stringr)
library(lubridate)
library(dplyr)
library(DT)

format_capitalone <- function(text_input){
  if(text_input == ''){
    data.frame(
      `Paste`='',
      Transactions='',
      For='',
      Table=''
    )
  } else {
    text_input %>% 
      str_split('\n') %>% 
      unlist() %>% 
      matrix(ncol=5, byrow=T) %>% 
      `colnames<-`(c('Date', 'Description', 'Category', 'Card', 'Amount')) %>% 
      as_tibble() -> input.string
    

    if (input.string$Date[1] != 'Pending'){
      input.string %>%
        mutate(
          Date = parse_date_time(Date, "m d") %>% as_date()
        ) -> input.string
      
      # In case it is the end/beginning of the year
      if((input.string$Date %>% min() %>% month()  == 1) &
         (input.string$Date %>% max() %>% month()  > 2) ){
        input.string[
          input.string$Date %>% month() == 1, 
        ]$Date <- input.string[
          input.string$Date %>% month() == 1, 
        ]$Date + years(1)
      }
      
      input.string %>%
        mutate(
          Amount = as.numeric(sub(',', '', sub('\\$', '', Amount)))
        ) %>%
        arrange(Date, Amount, Description) -> input.string
    }
    input.string
  }
}

format_capitalone_no_print <- function(input.string){
  if(input.string == ''){
    output <- data.frame(
      `Paste`='',
      Transactions='',
      For='',
      Table=''
    )
  } else {
    transaction_vector <- input.string %>% 
      str_split('\n') %>% 
      unlist() 
    transaction_vector <- transaction_vector[transaction_vector != '']
    
    if(toupper(transaction_vector[7]) == 'PENDING'){
      output <- transaction_vector[7:length(transaction_vector)] %>%
        matrix(ncol=5, byrow=T) %>% 
        `colnames<-`(c('Date', 'Description', 'Category', 'Card', 'Amount')) %>%
        as_tibble() %>% 
        mutate(
          Amount = as.numeric(sub(',', '', sub('\\$', '', Amount)))
        )
    } else {
      output <- transaction_vector %>%
        matrix(ncol=6, byrow=T) %>%
        `colnames<-`(
          c('Month', 'Day', 'Description', 'Category', 'Card', 'Amount')
        ) %>%
        as_tibble() %>%
        filter(row_number() != 1) %>%
        mutate(
          Date = parse_date_time(paste0(Month, ' ', Day), "m d") %>% as_date(),
          Amount = as.numeric(sub(',', '', sub('\\$', '', Amount)))
        ) %>%
        select(
          Date, everything(), -Month, -Day
        ) %>% 
        arrange(Date, Amount, Description)
      
      # In case it is the end/beginning of the year
      if((output$Date %>% min() %>% month()  == 1) &
         (output$Date %>% max() %>% month()  > 2) ){
        output[
          output$Date %>% month() > 1,
        ]$Date <- output[
          output$Date %>% month() > 1,
        ]$Date - years(1)
      }
    }
  }
  output
}

