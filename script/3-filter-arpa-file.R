library(tidyverse)
library(stringr)
library(forcats)
library(magrittr)

model.1 <- read_tsv("lm/en.arpa.1.txt",
                    col_names = c('pro', 'word', 'back_pro'),
                    col_types = 'ccc')
# pro_threshold = as.numeric(
#     levels(
#         as_factor(
#             as.character(
#                 sort(
#                     as.numeric(
#                         model.1$pro[-c(1,2)])))))[4])
model.1 = model.1 %>%
    filter(row_number() <=2 | as.numeric(pro) >= -6) %T>%
    write_tsv('lm/en.arpa.1.min.txt')

writeLines(sort(model.1$word), 'lm/en.arpa.1.word')

model.2 = read_tsv("lm/en.arpa.2.txt",
                   col_names = c('pro', 'word', 'back_pro'),
                   col_types = 'ccc') %>%
    separate(words, c('word.1', 'word.2'), sep = ' ') %>%
    filter((word.1 %in% model.1$word) & (word.2 %in% model.1$word))
