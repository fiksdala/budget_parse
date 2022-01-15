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
        (
          input.string[input.string$Date %>% month() == 1, ]$Date
        ) <- (
          input.string[input.string$Date %>% month() == 1, ]$Date + years(1)
        )
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