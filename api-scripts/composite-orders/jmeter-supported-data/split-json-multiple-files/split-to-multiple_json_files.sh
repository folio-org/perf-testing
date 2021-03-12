#!/bin/bash
# Script to read each line, stores it in a variable `line`, monitor and increment line count variable, then create/write to respective json file.
# This script will same number of files as number of lines in the file.
# Make sure filename in `file` matches that already exists in current directory
 
file=compositeOrders.json
count=1
while IFS= read -r line
do
        printf "%s\n" "$line" > "$count".json
        ((count=count+1))
done < "$file"
