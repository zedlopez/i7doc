#!/bin/bash

for file in i7handbook/*[a-z0-9].html; do
    BASE=`basename $file .html`
    OUT="i7handbook/$BASE.Z.html"
    ./stage1.rb "$file" > "$OUT"
    MD="i7handbook/$BASE.md"
    ./kr.rb "$OUT" > "$MD"
    ruby -Ilib kram.rb "$MD" > "docs/i7handbook/$BASE.html"
done
