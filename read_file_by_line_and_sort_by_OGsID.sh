#!/bin/bash

input="OGs.list"
while IFS= read -r var
do 
# echo "$var"
  grep -w -F $var all.hamstr.out > ./$var

   
done < "$input"
