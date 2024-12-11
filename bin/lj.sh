#!/bin/bash

FILENAME=$HOME/gg/lj/$(date "+%Y-%m-%d-%S-%A").diff
$@ | tee "$FILENAME"

echo "Saved diff to $FILENAME"
printf "\tline\twords\tchars"
wc $FILENAME
cloc $FILENAME | tail +2
echo "Press enter to open in $EDITOR"
read
$EDITOR $FILENAME
