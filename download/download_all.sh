#!/bin/bash

cat links.txt | while read line
do 
  DIR=$(echo "$line" | sed -E 's/links\///g; s/.csv//g') 
  echo "Downloading $DIR dataset..."
  cat $line | ./download.sh -d $DIR   
done
