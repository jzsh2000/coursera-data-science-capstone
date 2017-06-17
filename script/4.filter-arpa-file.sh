#!/usr/bin/env bash
set -ux

cd $(dirname $0)/..

# ===== 2-gram model
cat lm/en.arpa.2.txt \
    | awk '{print $2}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.2.id_1

cat lm/en.arpa.2.txt \
    | awk '{print $3}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.2.id_2

cat lm/en.arpa.2.id_1 \
    | comm -12 - lm/en.arpa.2.id_2 \
    | join --nocheck-order - <(nl -n rz -w 8 lm/en.arpa.2.txt) \
    | cut -d' ' -f 2- > lm/en.arpa.2.min.txt

# ===== 3-gram model
cat lm/en.arpa.3.txt \
    | awk '{print $2}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.3.id_1

cat lm/en.arpa.3.txt \
    | awk '{print $3}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.3.id_2

cat lm/en.arpa.3.txt \
    | awk '{print $4}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.3.id_3

cat lm/en.arpa.3.id_1 \
    | comm -12 - lm/en.arpa.3.id_2 \
    | comm -12 - lm/en.arpa.3.id_3 \
    | join --nocheck-order - <(nl -n rz -w 8 lm/en.arpa.3.txt) \
    | cut -d' ' -f 2- > lm/en.arpa.3.min.txt

# ===== 4-gram model
cat lm/en.arpa.4.txt \
    | awk '{print $2}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.4.id_1

cat lm/en.arpa.4.txt \
    | awk '{print $3}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.4.id_2

cat lm/en.arpa.4.txt \
    | awk '{print $4}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.4.id_3

cat lm/en.arpa.4.txt \
    | awk '{print $5}' \
    | nl -n rz -w 8 \
    | awk '{print $2,$1}' \
    | sort \
    | join --nocheck-order - <(sort lm/en.arpa.1.word) \
    | cut -d' ' -f2 \
    | sort > lm/en.arpa.4.id_4

cat lm/en.arpa.4.id_1 \
    | comm -12 - lm/en.arpa.4.id_2 \
    | comm -12 - lm/en.arpa.4.id_3 \
    | comm -12 - lm/en.arpa.4.id_4 \
    | join --nocheck-order - <(nl -n rz -w 8 lm/en.arpa.4.txt) \
    | cut -d' ' -f 2- > lm/en.arpa.4.min.txt
