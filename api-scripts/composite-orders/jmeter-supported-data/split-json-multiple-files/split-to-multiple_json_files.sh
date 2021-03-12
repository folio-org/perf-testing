#!/bin/bash
file=compositeOrders100.json
count=1
while IFS= read -r line
do
        printf "%s\n" "$line" > "$count".json
        ((count=count+1))
done < "$file"
