#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(stringr)
library(tidytext)
library(cowsay)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    get_input_sentence <- reactive({
        unnest_tokens(data_frame(sent = input$sentence), 'word', 'sent')$word
    }) %>% debounce(1000)

    output$next_word <- renderPrint({
        if (length(get_input_sentence()) == 0) {
            return(cat(say('=_=', by = 'cow', type = 'string')))
        }
        input_tokens = get_input_sentence()
        return(cat(say(rev(input_tokens)[1], by = 'cow', type = 'string')))
    })
})
