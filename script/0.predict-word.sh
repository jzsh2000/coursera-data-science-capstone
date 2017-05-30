#!/usr/bin/env bash
set -ue

echo "3-gram"
last_two=$(echo "$@" | awk '{print $(NF-1),$NF}')
grep -oP "$last_two \\w+" corpus/en_US/* \
    | cut -d' ' -f3 \
    | tr 'A-Z' 'a-z' \
    | sort \
    | uniq -c \
    | sort -k1,1nr \
    | head

echo "4-gram"
last_three=$(echo "$@" | awk '{print $(NF-2),$(NF-1),$NF}')
grep -oP "$last_three \\w+" corpus/en_US/* \
    | cut -d' ' -f4 \
    | tr 'A-Z' 'a-z' \
    | sort \
    | uniq -c \
    | sort -k1,1nr \
    | head
