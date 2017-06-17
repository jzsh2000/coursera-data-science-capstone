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

# ===== load data
load('robj/blogs.RData')
blogs.word = corpus.word$word[1]
blogs.2gram = corpus.bigrams %>% select(-n)
blogs.3gram = corpus.trigrams %>% select(-n)

load('robj/news.RData')
news.word = corpus.word$word[1]
news.2gram = corpus.bigrams %>% select(-n)
news.3gram = corpus.trigrams %>% select(-n)

load('robj/twitter.RData')
twitter.word = corpus.word$word[1]
twitter.2gram = corpus.bigrams %>% select(-n)
twitter.3gram = corpus.trigrams %>% select(-n)

dat_word = list(blogs = blogs.word,
                news = news.word,
                twitter = twitter.word)
dat_2gram = list(blogs = blogs.2gram,
                news = news.2gram,
                twitter = twitter.2gram)
dat_3gram = list(blogs = blogs.3gram,
                news = news.3gram,
                twitter = twitter.3gram)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    get_input_sentence <- reactive({
        unnest_tokens(data_frame(sent = input$sentence), 'word', 'sent')$word
    }) %>% debounce(1000)

    get_next_word <- reactive({
        render_word <- function(word_list) {
            # word_list: named word list
            return(set_names(map(unname(word_list),
                                 ~say(.x, by = 'cow', type = 'string')),
                             names(word_list)))
        }

        default_word = set_names(rep('😂', 3),
                                 c('blogs', 'news', 'twitter'))
        if (length(get_input_sentence()) == 0) {
            return(render_word(default_word))
        } else {
            pred_word = sapply(c('blogs', 'news', 'twitter'), function(source) {
                input_sentence = get_input_sentence()
                if (length(input_sentence) == 1) {
                    idx = match(input_sentence, dat_2gram[[source]]$word1)
                    if (is.na(idx)) {
                        return(dat_word[[source]])
                    } else {
                        return(dat_2gram[[source]]$word2[idx])
                    }
                } else {
                    # use the last two words
                    input_sentence = rev(input_sentence)[1:2]
                    idx = which(
                        dat_3gram[[source]]$word1 == input_sentence[2] &
                        dat_3gram[[source]]$word2 == input_sentence[1])
                    if (length(idx) == 0) {
                        idx = match(input_sentence[1], dat_2gram[[source]]$word1)
                        if (is.na(idx)) {
                            return(dat_word[[source]])
                        } else {
                            return(dat_2gram[[source]]$word2[idx])
                        }
                    } else {
                        return(dat_3gram[[source]]$word3[idx])
                    }
                }
            })
            return(render_word(pred_word))
        }
    })

    output$next_word <- renderUI({
        fluidRow(
            column(width = 4,
                   tags$div(class = "panel panel-default",
                            tags$div(class = 'panel-heading',
                                     'predicted by', tags$strong('blogs')),
                            tags$div(class = "panel-body",
                                     tags$pre(get_next_word()[['blogs']])))),
            column(width = 4,
                   tags$div(class = "panel panel-default",
                            tags$div(class = 'panel-heading',
                                     'predicted by', tags$strong('news')),
                            tags$div(class = "panel-body",
                                     tags$pre(get_next_word()[['news']])))),
            column(width = 4,
                   tags$div(class = "panel panel-default",
                            tags$div(class = 'panel-heading',
                                     'predicted by', tags$strong('twitter')),
                            tags$div(class = "panel-body",
                                     tags$pre(get_next_word()[['twitter']]))))
        )
    })
})
