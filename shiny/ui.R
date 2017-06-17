#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    title = 'Predict the next word',

    titlePanel('Predict the Next Word'),
    hr(),
    fluidRow(
        column(width = 8, offset = 2,
               textInput(
                   inputId = 'sentence',
                   label = 'Your sentence',
                   width = '100%',
                   placeholder = 'Type your awesome sentence here :)'
               ),
               uiOutput('next_word')
               )
    )
))
