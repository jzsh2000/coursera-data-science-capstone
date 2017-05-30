#!/usr/bin/env bash
set -ueo pipefail

cd $(dirname $0)/..
corpus_blogs='corpus/en_US/en_US.blogs.txt'
corpus_news='corpus/en_US/en_US.news.txt'
corpus_twitter='corpus/en_US/en_US.twitter.txt'
lm_bin=$(realpath ~/local/mosesdecoder/bin/lmplz)

function build_lm {
    name=$1; shift
    echo ===== $name =====
    cat $@ \
        | sed -e 's/\W/ /g' \
        | sed -e 's/  */ /g' \
        | tr 'A-Z' 'a-z' \
        > lm/${name}.clean.txt

    $lm_bin -o 4 < lm/${name}.clean.txt > lm/${name}.arpa.txt
}

# build_lm blogs $corpus_blogs
# build_lm news $corpus_news
# build_lm twitter $corpus_twitter
build_lm en $corpus_blogs $corpus_news $corpus_twitter
