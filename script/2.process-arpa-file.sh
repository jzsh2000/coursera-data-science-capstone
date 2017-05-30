#!/usr/bin/env bash
set -ueo pipefail

cd $(dirname $0)
csplit lm/en.arpa.txt '/^\\/' '{*}'

tail -n+2 xx02 | grep -v '</s>' > lm/en.arpa.1.txt
tail -n+2 xx03 | grep -v '</s>' > lm/en.arpa.2.txt
tail -n+2 xx04 | grep -v '</s>' > lm/en.arpa.3.txt
tail -n+2 xx05 | grep -v '</s>' > lm/en.arpa.4.txt

rm xx0?
