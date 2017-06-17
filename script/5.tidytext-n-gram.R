library(tidyverse)
library(tidytext)
library(stringr)

rm(list = ls())
corpus_files <- dir('corpus/en_US', full.names = TRUE)
corpus_files = set_names(corpus_files,
                         str_extract(corpus_files, '[^.]*(?=.txt)'))

walk2(corpus_files, names(corpus_files), function(file, source) {
    cat(paste('=====', source, '=====\n'))
    corpus <- data_frame(text = read_lines(file)) %>%
        mutate(line_num = seq_along(text))
    corpus.token <- corpus %>%
        unnest_tokens(word, text) %>%
        group_by(word) %>%
        mutate(n = n_distinct(line_num)) %>%
        select(word, n) %>%
        filter(n >= 10) %>%
        unique() %>%
        arrange(desc(n)) %>%
        ungroup() %>%
        filter(grepl('^[a-z]*$', word))

    cat(paste('-----', source, '-> get bigrams -----\n'))
    corpus.bigrams <- corpus %>%
        unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
        separate(bigram, c("word1", "word2"), sep = " ") %>%
        filter(word1 %in% corpus.token$word) %>%
        filter(word2 %in% corpus.token$word) %>%
        count(word1, word2, sort = TRUE) %>%
        filter(n >= 10) %>%
        group_by(word1) %>%
        arrange(desc(n)) %>%
        slice(1) %>%
        ungroup() %>%
        select(word1, word2, n)

    cat(paste('-----', source, '-> get trigrams -----\n'))
    corpus.trigrams <- corpus %>%
        unnest_tokens(bigram, text, token = "ngrams", n = 3) %>%
        separate(bigram, c("word1", "word2", "word3"), sep = " ") %>%
        filter(word1 %in% corpus.token$word) %>%
        filter(word2 %in% corpus.token$word) %>%
        filter(word3 %in% corpus.token$word) %>%
        count(word1, word2, word3, sort = TRUE) %>%
        filter(n >= 10) %>%
        group_by(word1, word2) %>%
        arrange(desc(n)) %>%
        slice(1) %>%
        ungroup() %>%
        select(word1, word2, word3, n)

    cat(paste('-----', source, '-> save RData -----\n'))
    corpus.word <- corpus.token %>%
        anti_join(stop_words, by = 'word') %>%
        arrange(desc(n))

    save(corpus.word, corpus.bigrams, corpus.trigrams,
         file = file.path('robj', paste0(source, '.RData')))
    # save(set_names(list(corpus.word$word[1],
    #                     corpus.bigrams %>% select(-n),
    #                     corpus.trigrams %>% select(-n)),
    #                paste(source, c('word', 'bigrams', 'trigrams'), sep = '.')),
    #      file = file.path('robj', paste0(source, '.shiny.RData')))

    rm(list = ls(pattern = 'corpus'))
    gc()
})
