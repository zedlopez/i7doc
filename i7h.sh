#!/bin/bash

for file in i7handbook/*.html; do
    ./stage1.rb $file  i7handbook/`basename $file .html`.md 
done
