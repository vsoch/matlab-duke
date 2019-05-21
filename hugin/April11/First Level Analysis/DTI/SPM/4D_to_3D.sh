#!/bin/bash

# Loop through the subjects to delete old run data

countVar = 1;

for i in TEST*
do

bxhabsorb $i $i.bxh
bxh2analyze --niftihdr $i.bxh V$countVar

let "countVar += 1";
 
done
